import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/feature/app/cubit/app_cubit.dart';
import 'package:anonka/src/feature/app/cubit/app_state.dart';
import 'package:anonka/src/feature/app/ui/widget/auth_gate_widget.dart';
import 'package:anonka/src/feature/app/ui/widget/update_app_dialog.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppScreen extends StateblocWidget<AppBloc, AppState> {
  AppScreen({super.key})
    : super(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!.getErrorMessage())),
            );
            context.read<AppBloc>().clearError();
          }
        },
      );

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
