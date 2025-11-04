import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required final String id,
    required final String text,
    required final DateTime createdAt,
    required final List likes,
    required final List dislikes,
  }) = _Post;

  factory Post.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Post(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt:
          ((data['createdAt'] ?? FieldValue.serverTimestamp()) as Timestamp)
              .toDate(),
      likes: doc['likes'] ?? [],
      dislikes: doc['dislikes'] ?? [],
    );
  }
}
