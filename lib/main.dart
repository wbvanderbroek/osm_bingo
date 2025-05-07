import 'package:flutter/material.dart';
import 'package:osm_bingo/at-location/AtLocation.dart';
import 'package:osm_bingo/custom_navigation_bar.dart';
import 'package:osm_bingo/screens/map.dart';

void main() {
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
      home: const CustomNavigationBar(),
    );
  }
}
