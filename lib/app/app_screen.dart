import 'package:anonka/app/app_bloc.dart';
import 'package:anonka/app/app_state.dart';
import 'package:anonka/constants.dart';
import 'package:anonka/injection/inject.dart';
import 'package:anonka/presentation/auth/google_auth/google_auth_screen.dart';
import 'package:anonka/presentation/home/home_screen.dart';
import 'package:anonka/widgets/navigation_observer.dart';
import 'package:anonka/widgets/statebloc_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppScreen extends StateblocWidget<AppBloc, AppState> {
  AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [get<NavigationObserver>()],
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: state.shouldShowUpdateScreen
          ? _showUpdateApp()
          : _getStartupScreen(),
    );
  }

  Widget _showUpdateApp() {
    return Scaffold(
      body: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon or Image for visual appeal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.system_update,
                  size: 50,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),
              // Title
              const Text(
                AppStrings.updateAvailable,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              // Description
              const Text(
                AppStrings.updateSlogan,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Update Now Button
                  ElevatedButton(
                    onPressed: bloc.launchUpdateUrl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      AppStrings.update,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getStartupScreen() {
    if (FirebaseAuth.instance.currentUser != null) {
      return HomeScreen();
    } else {
      return GoogleAuthScreen();
    }
  }
}
