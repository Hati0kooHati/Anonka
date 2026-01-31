import 'package:anonka/src/feature/post/model/post.dart';

class PostsState {
  const PostsState({this.isLoading = false, this.posts = const [], this.error});

  final bool isLoading;
  final List<Post> posts;
  final Object? error;

  PostsState copyWith({bool? isLoading, List<Post>? posts, Object? error}) {
    return PostsState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      error: error,
    );
  }
}
