import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:osm_bingo/bingo_marker.dart';
import 'package:osm_bingo/compass.dart';
import 'package:osm_bingo/in_range_checker.dart';
import 'package:osm_bingo/map_service.dart';
import 'package:osm_bingo/quest_popup.dart';

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

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      try {
        _mapService.determinePosition();
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    _mapService.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    _mapService.removeListener(() {
      if (!mounted) return;
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
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
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
              // Marker for the current location
              Marker(
                width: 50,
                height: 50,
                point: _mapService.currentPosition,
                child: StreamBuilder<CompassEvent>(
                  stream: FlutterCompass.events,
                  builder: (context, snapshot) {
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.heading == null) {
                      return const SizedBox();
                    }

                    double? heading = snapshot.data!.heading!;
                    // Rotate the marker based on the heading
                    return Transform.rotate(
                      angle: heading * (math.pi / 180), // Convert to radians
                      child: const Icon(
                        Icons.navigation,
                        size: 40,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          MarkerLayer(
            markers:
                _mapService.bingoMarkers.map((marker) {
                  return Marker(
                    width: marker.width,
                    height: marker.height,
                    point: marker.point,
                    child: GestureDetector(
                      onTap: () {
                        final bingoMarker = marker as BingoMarker;
                        final element = bingoMarker.element;
                        final userLat = _mapService.currentPosition.latitude;
                        final userLon = _mapService.currentPosition.longitude;

                        final distance = calculateDistance(
                          element.latitude,
                          element.longitude,
                          userLat,
                          userLon,
                        );

                        if (distance <= _mapService.calculatedRange) {
                          // Nearby: show QuestPopup
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuestPopup(
                                text: element.locName,
                                onButtonPressed:
                                    () => Navigator.of(context).pop(),
                              );
                            },
                          );
                        } else {
                          // Far away: show full dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(element.locName),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text(element.taskDescription)],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('Sluiten'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: marker.child,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
