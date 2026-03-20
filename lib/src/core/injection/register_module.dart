import 'package:anonka/src/feature/app/data/firebase_remote_config_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<FirebaseRemoteConfigService> firebaseRemoteConfig() =>
      FirebaseRemoteConfigService.create();

  @preResolve
  Future<PackageInfo> packageInfo() => PackageInfo.fromPlatform();

  @singleton
  FirebaseFirestore firestore() {
    final firestore = FirebaseFirestore.instance;
    firestore.settings = const Settings(persistenceEnabled: false);

    return firestore;
  }

  @singleton
  FirebaseStorage firebaseStorage() {
    final storage = FirebaseStorage.instance;

    return storage;
  }

  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @singleton
  @preResolve
  Future<SharedPreferences> preferences() => SharedPreferences.getInstance();
}
