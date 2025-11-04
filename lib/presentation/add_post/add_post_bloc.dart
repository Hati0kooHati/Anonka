import 'package:anonka/constants.dart';
import 'package:anonka/presentation/add_post/add_post_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPostBloc extends Cubit<AddPostState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth? _firebaseAuth;

  AddPostBloc(this._firestore, this._firebaseAuth) : super(AddPostState());

  Function({
    required Widget content,
    required Color color,
    required Duration duration,
  })?
  showSnackBar;

  void publish({
    required TextEditingController textController,
    required Function onSuccess,
  }) async {
    final String text = textController.text.trim();

    if (_firebaseAuth?.currentUser?.email == null ||
        state.isLoading ||
        text.isEmpty)
      return;

    if (text.length < 5) {
      showSnackBar?.call(
        content: Text(AppStrings.shortTextLength),
        color: Colors.yellow,
        duration: Duration(seconds: 3),
      );

      return;
    }

    if (text.length > 2000) {
      showSnackBar?.call(
        content: Text(AppStrings.longTextLength),
        color: Colors.yellow,
        duration: Duration(seconds: 3),
      );

      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final text = textController.text;

      await _firestore.collection('mukr_west_college').add({
        'userGmail': _firebaseAuth!.currentUser!.email,
        'createdAt': FieldValue.serverTimestamp(),
        'text': text,
        'likes': [],
        'dislikes': [],
      });

      showSnackBar?.call(
        content: Text("Опубликовано! 🚀"),
        color: Colors.green,
        duration: Duration(milliseconds: 600),
      );

      await Future.delayed(Duration(milliseconds: 1300));
      onSuccess();
      textController.clear();
    } catch (e) {
      showSnackBar?.call(
        content: Text("Произошла ошибка ⚠️"),
        color: Colors.red,
        duration: Duration(seconds: 3),
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
