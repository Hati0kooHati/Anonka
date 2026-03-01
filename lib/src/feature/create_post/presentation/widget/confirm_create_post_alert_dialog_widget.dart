import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class ConfirmCreatePostAlertDialogWidget extends StatelessWidget {
  final Function() createPost;

  const ConfirmCreatePostAlertDialogWidget({
    super.key,
    required this.createPost,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.publishPost),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SizedBox(
            height: 35,
            width: 70,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(AppStrings.no)),
            ),
          ),
        ),

        GestureDetector(
          onTap: createPost,
          child: SizedBox(
            height: 35,
            width: 70,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(AppStrings.yes)),
            ),
          ),
        ),
      ],
    );
  }
}
