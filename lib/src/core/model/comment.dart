import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String text,
    required DateTime createdAt,
    String? authorEmail,
  }) = _Comment;

  factory Comment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Comment(
      text: doc["text"] ?? "",
      createdAt:
          ((data['createdAt'] ?? FieldValue.serverTimestamp()) as Timestamp)
              .toDate(),
    );
  }
}
