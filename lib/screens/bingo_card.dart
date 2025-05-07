import 'package:flutter/material.dart';
import 'package:osm_bingo/bingo_logic/bingo_element.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';

class BingoCardScreen extends StatefulWidget {
  const BingoCardScreen({super.key});

  @override
  State<BingoCardScreen> createState() => _BingoCardScreenState();
}

class _BingoCardScreenState extends State<BingoCardScreen> {
  late final List<BingoElement> _flattenedBingoElements;

  @override
  void initState() {
    super.initState();
    final bingoCard = BingoCard();
    _flattenedBingoElements = bingoCard.bingoCard.expand((row) => row).toList();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Bingo Kaart';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 5,
              padding: EdgeInsets.zero,
              childAspectRatio: 1,
              children: List.generate(25, (index) {
                final element = _flattenedBingoElements[index];
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      element.locName,
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
