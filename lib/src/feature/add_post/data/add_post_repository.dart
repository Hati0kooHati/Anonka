import 'package:anonka/src/feature/add_post/data/add_post_data_source.dart';
import 'package:anonka/src/feature/add_post/model/post.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPostRepository {
  const AddPostRepository(this.addPostDataSource);

  final AddPostDataSource addPostDataSource;

  Future<void> addPost({required Post post, required String userGmail}) {
    return addPostDataSource.addPost(post: post, userGmail: userGmail);
  }
}
