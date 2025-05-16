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

  // This name is used to save the photos on the server
  static String nameWithUuid = "";

  final LocalDatabase _db = LocalDatabase();
  final _uuid = Uuid();

  Future<void> insertName(String name) async {
    await _db.init();

    await _db.database.rawInsert(
      'INSERT OR REPLACE INTO Name (name) VALUES (?)',
      [nameWithUuid],
    );
  }

  /// This makes sure to either retrieve the name saved on the device, or
  /// prompt the user to enter a name and then save that afterwards.

  Future<void> getName() async {
    await _db.init();

    final query = await _db.database.rawQuery('SELECT * FROM Name');
    if (query.isNotEmpty) {
      for (var name in query) {
        // Although of course should never be more than one
        nameWithUuid = name['name'] as String;
      }
      return;
    }

    // When no name is found on the device, we prompt the user to enter a name
    if (query.isEmpty) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          TextEditingController nameController = TextEditingController();
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text("Bedenk een goede teamnaam"),
              content: TextField(
                controller: nameController,
                maxLength: 20,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(counterText: ""),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    String name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      final uuid = _uuid.v4();
                      nameWithUuid = '${name}_$uuid';
                      insertName(nameWithUuid);

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
