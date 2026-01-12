import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension ErrorMapping on Object {
  String getErrorMessage() {
    String text = 'Попробуйте позже';

    if (this case FirebaseException e) {
      switch (e.code) {
        case 'invalid-credential':
          text = AppStrings.invalidCredential;
          break;
        case 'user-disabled':
          text = AppStrings.userDisabled;
          break;
        case 'network-request-failed':
          text = AppStrings.networkRequestFailed;
          break;
        case 'app-not-authorized':
          text = AppStrings.appNotAuthorized;
          break;
        case 'too-many-requests':
          text = AppStrings.tryLater;
          break;
        default:
          text = AppStrings.unknownError;
      }
    }

    return text;
  }
}
