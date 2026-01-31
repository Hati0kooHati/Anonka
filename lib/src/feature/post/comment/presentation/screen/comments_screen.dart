import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/core/injection/inject.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:anonka/src/feature/post/comment/model/comment.dart';
import 'package:anonka/src/feature/post/comment/presentation/cubit/comments_cubit.dart';
import 'package:anonka/src/feature/post/comment/presentation/cubit/comments_state.dart';
import 'package:anonka/src/feature/post/comment/presentation/widget/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsScreen extends StateblocWidget<CommentsCubit, CommentsState> {
  final String postId;

  CommentsScreen({super.key, required this.postId})
    : super(
        create: (context) {
          return get<CommentsCubit>(param1: postId);
        },
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!.getErrorMessage())),
            );
            context.read<CommentsCubit>().clearError();
          }
        },
      );

  final TextEditingController _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.loadInitial();
    });
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  void sendComment() {
    final String text = _commentTextController.text;
    final int textLength = text.characters.length;

    if (text.isEmpty) return;

    if (textLength > 2000) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.longTextWarning)));

      return;
    }

    _commentTextController.clear();

    bloc.sendComment(text: text);
  }

  bool onScrollNotification(ScrollEndNotification scrollInfo) {
    final isAtBottom =
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;

    if (isAtBottom && !state.isLoading) {
      bloc.loadMore();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
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

      mainContent = (ScrollController scrollController) => ListView.builder(
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                      onRefresh: () => bloc.refresh(),
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
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade800,
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
                              padding: const EdgeInsets.all(6.5),
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
  }
}
