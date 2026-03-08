class PollOption {
  PollOption({
    required this.text,
    required this.votesCount,
    required this.votedUsers,
  });

  final String text;
  final int votesCount;
  final List<String> votedUsers;

  bool hasVoted(String userEmail) => votedUsers.contains(userEmail);

  factory PollOption.fromMap(Map<String, dynamic> map) {
    return PollOption(
      text: map['text'] ?? '',
      votesCount: map['votes_count'] ?? 0,
      votedUsers: List<String>.from(map['voted_users'] ?? []),
    );
  }

  PollOption copyWith({int? votesCount, List<String>? votedUsers}) {
    return PollOption(
      text: text,
      votesCount: votesCount ?? this.votesCount,
      votedUsers: votedUsers ?? this.votedUsers,
    );
  }
}