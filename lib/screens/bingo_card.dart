import 'package:flutter/material.dart';

class BingoCard extends StatefulWidget {
  const BingoCard({super.key});

  @override
  State<BingoCard> createState() => _BingoCardState();
}

class _BingoCardState extends State<BingoCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Test')));
  }
}
