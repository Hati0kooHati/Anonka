import 'package:anonka/models/comment.dart';
import 'package:anonka/presentation/comment/comments_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CommentsBloc extends Cubit<CommentsState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final String postId;

  CommentsBloc(@factoryParam this.postId, this._firestore, this._firebaseAuth)
    : super(CommentsState());

  Function(dynamic e)? showError;
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  static const int pageSize = 5;

  void loadInitial() async {
    try {
      if (state.isLoading) return;

      emit(state.copyWith(isLoading: true));

      final snap = await _firestore
          .collection("mukr_west_college")
          .doc(postId)
          .collection("comments")
          .orderBy("createdAt", descending: true)
          .limit(pageSize)
          .get();

      final comments = snap.docs.map((doc) => Comment.fromDoc(doc)).toList();

      if (comments.isNotEmpty) {
        _lastDoc = snap.docs.last;
      }

      _hasMore = comments.length == pageSize;
      emit(state.copyWith(comments: comments, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("CommentsBloc loadInitial - $e");
      showError?.call(e);
    }
  }

  bool onScrollNotification(ScrollEndNotification scrollInfo) {
    final isAtBottom =
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;

    if (isAtBottom && !state.isLoading) {
      loadMore();
    }

    return false;
  }

  void loadMore() async {
    if (state.isLoading || _lastDoc == null || !_hasMore) return;

    try {
      final snap = await _firestore
          .collection("mukr_west_college")
          .doc(postId)
          .collection("comments")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(_lastDoc!)
          .limit(pageSize)
          .get();

      final List<Comment> comments = snap.docs
          .map((doc) => Comment.fromDoc(doc))
          .toList();

      _lastDoc = snap.docs.last;
      _hasMore = comments.length == pageSize;

      emit(
        state.copyWith(
          comments: [...comments, ...state.comments],
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("CommentsBloc loadMore - $e");
      showError?.call(e);
    }
  }

  Future<void> refresh() async {
    if (state.isLoading) return;

    _clear();

    loadInitial();
  }

  void sendComment({required String text}) {
    final String? userEmail = _firebaseAuth.currentUser?.email;

    if (userEmail == null || text.trim().isEmpty) return;

    final serverTimestamp = FieldValue.serverTimestamp();

    final newComment = Comment(
      text: text,
      authorEmail: userEmail,
      createdAt: DateTime.now(),
    );
    final newComments = [newComment, ...state.comments];

    try {
      _firestore
          .collection("mukr_west_college")
          .doc(postId)
          .collection("comments")
          .add({
            "text": newComment.text,
            "author": userEmail,
            "createdAt": serverTimestamp,
          });

      emit(state.copyWith(comments: newComments));
    } catch (e) {
      showError?.call(e);
    }
  }

  void _clear() {
    emit(state.copyWith(isLoading: false, comments: []));
    _lastDoc = null;
  }
}
