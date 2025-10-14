import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required final String postId,
    required final String text,
    required final Timestamp createdAt,
    required final List likes,
    required final List dislikes,
    required final List comments,
  }) = _Post;

  factory Post.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Post(
      postId: doc.id,
      text: data['text'] ?? '',
      createdAt: data['createdAt'] as Timestamp,
      comments: doc['comments'],
      likes: doc['likes'],
      dislikes: doc['dislikes'],
    );
  }
}
