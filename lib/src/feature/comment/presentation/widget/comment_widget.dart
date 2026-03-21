import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/feature/comment/model/comment.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;

  final Function({required String commentId}) loadSubComments;
  final Function(Comment comment) replyToComment;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.loadSubComments,
    required this.replyToComment,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _expanded = false;
  bool _loading = false;

  int get _totalCount => widget.comment.subCommentsCount;
  List<Comment> get _subComments => widget.comment.subComments;
  int get _remaining =>
      (_totalCount - _subComments.length).clamp(0, _totalCount);

  Future<void> _loadNextPage() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      await widget.loadSubComments(commentId: widget.comment.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.getErrorMessage())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleSubCommentsShowing() async {
    if (!_expanded) {
      setState(() => _expanded = true);
      if (_subComments.isEmpty) await _loadNextPage();
    } else {
      setState(() => _expanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasReplies = _totalCount > 0;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color.fromARGB(181, 33, 33, 33),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
            const SizedBox(height: 5.0),
            SelectableText(
              widget.comment.text,
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => widget.replyToComment(widget.comment),
                  child: Text(
                    AppStrings.answer,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (hasReplies)
                  GestureDetector(
                    onTap: _toggleSubCommentsShowing,
                    child: Text(
                      _expanded
                          ? AppStrings.hideReplies
                          : '${AppStrings.showReplies}($_totalCount)',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 8),
              ..._subComments.map(
                (sub) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: _SubCommentWidget(comment: sub),
                ),
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              if (!_loading && _remaining > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: GestureDetector(
                    onTap: _loadNextPage,
                    child: Text(
                      '${AppStrings.showReplies}($_remaining)',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubCommentWidget extends StatelessWidget {
  final Comment comment;
  const _SubCommentWidget({required this.comment});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                const Text(
                  AppStrings.anonim,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SelectableText(
              comment.text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
