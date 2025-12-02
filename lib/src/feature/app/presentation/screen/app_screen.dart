import 'package:anonka/src/feature/app/cubit/app_cubit.dart';
import 'package:anonka/src/feature/app/cubit/app_state.dart';
import 'package:anonka/src/feature/app/presentation/widget/auth_gate_widget.dart';
import 'package:anonka/src/feature/app/presentation/widget/update_app_dialog.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';

class AppScreen extends StateblocWidget<AppBloc, AppState> {
  AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: state.shouldShowUpdateScreen
            ? UpdateAppDialog(launchUpdateUrl: bloc.launchUpdateUrl)
            : AuthGateWidget(),
      ),
    );
  }
}
