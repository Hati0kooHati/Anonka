import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  Future<void> _initizalize() async {
    await _googleSignIn.initialize(
      serverClientId:
          "877574020248-q2uddkgc3l497uusk8062u9teqcmt1mk.apps.googleusercontent.com",
    );

    _initialized = true;
  }

  Future<dynamic> signInWithGoogle() async {
    if (!_initialized) {
      await _initizalize();
    }

    try {
      final googleUser = await _googleSignIn.authenticate(scopeHint: ["email"]);

      final googleAuth = googleUser.authentication;

      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(["email"]);

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authorization?.accessToken,
      );

      FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      return e;
    }
  }
}
