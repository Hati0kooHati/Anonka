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

  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  static const int pageSize = 5;

  void loadInitial({
    required Function onSuccess,
    required Function(dynamic e) onFailed,
  }) async {
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

      onSuccess();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("CommentsBloc loadInitial - $e");

      onFailed(e);
    }
  }

  void loadMore({
    required Function onSuccess,
    required Function(dynamic e) onFailed,
  }) async {
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

      onSuccess();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("CommentsBloc loadMore - $e");
      onFailed(e);
    }
  }

  Future<void> refresh({
    required Function onSuccess,
    required Function(dynamic e) onFailed,
  }) async {
    if (state.isLoading) return;

    _clear();

    loadInitial(onSuccess: onSuccess, onFailed: onFailed);
  }

  void sendComment({
    required String text,
    required Function onSuccess,
    required Function(dynamic e) onFailed,
  }) {
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

      onSuccess();
    } catch (e) {
      debugPrint("CommentsBloc sendComment - $e");
      onFailed(e);
    }
  }

  void _clear() {
    emit(state.copyWith(isLoading: false, comments: []));
    _lastDoc = null;
  }
}
