class Location {
  final String name;
  final String description;
  final List coord;

  Location(this.name, this.description, this.coord);

  Location.fromJson(Map<String, dynamic> dataJson)
    : this.name = dataJson['name'],
      this.description = dataJson['description'],
      this.coord = dataJson['coord']['coordinates'];
}