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

  void publish({
    required String text,
    required Function onSuccess,
    required Function(dynamic e) onFailed,
  }) async {
    if (_firebaseAuth?.currentUser?.email == null || state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      await _firestore.collection('mukr_west_college').add({
        'userGmail': _firebaseAuth!.currentUser!.email,
        'createdAt': FieldValue.serverTimestamp(),
        'text': text,
        'likes': [],
        'dislikes': [],
      });

      await Future.delayed(Duration(milliseconds: 1300));
      onSuccess();
    } catch (e) {
      debugPrint("AddPostBloc publish - $e");
      onFailed(e);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
