import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'package:learning/content.dart';
import 'package:learning/location.dart';

class ListActivity extends StatefulWidget {
  final String url = "https://pibic-project.herokuapp.com/activity";

  @override
  State<ListActivity> createState() {
    return ListActivityState();
  }
}

class ListActivityState extends State<ListActivity> {
  List activities;

  Future<String> _getAllActivities() async {
    var response = await http.get(Uri.encodeFull(widget.url),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      Map<String, dynamic> dataJson = json.decode(response.body);
      setState(() {
        activities = dataJson['data']
            .map((activity) => Activity.fromJson(activity))
            .toList();
      });
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: activities == null ? 0 : activities.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExecuteActivity(activity: activities[index])
                        )
                      );
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          activities[index].title,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    this._getAllActivities();
  }
}

class ExecuteActivity extends StatefulWidget {
  final String url = "https://class-path-location.herokuapp.com/distance";
  final Activity activity;

  ExecuteActivity({Key key, @required this.activity})
    : super(key: key);

  @override
  State<ExecuteActivity> createState() {
    return ExecuteActivityState();
  }
}

class ExecuteActivityState extends State<ExecuteActivity> {
  final contentController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> _distance(Position position) async {
    List origin = [position.longitude, position.latitude];
    List destination = widget.activity.location.coord;
    Map body = {
      'origin': origin,
      'destination': destination,
      'threshold': 3
    };
    var response = await http.post(
      Uri.encodeFull(widget.url),
      body: json.encode(body),
      headers: {
        'Content-type': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      Map dataJson = json.decode(response.body);
      
      if (dataJson['threshold']) {
        contentController.text = widget.activity.content.description;
      } else {
        contentController.text = dataJson['threshold'].toString();
      }

      scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("${dataJson['distance']}"),
          ),
        );
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            enabled: false,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "Atividade",
              border: OutlineInputBorder(),
            ),
            initialValue: widget.activity.description,
          ),
          Container(
            child: Center(
              child: RaisedButton(
                child: Text("Send location"),
                onPressed: () async {
                  Position position = await Geolocator().getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high
                  );

                  _distance(position);
                },
              ),
            ),
          ),
          TextFormField(
            enabled: false,
            maxLines: 5,
            controller: contentController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

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
