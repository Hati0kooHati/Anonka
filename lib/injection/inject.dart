import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:anonka/injection/inject.config.dart';

final getIt = GetIt.instance;

T get<T extends Object>() => getIt.get<T>();

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async => getIt.init();
