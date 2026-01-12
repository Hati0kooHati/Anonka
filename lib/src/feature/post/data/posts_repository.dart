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
          .orderBy("createdAt", descending: true)
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
      "likes": isSetLike
          ? FieldValue.arrayUnion([userEmail])
          : FieldValue.arrayRemove([userEmail]),
    });
  }

  Future<void> toggleDislike({
    required String postId,
    required bool isSetDislike,
    required String userEmail,
    required String channel,
  }) async {
    _firestore.collection(channel).doc(postId).update({
      "dislikes": isSetDislike
          ? FieldValue.arrayUnion([userEmail])
          : FieldValue.arrayRemove([userEmail]),
    });
  }
}
