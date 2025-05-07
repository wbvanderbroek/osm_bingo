import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_bingo/bingo_logic/bingo_card.dart';
import 'package:osm_bingo/bingo_logic/bingo_element.dart';

class OpenStreetMapScreen extends StatefulWidget {
  const OpenStreetMapScreen({super.key});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  final MapController _mapController = MapController();
  static LatLng _currentPosition = LatLng(
    53.2194,
    6.5665,
  ); // Default to Groningen
  Timer? _timer;
  static bool isFirstTime = true;
  late final List<BingoElement> _flattenedBingoElements;
  List<Marker> _bingoMarkers = [];

  @override
  void initState() {
    super.initState();
    _determinePosition();

    final bingoCard = BingoCard();
    _flattenedBingoElements = bingoCard.bingoCard.expand((row) => row).toList();

    _populateMap();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      _determinePosition();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _populateMap() {
    for (var element in _flattenedBingoElements) {
      final marker = Marker(
        point: LatLng(element.latitude, element.longitude),
        width: 40,
        height: 40,
        child: const Icon(Icons.location_pin, color: Colors.blue, size: 30),
      );
      _bingoMarkers.add(marker);
    }
    setState(() {});
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    final Position position = await Geolocator.getCurrentPosition();
    final newPosition = LatLng(position.latitude, position.longitude);

    if (!mounted) return;

    setState(() {
      _currentPosition = newPosition;
    });
    if (isFirstTime) {
      isFirstTime = false;
      _mapController.move(newPosition, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Current Location: ${_currentPosition.latitude}, ${_currentPosition.longitude}',
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: _currentPosition, initialZoom: 13),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example',
          ),
          MarkerLayer(
            markers: [
              ..._bingoMarkers,
              Marker(
                point: _currentPosition,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 30,
                ),
              ), // TODO: Test marker, need to remove later
            ],
          ),
        ],
      ),
    );
  }
}
