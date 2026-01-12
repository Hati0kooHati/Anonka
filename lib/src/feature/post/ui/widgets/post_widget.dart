import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/feature/post/model/post.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final int postIndex;
  final Function({required Post post, required int postIndex}) toggleLike;
  final Function({required Post post, required int postIndex}) toggleDislike;
  final Function({required String postId}) onCommentPressed;

  const PostWidget({
    super.key,
    required this.post,
    required this.postIndex,
    required this.toggleLike,
    required this.toggleDislike,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[800],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(100),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 8),
              const Text(
                AppStrings.anonim,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Roboto',
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Like button
              _buildActionButton(
                icon: Icons.thumb_up,
                count: post.likesCount,
                onTap: () => toggleLike(post: post, postIndex: postIndex),
              ),
              // Dislike button
              _buildActionButton(
                icon: Icons.thumb_down,
                count: post.dislikesCount,
                onTap: () => toggleDislike(post: post, postIndex: postIndex),
              ),
              // Comment button
              _buildActionButton(
                icon: Icons.comment,
                count: null,
                onTap: () => onCommentPressed(postId: post.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int? count,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(80),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              '${count ?? ''}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
