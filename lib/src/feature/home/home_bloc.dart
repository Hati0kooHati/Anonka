import 'package:anonka/src/feature/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState());

  void changeTab(int tabIndex) {
    emit(state.copyWith(tabIndex: tabIndex));
  }
}
