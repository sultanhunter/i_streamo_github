import 'package:i_streamo_github/repos/domain/github_repo.dart';
import 'package:i_streamo_github/repos/infrastructure/pagination_config.dart';
import 'package:i_streamo_github/repos/infrastructure/sembast_database.dart';
import 'package:sembast/sembast.dart';
import 'package:collection/src/iterable_extensions.dart';

class GithubLocalService {
  final _store = intMapStoreFactory.store('repos');

  Future<void> upsertPage(List<GithubRepo> repos, int page) async {
    final sembastPage = page - 1;

    const itemsInSinglePage = PaginationConfig.itemsPerPage;

    ///this number gives the starting index of the first item of the respective page
    final algoNumber = sembastPage * itemsInSinglePage;

    await _store
        .records(repos.mapIndexed((index, _) => index + algoNumber))
        .put(SembastDatabase.instance, repos.map((e) => e.toMap()).toList());
  }

  Future<List<GithubRepo>> getPage(int page) async {
    final sembastPage = page - 1;
    const itemsInSinglePage = PaginationConfig.itemsPerPage;

    ///this number gives the starting index of the first item of the respective page
    final algoNumber = sembastPage * itemsInSinglePage;

    final records = await _store.find(SembastDatabase.instance,
        finder: Finder(
          limit: itemsInSinglePage,
          offset: algoNumber,
        ));

    return records.map((e) => GithubRepo.fromMap(e.value)).toList();
  }

  Future<int> getLocalPageCount() async {
    final reposCount = await _store.count(SembastDatabase.instance);
    final pageCount = (reposCount / PaginationConfig.itemsPerPage).ceil();
    return pageCount;
  }

  Future<void> deleteAllRecords() async {
    await _store.delete(SembastDatabase.instance);
  }
}
