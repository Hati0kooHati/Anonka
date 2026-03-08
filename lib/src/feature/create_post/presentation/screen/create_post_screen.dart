import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:anonka/src/core/extension/object_extensions.dart';
import 'package:anonka/src/feature/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:anonka/src/feature/create_post/presentation/cubit/create_post_state.dart';
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

          if (state.createdPost != null) {
            FocusScope.of(context).unfocus();
            Navigator.pop(context, state.createdPost);
          }
        },
      );

  final TextEditingController _postTextController = TextEditingController();
  final TextEditingController _pollQuestionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // One controller per poll option, kept in sync with state.pollOptions length.
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

  /// Keep _optionControllers list length in sync with state.pollOptions.
  void _syncOptionControllers(List<String> pollOptions) {
    while (_optionControllers.length < pollOptions.length) {
      _optionControllers.add(TextEditingController());
    }
    while (_optionControllers.length > pollOptions.length) {
      _optionControllers.removeLast().dispose();
    }
  }

  bool _canPublish(CreatePostState s) {
    if (s.isPollMode) {
      final questionFilled = _pollQuestionController.text.trim().isNotEmpty;
      final allOptionsFilled = s.pollOptions.every((o) => o.trim().isNotEmpty);
      return questionFilled && allOptionsFilled;
    }
    return _postTextController.text.trim().isNotEmpty;
  }

  void _onPublish() {
    if (state.isLoading) return;

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
    // Sync controllers every build (safe — only adds/removes if length changed)
    _syncOptionControllers(state.pollOptions);

    final bool canPublish = _canPublish(state) && !state.isLoading;

    return GestureDetector(
      onTap: () {
        if (!_focusNode.hasFocus) _focusNode.requestFocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(),
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Poll mode toggle
                  _PollToggleButton(
                    isActive: state.isPollMode,
                    onTap: bloc.togglePollMode,
                  ),

                  const SizedBox(height: 12),

                  // Content area
                  Expanded(
                    child: state.isPollMode
                        ?
                          // poll mode
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Question
                                _PollTextField(
                                  controller: _pollQuestionController,
                                  hintText: AppStrings.question,
                                  autofocus: true,
                                  // Rebuild to update publish button state.
                                  onChanged: (_) => bloc.emit(state.copyWith()),
                                ),

                                const SizedBox(height: 12),

                                // Options
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

                                // Add option
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                            ),
                          )
                        :
                          // not poll mode
                          Container(
                            padding: const EdgeInsets.all(12),
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
                              maxLines: null,
                              expands: true,
                              enableInteractiveSelection: true,
                              // Trigger a rebuild so publish button reacts to text changes.
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
                  ),

                  const SizedBox(height: 16),

                  // Publish button
                  _PublishButton(
                    isLoading: state.isLoading,
                    canPublish: canPublish,
                    onTap: _onPublish,
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
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
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
