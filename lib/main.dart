import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/landing_page.dart';
import 'package:timetracker/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hi',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LandingPage(
        auth: Auth(),
      ),
    );
  }
}
