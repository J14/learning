import 'package:learning/models/content.dart';
import 'package:learning/models/location.dart';


class Activity {
  final String title;
  final String description;
  final Location location;
  final Content content;

  Activity(this.title, this.description, this.location, this.content);

  Activity.fromJson(Map<String, dynamic> dataJson)
      : this.title = dataJson['title'],
        this.description = dataJson['description'],
        this.location = Location.fromJson(dataJson['location']),
        this.content = Content.fromJson(dataJson['content']);
}