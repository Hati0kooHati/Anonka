import 'package:anonka/constants.dart';
import 'package:anonka/models/post.dart';
import 'package:flutter/material.dart';

class CommentsSheet extends StatefulWidget {
  final Post post;
  final Function({
    required TextEditingController commentController,
    required Post post,
  })
  sendComment;

  const CommentsSheet({
    super.key,
    required this.post,
    required this.sendComment,
  });

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
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
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: widget.post.comments.length,
                      itemBuilder: (context, index) {
                        return _buildComment(widget.post.comments[index]);
                      },
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

  Widget _buildComment(String comment) {
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
            comment,
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
              onPressed: () => widget.sendComment(
                post: widget.post,
                commentController: _commentController,
              ),
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
