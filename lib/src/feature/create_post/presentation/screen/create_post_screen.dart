import 'dart:io';

import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/feature/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:anonka/src/feature/create_post/presentation/cubit/create_post_state.dart';
import 'package:anonka/src/core/widgets/custom_app_bar.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:anonka/src/feature/create_post/presentation/widget/full_screen_image_widget.dart';
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

          if (state.createdPost != null) {
            FocusScope.of(context).unfocus();
            Navigator.pop(context, state.createdPost);
          }
        },
      );

  final TextEditingController _postTextController = TextEditingController();
  final TextEditingController _pollQuestionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _postTextController.dispose();
    _pollQuestionController.dispose();
    _focusNode.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _syncOptionControllers(List<String> pollOptions) {
    while (_optionControllers.length < pollOptions.length) {
      _optionControllers.add(TextEditingController());
    }
    while (_optionControllers.length > pollOptions.length) {
      _optionControllers.removeLast().dispose();
    }
  }

  bool _canPublish(CreatePostState s) {
    if (!s.canPost) return false;
    if (s.isPollMode) {
      final questionFilled = _pollQuestionController.text.trim().isNotEmpty;
      final allOptionsFilled = s.pollOptions.every((o) => o.trim().isNotEmpty);
      return questionFilled && allOptionsFilled;
    }
    return _postTextController.text.trim().isNotEmpty;
  }

  void _onPublish() {
    if (state.isLoading || !state.canPost) return;

    if (state.isPollMode) {
      final question = _pollQuestionController.text.trim();
      if (question.isEmpty) return;
      bloc.createPoll(question: question);
    } else {
      final text = _postTextController.text;
      if (text.isEmpty) return;

      if (text.characters.length > 2000) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.longTextWarning)));
        return;
      }

      bloc.createPost(text: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    _syncOptionControllers(state.pollOptions);

    final bool canPublish = _canPublish(state) && !state.isLoading;
    final int remaining = (CreatePostState.dailyLimit - state.postsUsed)
        .clamp(0, CreatePostState.dailyLimit)
        .toInt();

    return GestureDetector(
      onTap: () {
        if (!_focusNode.hasFocus) _focusNode.requestFocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        floatingActionButton: SizedBox(
          height: 50,
          width: 170,
          child: _PublishButton(
            isLoading: state.isLoading,
            canPublish: canPublish,
            onTap: _onPublish,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _PollToggleButton(
                        isActive: state.isPollMode,
                        onTap: bloc.togglePollMode,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: bloc.pickImage,
                        child: SizedBox(
                          child: Icon(Icons.image_outlined, size: 38),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _PostLimitBadge(
                          remaining: remaining,
                          total: CreatePostState.dailyLimit,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (state.pathToSelectedImage != null) ...[
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenImageWidget(
                            path: state.pathToSelectedImage!,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(state.pathToSelectedImage!),
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: bloc.clearSelectedImage,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(160),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  state.isPollMode
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PollTextField(
                              controller: _pollQuestionController,
                              hintText: AppStrings.question,
                              autofocus: true,
                              onChanged: (_) => bloc.emit(state.copyWith()),
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(state.pollOptions.length, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _PollOptionField(
                                  controller: _optionControllers[i],
                                  index: i,
                                  canRemove: state.pollOptions.length > 2,
                                  onRemove: () => bloc.removePollOption(i),
                                  onChanged: (value) =>
                                      bloc.updatePollOption(i, value),
                                ),
                              );
                            }),
                            if (state.pollOptions.length < 10)
                              GestureDetector(
                                onTap: bloc.addPollOption,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.grey.shade400,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        AppStrings.addOption,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
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
                            focusNode: _focusNode,
                            autofocus: true,
                            minLines: 3,
                            maxLines: null,
                            enableInteractiveSelection: true,
                            onChanged: (_) => bloc.emit(state.copyWith()),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                            decoration: const InputDecoration(
                              hintText: AppStrings.shareWithYourThoughts,
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontFamily: 'Roboto',
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

/// Бейдж лимита постов, например «2/3».
class _PostLimitBadge extends StatelessWidget {
  final int remaining;
  final int total;

  const _PostLimitBadge({required this.remaining, required this.total});

  @override
  Widget build(BuildContext context) {
    final bool exhausted = remaining == 0;
    final Color color = exhausted ? Colors.red.shade400 : Colors.grey.shade400;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon(Icons.edit_outlined, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          '$remaining/$total',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}

class _PollToggleButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _PollToggleButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade900 : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.blue.shade600 : Colors.grey.shade700,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.poll_outlined,
              color: isActive ? Colors.blue.shade300 : Colors.grey.shade400,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              AppStrings.survey,
              style: TextStyle(
                color: isActive ? Colors.blue.shade300 : Colors.grey.shade400,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PublishButton extends StatelessWidget {
  final bool isLoading;
  final bool canPublish;
  final VoidCallback onTap;

  const _PublishButton({
    required this.isLoading,
    required this.canPublish,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canPublish ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: canPublish ? Colors.blue.shade800 : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  AppStrings.publish,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: canPublish ? Colors.white : Colors.grey.shade500,
                    fontFamily: 'Montserrat',
                  ),
                ),
        ),
      ),
    );
  }
}

class _PollTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const _PollTextField({
    required this.controller,
    required this.hintText,
    this.autofocus = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        maxLines: 5,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontFamily: 'Roboto',
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _PollOptionField extends StatelessWidget {
  final TextEditingController controller;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;
  final ValueChanged<String>? onChanged;

  const _PollOptionField({
    required this.controller,
    required this.index,
    required this.canRemove,
    required this.onRemove,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: 3,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
              decoration: InputDecoration(
                hintText: '${AppStrings.option} ${index + 1}',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontFamily: 'Roboto',
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (canRemove)
            IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.close, color: Colors.grey.shade500, size: 20),
              splashRadius: 18,
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}
