import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Health_Care/screens/homepage.dart';
import 'package:Health_Care/screens/login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return homepage();
          }

          //user not logged in
          else {
            return LoginPage();
          }
        }
      )
    );
  }
}