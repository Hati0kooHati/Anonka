import 'package:anonka/core/constants.dart';
import 'package:anonka/core/helpers/error_handler.dart';
import 'package:anonka/presentation/add_post/add_post_bloc.dart';
import 'package:anonka/presentation/add_post/add_post_state.dart';
import 'package:anonka/widgets/custom_app_bar.dart';
import 'package:anonka/widgets/custom_snack_bar.dart';
import 'package:anonka/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StateblocWidget<AddPostBloc, AddPostState> {
  AddPostScreen({super.key});

  final TextEditingController _postTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _postTextController.dispose();
  }

  void onSuccess() {
    Navigator.pop(context);
  }

  void onFailed(dynamic e) {
    ErrorHandler.showSnackbarErrorMessage(e: e, context: context);
  }

  void publish() {
    final String text = _postTextController.text;
    final int textLength = text.characters.length;

    if (textLength < 5) {
      CustomSnackBar.showSnackBar(
        context,
        content: Text(AppStrings.shortTextWarning),
        backgroundColor: Colors.yellow,
        duration: Duration(seconds: 3),
      );

      return;
    }

    if (textLength > 2000) {
      CustomSnackBar.showSnackBar(
        context,
        content: Text(AppStrings.longTextWarning),
        backgroundColor: Colors.yellow,
        duration: Duration(seconds: 3),
      );
    }

    bloc.publish(text: text, onSuccess: onSuccess, onFailed: onFailed);
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

                _buildInputField(),
                const SizedBox(height: 16),

                _buildSubmitButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Expanded(
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
            hintStyle: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: publish,
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
    );
  }
}
