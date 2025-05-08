// compass.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

class Compass extends StatefulWidget {
  const Compass({super.key});

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  void _fetchPermissionStatus() async {
    final status = await Permission.locationWhenInUse.status;
    if (mounted) {
      setState(() {
        _hasPermissions = (status == PermissionStatus.granted);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermissions) return const SizedBox();

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.heading == null) {
          return const SizedBox();
        }

        double? direction = snapshot.data!.heading!;
        return Transform.rotate(
          angle: -direction * (math.pi / 180),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.6),
            ),
            child: const Center(
              child: Icon(Icons.navigation, color: Colors.white, size: 30),
            ),
          ),
        );
      },
    );
  }
}
