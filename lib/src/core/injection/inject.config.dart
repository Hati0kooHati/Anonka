// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:anonka/src/core/helpers/error_handler.dart' as _i707;
import 'package:anonka/src/core/injection/register_module.dart' as _i796;
import 'package:anonka/src/core/service/auth_service.dart' as _i60;
import 'package:anonka/src/core/service/firebase_remote_config_service.dart'
    as _i791;
import 'package:anonka/src/feature/add_post/cubit/add_post_cubit.dart' as _i908;
import 'package:anonka/src/feature/add_post/data/add_post_data_source.dart'
    as _i411;
import 'package:anonka/src/feature/add_post/data/add_post_repository.dart'
    as _i699;
import 'package:anonka/src/feature/app/app_bloc.dart' as _i602;
import 'package:anonka/src/feature/auth/google_auth/google_auth_bloc.dart'
    as _i746;
import 'package:anonka/src/feature/comment/comments_bloc.dart' as _i408;
import 'package:anonka/src/feature/home/home_bloc.dart' as _i734;
import 'package:anonka/src/feature/posts/posts_bloc.dart' as _i932;
import 'package:anonka/src/feature/profile/profile_bloc.dart' as _i674;
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
    gh.factory<_i734.HomeBloc>(() => _i734.HomeBloc());
    gh.factory<_i674.ProfileBloc>(() => _i674.ProfileBloc());
    gh.singleton<_i59.FirebaseAuth>(() => registerModule.user);
    gh.singleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.factoryParam<_i408.CommentsBloc, String, dynamic>(
      (postId, _) => _i408.CommentsBloc(
        postId,
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i602.AppBloc>(
      () => _i602.AppBloc(
        gh<_i791.FirebaseRemoteConfigService>(),
        gh<_i655.PackageInfo>(),
        gh<_i707.ErrorHandler>(),
      ),
    );
    gh.factory<_i932.PostsBloc>(
      () => _i932.PostsBloc(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i411.AddPostDataSource>(
      () => _i411.AddPostDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i746.GoogleAuthBloc>(
      () => _i746.GoogleAuthBloc(gh<_i60.AuthService>()),
    );
    gh.factory<_i699.AddPostRepository>(
      () => _i699.AddPostRepository(gh<_i411.AddPostDataSource>()),
    );
    gh.factory<_i908.AddPostCubit>(
      () => _i908.AddPostCubit(
        gh<_i699.AddPostRepository>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i796.RegisterModule {}
