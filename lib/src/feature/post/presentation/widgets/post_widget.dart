import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/date_time_extentions.dart';
import 'package:anonka/src/core/icons/icomoon_icons.dart';
import 'package:anonka/src/feature/post/model/post.dart';
import 'package:anonka/src/feature/post/presentation/widgets/action_button.dart';
import 'package:anonka/src/feature/post/presentation/widgets/report_widget.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final int postIndex;
  final Function({required Post post, required int postIndex}) toggleLike;
  final Function({required Post post, required int postIndex}) toggleDislike;
  final Function({required String postId}) onCommentPressed;
  final Function({required String reportType, required String postId}) report;

  const PostWidget({
    super.key,
    required this.post,
    required this.postIndex,
    required this.toggleLike,
    required this.toggleDislike,
    required this.onCommentPressed,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // первый ряд
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.anonim,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(post.createdAt.date),
                    ],
                  ),
                  const Spacer(),
                  ActionButton(
                    icon: Icons.more_horiz_rounded,
                    count: null,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade800,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (_) => ReportWidget(
                                          report: report,
                                          postId: post.id,
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.report_gmailerrorred,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          AppStrings.report,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              // текст
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
              const SizedBox(height: 12),
              // лайк, дизлайк, коммент
              Row(
                children: [
                  Row(
                    children: [
                      ActionButton(
                        icon: post.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        iconColor: post.isLiked ? Colors.red.shade700 : null,
                        count: post.likesCount,
                        onTap: () =>
                            toggleLike(post: post, postIndex: postIndex),
                      ),
                      const SizedBox(width: 32,),
                      ActionButton(
                        icon: post.isDisliked
                            ? Icons.thumb_down
                            : AppIcons.dislike,
                        iconColor: post.isDisliked ? Colors.yellow : null,
                        count: post.dislikesCount,
                        onTap: () =>
                            toggleDislike(post: post, postIndex: postIndex),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ActionButton(
                    icon: Icons.comment,
                    count: post.commentsCount,
                    onTap: () => onCommentPressed(postId: post.id),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(thickness: 1, color: Colors.grey.shade900,),
        const SizedBox(height: 8),
      ],
    );
  }
}
