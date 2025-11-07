import 'dart:io';

import 'package:anonka/app/app_state.dart';
import 'package:anonka/core/constants.dart';
import 'package:anonka/core/helpers/error_handler.dart';
import 'package:anonka/core/repository/firebase_remote_config_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class AppBloc extends Cubit<AppState> {
  final FirebaseRemoteConfigRepository firebaseRemoteConfigService;
  final PackageInfo packageInfo;
  final ErrorHandler errorHandler;

  AppBloc(this.firebaseRemoteConfigService, this.packageInfo, this.errorHandler)
    : super(AppState()) {
    checkForUpdates();
  }

  Function(dynamic e)? showError;

  void checkForUpdates() async {
    String minRequiredVersion = firebaseRemoteConfigService
        .getMinRequiredVersion();
    String currentVersion = packageInfo.version;

    debugPrint("minRequiredVersion - $minRequiredVersion");
    debugPrint("currentVersion - $currentVersion");

    if (minRequiredVersion != currentVersion) {
      emit(state.copyWith(shouldShowUpdateScreen: true));
    }
  }

  void launchUpdateUrl() async {
    final isIos = Platform.isIOS;

    final url = isIos ? LinkStore.appStoreUrl : LinkStore.googlePlayUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Cannot launch url";
    }
  }
}
