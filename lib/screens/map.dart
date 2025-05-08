import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:osm_bingo/map_service.dart';

class OpenStreetMapScreen extends StatefulWidget {
  const OpenStreetMapScreen({super.key});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  Timer? _timer;
  final MapService _mapService = MapService();

  @override
  void initState() {
    super.initState();
    _mapService.determinePosition();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      _mapService.determinePosition();
    });

    _mapService.addListener(() {
      setState(() {});
    });

    // These lines can ben used to test bing checks or visualization
    // BingoCard.markAsCompleted(
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
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    _mapService.removeListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Current Location: ${_mapService.currentPosition.latitude}, ${_mapService.currentPosition.longitude}',
        ),
      ),
      body: FlutterMap(
        mapController: _mapService.mapController,
        options: MapOptions(
          initialCenter: _mapService.currentPosition,
          initialZoom: 13,
          minZoom: 3,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example',
          ),
          CircleLayer(
            circles: [
              CircleMarker(
                point: _mapService.currentPosition,
                color: Colors.blue.withAlpha(20),
                borderStrokeWidth: 2,
                useRadiusInMeter: true,
                radius: MapService().calculatedRange.toDouble(), // in meters
                borderColor: Colors.blue,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              ..._mapService.bingoMarkers,
              Marker(
                point: _mapService.currentPosition,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.accessibility_new_outlined,
                  color: Colors.red,
                  size: 45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
