import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:anonka/src/core/injection/inject.config.dart';

final getIt = GetIt.instance;

T get<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) => getIt.get<T>(instanceName: instanceName, param1: param1, param2: param2);

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async => getIt.init();
