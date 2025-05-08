import 'package:flutter/material.dart';
import 'package:osm_bingo/screens/bingo_card.dart';
import 'package:osm_bingo/screens/map.dart';
import 'package:osm_bingo/screens/cam.dart';

class CustomNavigationBar extends StatefulWidget {
  @visibleForTesting
  final int initialIndex;

  const CustomNavigationBar({super.key, this.initialIndex = 0});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBar();
}

class _CustomNavigationBar extends State<CustomNavigationBar> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1, thickness: 1),
            NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              indicatorColor: Colors.amber,
              backgroundColor: Colors.white70,
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
                NavigationDestination(
                  icon: Icon(Icons.grid_view),
                  label: 'Bingo Kaart',
                ),
                NavigationDestination(
                  icon: Icon(Icons.camera),
                  label: 'camera',
                ),
              ],
            ),
          ],
        ),
      ),
      body:
          <Widget>[
            const OpenStreetMapScreen(),
            const BingoCardScreen(),
            const TakePictureScreen(),
          ][currentPageIndex],
    );
  }
}
