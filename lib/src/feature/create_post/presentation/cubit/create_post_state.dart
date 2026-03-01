import 'package:anonka/src/core/helper/copy_with_helper.dart';
import 'package:anonka/src/feature/post/model/post.dart';

class CreatePostState {
  const CreatePostState({this.isLoading = false, this.error, this.createdPost});

  final bool isLoading;
  final Object? error;
  final Post? createdPost;

  CreatePostState copyWith({
    bool? isLoading,
    Defaulted<Object>? error = const Omit(),
    Post? createdPost,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      error: error is Omit ? this.error : error as Object?,
      createdPost: createdPost ?? this.createdPost,
    );
  }
}
