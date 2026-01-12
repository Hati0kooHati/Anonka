import 'package:anonka/src/core/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await _googleSignIn.initialize(serverClientId: kFirebaseServerClientId);
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.authenticate(scopeHint: ["email"]);

    final googleAuth = googleUser.authentication;

    final authClient = _googleSignIn.authorizationClient;
    final authorization = await authClient.authorizationForScopes(["email"]);

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: authorization?.accessToken,
    );

    FirebaseAuth.instance.signInWithCredential(credential);
  }
}
