import 'package:anonka/src/feature/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileBloc extends Cubit<ProfileState> {
  ProfileBloc() : super(ProfileState());
}
