import 'package:anonka/service/firebase_remote_config_service.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<FirebaseRemoteConfigService> firebaseRemoteConfig() =>
      FirebaseRemoteConfigService.create();

  @preResolve
  Future<PackageInfo> packageInfo() => PackageInfo.fromPlatform();
}