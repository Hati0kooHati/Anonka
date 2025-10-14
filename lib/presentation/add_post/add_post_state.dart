import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_post_state.freezed.dart';

@freezed
abstract class AddPostState with _$AddPostState {
  const factory AddPostState({@Default(false) bool isLoading}) = _AddPostState;
}
