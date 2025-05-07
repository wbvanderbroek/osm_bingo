class BingoElement {
  String locName = "";
  double longitude = 0;
  double latitude = 0;
  bool hasCompleted = false;

  BingoElement(String name, double lat, double long) {
    locName = name;
    longitude = long;
    latitude = lat;
  }
}
