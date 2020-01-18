import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:learning/models/activity.dart';
import 'package:learning/pages/execute_activity.dart';


class ListActivity extends StatefulWidget {
  final String url = "http://class-path-content.herokuapp.com/activities/";

  @override
  State<ListActivity> createState() {
    return ListActivityState();
  }
}

class ListActivityState extends State<ListActivity> {
  List activities;

  Future<String> _getAllActivities() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.get(
      Uri.encodeFull(widget.url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Token $token"
      }
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      List dataJson = json.decode(body);
      setState(() {
        activities = dataJson.map((activity) => Activity.fromJson(activity)).toList();
      });
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atividades"),
      ),
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