import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:learning/activity.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  final String url = "https://pibic-project.herokuapp.com/login";

  @override
  State<Login> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<String> _login(User user) async {
    var response = await http.post(
      Uri.encodeFull(widget.url),
      body: json.encode(user),
      headers: {
        "Content-type": "application/json"
      }
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListActivity())
      );
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "username"
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter some text";
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "password"
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter some text";
                  return null;
                },
              ),
            ),
            RaisedButton(
              child: Text("Enter"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  User user = User(usernameController.text, passwordController.text);
                  _login(user);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  final String username;
  final String password;

  User(this.username, this.password);

  Map<String, dynamic> toJson() =>
    {
      "username": username,
      "password": password
    };
}