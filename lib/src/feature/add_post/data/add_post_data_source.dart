import 'package:anonka/src/feature/add_post/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPostDataSource {
  AddPostDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> addPost({required Post post, required String userGmail}) async {
    post.toJson().addAll({
      "user_gmail": userGmail,
      "created_at": FieldValue.serverTimestamp(),
    });

    _firestore.collection("mukr_west_college").add(post.toJson());
  }
}
