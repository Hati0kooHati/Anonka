import 'package:anonka/presentation/auth/google_auth/google_auth_state.dart';
import 'package:anonka/core/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoogleAuthBloc extends Cubit<GoogleAuthState> {
  final AuthRepository authService;

  GoogleAuthBloc(this.authService) : super(GoogleAuthState());

  Function(dynamic e)? showError;

  Future<void> signInWithGoogle(Function onSuccess) async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    final error = await authService.signInWithGoogle();

    if (error != null) {
      showError?.call(error);
    } else {
      onSuccess();
    }

    emit(state.copyWith(isLoading: false));
  }
}
