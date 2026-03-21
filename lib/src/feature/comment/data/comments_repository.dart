import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class CommentsRepository {
  final FirebaseFirestore _firestore;

  CommentsRepository(this._firestore);

  // ── top-level comments ──────────────────────────────────────────────────────

  Future<QuerySnapshot<Map<String, dynamic>>> loadComments({
    required String postId,
    required String channel,
    required String userEmail,
    required int limit,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    var query = _firestore
        .collection(channel)
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) query = query.startAfterDocument(lastDoc);
    return query.get();
  }

  Future<void> createComment({
    required String postId,
    required String userEmail,
    required String commentText,
  }) {
    return _firestore
        .collection('mukr_west_college')
        .doc(postId)
        .collection('comments')
        .add({
          'text': commentText,
          'author': userEmail,
          'createdAt': FieldValue.serverTimestamp(),
          'sub_comments_count': 0,
        });
  }

  // ── sub-comments ────────────────────────────────────────────────────────────

  Future<QuerySnapshot<Map<String, dynamic>>> loadSubComments({
    required String channel,
    required String postId,
    required String commentId,
    required int limit,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    var query = _firestore
        .collection(channel)
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('sub_comments')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) query = query.startAfterDocument(lastDoc);
    return query.get();
  }

  Future<void> createSubComment({
    required String channel,
    required String postId,
    required String commentId,
    required String userEmail,
    required String text,
  }) async {
    final batch = _firestore.batch();

    final subRef = _firestore
        .collection(channel)
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('sub_comments')
        .doc();

    batch.set(subRef, {
      'text': text,
      'author': userEmail,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final postRef = _firestore.collection(channel).doc(postId);

    final commentRef = _firestore
        .collection(channel)
        .doc(postId)
        .collection('comments')
        .doc(commentId);

    batch.update(commentRef, {'sub_comments_count': FieldValue.increment(1)});
    batch.update(postRef, {"comments_count": FieldValue.increment(1)});

    await batch.commit();
  }
}
