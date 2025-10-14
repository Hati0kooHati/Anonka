import 'package:anonka/models/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'posts_state.freezed.dart';

@freezed
abstract class PostsState with _$PostsState {
  const factory PostsState({
    @Default(false) bool isLoading,
    @Default([]) List<Post> posts,
    @Default(true) bool hasMore,
  }) = _PostsState;
}
