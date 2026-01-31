import 'package:anonka/src/feature/post/comment/model/comment.dart';

class CommentsState {
  const CommentsState({
    this.isLoading = false,
    this.comments = const [],
    this.error,
  });

  final bool isLoading;
  final List<Comment> comments;
  final Object? error;

  CommentsState copyWith({
    bool? isLoading,
    List<Comment>? comments,
    Object? error,
  }) {
    return CommentsState(
      isLoading: isLoading ?? this.isLoading,
      comments: comments ?? this.comments,
      error: error,
    );
  }
}
