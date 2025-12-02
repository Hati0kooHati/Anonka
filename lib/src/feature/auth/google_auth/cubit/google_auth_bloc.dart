import 'package:anonka/src/feature/auth/google_auth/cubit/google_auth_state.dart';
import 'package:anonka/src/feature/auth/google_auth/data/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final AuthService authService;

  GoogleAuthCubit(this.authService) : super(GoogleAuthState());

  Future<void> signInWithGoogle(Function onSuccess) async {
    if (state.isLoading) {
      return;
    }

    try {
      emit(state.copyWith(isLoading: true));

      await authService.signInWithGoogle();

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
