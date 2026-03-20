import 'package:anonka/src/core/helper/copy_with_helper.dart';

class CreatePostState {
  CreatePostState({
    this.isLoading = false,
    this.error,
    this.pathToSelectedImage,
    this.createdPost,
    this.isPollMode = false,
    this.pollOptions = const ['', ''],
    this.postsUsed = 0,
  });

  final bool isLoading;
  final Object? error;
  final dynamic createdPost; // Post
  final bool isPollMode;
  final String? pathToSelectedImage;
  final List<String> pollOptions;

  /// Сколько постов уже опубликовано с момента последнего сброса.
  final int postsUsed;

  static const int dailyLimit = 3;

  bool get canPost => postsUsed < dailyLimit;

  int get remaining => (dailyLimit - postsUsed).clamp(0, dailyLimit);

  CreatePostState copyWith({
    bool? isLoading,
    Defaulted<Object?> error = const Omit(),
    dynamic createdPost,
    bool? isPollMode,
    List<String>? pollOptions,
    bool clearCreatedPost = false,
    Defaulted<String>? pathToSelectedImage = const Omit(),
    int? postsUsed,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      error: error is Omit ? this.error : error,
      createdPost: clearCreatedPost ? null : (createdPost ?? this.createdPost),
      isPollMode: isPollMode ?? this.isPollMode,
      pollOptions: pollOptions ?? this.pollOptions,
      pathToSelectedImage: pathToSelectedImage is Omit
          ? this.pathToSelectedImage
          : pathToSelectedImage as String?,
      postsUsed: postsUsed ?? this.postsUsed,
    );
  }
}
