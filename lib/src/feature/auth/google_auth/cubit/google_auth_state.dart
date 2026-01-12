class GoogleAuthState {
  const GoogleAuthState({this.isLoading = false, this.error});

  final bool isLoading;
  final Object? error;

  GoogleAuthState copyWith({bool? isLoading, Object? error}) {
    return GoogleAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
