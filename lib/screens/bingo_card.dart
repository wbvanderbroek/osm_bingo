import 'package:flutter/material.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/bingo_logic/bingo_element.dart';

class BingoCardScreen extends StatefulWidget {
  const BingoCardScreen({super.key});

  @override
  State<BingoCardScreen> createState() => _BingoCardScreenState();
}

class _BingoCardScreenState extends State<BingoCardScreen> {
  @override
  void initState() {
    super.initState();
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
                final element = BingoCard.flattenedBingoElements[index];
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color:
                        element.locationStatus == LocationStatus.completed
                            ? Colors.green
                            : element.locationStatus ==
                                LocationStatus.hasBeenInRange
                            ? Colors.orange
                            : Colors.white,
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
