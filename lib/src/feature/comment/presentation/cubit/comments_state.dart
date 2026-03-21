import 'package:anonka/src/core/helper/copy_with_helper.dart';
import 'package:anonka/src/feature/comment/model/comment.dart';

class CommentsState {
  const CommentsState({
    this.isLoading = false,
    this.comments = const [],
    this.error,
    this.replyingTo,
  });

  final bool isLoading;
  final List<Comment> comments;
  final Object? error;

  /// Комментарий, на который отвечаем прямо сейчас (null = обычный режим)
  final Comment? replyingTo;

  CommentsState copyWith({
    bool? isLoading,
    List<Comment>? comments,
    Object? error,
    Defaulted<Comment>? replyingTo = const Omit(),
  }) {
    return CommentsState(
      isLoading: isLoading ?? this.isLoading,
      comments: comments ?? this.comments,
      error: error,
      replyingTo: replyingTo is Omit ? this.replyingTo : replyingTo as Comment?,
    );
  }
}
