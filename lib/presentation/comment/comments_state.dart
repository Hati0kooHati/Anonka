import 'package:anonka/models/comment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comments_state.freezed.dart';

@freezed
abstract class CommentsState with _$CommentsState {
  const factory CommentsState({
    @Default(false) bool isLoading,
    @Default([]) List<Comment> comments,
  }) = _CommentsState;
}
