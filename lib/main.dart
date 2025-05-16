import 'package:flutter/material.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/custom_navigation_bar.dart';
import 'package:osm_bingo/dao/bingo.dart';
import 'package:osm_bingo/dao/local_database.dart';
import 'package:osm_bingo/dao/team.dart';
import 'package:osm_bingo/navigation_service.dart';

Future<void> main() async {
  // Load all data from database and
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase().init();

  await BingoCard.loadBingoCard();
  await BingoDao().getCompleted();

  runApp(const MyApp());
  // Try to load team name, if no team name exists this will prompt the user to create one
  await TeamDao().getName();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      navigatorKey: navigatorKey,
      home: const CustomNavigationBar(),
    );
  }
}
