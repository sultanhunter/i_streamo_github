import 'package:i_streamo_github/repos/domain/github_repo.dart';
import 'package:i_streamo_github/repos/domain/github_repo_detail.dart';
import 'package:i_streamo_github/repos/infrastructure/sembast_database.dart';
import 'package:sembast/sembast.dart';

class GithubRepoDetailLocalService {
  final _store = stringMapStoreFactory.store('reposDetail');

  Future<void> saveRepoData(
      String fullName, GithubRepoDetail repoDetail) async {
    await _store
        .record(fullName)
        .put(SembastDatabase.instance, repoDetail.toMap());
  }

  Future<GithubRepoDetail> getRepoData(String fullName) async {
    final repoDataMap =
        await _store.record(fullName).get(SembastDatabase.instance);
    return GithubRepoDetail.fromMap(repoDataMap as Map<String, dynamic>);
  }

  Future<bool> isCached(String fullName) async {
    final _isCached =
        await _store.record(fullName).exists(SembastDatabase.instance);
    return _isCached;
  }

  Future<void> deleteAllRecords() async {
    await _store.delete(SembastDatabase.instance);
  }
}
