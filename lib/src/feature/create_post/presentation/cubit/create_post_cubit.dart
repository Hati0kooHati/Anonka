import 'package:anonka/src/feature/create_post/model/create_poll.dart';
import 'package:anonka/src/feature/create_post/presentation/cubit/create_post_state.dart';
import 'package:anonka/src/feature/create_post/data/create_post_repository.dart';
import 'package:anonka/src/feature/create_post/model/create_post.dart';
import 'package:anonka/src/feature/post/model/post.dart';
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

  // ── Poll mode ────────────────────────────────────────────────────────────

  void togglePollMode() {
    emit(state.copyWith(isPollMode: !state.isPollMode));
  }

  void updatePollOption(int index, String value) {
    final updated = List<String>.from(state.pollOptions);
    updated[index] = value;
    emit(state.copyWith(pollOptions: updated));
  }

  void addPollOption() {
    if (state.pollOptions.length >= 10) return;
    emit(state.copyWith(pollOptions: [...state.pollOptions, '']));
  }

  void removePollOption(int index) {
    if (state.pollOptions.length <= 2) return;
    final updated = List<String>.from(state.pollOptions)..removeAt(index);
    emit(state.copyWith(pollOptions: updated));
  }

  // ── Create ───────────────────────────────────────────────────────────────

  void createPost({required String text}) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    try {
      final Post createdPost = await createPostRepository.createPost(
        createPost: CreatePost(userEmail: userEmail, text: text),
        channel: channel,
      );

      emit(state.copyWith(isLoading: false, createdPost: createdPost));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  void createPoll({required String question}) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    try {
      final Post createdPost = await createPostRepository.createPost(
        createPost: CreatePost(
          userEmail: userEmail,
          text: question,
          poll: CreatePoll(question: question, options: state.pollOptions),
        ),
        channel: channel,
      );

      emit(state.copyWith(isLoading: false, createdPost: createdPost));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  // ── Utils ─────────────────────────────────────────────────────────────────

  void clearError() {
    emit(state.copyWith(error: null));
  }
}