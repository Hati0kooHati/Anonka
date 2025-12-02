import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig remoteConfig;

  FirebaseRemoteConfigService._(this.remoteConfig);

  static Future<FirebaseRemoteConfigService> create() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults(const {'minRequiredVersion': '1.0.0'});

    await remoteConfig.fetchAndActivate();

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });

    return FirebaseRemoteConfigService._(remoteConfig);
  }

  String getMinRequiredVersion() =>
      remoteConfig.getString('minRequiredVersion');
}
