import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/feature/create_post/cubit/create_post_cubit.dart';
import 'package:anonka/src/feature/create_post/cubit/create_post_state.dart';
import 'package:anonka/src/core/widgets/custom_app_bar.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostScreen
    extends StateblocWidget<CreatePostCubit, CreatePostState> {
  CreatePostScreen({super.key})
    : super(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!.getErrorMessage())),
            );
            context.read<CreatePostCubit>().clearError();
          }

          if (state.isPostCreated) {
            Navigator.pop(context);
          }
        },
      );

  final TextEditingController _postTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _postTextController.dispose();
  }

  void createPost() {
    final String text = _postTextController.text;

    if (text.isEmpty) return;

    if (text.characters.length > 2000) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.longTextWarning)));

      return;
    }

    // TODO показывать material bunner с потверждением для создания поста

    bloc.createPost(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[600],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _postTextController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                      decoration: const InputDecoration(
                        hintText: AppStrings.shareWithYourThoughts,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: createPost,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.purple[600],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: state.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              AppStrings.publish,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
