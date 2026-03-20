import 'dart:io';
import 'dart:typed_data';

import 'package:anonka/src/feature/create_post/model/create_poll.dart';
import 'package:anonka/src/feature/create_post/presentation/cubit/create_post_state.dart';
import 'package:anonka/src/feature/create_post/data/create_post_repository.dart';
import 'package:anonka/src/feature/create_post/model/create_post.dart';
import 'package:anonka/src/feature/post/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostRepository createPostRepository;
  final String userEmail;
  final SharedPreferences prefs;

  static const String _lastResetDateKey = 'post_limit_last_reset_date';
  static const String _postsUsedKey = 'post_limit_posts_used';

  CreatePostCubit(
    this.createPostRepository,
    this.prefs,
    FirebaseAuth firebaseAuth,
  ) : userEmail =
          firebaseAuth.currentUser?.uid ??
          (throw Error.throwWithStackTrace(
            "тут не должно быть null т.к в app/presentation/widgets/auth_gate_widget мы проверяем",
            StackTrace.current,
          )),
      super(CreatePostState()) {
    _initLimit();
  }

  final String channel = "mukr_west_college";
  final _imagePicker = ImagePicker();
  final int _maxImageSize = 5 * 1024 * 1024;

  // ── Daily limit ──────────────────────────────────────────────────────────

  void _initLimit() {
    final String? lastResetDateStr = prefs.getString(_lastResetDateKey);
    final int postsUsed = prefs.getInt(_postsUsedKey) ?? 0;

    if (lastResetDateStr == null) {
      // Первый запуск — инициализируем дату и обнуляем счётчик
      _saveCurrentDate();
      emit(state.copyWith(postsUsed: 0));
      return;
    }

    final DateTime lastResetDate = DateTime.parse(lastResetDateStr);
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(lastResetDate);

    if (diff.inHours >= 24) {
      // Прошло 24 часа — восстанавливаем лимит и обновляем дату
      _saveCurrentDate();
      prefs.setInt(_postsUsedKey, 0);
      emit(state.copyWith(postsUsed: 0));
    } else {
      emit(state.copyWith(postsUsed: postsUsed));
    }
  }

  void _saveCurrentDate() {
    prefs.setString(_lastResetDateKey, DateTime.now().toIso8601String());
  }

  void _incrementPostsUsed() {
    final int newValue = state.postsUsed + 1;
    prefs.setInt(_postsUsedKey, newValue);
    emit(state.copyWith(postsUsed: newValue));
  }

  // ── Poll mode ────────────────────────────────────────────────────────────

  void togglePollMode() {
    emit(state.copyWith(isPollMode: !state.isPollMode));
  }

  void updatePollOption(int index, String value) {
    final updated = List<String>.from(state.pollOptions);
    updated[index] = value;
    emit(state.copyWith(pollOptions: updated));
  }

  void addPollOption() {
    if (state.pollOptions.length >= 10) return;
    emit(state.copyWith(pollOptions: [...state.pollOptions, '']));
  }

  void removePollOption(int index) {
    if (state.pollOptions.length <= 2) return;
    final updated = List<String>.from(state.pollOptions)..removeAt(index);
    emit(state.copyWith(pollOptions: updated));
  }

  // ── Image ────────────────────────────────────────────────────────────────

  Future<void> pickImage() async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;

    final File compressed = await _compressUntil5MB(File(picked.path));
    emit(state.copyWith(pathToSelectedImage: compressed.path));
  }

  void clearSelectedImage() {
    emit(state.copyWith(pathToSelectedImage: null));
  }

  Future<File> _compressUntil5MB(File file) async {
    if (await file.length() <= _maxImageSize) return file;

    int quality = 90;
    final String tempPath = '${file.path}_compressed.jpg';
    File result = file;

    while (await result.length() > _maxImageSize && quality > 10) {
      final Uint8List? bytes = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: quality,
      );

      if (bytes == null) break;

      result = await File(tempPath).writeAsBytes(bytes);
      quality -= 10;
    }

    return result;
  }

  // ── Create ───────────────────────────────────────────────────────────────

  void createPost({required String text}) async {
    if (state.isLoading || !state.canPost) return;

    emit(state.copyWith(isLoading: true));

    try {
      final Post createdPost = await createPostRepository.createPost(
        createPost: CreatePost(userEmail: userEmail, text: text),
        channel: channel,
        imagePath: state.pathToSelectedImage,
      );

      _incrementPostsUsed();
      emit(state.copyWith(isLoading: false, createdPost: createdPost));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  void createPoll({required String question}) async {
    if (state.isLoading || !state.canPost) return;

    emit(state.copyWith(isLoading: true));

    try {
      final Post createdPost = await createPostRepository.createPost(
        createPost: CreatePost(
          userEmail: userEmail,
          text: question,
          poll: CreatePoll(question: question, options: state.pollOptions),
        ),
        channel: channel,
        imagePath: state.pathToSelectedImage,
      );

      _incrementPostsUsed();
      emit(state.copyWith(isLoading: false, createdPost: createdPost));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  // ── Utils ─────────────────────────────────────────────────────────────────

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
