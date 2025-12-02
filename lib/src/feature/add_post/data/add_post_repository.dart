import 'package:anonka/src/feature/add_post/data/add_post_data_source.dart';
import 'package:anonka/src/feature/add_post/model/add_post.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPostRepository {
  const AddPostRepository(this.addPostDataSource);

  final AddPostDataSource addPostDataSource;

  Future<void> addPost({required AddPost addPost}) {
    return addPostDataSource.addPost(addPost: addPost);
  }
}
