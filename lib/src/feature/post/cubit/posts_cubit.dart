import 'package:anonka/src/feature/post/model/post.dart';
import 'package:anonka/src/feature/post/cubit/posts_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PostsCubit extends Cubit<PostsState> {
  final FirebaseFirestore _firestore;

  PostsCubit(this._firestore, firebaseAuth)
    : userEmail =
          firebaseAuth.currentUser?.uid ??
          "тут не должно быть null т.к в app/presentation/widgets/auth_gate_widget мы проверяем",
      super(PostsState());

  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  final int pageLimit = 5;

  final String userEmail;

  Future<void> refresh({required Function(dynamic e) onFailed}) async {
    if (state.isLoading) return;

    clear();

    loadInitial(onFailed: onFailed);
  }

  Future<void> loadInitial({required Function(dynamic e) onFailed}) async {
    emit(state.copyWith(isLoading: true));

    try {
      final snap = await _firestore
          .collection("mukr_west_college")
          .orderBy("created_at", descending: true)
          .limit(pageLimit)
          .get();
      final posts = snap.docs.map((doc) => Post.fromDoc(doc)).toList();

      if (snap.docs.isNotEmpty) {
        _lastDoc = snap.docs.last;
      }

      emit(state.copyWith(posts: posts, isLoading: false));

      _hasMore = posts.length == pageLimit;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("PostsCubit loadInitial - $e");

      onFailed(e);
    }
  }

  void loadMore({required Function(dynamic e) onFailed}) async {
    if (!_hasMore || state.isLoading || _lastDoc == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      final snap = await _firestore
          .collection("mukr_west_college")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(_lastDoc!)
          .limit(pageLimit)
          .get();

      final posts = snap.docs.map((doc) => Post.fromDoc(doc)).toList();
      _lastDoc = snap.docs.last;

      emit(state.copyWith(posts: [...state.posts, ...posts], isLoading: false));

      _hasMore = posts.length == pageLimit;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("PostsCubit loadMore - $e");

      onFailed(e);
    }
  }

  void toggleLike(Post post) {
    try {
      final newPosts = [...state.posts];

      if (post.likes.contains(userEmail)) {
        final postIndex = newPosts.indexOf(post);

        final newPostlikes = newPosts[postIndex].likes.toList();

        newPostlikes.remove(userEmail);

        newPosts[postIndex] = post.copyWith(likes: newPostlikes);

        emit(state.copyWith(posts: newPosts));

        _firestore.collection("mukr_west_college").doc(post.id).update({
          "likes": FieldValue.arrayRemove([userEmail]),
        });
      } else {
        newPosts[newPosts.indexOf(post)] = post.copyWith(
          likes: [userEmail, ...post.likes],
        );

        _firestore.collection("mukr_west_college").doc(post.id).update({
          "likes": FieldValue.arrayUnion([userEmail]),
        });
      }

      emit(state.copyWith(posts: newPosts));
    } catch (e) {
      debugPrint("PostsCubit toggleLike - e");
    }
  }

  void toggleDislike(Post post) {
    try {
      final newPosts = [...state.posts];

      if (post.dislikes.contains(userEmail)) {
        final postIndex = newPosts.indexOf(post);

        final newPostDislikes = newPosts[postIndex].dislikes.toList();

        newPostDislikes.remove(userEmail);

        newPosts[postIndex] = post.copyWith(dislikes: newPostDislikes);

        _firestore.collection("mukr_west_college").doc(post.id).update({
          "dislikes": FieldValue.arrayRemove([userEmail]),
        });
      } else {
        newPosts[newPosts.indexOf(post)] = post.copyWith(
          dislikes: [userEmail, ...post.dislikes],
        );

        _firestore.collection("mukr_west_college").doc(post.id).update({
          "dislikes": FieldValue.arrayUnion([userEmail]),
        });
      }

      emit(state.copyWith(posts: newPosts));
    } catch (e) {
      debugPrint("PostsCubit toggleDislike - e");
    }
  }

  void clear() {
    emit(state.copyWith(posts: []));
    _lastDoc = null;
  }
}
