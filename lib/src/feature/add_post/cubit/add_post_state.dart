class AddPostState {
  const AddPostState({bool? isLoading}) : isLoading = isLoading ?? false;

  final bool isLoading;

  AddPostState copyWith({bool? isLoading}) {
    return AddPostState(isLoading: isLoading ?? this.isLoading);
  }
}
