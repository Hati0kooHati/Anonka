import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    String? id,
    String? text,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? dislikes,
  }) : id = id ?? "",
       text = text ?? "",
       createdAt = createdAt ?? DateTime.now(),
       likes = likes ?? [],
       dislikes = dislikes ?? [];

  final String id;
  final String text;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> dislikes;

  factory Post.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Post(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: ((data['created_at'] ?? Timestamp.now()) as Timestamp)
          .toDate(),
      likes: doc['likes'] ?? [],
      dislikes: doc['dislikes'] ?? [],
    );
  }

  // тут нету created_at т.к. я добавляю ее когда отправляю запрос
  // в add_post_data_source.  FieldValue.serverTimestamp()

  // нету также id т.к. оно генерируется на Firebase стороне
  Map<String, dynamic> toJson() {
    return {"text": text, "likes": likes, "dislikes": dislikes};
  }

  Post copyWith({
    String? id,
    String? userGmail,
    String? text,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? dislikes,
  }) {
    return Post(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
    );
  }
}
