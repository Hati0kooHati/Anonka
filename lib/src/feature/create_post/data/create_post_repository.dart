import 'package:anonka/src/feature/create_post/model/create_post.dart';
import 'package:anonka/src/feature/post/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostRepository {
  final FirebaseFirestore _firestore;

  const CreatePostRepository(this._firestore);

  Future<Post> createPost({
    required CreatePost createPost,
    required String channel,
  }) async {
    final postJson = createPost.toJson();

    postJson.addAll({"created_at": FieldValue.serverTimestamp()});

    final DocumentReference<Map<String, dynamic>> createdDocRef =
        await _firestore.collection(channel).add(postJson);

    return Post(
      id: createdDocRef.id,
      text: createPost.text,
      createdAt: DateTime.now(),
      isLiked: false,
      isDisliked: false,
      likesCount: 0,
      dislikesCount: 0,
      commentsCount: 0,
    );
  }
}
