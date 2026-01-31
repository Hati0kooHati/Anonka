// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:anonka/src/core/injection/register_module.dart' as _i796;
import 'package:anonka/src/feature/app/data/firebase_remote_config_service.dart'
    as _i712;
import 'package:anonka/src/feature/app/presentation/cubit/app_cubit.dart'
    as _i1035;
import 'package:anonka/src/feature/auth/google_auth/data/google_auth_service.dart'
    as _i1013;
import 'package:anonka/src/feature/auth/google_auth/presentation/cubit/google_auth_bloc.dart'
    as _i31;
import 'package:anonka/src/feature/create_post/data/create_post_data_source.dart'
    as _i552;
import 'package:anonka/src/feature/create_post/data/create_post_repository.dart'
    as _i793;
import 'package:anonka/src/feature/create_post/presentation/cubit/create_post_cubit.dart'
    as _i638;
import 'package:anonka/src/feature/post/comment/data/comments_repository.dart'
    as _i889;
import 'package:anonka/src/feature/post/comment/presentation/cubit/comments_cubit.dart'
    as _i354;
import 'package:anonka/src/feature/post/data/posts_repository.dart' as _i791;
import 'package:anonka/src/feature/post/presentation/cubit/posts_cubit.dart'
    as _i1057;
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
    await gh.factoryAsync<_i712.FirebaseRemoteConfigService>(
      () => registerModule.firebaseRemoteConfig(),
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo(),
      preResolve: true,
    );
    await gh.factoryAsync<_i1013.GoogleAuthService>(() {
      final i = _i1013.GoogleAuthService();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.singleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.singleton<_i974.FirebaseFirestore>(() => registerModule.firestore());
    gh.factory<_i31.GoogleAuthCubit>(
      () => _i31.GoogleAuthCubit(gh<_i1013.GoogleAuthService>()),
    );
    gh.factory<_i552.CreatePostDataSource>(
      () => _i552.CreatePostDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i889.CommentsRepository>(
      () => _i889.CommentsRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i791.PostsRepository>(
      () => _i791.PostsRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i1035.AppBloc>(
      () => _i1035.AppBloc(
        gh<_i712.FirebaseRemoteConfigService>(),
        gh<_i655.PackageInfo>(),
      ),
    );
    gh.factory<_i793.CreatePostRepository>(
      () => _i793.CreatePostRepository(gh<_i552.CreatePostDataSource>()),
    );
    gh.factoryParam<_i354.CommentsCubit, String, dynamic>(
      (postId, _) => _i354.CommentsCubit(
        postId,
        gh<_i791.PostsRepository>(),
        gh<_i889.CommentsRepository>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i1057.PostsCubit>(
      () => _i1057.PostsCubit(
        gh<_i791.PostsRepository>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i638.CreatePostCubit>(
      () => _i638.CreatePostCubit(
        gh<_i793.CreatePostRepository>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i796.RegisterModule {}
