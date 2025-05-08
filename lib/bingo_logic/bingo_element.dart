class BingoElement {
  String locName = "";
  String taskDescription = "";
  double latitude = 0;
  double longitude = 0;
  bool hasCompleted = false;

  BingoElement(String name, String description, double lat, double long) {
    locName = name;
    taskDescription = description;
    longitude = long;
    latitude = lat;
  }
}
