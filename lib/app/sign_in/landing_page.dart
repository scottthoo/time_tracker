import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/home_page.dart';
import 'package:timetracker/app/sign_in/sign_in.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/services/auth_provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage();
            }
            return HomePage();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
