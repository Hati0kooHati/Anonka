import 'dart:io';
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
    String text = 'Ошибка. Попробуйте позже';

    if (e is SocketException) {
      debugPrint('_SocketException_: ${e.toString()}');
      text =
          'Проблема с подключением к серверу. Проверьте интернет-соединение или повторите попытку позже.';
    } else if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
          text = 'Неверные учетные данные.';
          break;
        case 'user-disabled':
          text = 'Ты заблокирован.';
          break;
        case 'network-request-failed':
          text = 'Проблемы с интернетом';
          break;
        case 'app-not-authorized':
          text = 'Я сам хз';
          break;
        case 'too-many-requests':
          text = 'Ты заспамил. Попробуй позже';
          break;
        default:
          text = 'Неизвестная ошибка ${e.code} — ${e.message}';
      }
    } else {
      debugPrint('error type : $e');
      String message = e.toString();
      if (message.contains('Failed host lookup')) {
        text = 'Проблема с сервером или с доступом в интернет';
      } else if (message.contains('Connection refused')) {
        text = 'В соединении отказано';
      } else if (message.contains('Cannot query field')) {
        text = 'Ошибка при чтении поля';
      } else {
        text = message;
      }
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    CustomSnackBar.showSnackBar(context, content: Text(text));
  }
}
