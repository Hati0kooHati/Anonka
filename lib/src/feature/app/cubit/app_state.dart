class AppState {
  const AppState({
    this.isLoading = false,
    this.shouldShowUpdateScreen = false,
    this.error,
  });

  final bool isLoading;
  final bool shouldShowUpdateScreen;
  final Object? error;

  AppState copyWith({
    bool? isLoading,
    bool? shouldShowUpdateScreen,
    Object? error,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      shouldShowUpdateScreen:
          shouldShowUpdateScreen ?? this.shouldShowUpdateScreen,
      error: error,
    );
  }
}
