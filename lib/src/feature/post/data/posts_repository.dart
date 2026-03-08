import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class PostsRepository {
  final FirebaseFirestore _firestore;

  PostsRepository(this._firestore);

  Future<QuerySnapshot<Map<String, dynamic>>> loadPosts({
    required int limit,
    required String channel,
    DocumentSnapshot? lastDoc,
  }) {
    if (lastDoc == null) {
      return _firestore
          .collection(channel)
          .orderBy("created_at", descending: true)
          .limit(limit)
          .get();
    } else {
      return _firestore
          .collection(channel)
          .orderBy("created_at", descending: true)
          .startAfterDocument(lastDoc)
          .limit(limit)
          .get();
    }
  }

  Future<void> toggleLike({
    required String postId,
    required bool isSetLike,
    required String userEmail,
    required String channel,
  }) async {
    _firestore.collection(channel).doc(postId).update({
      "likes_count": FieldValue.increment(isSetLike ? 1 : -1),
      "liked_users": isSetLike
          ? FieldValue.arrayUnion([userEmail])
          : FieldValue.arrayRemove([userEmail]),
    });
  }

  Future<void> report({
    required String postId,
    required String reportType,
    required String channel,
  }) async {
    _firestore.collection("reports").doc("$channel $postId").set({
      reportType: FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<void> toggleDislike({
    required String postId,
    required bool isSetDislike,
    required String userEmail,
    required String channel,
  }) async {
    _firestore.collection(channel).doc(postId).update({
      "dislikes_count": FieldValue.increment(isSetDislike ? 1 : -1),
      "disliked_users": isSetDislike
          ? FieldValue.arrayUnion([userEmail])
          : FieldValue.arrayRemove([userEmail]),
    });
  }

  Future<void> increaseCommentsCount({
    required String postId,
    required String userEmail,
    required String channel,
  }) async {
    _firestore.collection(channel).doc(postId).update({
      "comments_count": FieldValue.increment(1),
    });
  }

  /// Vote on a poll option.
  /// [optionIndex] — the index inside poll.options array.
  Future<void> votePoll({
    required String postId,
    required int optionIndex,
    required String userEmail,
    required String channel,
  }) async {
    // Use a transaction so we can update the nested array element atomically.
    await _firestore.runTransaction((transaction) async {
      final docRef = _firestore.collection(channel).doc(postId);
      final snap = await transaction.get(docRef);
      final data = snap.data()!;
      final poll = Map<String, dynamic>.from(data['poll'] as Map);
      final options = List<dynamic>.from(poll['options'] as List);

      // Guard: user already voted somewhere
      for (final opt in options) {
        final votedUsers = List<String>.from(opt['voted_users'] ?? []);
        if (votedUsers.contains(userEmail)) return;
      }

      final option = Map<String, dynamic>.from(options[optionIndex] as Map);
      option['votes_count'] = (option['votes_count'] as int) + 1;
      option['voted_users'] = [
        ...List<String>.from(option['voted_users'] ?? []),
        userEmail,
      ];
      options[optionIndex] = option;
      poll['options'] = options;
      poll['total_votes'] = (poll['total_votes'] as int) + 1;

      transaction.update(docRef, {'poll': poll});
    });
  }
}