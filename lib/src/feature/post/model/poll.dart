import 'package:anonka/src/feature/post/model/poll_option.dart';

class Poll {
  Poll({
    required this.question,
    required this.options,
    required this.totalVotes,
  });

  final String question;
  final List<PollOption> options;
  final int totalVotes;

  /// Returns the index of the option this user voted for, or null
  int? votedOptionIndex(String userEmail) {
    for (int i = 0; i < options.length; i++) {
      if (options[i].hasVoted(userEmail)) return i;
    }
    return null;
  }

  factory Poll.fromMap(Map<String, dynamic> map) {
    final rawOptions = (map['options'] as List?) ?? [];
    return Poll(
      question: map['question'] ?? '',
      options: rawOptions
          .map((o) => PollOption.fromMap(Map<String, dynamic>.from(o)))
          .toList(),
      totalVotes: map['total_votes'] ?? 0,
    );
  }

  Poll copyWith({List<PollOption>? options, int? totalVotes}) {
    return Poll(
      question: question,
      options: options ?? this.options,
      totalVotes: totalVotes ?? this.totalVotes,
    );
  }
}