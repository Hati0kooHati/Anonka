import 'package:freezed_annotation/freezed_annotation.dart';
part 'google_auth_state.freezed.dart';

@freezed
abstract class GoogleAuthState with _$GoogleAuthState {
  const factory GoogleAuthState({@Default(false) bool isLoading}) =
      _GoogleAuthState;
}
