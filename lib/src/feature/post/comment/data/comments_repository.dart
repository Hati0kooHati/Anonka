import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class CommentsRepository {
  final FirebaseFirestore _firestore;

  CommentsRepository(this._firestore);

  Future<QuerySnapshot<Map<String, dynamic>>> loadComments({
    required String postId,
    required String channel,
    required String userEmail,
    required int limit,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    if (lastDoc == null) {
      return _firestore
          .collection(channel)
          .doc(postId)
          .collection("comments")
          .orderBy("createdAt", descending: true)
          .limit(limit)
          .get();
    } else {
      return _firestore
          .collection(channel)
          .doc(postId)
          .collection("comments")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(lastDoc)
          .limit(limit)
          .get();
    }
  }

  Future<void> createComment({
    required String postId,
    required String userEmail,
    required String commentText,
  }) async {
    _firestore
        .collection("mukr_west_college")
        .doc(postId)
        .collection("comments")
        .add({
          "text": commentText,
          "author": userEmail,
          "createdAt": FieldValue.serverTimestamp(),
        });
  }
}
