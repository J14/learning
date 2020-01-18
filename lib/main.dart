import 'package:flutter/material.dart';

import 'package:learning/pages/login.dart';
import 'package:learning/screens/list_activity.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => Login(),
      "/listActivity": (context) => ListActivity()
    },
  ));
}
