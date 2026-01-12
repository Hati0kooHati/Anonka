import 'package:anonka/src/feature/post/data/posts_repository.dart';
import 'package:anonka/src/feature/post/model/post.dart';
import 'package:anonka/src/feature/post/cubit/posts_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PostsCubit extends Cubit<PostsState> {
  final PostsRepository postsRepository;

  final String userEmail;

  PostsCubit(this.postsRepository, FirebaseAuth firebaseAuth)
    : userEmail =
          firebaseAuth.currentUser?.uid ??
          (throw Error.throwWithStackTrace(
            "тут не должно быть null т.к в app/presentation/widgets/auth_gate_widget мы проверяем",
            StackTrace.current,
          )),
      super(PostsState());

  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  final int limit = 10;
  final String channel = "bishkek_11_school";

  Future<void> refresh() async {
    if (state.isLoading) return;

    _lastDoc = null;

    loadInitial();
  }

  Future<void> loadInitial() async {
    emit(state.copyWith(isLoading: true, posts: []));

    try {
      final snap = await postsRepository.loadPosts(
        limit: limit,
        channel: channel,
      );

      final posts = snap.docs
          .map((doc) => Post.fromDoc(doc: doc, userEmail: userEmail))
          .toList();

      if (snap.docs.isNotEmpty) {
        _lastDoc = snap.docs.last;
      }

      emit(state.copyWith(posts: posts, isLoading: false));

      _hasMore = posts.length == limit;
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  void loadMore() async {
    if (!_hasMore || state.isLoading || _lastDoc == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      final snap = await postsRepository.loadPosts(
        channel: channel,
        limit: limit,
        lastDoc: _lastDoc,
      );

      final posts = snap.docs
          .map((doc) => Post.fromDoc(doc: doc, userEmail: userEmail))
          .toList();
      _lastDoc = snap.docs.last;

      emit(state.copyWith(posts: [...state.posts, ...posts], isLoading: false));

      _hasMore = posts.length == limit;
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  void toggleLike({required Post post, required int postIndex}) {
    final updatedPosts = [...state.posts];
    final updatedPost = updatedPosts[postIndex];

    final bool updatedIsLiked = updatedPost.isLiked;

    updatedPosts[postIndex] = updatedPost.copyWith(isLiked: !updatedIsLiked);

    emit(state.copyWith(posts: updatedPosts));

    try {
      postsRepository.toggleLike(
        postId: updatedPost.id,
        isSetLike: !updatedIsLiked,
        userEmail: userEmail,
        channel: channel,
      );
    } catch (e) {
      emit(state.copyWith(error: e));
    }
  }

  void toggleDislike({required Post post, required int postIndex}) {
    final updatedPosts = [...state.posts];
    final updatedPost = updatedPosts[postIndex];

    final bool updatedIsDisliked = !updatedPost.isDisliked;

    updatedPosts[postIndex] = updatedPost.copyWith(
      isDisliked: updatedIsDisliked,
    );

    emit(state.copyWith(posts: updatedPosts));

    try {
      postsRepository.toggleDislike(
        postId: updatedPost.id,
        isSetDislike: updatedIsDisliked,
        userEmail: userEmail,
        channel: channel,
      );
    } catch (e) {
      emit(state.copyWith(error: e));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
