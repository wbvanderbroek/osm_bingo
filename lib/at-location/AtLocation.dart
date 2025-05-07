import 'dart:math';
import 'package:vibration/vibration.dart';

List<double> positionsLat = [53.211034524286035, 53.2033246558365];
List<double> positionsLon = [6.564051943997352, 6.562639551423343];
List<String> positionsName = ["Station", "School"];
bool hasVibraded = false;
bool hasVibratedLoopEnd = false; // Checks if hasVibrated has ever become true.

class Atlocation {
  void checkLocation(final lat, final lon) {
    bool neverTrue = false; // Checks if hasVibrated has never becomes false;
    for (int i = 0; i < positionsLat.length; i++) {
      double distanceInMeters = calculateDistance(
        positionsLat[i],
        positionsLon[i],
        lat,
        lon,
      );
      if (distanceInMeters <= 20) {
        print(
          "You're close to ${positionsName[i]} by ${distanceInMeters.toInt()} meters",
        );
        neverTrue = true; // Has vibrated becomes false so this becomes true.
        if (hasVibraded == false) {
          Vibration.vibrate();
          hasVibraded = true;
          hasVibratedLoopEnd = true;
        }
      }
    }
    if (hasVibratedLoopEnd == false) {
      hasVibraded = false;
    }
    if (neverTrue == false) hasVibratedLoopEnd = false;
  }
}

// Haversine formula to calculate the distance between two points on a sphere
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371e3; // Earth's radius in meters
  final phi1 = lat1 * pi / 180; // φ, λ in radians
  final phi2 = lat2 * pi / 180;
  final deltaPhi = (lat2 - lat1) * pi / 180;
  final deltaLambda = (lon2 - lon1) * pi / 180;

  final a =
      sin(deltaPhi / 2) * sin(deltaPhi / 2) +
      cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c; // in meters
}
