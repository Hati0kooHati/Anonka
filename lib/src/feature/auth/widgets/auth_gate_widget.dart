import 'package:anonka/src/feature/auth/google_auth/google_auth_screen.dart';
import 'package:anonka/src/feature/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGateWidget extends StatefulWidget {
  const AuthGateWidget({super.key});

  @override
  State<AuthGateWidget> createState() => _AuthGateWidgetState();
}

class _AuthGateWidgetState extends State<AuthGateWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return GoogleAuthScreen();
        } else {
          return HomeScreen();
        }
      },
    );
  }
}
