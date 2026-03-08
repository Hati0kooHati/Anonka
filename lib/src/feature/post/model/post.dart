import 'package:anonka/src/feature/post/model/poll.dart';
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
    required this.commentsCount,
    this.poll,
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final bool isLiked;
  final bool isDisliked;
  final int likesCount;
  final int dislikesCount;
  final int commentsCount;
  final Poll? poll;

  bool get isPoll => poll != null;

  factory Post.fromDoc({
    required DocumentSnapshot<Map<String, dynamic>> doc,
    required String userEmail,
  }) {
    final data = doc.data()!;
    final rawPoll = data['poll'];

    return Post(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: ((data['created_at'] ?? Timestamp.now()) as Timestamp).toDate(),
      isLiked: ((data['liked_users'] as List?) ?? []).contains(userEmail),
      isDisliked: ((data['disliked_users'] as List?) ?? []).contains(userEmail),
      likesCount: data['likes_count'] ?? 0,
      dislikesCount: data['dislikes_count'] ?? 0,
      commentsCount: data['comments_count'] ?? 0,
      poll: rawPoll != null
          ? Poll.fromMap(Map<String, dynamic>.from(rawPoll))
          : null,
    );
  }

  Post copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    bool? isLiked,
    bool? isDisliked,
    int? likesCount,
    int? dislikesCount,
    int? commentsCount,
    Poll? poll,
  }) {
    return Post(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      poll: poll ?? this.poll,
    );
  }
}
