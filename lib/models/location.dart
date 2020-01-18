class Location {
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  Location({this.name, this.description, this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> dataJson)
    : this.name = dataJson['name'],
      this.description = dataJson['description'],
      this.latitude = dataJson['latitude'],
      this.longitude = dataJson['longitude'];
}