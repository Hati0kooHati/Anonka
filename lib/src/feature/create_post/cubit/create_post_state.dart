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
    Object? error,
    bool? isPostCreated,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isPostCreated: isPostCreated ?? this.isPostCreated,
    );
  }
}
