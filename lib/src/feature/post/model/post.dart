import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.isLiked,
    required this.isDisliked,
    required this.likesCount,
    required this.dislikesCount,
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final bool isLiked;
  final bool isDisliked;
  final int likesCount;
  final int dislikesCount;

  factory Post.fromDoc({
    required DocumentSnapshot<Map<String, dynamic>> doc,
    required String userEmail,
  }) {
    final data = doc.data()!;
    return Post(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: ((data['created_at'] ?? Timestamp.now()) as Timestamp)
          .toDate(),
      isLiked: ((data['liked_users'] as List?) ?? []).contains(userEmail),
      isDisliked: ((data['disliked_users'] as List?) ?? []).contains(userEmail),
      likesCount: data['likes_count'],
      dislikesCount: data['dislikes_count'],
    );
  }

  Post copyWith({
    String? id,
    String? userGmail,
    String? text,
    DateTime? createdAt,
    bool? isLiked,
    bool? isDisliked,
    int? likesCount,
    int? dislikesCount,
  }) {
    return Post(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
    );
  }
}
