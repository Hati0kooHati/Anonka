// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:anonka/src/core/app/app_bloc.dart' as _i365;
import 'package:anonka/src/core/helpers/error_handler.dart' as _i707;
import 'package:anonka/src/core/injection/register_module.dart' as _i796;
import 'package:anonka/src/core/service/auth_service.dart' as _i60;
import 'package:anonka/src/core/service/firebase_remote_config_service.dart'
    as _i791;
import 'package:anonka/src/feature/add_post/add_post_bloc.dart' as _i547;
import 'package:anonka/src/feature/auth/google_auth/google_auth_bloc.dart'
    as _i461;
import 'package:anonka/src/feature/comment/comments_bloc.dart' as _i560;
import 'package:anonka/src/feature/home/home_bloc.dart' as _i768;
import 'package:anonka/src/feature/posts/posts_bloc.dart' as _i556;
import 'package:anonka/src/feature/profile/profile_bloc.dart' as _i421;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
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
    gh.factory<_i707.ErrorHandler>(() => _i707.ErrorHandler());
    await gh.factoryAsync<_i791.FirebaseRemoteConfigService>(
      () => registerModule.firebaseRemoteConfig(),
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo(),
      preResolve: true,
    );
    gh.factory<_i60.AuthService>(() => _i60.AuthService());
    gh.factory<_i768.HomeBloc>(() => _i768.HomeBloc());
    gh.factory<_i421.ProfileBloc>(() => _i421.ProfileBloc());
    gh.singleton<_i59.FirebaseAuth>(() => registerModule.user);
    gh.singleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.factoryParam<_i560.CommentsBloc, String, dynamic>(
      (postId, _) => _i560.CommentsBloc(
        postId,
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i365.AppBloc>(
      () => _i365.AppBloc(
        gh<_i791.FirebaseRemoteConfigService>(),
        gh<_i655.PackageInfo>(),
        gh<_i707.ErrorHandler>(),
      ),
    );
    gh.factory<_i547.AddPostBloc>(
      () => _i547.AddPostBloc(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i556.PostsBloc>(
      () => _i556.PostsBloc(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i461.GoogleAuthBloc>(
      () => _i461.GoogleAuthBloc(gh<_i60.AuthService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i796.RegisterModule {}
