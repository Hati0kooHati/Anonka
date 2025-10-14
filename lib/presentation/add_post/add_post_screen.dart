import 'package:anonka/presentation/add_post/add_post_bloc.dart';
import 'package:anonka/presentation/add_post/add_post_state.dart';
import 'package:anonka/widgets/custom_app_bar.dart';
import 'package:anonka/widgets/custom_snack_bar.dart';
import 'package:anonka/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StateblocWidget<AddPostBloc, AddPostState> {
  final TextEditingController _textController = TextEditingController();

  AddPostScreen({super.key});

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.showSnackBar = (Widget content) {
        CustomSnackBar.showSnackBar(
          context,
          content: content,
          duration: Duration(milliseconds: 500),
        );
      };
    });
  }

  void onSuccess() {
    Navigator.pop(context);
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
                const Text(
                  'Напиши свой вайб ✨',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 20),

                _buildInputField(),
                const SizedBox(height: 16),

                _buildSubmitButton(),
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
          controller: _textController,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
          decoration: const InputDecoration(
            hintText: 'Поделись своим мнением 👀',
            hintStyle: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () =>
          bloc.publish(textController: _textController, onSuccess: onSuccess),
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
                  'Опубликовать!',
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
