import 'package:flutter/material.dart';

class BingoCard extends StatefulWidget {
  const BingoCard({super.key});

  @override
  State<BingoCard> createState() => _BingoCardState();
}

class _BingoCardState extends State<BingoCard> {
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
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      'Item $index',
                      style: const TextStyle(fontSize: 12),
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
