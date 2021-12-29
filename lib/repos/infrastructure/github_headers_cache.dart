import 'package:i_streamo_github/repos/domain/github_headers.dart';
import 'package:i_streamo_github/repos/infrastructure/sembast_database.dart';
import 'package:sembast/sembast.dart';

class GithubHeadersCache {
  final _store = stringMapStoreFactory.store('headers');

  Future<void> saveHeaders(Uri uri, GithubHeaders headers) async {
    await _store
        .record(uri.toString())
        .put(SembastDatabase.instance, headers.toJson());
  }

  Future<GithubHeaders?> getHeaders(Uri uri) async {
    final json =
        await _store.record(uri.toString()).get(SembastDatabase.instance);
    return json == null ? null : GithubHeaders.fromJson(json);
  }

  Future<void> deleteHeaders(Uri uri) async {
    await _store.record(uri.toString()).delete(SembastDatabase.instance);
  }
}
