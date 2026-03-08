class CreatePoll {
  CreatePoll({required this.question, required this.options});

  final String question;
  final List<String> options;

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "options": options
          .map((o) => {"text": o, "votes_count": 0, "voted_users": []})
          .toList(),
      "total_votes": 0,
    };
  }
}
