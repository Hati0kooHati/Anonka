import 'package:anonka/src/core/injection/inject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StateblocWidget<B extends Cubit<S>, S> extends StatefulWidget {
  StateblocWidget({super.key, this.create, this.listener});

  final B Function(BuildContext context)? create;
  final void Function(BuildContext context, S state)? listener;
  final store = _StateblocStore<B, S>();

  BuildContext get context => store.context!;

  S get state => store.state!;

  B get bloc => store.bloc!;

  void initState() {}

  @protected
  Widget build(BuildContext context);

  void dispose() {}

  void onResume() {}

  void onUpdate() {}

  Future<T?> showBlocDialog<T>(
    BuildContext context, {
    required Widget Function(BuildContext context, B bloc, S state) builder,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: BlocBuilder<B, S>(
            builder: (ctx, state) => builder(ctx, bloc, state),
          ),
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _StateblocWidgetState<B, S>();
}

class _StateblocWidgetState<B extends Cubit<S>, S>
    extends State<StateblocWidget<B, S>> {
  @override
  void initState() {
    super.initState();
    widget.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;

    if (widget.listener != null) {
      child = BlocConsumer<B, S>(
        builder: (context, state) {
          widget.store
            ..context = context
            ..state = state
            ..bloc = context.watch();

          return widget.build(context);
        },
        listener: widget.listener!,
      );
    } else {
      child = BlocBuilder<B, S>(
        builder: (context, state) {
          widget.store
            ..context = context
            ..state = state
            ..bloc = context.watch();

          return widget.build(context);
        },
      );
    }

    return BlocProvider<B>(
      create: (context) =>
          widget.create != null ? widget.create!(context) : get<B>(),
      child: child,
    );
  }

  @override
  void dispose() {
    widget.dispose();
    widget.store.clear();
    super.dispose();
  }
}

class _StateblocStore<B extends Cubit<S>, S> {
  BuildContext? context;
  B? bloc;
  S? state;

  clear() {
    context = null;
    bloc = null;
    state = null;
  }
}
