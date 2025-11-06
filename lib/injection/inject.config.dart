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
import 'package:anonka/presentation/comment/comments_bloc.dart' as _i989;
import 'package:anonka/presentation/home/home_bloc.dart' as _i381;
import 'package:anonka/presentation/posts/posts_bloc.dart' as _i824;
import 'package:anonka/presentation/profile/profile_bloc.dart' as _i860;
import 'package:anonka/repository/auth_repository.dart' as _i540;
import 'package:anonka/repository/firebase_remote_config_repository.dart'
    as _i633;
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
    gh.factory<_i655.ErrorHandler>(() => _i655.ErrorHandler());
    await gh.factoryAsync<_i633.FirebaseRemoteConfigRepository>(
      () => registerModule.firebaseRemoteConfig(),
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo(),
      preResolve: true,
    );
    gh.factory<_i381.HomeBloc>(() => _i381.HomeBloc());
    gh.factory<_i860.ProfileBloc>(() => _i860.ProfileBloc());
    gh.factory<_i540.AuthRepository>(() => _i540.AuthRepository());
    gh.singleton<_i59.FirebaseAuth>(() => registerModule.user);
    gh.singleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.factory<_i160.AppBloc>(
      () => _i160.AppBloc(
        gh<_i633.FirebaseRemoteConfigRepository>(),
        gh<_i655.PackageInfo>(),
        gh<_i655.ErrorHandler>(),
      ),
    );
    gh.factory<_i173.GoogleAuthBloc>(
      () => _i173.GoogleAuthBloc(gh<_i540.AuthRepository>()),
    );
    gh.factoryParam<_i989.CommentsBloc, String, dynamic>(
      (postId, _) => _i989.CommentsBloc(
        postId,
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i224.AddPostBloc>(
      () => _i224.AddPostBloc(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i824.PostsBloc>(
      () => _i824.PostsBloc(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i552.RegisterModule {}
