// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:anonka/app/app_bloc.dart' as _i160;
import 'package:anonka/core/helpers/error_handler.dart' as _i655;
import 'package:anonka/injection/register_module.dart' as _i552;
import 'package:anonka/presentation/add_post/add_post_bloc.dart' as _i224;
import 'package:anonka/presentation/auth/google_auth/google_auth_bloc.dart'
    as _i173;
import 'package:anonka/presentation/home/home_bloc.dart' as _i381;
import 'package:anonka/presentation/posts/posts_bloc.dart' as _i824;
import 'package:anonka/presentation/profile/profile_bloc.dart' as _i860;
import 'package:anonka/service/auth_service.dart' as _i279;
import 'package:anonka/service/firebase_remote_config_service.dart' as _i401;
import 'package:anonka/widgets/navigation_observer.dart' as _i225;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i401.FirebaseRemoteConfigService>(
      () => registerModule.firebaseRemoteConfig(),
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo(),
      preResolve: true,
    );
    gh.factory<_i279.AuthService>(() => _i279.AuthService());
    gh.factory<_i655.ErrorHandler>(() => _i655.ErrorHandler());
    gh.factory<_i381.HomeBloc>(() => _i381.HomeBloc());
    gh.factory<_i824.PostsBloc>(() => _i824.PostsBloc());
    gh.factory<_i860.ProfileBloc>(() => _i860.ProfileBloc());
    gh.factory<_i224.AddPostBloc>(() => _i224.AddPostBloc());
    gh.lazySingleton<_i225.NavigationObserver>(
      () => _i225.NavigationObserver(),
    );
    gh.factory<_i160.AppBloc>(
      () => _i160.AppBloc(
        gh<_i401.FirebaseRemoteConfigService>(),
        gh<_i655.PackageInfo>(),
        gh<_i655.ErrorHandler>(),
      ),
    );
    gh.factory<_i173.GoogleAuthBloc>(
      () => _i173.GoogleAuthBloc(gh<_i279.AuthService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i552.RegisterModule {}
