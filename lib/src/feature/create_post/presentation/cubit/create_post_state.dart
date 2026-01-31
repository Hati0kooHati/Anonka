import 'package:anonka/src/core/helper/copy_with_helper.dart';

class CreatePostState {
  const CreatePostState({
    this.isLoading = false,
    this.error,
    this.isPostCreated = false,
  });

  final bool isLoading;
  final Object? error;
  final bool isPostCreated;

  CreatePostState copyWith({
    bool? isLoading,
    Defaulted<Object>? error = const Omit(),
    bool? isPostCreated,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      error: error is Omit ? this.error : error as Object?,
      isPostCreated: isPostCreated ?? this.isPostCreated,
    );
  }
}
