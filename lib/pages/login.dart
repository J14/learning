import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:learning/models/user.dart';


class Login extends StatefulWidget {
  final String url = "http://class-path-auth.herokuapp.com/login/";

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
      String body = utf8.decode(response.bodyBytes);
      Map data = json.decode(body);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", data['token']);

      Navigator.pushReplacementNamed(context, "/listActivity");
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
                  labelText: "usuário"
                ),
                validator: (value) {
                  if (value.isEmpty) return "Por favor, informe um usuário";
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
                  labelText: "senha"
                ),
                validator: (value) {
                  if (value.isEmpty) return "Por favor, informe uma senha";
                  return null;
                },
              ),
            ),
            RaisedButton(
              child: Text("Entrar"),
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
