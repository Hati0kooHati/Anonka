import 'package:anonka/core/constants.dart';
import 'package:anonka/widgets/custom_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class ErrorHandler {
  static void showSnackbarErrorMessage({
    required dynamic e,
    required BuildContext context,
  }) {
    debugPrint('_ErrorHandler_');
    debugPrint('error: $e');
    String text = 'Ошибка. Попробуйте позже';

    if (e is FirebaseAuthException) {
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
          text = AppStrings.tooManyRequests;
          break;
        default:
          text = AppStrings.unknownError;
      }
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    CustomSnackBar.showSnackBar(context, content: Text(text));
  }
}
