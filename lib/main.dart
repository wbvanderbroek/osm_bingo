import 'package:flutter/material.dart';
import 'package:osm_bingo/cam.dart';
import 'package:osm_bingo/map.dart';

void main() {
  openCamera();
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
      home: const OpenStreetMap(title: 'Flutter Map Location'),
    );
  }
}
