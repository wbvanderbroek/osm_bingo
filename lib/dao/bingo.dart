import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/dao/local_database.dart';

List<String> bingoTableDeclaration = [
  "CREATE TABLE IF NOT EXISTS Card (gridLocation TEXT NOT NULL PRIMARY KEY)",
];

class BingoDao {
  static final BingoDao _instance = BingoDao._internal();
  factory BingoDao() => _instance;
  BingoDao._internal();

  final LocalDatabase _db = LocalDatabase();

  /// Inserts a completed location into the database.
  Future<void> insertCompleted(int gridLocationX, int gridLocationY) async {
    await _db.init();
    await _db.database.rawQuery(
      'INSERT OR REPLACE INTO Card (gridLocation) VALUES (?)',
      ["$gridLocationX,$gridLocationY"],
    );
  }

  /// Gets completed locations from the database and loads it into the bingo card.
  Future<void> getCompleted() async {
    await _db.init();

    final query = await _db.database.rawQuery('SELECT * FROM Card');
    if (query.isNotEmpty) {
      for (var card in query) {
        String gridLocation = card['gridLocation'] as String;

        List<String> parts = gridLocation.split(',');
        int gridLocationX = int.parse(parts[0]);
        int gridLocationY = int.parse(parts[1]);
        final element = BingoCard.bingoCard[gridLocationX][gridLocationY];
        BingoCard.markAsCompleted(
          element.latitude,
          element.longitude,
          fromDataBase: true,
        );
      }
      return;
    }
  }
}
