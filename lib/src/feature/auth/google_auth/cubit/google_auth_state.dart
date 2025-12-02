class GoogleAuthState {
  const GoogleAuthState({this.isLoading = false});

  final bool isLoading;

  GoogleAuthState copyWith({bool? isLoading}) {
    return GoogleAuthState(isLoading: isLoading ?? this.isLoading);
  }
}
