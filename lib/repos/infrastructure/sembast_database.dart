import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastDatabase {
  static late Database instance;

  static bool _hasBeenInitialized = false;

  static Future<void> init() async {
    if (_hasBeenInitialized) return;
    final dbDirectory = await getApplicationDocumentsDirectory();
    dbDirectory.create(recursive: true);
    final dbPath = join(dbDirectory.path, 'db.sembast');
    instance = await databaseFactoryIo.openDatabase(dbPath);
    _hasBeenInitialized = true;
  }
}
