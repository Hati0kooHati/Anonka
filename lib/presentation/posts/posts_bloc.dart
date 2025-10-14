import 'package:anonka/models/post.dart';
import 'package:anonka/presentation/posts/posts_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PostsBloc extends Cubit<PostsState> {
  PostsBloc() : super(PostsState());

  final String? user = FirebaseAuth.instance.currentUser?.email;

  Function(dynamic e)? showError;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDoc;
  static const int pageSize = 10;

  bool onScrollNotification(ScrollEndNotification scrollInfo) {
    final isAtBottom =
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;

    if (isAtBottom && !state.isLoading) {
      loadMore();
    }

    return false;
  }

  Future<void> refresh() async {
    if (state.isLoading) return;

    emit(state.copyWith(posts: [], hasMore: true));

    loadInitial();
    return Future.delayed(const Duration(seconds: 0));
  }

  Future<void> loadInitial() async {
    emit(state.copyWith(isLoading: true));

    try {
      final snap = await _firestore
          .collection("mukr_west_college")
          .orderBy("createdAt", descending: true)
          .limit(pageSize)
          .get();
      final posts = snap.docs.map((doc) => Post.fromDoc(doc)).toList();

      if (snap.docs.isNotEmpty) {
        _lastDoc = snap.docs.last;
      }

      emit(
        state.copyWith(
          posts: posts,
          isLoading: false,
          hasMore: posts.length == pageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("loadInitial - $e");
      showError?.call(e);
    }
  }

  void loadMore() async {
    if (!state.hasMore || state.isLoading || _lastDoc == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      final snap = await _firestore
          .collection("mukr_west_college")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(_lastDoc!)
          .limit(pageSize)
          .get();

      final posts = snap.docs.map((doc) => Post.fromDoc(doc)).toList();
      _lastDoc = snap.docs.last;

      emit(
        state.copyWith(
          posts: [...state.posts, ...posts],
          isLoading: false,
          hasMore: posts.length == pageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      showError?.call(e);
    }
  }

  void toggleLike(Post post) {
    if (user == null) return;

    try {
      final newPosts = [...state.posts];

      if (post.likes.contains(user)) {
        final postIndex = newPosts.indexOf(post);

        final newPostlikes = newPosts[postIndex].likes.toList();

        newPostlikes.remove(user);

        newPosts[postIndex] = post.copyWith(likes: newPostlikes);

        emit(state.copyWith(posts: newPosts));

        _firestore.collection("mukr_west_college").doc(post.postId).update({
          "likes": FieldValue.arrayRemove([user]),
        });
      } else {
        newPosts[newPosts.indexOf(post)] = post.copyWith(
          likes: [user!, ...post.likes],
        );

        _firestore.collection("mukr_west_college").doc(post.postId).update({
          "likes": FieldValue.arrayUnion([user]),
        });
      }

      emit(state.copyWith(posts: newPosts));
    } catch (e) {
      showError?.call(e);
    }
  }

  void toggleDislike(Post post) {
    if (user == null) return;

    try {
      final newPosts = [...state.posts];

      if (post.dislikes.contains(user)) {
        final postIndex = newPosts.indexOf(post);

        final newPostDislikes = newPosts[postIndex].dislikes.toList();

        newPostDislikes.remove(user);

        newPosts[postIndex] = post.copyWith(dislikes: newPostDislikes);

        _firestore.collection("mukr_west_college").doc(post.postId).update({
          "dislikes": FieldValue.arrayRemove([user]),
        });
      } else {
        newPosts[newPosts.indexOf(post)] = post.copyWith(
          dislikes: [user!, ...post.dislikes],
        );

        _firestore.collection("mukr_west_college").doc(post.postId).update({
          "dislikes": FieldValue.arrayUnion([user]),
        });
      }

      emit(state.copyWith(posts: newPosts));
    } catch (e) {
      showError?.call(e);
    }
  }

  void sendComment({
    required TextEditingController commentController,
    required Post post,
  }) {
    try {
      final newPosts = [...state.posts];
      final String text = commentController.text;

      if (text.isEmpty) return;

      _firestore
          .collection("mukr_west_college")
          .doc(post.postId)
          .collection("comments")
          .add({"text": text});

      newPosts[newPosts.indexOf(post)] = post.copyWith(
        comments: [text, ...post.comments],
      );

      emit(state.copyWith(posts: newPosts));

      commentController.clear();
    } catch (e) {
      showError?.call(e);
    }
  }
}
