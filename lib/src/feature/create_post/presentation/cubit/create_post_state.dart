import 'package:anonka/src/core/helper/copy_with_helper.dart';
import 'package:anonka/src/feature/post/model/post.dart';

class CreatePostState {
  CreatePostState({
    this.isLoading = false,
    this.error,
    this.createdPost,
    this.isPollMode = false,
    this.pollOptions = const ['', ''],
  });

  final bool isLoading;
  final Object? error;
  final dynamic createdPost; // Post
  final bool isPollMode;
  final List<String> pollOptions;

  CreatePostState copyWith({
    bool? isLoading,
    Defaulted<Object?> error = const Omit(),
    dynamic createdPost,
    bool? isPollMode,
    List<String>? pollOptions,
    bool clearCreatedPost = false,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      error: error is Omit ? this.error : error,
      createdPost: clearCreatedPost ? null : (createdPost ?? this.createdPost),
      isPollMode: isPollMode ?? this.isPollMode,
      pollOptions: pollOptions ?? this.pollOptions,
    );
  }
}
