import 'package:anonka/src/feature/app/app_screen.dart';
import 'package:anonka/firebase_options.dart';
import 'package:anonka/src/core/injection/inject.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await configureDependencies();

  runApp(AppScreen());
}
