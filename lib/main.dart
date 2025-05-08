import 'package:flutter/material.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/custom_navigation_bar.dart';
import 'package:osm_bingo/dao/bingo.dart';
import 'package:osm_bingo/dao/local_database.dart';
import 'package:osm_bingo/navigation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase().init();

  await BingoDao().getCompleted();
  BingoCard.loadBingoCard();
  runApp(const MyApp());
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
