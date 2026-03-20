import 'dart:io';

import 'package:anonka/src/feature/create_post/model/create_post.dart';
import 'package:anonka/src/feature/post/model/poll.dart';
import 'package:anonka/src/feature/post/model/poll_option.dart';
import 'package:anonka/src/feature/post/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  const CreatePostRepository(this._firestore, this._storage);

  Future<Post> createPost({
    required CreatePost createPost,
    required String channel,
    String? imagePath,
  }) async {
    final postJson = createPost.toJson();

    String? downloadUrl;

    if (imagePath != null) {
      final refToUploadImage = _storage
          .ref()
          .child(channel)
          .child(
            "${createPost.userEmail}___${DateTime.now()}___${createPost.text}",
          );

      await refToUploadImage.putFile(File(imagePath));

      downloadUrl = await refToUploadImage.getDownloadURL();
    }

    postJson.addAll({"created_at": FieldValue.serverTimestamp()});

    if (downloadUrl != null) {
      postJson.addAll({"image_url": downloadUrl});
    }

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
      imageUrl: downloadUrl,
      poll: createPost.poll != null
          ? Poll(
              question: createPost.poll!.question,
              options: createPost.poll!.options
                  .map(
                    (optionText) => PollOption(
                      text: optionText,
                      votesCount: 0,
                      votedUsers: [],
                    ),
                  )
                  .toList(),
              totalVotes: 0,
            )
          : null,
    );
  }
}
