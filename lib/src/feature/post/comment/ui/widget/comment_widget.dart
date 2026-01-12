import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/feature/post/comment/model/comment.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.purple[800],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white),
              const SizedBox(width: 8.0),
              const Text(
                AppStrings.anonim,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          SelectableText(
            comment.text,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
