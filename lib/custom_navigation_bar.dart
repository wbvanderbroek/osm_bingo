import 'package:flutter/material.dart';
import 'package:osm_bingo/navigation_service.dart';
import 'package:osm_bingo/screens/bingo_card.dart';
import 'package:osm_bingo/screens/cam.dart';
import 'package:osm_bingo/screens/map.dart';

class CustomNavigationBar extends StatefulWidget {
  @visibleForTesting
  final int initialIndex;

  const CustomNavigationBar({super.key, this.initialIndex = 0});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBar();
}

class _CustomNavigationBar extends State<CustomNavigationBar> {
  @override
  void initState() {
    super.initState();

    // Update the widget when the navigation index changes
    navigationIndexNotifier.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    navigationIndexNotifier.removeListener(() {
      if (mounted) {
        setState(() {});
      }
    });
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
                  navigationIndexNotifier.value = index;
                });
              },
              indicatorColor: Colors.amber,
              backgroundColor: Colors.white70,
              selectedIndex: navigationIndexNotifier.value,
              // Assign the classes to the destinations
              destinations: const <Widget>[
                NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
                NavigationDestination(
                  icon: Icon(Icons.grid_view),
                  label: 'Bingo Kaart',
                ),
                NavigationDestination(
                  icon: Icon(Icons.camera),
                  label: 'Camera',
                ),
              ],
            ),
          ],
        ),
      ),
      body:
          // This is where the screens are displayed
          <Widget>[
            const OpenStreetMapScreen(),
            const BingoCardScreen(),
            const TakePictureScreen(),
          ][navigationIndexNotifier.value],
    );
  }
}
