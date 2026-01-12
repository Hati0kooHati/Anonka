import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  const Comment({required this.text, required this.createdAt});

  final String text;
  final DateTime createdAt;

  factory Comment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Comment(
      text: doc["text"] ?? "",
      createdAt: ((data['createdAt'] ?? Timestamp.now()) as Timestamp).toDate(),
    );
  }
}
