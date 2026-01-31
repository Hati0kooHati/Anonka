import 'package:anonka/src/feature/create_post/model/create_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostDataSource {
  CreatePostDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> createPost({
    required CreatePost createPost,
    required String channel,
  }) async {
    final postJson = createPost.toJson();

    postJson.addAll({"created_at": FieldValue.serverTimestamp()});

    _firestore.collection(channel).add(postJson);
  }
}
