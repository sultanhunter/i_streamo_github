import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:i_streamo_github/core/infrastructure/dio_extensions.dart';
import 'package:i_streamo_github/repos/domain/fresh.dart';
import 'package:i_streamo_github/repos/domain/github_failure.dart';
import 'package:i_streamo_github/repos/domain/github_headers.dart';
import 'package:i_streamo_github/repos/domain/github_repo_detail.dart';
import 'package:i_streamo_github/repos/infrastructure/github_headers_cache.dart';
import 'package:i_streamo_github/repos/infrastructure/github_repo_details/github_repo_details_local_service.dart';

class GithubRepoDetailRepository {
  final _client = Dio();
  final GithubHeadersCache _githubHeadersCache = GithubHeadersCache();
  final GithubRepoDetailLocalService _githubRepoDetailLocalService =
      GithubRepoDetailLocalService();

  Future<Either<GithubFailure, Fresh<GithubRepoDetail>>> getReadmeHtml(
      String fullName) async {
    final Completer<Either<GithubFailure, Fresh<GithubRepoDetail>>> _completer =
        Completer();
    final requestUri = Uri.http(
      'github.com',
      '/$fullName/blob/master/README.md',
    );
    const accept = 'application/vnd.github.v3.html+json';
    final previousHeaders = await _githubHeadersCache.getHeaders(requestUri);
    try {
      final response = await _client.getUri(requestUri,
          options: Options(
            headers: {
              'Accept': accept,
              'If-None-Match': previousHeaders?.etag ?? '',
            },
            responseType: ResponseType.plain,
            validateStatus: (status) =>
                status != null && status >= 200 && status < 400,
          ));

      if (response.statusCode == 304) {
        final _repoDetail =
            await _githubRepoDetailLocalService.getRepoData(fullName);
        _completer.complete(right(Fresh(_repoDetail, true, true)));
      } else if (response.statusCode == 200) {
        final _headers = GithubHeaders.parse(response);
        await _githubHeadersCache.saveHeaders(requestUri, _headers);

        final _convertedData = GithubRepoDetail.fromApiData(response);
        await _githubRepoDetailLocalService.saveRepoData(
            fullName, _convertedData);
        _completer.complete(right(Fresh(_convertedData, true, true)));
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        final _isCached =
            await _githubRepoDetailLocalService.isCached(fullName);
        if (_isCached) {
          final _repoDetail =
              await _githubRepoDetailLocalService.getRepoData(fullName);
          _completer.complete(right(Fresh(_repoDetail, false, true)));
        } else {
          _completer.complete(left(GithubFailureNoInternetAndNoCache()));
        }
      } else {
        _completer.complete(left(GithubFailureApi(errorMessage: e.message)));
      }
    }
    return _completer.future;
  }
}
