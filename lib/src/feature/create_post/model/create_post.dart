class CreatePost {
  CreatePost({required this.userEmail, required this.text});

  final String userEmail;
  final String text;
  final int likesCount = 0;
  final int dislikesCount = 0;
  final int commentsCount = 0;
  final List<String> likedUsers = [];
  final List<String> dislikedUsers = [];

  Map<String, dynamic> toJson() {
    return {
      "user_email": userEmail,
      "text": text,
      "likes_count": likesCount,
      "dislikes_count": dislikesCount,
      "liked_users": likedUsers,
      "comments_count": commentsCount,
      "disliked_users": dislikedUsers,
    };
  }
}
