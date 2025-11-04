import 'package:anonka/injection/inject.dart' as inject;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StateblocWidget<B extends Cubit<S>, S> extends StatefulWidget {
  final B Function(BuildContext context)? createBloc;

  StateblocWidget({super.key, this.createBloc});

  final store = _StateblocStore<B, S>();

  BuildContext get context => store.context!;

  S get state => store.state!;

  B get bloc => store.bloc!;

  void initState() {}

  Widget build(BuildContext context);

  void dispose() {}

  @override
  State<StateblocWidget<B, S>> createState() => _StateblocWidgetState();
}

class _StateblocWidgetState<B extends Cubit<S>, S>
    extends State<StateblocWidget<B, S>> {
  @override
  void initState() {
    super.initState();
    widget.initState();
  }

  @override
  void dispose() {
    widget.dispose();
    widget.store.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.createBloc?.call(context) ?? inject.get<B>(),
      child: BlocBuilder<B, S>(
        builder: (context, state) {
          widget.store
            ..bloc = context.read<B>()
            ..state = state
            ..context = context;

          return widget.build(context);
        },
      ),
    );
  }
}

class _StateblocStore<B extends Cubit<S>, S> {
  BuildContext? context;
  S? state;
  B? bloc;

  clear() {
    context = null;
    bloc = null;
    state = null;
  }
}
