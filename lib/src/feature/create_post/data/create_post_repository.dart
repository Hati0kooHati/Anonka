import 'package:anonka/src/feature/create_post/data/create_post_data_source.dart';
import 'package:anonka/src/feature/create_post/model/create_post.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostRepository {
  const CreatePostRepository(this.createPostDataSource);

  final CreatePostDataSource createPostDataSource;

  Future<void> createPost({
    required CreatePost createPost,
    required String channel,
  }) {
    return createPostDataSource.createPost(
      createPost: createPost,
      channel: channel,
    );
  }
}
