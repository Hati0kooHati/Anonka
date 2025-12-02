class AppState {
  const AppState({bool? isLoading, bool? shouldShowUpdateScreen})
    : isLoading = isLoading ?? false,
      shouldShowUpdateScreen = shouldShowUpdateScreen ?? false;

  final bool isLoading;
  final bool shouldShowUpdateScreen;

  AppState copyWith({bool? isLoading, bool? shouldShowUpdateScreen}) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      shouldShowUpdateScreen:
          shouldShowUpdateScreen ?? this.shouldShowUpdateScreen,
    );
  }
}
