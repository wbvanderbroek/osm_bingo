import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/bingo_marker.dart';

import 'in_range_checker.dart';

class MapService extends ChangeNotifier {
  static final MapService _instance = MapService._internal();

  factory MapService() => _instance;

  final MapController mapController = MapController();
  LatLng currentPosition = const LatLng(53.2194, 6.5665);
  final List<BingoMarker> bingoMarkers = [];
  static final defaultRange = 50;
  double calculatedRange = defaultRange.toDouble();
  static bool isFirstTime = true;

  MapService._internal() {
    _populateMarkers();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      return;
    }

    final Position position = await Geolocator.getCurrentPosition();
    final newPosition = LatLng(position.latitude, position.longitude);

    final accuracy = position.accuracy;
    if (accuracy > 0.0) {
      calculatedRange = defaultRange + accuracy;
    }

    currentPosition = newPosition;

    if (isFirstTime) {
      isFirstTime = false;
      mapController.move(newPosition, mapController.camera.zoom);

      // These lines can ben used to test bing checks or visualization
      // BingoCard.markAsSeen(
      //   BingoCard.bingoCard[0][0].latitude,
      //   BingoCard.bingoCard[0][0].longitude,
      // );
      // BingoCard.markAsCompleted(
      //   BingoCard.bingoCard[0][1].latitude,
      //   BingoCard.bingoCard[0][1].longitude,
      // );
      // BingoCard.markAsCompleted(
      //   BingoCard.bingoCard[0][2].latitude,
      //   BingoCard.bingoCard[0][2].longitude,
      // );
      // BingoCard.markAsCompleted(
      //   BingoCard.bingoCard[0][3].latitude,
      //   BingoCard.bingoCard[0][3].longitude,
      // );
      // BingoCard.markAsCompleted(
      //   BingoCard.bingoCard[0][4].latitude,
      //   BingoCard.bingoCard[0][4].longitude,
      // );

      // for (final marker in bingoMarkers) {
      //   BingoCard.markAsCompleted(
      //     marker.element.latitude,
      //     marker.element.longitude,
      //   );
      // }
    }
    notifyListeners();

    InRangeChecker().checkLocation(position.latitude, position.longitude);
  }

  void _populateMarkers() {
    bingoMarkers.clear();
    for (var element in BingoCard.flattenedBingoElements) {
      bingoMarkers.add(BingoMarker(element: element));
    }
  }

  void refreshMarkers() {
    _populateMarkers();
  }
}
