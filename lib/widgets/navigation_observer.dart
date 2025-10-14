import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  final _shouldUpdates = <String>[];

  void _log(Route? route, String action) {
    if (route is! PageRoute) return;
    log("$action ${route.settings.name}");
  }

  @override
  void didPop(Route route, Route? previousRoute) async {
    super.didPop(route, previousRoute);
    _log(route, "navigation: pop ${await route.popped}");
    _clearUpdates([route, if (previousRoute != null) previousRoute]);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _log(route, "navigation: push ${route.settings.arguments}");
    // if (route.settings.asOrNull<AutoRoutePage>()?.routeData.path == '/') {
    //   get<AppBloc>().start(wait: true);
    // }
    _clearUpdates([route, if (previousRoute != null) previousRoute]);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _log(route, "remove");
    _clearUpdates([route, if (previousRoute != null) previousRoute]);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _log(newRoute, "replace");
    _clearUpdates([newRoute, oldRoute].whereType<Route>().toList());
  }

  void _clearUpdates(List<Route> routes) {
    for (var e in routes) {
      _shouldUpdates.remove(e.settings.name);
    }
  }

  void addToUpdate(List<String> names) => _shouldUpdates.addAll(names);

  bool shouldUpdate(String path) => _shouldUpdates.contains(path);
}
