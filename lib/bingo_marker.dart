import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_bingo/bingo_logic/bingo_element.dart';

class BingoMarker extends Marker {
  final BingoElement element;

  BingoMarker({required this.element})
    : super(
        point: LatLng(element.latitude, element.longitude),
        width: 40,
        height: 40,
        child: Icon(
          Icons.location_pin,
          color:
              element.locationStatus == LocationStatus.completed
                  ? Colors.green
                  : element.locationStatus == LocationStatus.hasBeenInRange
                  ? Colors.orange
                  : Colors.black,
          size: 30,
        ),
      );
}
