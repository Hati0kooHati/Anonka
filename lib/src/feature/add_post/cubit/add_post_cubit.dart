import 'package:anonka/src/feature/add_post/cubit/add_post_state.dart';
import 'package:anonka/src/feature/add_post/data/add_post_repository.dart';
import 'package:anonka/src/feature/add_post/model/add_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPostCubit extends Cubit<AddPostState> {
  AddPostCubit(this.addPostRepository, this.firebaseAuth)
    : super(AddPostState());

  final AddPostRepository addPostRepository;
  final FirebaseAuth? firebaseAuth;

  void addPost({
    required String text,
    required Function onSuccess,
    required Function(dynamic e) onFailed,
  }) async {
    final userGmail = firebaseAuth?.currentUser?.email;

    if (userGmail == null || state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      await addPostRepository.addPost(
        addPost: AddPost(userGmail: userGmail, text: text),
      );

      onSuccess();

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      debugPrint("AddPostBloc publish - $e");
      onFailed(e);

      emit(state.copyWith(isLoading: false));
    }
  }
}
