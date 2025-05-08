import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';

class MapService {
  static final MapService _instance = MapService._internal();

  factory MapService() => _instance;

  final MapController mapController = MapController();
  LatLng currentPosition = const LatLng(53.2194, 6.5665);
  final List<Marker> bingoMarkers = [];
  static final range = 50;

  MapService._internal() {
    _populateMarkers();
  }

  void _populateMarkers() {
    bingoMarkers.clear();
    for (var element in BingoCard.flattenedBingoElements) {
      final marker = Marker(
        point: LatLng(element.latitude, element.longitude),
        width: 40,
        height: 40,
        child: Icon(
          Icons.location_pin,
          color: element.hasCompleted ? Colors.green : Colors.black,
          size: 30,
        ),
      );
      bingoMarkers.add(marker);
    }
  }

  void refreshMarkers() {
    _populateMarkers();
  }
}
