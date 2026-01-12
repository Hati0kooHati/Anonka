import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/core/injection/inject.dart';
import 'package:anonka/src/feature/post/comment/model/comment.dart';
import 'package:anonka/src/feature/post/comment/cubit/comments_cubit.dart';
import 'package:anonka/src/feature/post/comment/cubit/comments_state.dart';
import 'package:anonka/src/feature/post/comment/ui/widget/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<CommentsCubit>().loadInitial();
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  void sendComment() {
    final String text = _commentTextController.text;
    final int textLength = text.characters.length;

    if (textLength > 2000) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.longTextWarning)));

      return;
    }

    context.read<CommentsCubit>().sendComment(text: text);
  }

  bool onScrollNotification(ScrollEndNotification scrollInfo) {
    final isAtBottom =
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;

    if (isAtBottom && !context.read<CommentsCubit>().state.isLoading) {
      context.read<CommentsCubit>().loadMore();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => get<CommentsCubit>(param1: widget.postId),
      child: BlocConsumer<CommentsCubit, CommentsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!.getErrorMessage())),
            );
            context.read<CommentsCubit>().clearError();
          }
        },
        builder: (context, state) {
          Widget Function(ScrollController scrollController) mainContent;
          if (state.isLoading && state.comments.isEmpty) {
            mainContent = (ScrollController scrollController) => ListView(
              controller: ScrollController(),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.purple),
                  ),
                ),
              ],
            );
          } else if (state.comments.isEmpty) {
            mainContent = (ScrollController scrollController) => ListView(
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

            mainContent = (ScrollController scrollController) =>
                ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: commentsLen + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < commentsLen) {
                      final Comment comment = comments[index];

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        // margin: const EdgeInsets.only(
                        //   left: 15,
                        //   right: 21,
                        //   top: 10,
                        //   bottom: 8,
                        // ),
                        child: CommentWidget(comment: comment),
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
                          child: RefreshIndicator(
                            color: Colors.purple,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            onRefresh: () =>
                                context.read<CommentsCubit>().refresh(),
                            child: NotificationListener<ScrollEndNotification>(
                              onNotification: onScrollNotification,
                              child: mainContent(scrollController),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.purple[800],
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
                                    maxLength: 700,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.purple[700],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(60),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(12),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: sendComment,
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ],
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
