import 'package:anonka/src/core/service/firebase_remote_config_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<FirebaseRemoteConfigService> firebaseRemoteConfig() =>
      FirebaseRemoteConfigService.create();

  @preResolve
  Future<PackageInfo> packageInfo() => PackageInfo.fromPlatform();

  @singleton
  FirebaseAuth get user => FirebaseAuth.instance;

  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}
