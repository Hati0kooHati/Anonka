import 'package:anonka/src/core/constants.dart';
import 'package:anonka/src/core/helpers/error_handler.dart';
import 'package:anonka/src/feature/add_post/model/post.dart';
import 'package:anonka/src/feature/comment/comments_screen.dart';
import 'package:anonka/src/feature/posts/posts_bloc.dart';
import 'package:anonka/src/feature/posts/posts_state.dart';
import 'package:anonka/src/feature/posts/widgets/post_widget.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StateblocWidget<PostsBloc, PostsState> {
  PostsScreen({super.key});

  @override
  void initState() {
    super.initState();
    bloc.loadInitial(onFailed: onFailed);
  }

  void onFailed(dynamic e) {
    ErrorHandler.showSnackbarErrorMessage(e: e, context: context);
  }

  bool onScrollNotification(ScrollEndNotification scrollInfo) {
    final isAtBottom =
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;

    if (isAtBottom && !state.isLoading) {
      bloc.loadMore(onFailed: onFailed);
    }

    return false;
  }

  void showCommentsSheet(Post post) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CommentsScreen(commentId: post.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late final Widget mainContent;
    final height = MediaQuery.of(context).size.height;

    if (state.isLoading && state.posts.isEmpty) {
      mainContent = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: height * 0.40),
          Center(child: CircularProgressIndicator(color: Colors.purple)),
        ],
      );
    } else if (state.posts.isEmpty) {
      mainContent = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: height * 0.85,
            child: Center(child: Text(AppStrings.noPosts)),
          ),
        ],
      );
    } else {
      final List<Post> posts = state.posts;
      final int postsLen = posts.length;

      mainContent = ListView.builder(
        itemCount: postsLen + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < postsLen) {
            final Post post = posts[index];

            return PostWidget(
              post: post,
              bloc: bloc,
              onCommentPressed: showCommentsSheet,
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

    return RefreshIndicator(
      color: Colors.purple,
      backgroundColor: Colors.white,
      elevation: 0,
      onRefresh: () => bloc.refresh(onFailed: onFailed),
      child: NotificationListener<ScrollEndNotification>(
        onNotification: onScrollNotification,
        child: mainContent,
      ),
    );
  }
}
