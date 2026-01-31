import 'package:anonka/src/feature/post/comment/data/comments_repository.dart';
import 'package:anonka/src/feature/post/comment/model/comment.dart';
import 'package:anonka/src/feature/post/comment/presentation/cubit/comments_state.dart';
import 'package:anonka/src/feature/post/data/posts_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CommentsCubit extends Cubit<CommentsState> {
  final String postId;
  final PostsRepository postsRepository;
  final CommentsRepository commentRepository;
  final String userEmail;

  CommentsCubit(
    @factoryParam this.postId,
    this.postsRepository,
    this.commentRepository,
    FirebaseAuth firebaseAuth,
  ) : userEmail =
          firebaseAuth.currentUser?.uid ??
          (throw Error.throwWithStackTrace(
            "тут не должно быть null т.к в app/presentation/widgets/auth_gate_widget мы проверяем",
            StackTrace.current,
          )),
      super(CommentsState()) {
    loadInitial();
  }

  DocumentSnapshot? lastDoc;
  bool hasMore = true;
  final int limit = 10;
  final String channel = "mukr_west_college";

  void loadInitial() async {
    try {
      if (state.isLoading) return;

      emit(state.copyWith(isLoading: true));

      final QuerySnapshot<Map<String, dynamic>> snap = await commentRepository
          .loadComments(
            channel: channel,
            limit: limit,
            postId: postId,
            userEmail: userEmail,
            lastDoc: lastDoc,
          );

      final List<Comment> comments = snap.docs
          .map((doc) => Comment.fromDoc(doc))
          .toList();

      if (comments.isNotEmpty) {
        lastDoc = snap.docs.last;
      }

      hasMore = comments.length == limit;

      emit(state.copyWith(comments: comments, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  void loadMore() async {
    if (state.isLoading || lastDoc == null || !hasMore) return;

    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await commentRepository
          .loadComments(
            channel: channel,
            limit: limit,
            userEmail: userEmail,
            postId: postId,
            lastDoc: lastDoc,
          );

      final List<Comment> comments = snap.docs
          .map((doc) => Comment.fromDoc(doc))
          .toList();

      lastDoc = snap.docs.last;
      hasMore = comments.length == limit;

      emit(
        state.copyWith(
          comments: [...comments, ...state.comments],
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  Future<void> refresh() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: false, comments: []));
    lastDoc = null;

    loadInitial();
  }

  void sendComment({required String text}) {
    final newComments = [
      Comment(text: text, createdAt: DateTime.now()),
      ...state.comments,
    ];

    try {
      commentRepository.createComment(
        commentText: text,
        postId: postId,
        userEmail: userEmail,
      );

      postsRepository.increaseCommentsCount(
        channel: channel,
        postId: postId,
        userEmail: userEmail,
      );

      emit(state.copyWith(comments: newComments));
    } catch (e) {
      emit(state.copyWith(error: e));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
