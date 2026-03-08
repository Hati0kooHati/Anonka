import 'package:anonka/src/feature/create_post/model/create_poll.dart';

class CreatePost {
  CreatePost({
    required this.userEmail,
    required this.text,
    this.poll,
  });

  final String userEmail;
  final String text;
  final CreatePoll? poll;
  final int likesCount = 0;
  final int dislikesCount = 0;
  final int commentsCount = 0;
  final List<String> likedUsers = [];
  final List<String> dislikedUsers = [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "user_email": userEmail,
      "text": text,
      "likes_count": likesCount,
      "dislikes_count": dislikesCount,
      "liked_users": likedUsers,
      "comments_count": commentsCount,
      "disliked_users": dislikedUsers,
    };

    if (poll != null) {
      map["poll"] = poll!.toJson();
    }

    return map;
  }
}