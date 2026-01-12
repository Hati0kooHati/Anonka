import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/feature/auth/google_auth/cubit/google_auth_bloc.dart';
import 'package:anonka/src/feature/auth/google_auth/cubit/google_auth_state.dart';
import 'package:anonka/src/feature/tabs_screen/tabs_screen.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleAuthScreen
    extends StateblocWidget<GoogleAuthCubit, GoogleAuthState> {
  GoogleAuthScreen({super.key})
    : super(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!.getErrorMessage())),
            );
            context.read<GoogleAuthCubit>().clearError();
          }
        },
      );

  void onSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TabsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 34, 4, 50).withAlpha(180),
                    const Color.fromARGB(255, 4, 24, 114).withAlpha(180),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.anonka,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 12, 26, 177),
                            Color.fromARGB(255, 11, 59, 98),
                          ],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(80),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.speakFreely,
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.remainAnonym,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      color: Colors.white.withAlpha(220),
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 6,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90),
            // google sign in
            SizedBox(
              width: size.width * 0.85,
              height: size.height * 0.07,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => bloc.signInWithGoogle(onSuccess),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 10, 10, 94).withAlpha(200),
                        const Color.fromARGB(96, 39, 0, 212).withAlpha(200),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: state.isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://www.google.com/favicon.ico',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppStrings.signInWithGoogle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
