import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:anonka/src/feature/post/model/post.dart';
import 'package:anonka/src/feature/post/comment/presentation/screen/comments_screen.dart';
import 'package:anonka/src/feature/post/presentation/cubit/posts_cubit.dart';
import 'package:anonka/src/feature/post/presentation/cubit/posts_state.dart';
import 'package:anonka/src/feature/post/presentation/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsScreen extends StateblocWidget<PostsCubit, PostsState> {
  PostsScreen({super.key})
    : super(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!.getErrorMessage())),
            );
            context.read<PostsCubit>().clearError();
          }
        },
      );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(((_) {
      bloc.loadInitial();
    }));
  }

  bool onScrollNotification(ScrollEndNotification scrollInfo) {
    final isAtBottom =
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;

    if (isAtBottom && !state.isLoading) {
      bloc.loadMore();
    }

    return false;
  }

  void showCommentsSheet({required String postId}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CommentsScreen(postId: postId);
      },
    );
  }

  void report({required String reportType, required String postId}) {
    bloc.report(reportType: reportType, postId: postId);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppStrings.reportPublished)));
    print("pubushed");
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
        itemBuilder: (context, postIndex) {
          if (postIndex < postsLen) {
            final Post post = posts[postIndex];

            return PostWidget(
              post: post,
              postIndex: postIndex,
              toggleLike: bloc.toggleLike,
              toggleDislike: bloc.toggleDislike,
              onCommentPressed: showCommentsSheet,
              report: report,
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
      onRefresh: bloc.refresh,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: onScrollNotification,
        child: mainContent,
      ),
    );
  }
}
