import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:i_streamo_github/repos/domain/fresh.dart';
import 'package:i_streamo_github/repos/domain/github_failure.dart';
import 'package:i_streamo_github/repos/domain/github_headers.dart';
import 'package:i_streamo_github/repos/domain/github_repo.dart';
import 'package:i_streamo_github/repos/infrastructure/github_headers_cache.dart';
import 'package:i_streamo_github/repos/infrastructure/github_local_service.dart';
import 'package:i_streamo_github/repos/infrastructure/pagination_config.dart';
import 'package:i_streamo_github/repos/infrastructure/sembast_database.dart';
import 'package:i_streamo_github/core/infrastructure/dio_extensions.dart';

class GithubRepository {
  late final GithubLocalService _githubLocalService;
  late final GithubHeadersCache _githubHeadersCache;

  GithubRepository() {
    _githubHeadersCache = GithubHeadersCache();
    _githubLocalService = GithubLocalService();
  }

  final _client = Dio();
  Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> getRepos(
      int page) async {
    final Completer<Either<GithubFailure, Fresh<List<GithubRepo>>>> _completer =
        Completer();
    const accept = 'application/vnd.github.v3.html+json';
    final requestUri = Uri.https('api.github.com', '/users/JakeWharton/repos', {
      'page': '$page',
      'per_page': PaginationConfig.itemsPerPage.toString(),
    });
    final previousHeaders = await _githubHeadersCache.getHeaders(requestUri);
    try {
      final response = await _client.getUri(requestUri,
          options: Options(
            headers: {
              'Accept': accept,
              'If-None-Match': previousHeaders?.etag ?? '',
            },
            validateStatus: (status) =>
                status != null && status >= 200 && status < 400,
          ));
      if (response.statusCode == 304) {
        print('304');
        final _maxPage = previousHeaders?.paginationLink?.maxPage ?? 0;
        final _repos = await _githubLocalService.getPage(page);
        _completer.complete(right(Fresh(_repos, true, _maxPage > page)));
      } else if (response.statusCode == 200) {
        print('200');
        final headers = GithubHeaders.parse(response);
        final _maxPage = headers.paginationLink?.maxPage ?? 1;
        await _githubHeadersCache.saveHeaders(requestUri, headers);

        final _convertedData = (response.data as List<dynamic>)
            .map((e) => GithubRepo.fromMap(e as Map<String, dynamic>))
            .toList();
        await _githubLocalService.upsertPage(_convertedData, page);
        _completer
            .complete(right(Fresh(_convertedData, true, _maxPage > page)));
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        print('no internt');
        final _repos = await _githubLocalService.getPage(page);
        final _maxPage = previousHeaders?.paginationLink?.maxPage ?? 0;
        _completer.complete(right(Fresh(_repos, false, _maxPage > page)));
      } else {
        return left(GithubFailureApi(errorMessage: e.message));
      }
    }
    return _completer.future;
  }
}
