import 'dart:io';
import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/feature/app/presentation/cubit/app_state.dart';
import 'package:anonka/src/core/constants/constants.dart';
import 'package:anonka/src/feature/app/data/firebase_remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class AppBloc extends Cubit<AppState> {
  final FirebaseRemoteConfigService firebaseRemoteConfigService;
  final PackageInfo packageInfo;

  AppBloc(this.firebaseRemoteConfigService, this.packageInfo)
    : super(AppState()) {
    checkForUpdates();
  }

  Function(dynamic e)? showError;

  void checkForUpdates() async {
    try {
      String minRequiredVersion = firebaseRemoteConfigService
          .getMinRequiredVersion();
      String currentVersion = packageInfo.version;

      debugPrint("minRequiredVersion - $minRequiredVersion");
      debugPrint("currentVersion - $currentVersion");

      if (minRequiredVersion != currentVersion) {
        emit(state.copyWith(shouldShowUpdateScreen: true));
      }
    } catch (e) {
      emit(state.copyWith(error: Exception(AppStrings.tryLater)));
    }
  }

  void launchUpdateUrl() async {
    final isIos = Platform.isIOS;

    final url = isIos ? LinkStore.appStoreUrl : LinkStore.googlePlayUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      emit(state.copyWith(error: Exception(AppStrings.tryLater)));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
