class AddPost {
  AddPost({required this.userGmail, required this.text})
    : likes = [],
      dislikes = [];

  final String userGmail;
  final String text;
  final List<String> likes;
  final List<String> dislikes;

  Map<String, dynamic> toJson() {
    return {
      "user_gmail": userGmail,
      "text": text,
      "likes": likes,
      "dislikes": dislikes,
    };
  }
}
