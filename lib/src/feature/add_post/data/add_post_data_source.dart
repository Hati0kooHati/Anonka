import 'package:anonka/src/feature/add_post/model/add_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPostDataSource {
  AddPostDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> addPost({required AddPost addPost}) async {
    final postJson = addPost.toJson();

    postJson.addAll({"created_at": FieldValue.serverTimestamp()});

    _firestore.collection("mukr_west_college").add(postJson);
  }
}
