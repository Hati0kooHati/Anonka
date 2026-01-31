import 'package:anonka/src/feature/create_post/presentation/cubit/create_post_state.dart';
import 'package:anonka/src/feature/create_post/data/create_post_repository.dart';
import 'package:anonka/src/feature/create_post/model/create_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostRepository createPostRepository;
  final String userEmail;

  CreatePostCubit(this.createPostRepository, FirebaseAuth firebaseAuth)
    : userEmail =
          firebaseAuth.currentUser?.uid ??
          (throw Error.throwWithStackTrace(
            "тут не должно быть null т.к в app/presentation/widgets/auth_gate_widget мы проверяем",
            StackTrace.current,
          )),
      super(CreatePostState());

  final String channel = "mukr_west_college";

  void createPost({required String text}) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    print(state.isLoading);

    try {
      final CreatePost createPost = CreatePost(
        userEmail: userEmail,
        text: text,
      );

      await Future.delayed(Duration(seconds: 4));

      await createPostRepository.createPost(
        createPost: createPost,
        channel: channel,
      );

      emit(state.copyWith(isLoading: false, isPostCreated: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
