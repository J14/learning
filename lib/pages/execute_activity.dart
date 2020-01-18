import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:learning/models/activity.dart';


class ExecuteActivity extends StatefulWidget {
  final String url = "https://class-path-location.herokuapp.com/distance/";
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
    List origin = [position.latitude, position.longitude];
    List destination = [
      widget.activity.location.latitude,
      widget.activity.location.longitude
    ];

    Map body = {
      'origin': origin,
      'destination': destination,
      'threshold': 10
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
                child: Text("Verificar localização"),
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
