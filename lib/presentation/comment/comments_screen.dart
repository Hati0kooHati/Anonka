import 'package:anonka/core/constants.dart';
import 'package:anonka/core/helpers/error_handler.dart';
import 'package:anonka/injection/inject.dart';
import 'package:anonka/models/comment.dart';
import 'package:anonka/presentation/comment/comments_bloc.dart';
import 'package:anonka/presentation/comment/comments_state.dart';
import 'package:anonka/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StateblocWidget<CommentsBloc, CommentsState> {
  final String commentId;

  CommentsScreen({super.key, required this.commentId})
    : super(createBloc: (context) => get<CommentsBloc>(param1: commentId));

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.loadInitial();
      bloc.showError = (dynamic e) {
        ErrorHandler.showSnackbarErrorMessage(e: e, context: context);
      };
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void sendComment() {
    bloc.sendComment(text: _commentController.text);
    _commentController.clear();
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

            return _buildComment(comment);
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      );
    }

    return _buildCommentSheet(mainContent);
  }

  Widget _buildCommentSheet(
    Widget Function(ScrollController scrollController) mainContent,
  ) {
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
                      onRefresh: bloc.refresh,
                      child: NotificationListener<ScrollEndNotification>(
                        onNotification: bloc.onScrollNotification,
                        child: mainContent(scrollController),
                      ),
                    ),
                  ),
                  _buildCommentInputField(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(left: 15, right: 21, top: 10, bottom: 8),
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

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                controller: _commentController,
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
    );
  }
}
