import 'package:anonka/injection/inject.dart';
import 'package:anonka/widgets/navigation_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StateblocWidget<B extends Cubit<S>, S> extends StatefulWidget {
  StateblocWidget({super.key});

  final store = _StateblocStore<B, S>();

  BuildContext get context => store.context!;

  S get state => store.state!;

  B get bloc => store.bloc!;

  void initState() {}

  Widget build(BuildContext context);

  void dispose() {}

  void onResume() {}

  void onUpdate() {}

  @override
  State<StateblocWidget<B, S>> createState() => _StateblocWidgetState();
}

class _StateblocWidgetState<B extends Cubit<S>, S>
    extends State<StateblocWidget<B, S>>
    with RouteAware {
  NavigationObserver get navigationObserver => get<NavigationObserver>();

  @override
  void initState() {
    super.initState();
    widget.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => get<B>(),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) navigationObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    navigationObserver.unsubscribe(this);
    widget.dispose();
    widget.store.clear();
    super.dispose();
  }

  @override
  void didPush() {
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onResume());
  }

  @override
  void didPopNext() {
    widget.onResume();
    final route = ModalRoute.of(context);
    final path = route?.settings.name;
    if (path == null) return;
    final shouldUpdate = navigationObserver.shouldUpdate(path);
    if (shouldUpdate) widget.onUpdate();
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
