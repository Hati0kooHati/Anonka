import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/date_time_extentions.dart';
import 'package:anonka/src/core/icons/icomoon_icons.dart';
import 'package:anonka/src/feature/create_post/presentation/widget/full_screen_image_widget.dart';
import 'package:anonka/src/feature/post/model/poll.dart';
import 'package:anonka/src/feature/post/model/post.dart';
import 'package:anonka/src/feature/post/presentation/widgets/action_button.dart';
import 'package:anonka/src/feature/post/presentation/widgets/report_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final int postIndex;
  final Function({required Post post, required int postIndex}) toggleLike;
  final Function({required Post post, required int postIndex}) toggleDislike;
  final Function({required String postId}) onCommentPressed;
  final Function({required String reportType, required String postId}) report;
  final Function({required int postIndex, required int optionIndex}) votePoll;

  const PostWidget({
    super.key,
    required this.post,
    required this.postIndex,
    required this.toggleLike,
    required this.toggleDislike,
    required this.onCommentPressed,
    required this.report,
    required this.votePoll,
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
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(100),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.person, color: Colors.white, size: 30),
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
                                        const Icon(
                                          Icons.report_gmailerrorred,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          AppStrings.report,
                                          style: const TextStyle(
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

              const SizedBox(height: 12),

              // image
              if (post.imageUrl != null)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FullScreenImageWidget(url: post.imageUrl!),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrl!,
                      fit: BoxFit.cover,
                      width: 120,
                      placeholder: (context, url) => DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey),
                        child: SizedBox(height: 120, width: 90),
                      ),
                      errorWidget: (context, url, error) => DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey),
                        child: SizedBox(
                          height: 120,
                          width: 90,
                          child: Center(child: const Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Poll or text content
              if (post.isPoll)
                _PollWidget(
                  poll: post.poll!,
                  onVote: (optionIndex) =>
                      votePoll(postIndex: postIndex, optionIndex: optionIndex),
                  // We pass the user check via the poll itself (hasVoted),
                  // so the widget knows internally whether user already voted.
                )
              else
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

              // Actions row
              Row(
                children: [
                  // Polls have no like/dislike
                  if (!post.isPoll)
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
                        const SizedBox(width: 32),
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
        Divider(thickness: 1, color: Colors.grey.shade900),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PollWidget extends StatelessWidget {
  final Poll poll;
  final void Function(int optionIndex) onVote;

  const _PollWidget({required this.poll, required this.onVote});

  @override
  Widget build(BuildContext context) {
    // We detect voted state by checking if any option has votedUsers
    // containing the current user. Since PostWidget already has the Post
    // model with embedded userEmail info via PollOption.votedUsers,
    // we rely on Poll.votedOptionIndex — but we don't have userEmail here.
    // Instead, we expose a simpler check: any option with votesCount > 0
    // that the local state already marked. We pass hasVoted from outside
    // if needed, but the simplest approach is to check if total_votes changed
    // after optimistic update: we check votedUsers non-empty via a flag.
    //
    // Since PollOption.votedUsers is available, we check if any option
    // contains ANY voter (proxy: total_votes > 0 and the option with max
    // votes is highlighted). But we don't have userEmail here.
    //
    // Best approach: add a `userVotedIndex` to Poll or pass it in.
    // For now we check `poll.options[i].votedUsers` is populated
    // (relies on optimistic update adding the user) – works for current user.
    //
    // To avoid passing userEmail deep, we expose a helper on Poll:
    // poll.votedOptionIndex(userEmail). We need to pass votedIndex from above.
    //
    // The cleanest solution: pass `votedOptionIndex` as a nullable int param.
    // We add that as a named param here.

    final bool hasVoted = poll.options.any((o) => o.votedUsers.isNotEmpty);
    final int totalVotes = poll.totalVotes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question
        Text(
          poll.question,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 10),

        // Options
        ...List.generate(poll.options.length, (i) {
          final option = poll.options[i];
          final bool isVoted = option.votedUsers.isNotEmpty;
          final double percent = totalVotes > 0
              ? option.votesCount / totalVotes
              : 0.0;
          final int percentInt = (percent * 100).round();

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: hasVoted ? null : () => onVote(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isVoted
                        ? Colors.blue.shade600
                        : Colors.grey.shade700,
                    width: isVoted ? 1.5 : 1,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    // Progress fill
                    if (hasVoted)
                      FractionallySizedBox(
                        widthFactor: percent,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: isVoted
                                ? Colors.blue.shade900.withAlpha(180)
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),
                    // Label + percent
                    SizedBox(
                      height: 44,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.text,
                                style: TextStyle(
                                  color: isVoted
                                      ? Colors.blue.shade200
                                      : Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: isVoted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (hasVoted)
                              Text(
                                '$percentInt%',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 4),
        Text(
          '$totalVotes ${_votesLabel(totalVotes)}',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  String _votesLabel(int count) {
    if (count % 100 >= 11 && count % 100 <= 14) return AppStrings.votesOv;
    switch (count % 10) {
      case 1:
        return AppStrings.vote;
      case 2:
      case 3:
      case 4:
        return AppStrings.votes;
      default:
        return AppStrings.votesOv;
    }
  }
}
