import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  const Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    this.subCommentsCount = 0,
    this.subComments = const [],
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final int subCommentsCount;
  final List<Comment> subComments;

  factory Comment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Comment(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: ((data['createdAt'] ?? Timestamp.now()) as Timestamp).toDate(),
      subCommentsCount: (data['sub_comments_count'] as int?) ?? 0,
      // будем загружать с pagination
      subComments: const [],
    );
  }

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    int? subCommentsCount,
    List<Comment>? subComments,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      subCommentsCount: subCommentsCount ?? this.subCommentsCount,
      subComments: subComments ?? this.subComments,
    );
  }
}
