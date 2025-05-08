class BingoElement {
  String locName = "";
  String taskDescription = "";
  double latitude = 0;
  double longitude = 0;

  LocationStatus locationStatus = LocationStatus.notSeen;

  BingoElement(String name, String description, double lat, double long) {
    locName = name;
    taskDescription = description;
    longitude = long;
    latitude = lat;
  }
}

enum LocationStatus { notSeen, hasBeenInRange, completed }
