import 'package:anonka/src/feature/post/model/post.dart';

class PostsState {
  const PostsState({this.isLoading = false, this.posts = const []});

  final bool isLoading;
  final List<Post> posts;

  PostsState copyWith({bool? isLoading, List<Post>? posts}) {
    return PostsState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
    );
  }
}
