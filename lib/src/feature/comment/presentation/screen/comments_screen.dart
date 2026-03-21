import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/core/injection/inject.dart';
import 'package:anonka/src/feature/comment/model/comment.dart';
import 'package:anonka/src/feature/comment/presentation/cubit/comments_cubit.dart';
import 'package:anonka/src/feature/comment/presentation/cubit/comments_state.dart';
import 'package:anonka/src/feature/comment/presentation/widget/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late final CommentsCubit _cubit;
  late final TextEditingController _commentTextController;

  final maxCommentsLength = 3000;

  @override
  void initState() {
    super.initState();
    _cubit = get<CommentsCubit>(param1: widget.postId);
    _commentTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadInitial();
    });
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _sendComment() {
    final String text = _commentTextController.text;
    final int textLength = text.length;

    if (text.trim().isEmpty) return;

    if (textLength > maxCommentsLength) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.longTextWarning)));
      return;
    }

    _commentTextController.clear();
    FocusScope.of(context).unfocus();
    _cubit.sendComment(text: text);
  }

  bool _onScrollNotification(ScrollEndNotification scrollInfo) {
    final isAtBottom =
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;

    if (isAtBottom && !_cubit.state.isLoading) {
      _cubit.loadMore();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CommentsCubit, CommentsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!.getErrorMessage())),
            );
            _cubit.clearError();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.7,
                maxChildSize: 1,
                expand: false,
                builder: (context, scrollController) {
                  Widget mainContent;

                  if (state.isLoading && state.comments.isEmpty) {
                    mainContent = ListView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state.comments.isEmpty) {
                    mainContent = ListView(
                      controller: scrollController,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(child: Text(AppStrings.noComments)),
                        ),
                      ],
                    );
                  } else {
                    final List<Comment> comments = state.comments;
                    final int commentsLen = comments.length;

                    mainContent = ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: commentsLen + (state.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < commentsLen) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CommentWidget(
                              comment: comments[index],
                              loadSubComments: _cubit.loadSubComments,
                              replyToComment: _cubit.setReplyingTo,
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );
                  }

                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 3),
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: NotificationListener<ScrollEndNotification>(
                            onNotification: _onScrollNotification,
                            child: mainContent,
                          ),
                        ),
                        if (state.replyingTo != null)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.replyingTo!.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _cubit.clearReplyingTo,
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white54,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _commentTextController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 1,
                              maxLines: 16,
                              maxLength: maxCommentsLength,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                suffixIconConstraints: const BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue.shade800,
                                    ),
                                    child: InkWell(
                                      onTap: _sendComment,
                                      child: const Icon(
                                        Icons.arrow_upward_rounded,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                                hintText: AppStrings.writeComment,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  color: Colors.white.withAlpha(150),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
