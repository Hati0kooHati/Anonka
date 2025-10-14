import 'package:anonka/presentation/add_post/add_post_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPostBloc extends Cubit<AddPostState> {
  AddPostBloc() : super(AddPostState());

  Function? showSnackBar;
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  void publish({
    required TextEditingController textController,
    required Function onSuccess,
  }) async {
    if (user == null || state.isLoading) return;

    final String text = textController.text.trim();

    if (text.length < 5) {
      showSnackBar?.call(Text("Че так мало ? 👊"));

      return;
    }

    if (text.length > 2000) {
      showSnackBar?.call(Text("Бро, пиши поменьше 😑"));

      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final text = textController.text;

      await _firestore.collection('mukr_west_college').add({
        'userGmail': user!.email,
        'createdAt': FieldValue.serverTimestamp(),
        'text': text,
        'likes': [],
        'dislikes': [],
        'comments': [],
      });

      showSnackBar?.call(Text("Опубликовано! 🚀"));

      await Future.delayed(Duration(milliseconds: 1300));

      onSuccess();
      textController.clear();
    } catch (e) {
      showSnackBar?.call(Text("Произошла ошибка ⚠️"));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
