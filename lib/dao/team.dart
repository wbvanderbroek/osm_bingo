import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osm_bingo/dao/local_database.dart';
import 'package:osm_bingo/navigation_service.dart';
import 'package:uuid/uuid.dart';

List<String> teamTableDeclaration = [
  "CREATE TABLE IF NOT EXISTS Name (name TEXT NOT NULL PRIMARY KEY)",
];

class TeamDao {
  static final TeamDao _instance = TeamDao._internal();
  factory TeamDao() => _instance;
  TeamDao._internal();
  static String playerName = "";

  final LocalDatabase _db = LocalDatabase();
  final _uuid = Uuid();

  Future<void> insertName(String name) async {
    await _db.init();
    final uuid = _uuid.v4();
    final nameWithUuid = '${name}_$uuid';

    await _db.database.rawInsert(
      'INSERT OR REPLACE INTO Name (name) VALUES (?)',
      [nameWithUuid],
    );
  }

  Future<void> getName() async {
    await _db.init();

    final query = await _db.database.rawQuery('SELECT * FROM Name');
    if (query.isNotEmpty) {
      for (var name in query) {
        // Although of course should never be more than one
        playerName = name['name'] as String;
      }
      return;
    }

    if (query.isEmpty) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          TextEditingController nameController = TextEditingController();
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text("Enter Your Name"),
              content: TextField(
                controller: nameController,
                maxLength: 20,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(
                  hintText: "Bedenk een goede teamnaam",
                  counterText: "",
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    String name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      insertName(name);
                      playerName = name;
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
