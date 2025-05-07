import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:osm_bingo/dao/bingo.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._internal();
  LocalDatabase._internal();
  factory LocalDatabase() => instance;

  Database? _database;
  Database get database => _database!;

  static const dbName = 'osm_bingo.db';

  Future<void> init() async {
    if (_database != null) return;

    if (kIsWeb) {
      throw UnsupportedError('Web is not supported for sqflite');
    }

    String dbPath;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      dbPath = dbName;
    } else {
      final databasesPath = await getDatabasesPath();
      dbPath = join(databasesPath, dbName);
    }

    _database = await openDatabase(dbPath, version: 1, onCreate: createTables);
  }

  Future<void> createTables(Database db, int version, [int? newVersion]) async {
    final allTableDeclarations = [...bingoTableDeclaration];

    for (var query in allTableDeclarations) {
      await db.execute(query);
    }
  }
}
