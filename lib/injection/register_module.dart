import 'package:anonka/Repository/firebase_remote_config_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<FirebaseRemoteConfigRepository> firebaseRemoteConfig() =>
      FirebaseRemoteConfigRepository.create();

  @preResolve
  Future<PackageInfo> packageInfo() => PackageInfo.fromPlatform();
}
