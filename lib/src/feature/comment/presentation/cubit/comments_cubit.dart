import 'package:anonka/src/feature/comment/data/comments_repository.dart';
import 'package:anonka/src/feature/comment/model/comment.dart';
import 'package:anonka/src/feature/comment/presentation/cubit/comments_state.dart';
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
            'тут не должно быть null',
            StackTrace.current,
          )),
      super(const CommentsState()) {
    loadInitial();
  }

  DocumentSnapshot? commentLastDoc;
  bool hasMore = true;
  final int limit = 10;
  final String channel = 'mukr_west_college';
  final Map<String, DocumentSnapshot> _subCommentLastDocs = {};

  // ── top-level loading ────────────────────────────────────────────────────────

  void loadInitial() async {
    try {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true));

      final snap = await commentRepository.loadComments(
        channel: channel,
        limit: limit,
        postId: postId,
        userEmail: userEmail,
        lastDoc: null,
      );

      final comments = snap.docs.map(Comment.fromDoc).toList();
      if (comments.isNotEmpty) commentLastDoc = snap.docs.last;
      hasMore = comments.length == limit;

      emit(state.copyWith(comments: comments, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  void loadMore() async {
    if (state.isLoading || commentLastDoc == null || !hasMore) return;

    try {
      emit(state.copyWith(isLoading: true));

      final snap = await commentRepository.loadComments(
        channel: channel,
        limit: limit,
        userEmail: userEmail,
        postId: postId,
        lastDoc: commentLastDoc,
      );

      final more = snap.docs.map(Comment.fromDoc).toList();
      if (snap.docs.isNotEmpty) commentLastDoc = snap.docs.last;
      hasMore = more.length == limit;

      emit(
        state.copyWith(
          comments: [...state.comments, ...more],
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  // ── subcomments ──────────────────────────────────────────────────────────────────

  // поле в классе

  Future<void> loadSubComments({required String commentId}) async {
    const int subLimit = 10;

    final lastDoc = _subCommentLastDocs[commentId];

    final snap = await commentRepository.loadSubComments(
      channel: channel,
      postId: postId,
      commentId: commentId,
      limit: subLimit,
      lastDoc: lastDoc,
    );

    if (snap.docs.isEmpty) return;

    _subCommentLastDocs[commentId] = snap.docs.last;

    final newSubs = snap.docs.map(Comment.fromDoc).toList();

    final updated = state.comments.map((c) {
      if (c.id != commentId) return c;
      return c.copyWith(subComments: [...c.subComments, ...newSubs]);
    }).toList();

    emit(state.copyWith(comments: updated));
  }

  // ── sending ──────────────────────────────────────────────────────────────────

  void sendComment({required String text}) async {
    final replyingTo = state.replyingTo;

    // clear reply bar immediately
    emit(state.copyWith(replyingTo: null));

    try {
      if (replyingTo != null) {
        // ── sub-comment ──

        // bump count locally so the UI updates without a full reload
        final updated = state.comments.map((c) {
          if (c.id == replyingTo.id) {
            return Comment(
              id: c.id,
              text: c.text,
              createdAt: c.createdAt,
              subCommentsCount: c.subCommentsCount + 1,
              subComments: [
                Comment(id: "", text: text, createdAt: DateTime.now()),
                ...c.subComments,
              ],
            );
          }
          return c;
        }).toList();

        emit(state.copyWith(comments: updated));

        await commentRepository.createSubComment(
          channel: channel,
          postId: postId,
          commentId: replyingTo.id,
          userEmail: userEmail,
          text: text,
        );
      } else {
        // ── top-level comment ──
        final optimistic = Comment(
          id: 'optimistic_${DateTime.now().millisecondsSinceEpoch}',
          text: text,
          createdAt: DateTime.now(),
        );

        emit(state.copyWith(comments: [optimistic, ...state.comments]));

        await commentRepository.createComment(
          commentText: text,
          postId: postId,
          userEmail: userEmail,
        );

        await postsRepository.increaseCommentsCount(
          channel: channel,
          postId: postId,
          userEmail: userEmail,
        );
      }
    } catch (e) {
      emit(state.copyWith(error: e));
    }
  }

  // ── reply state ──────────────────────────────────────────────────────────────

  void setReplyingTo(Comment comment) =>
      emit(state.copyWith(replyingTo: comment));

  void clearReplyingTo() => emit(state.copyWith(replyingTo: null));

  void clearError() => emit(state.copyWith(error: null));
}
