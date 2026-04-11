import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_cubit.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 8,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black,
              child: Text(
                'me',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlocBuilder<CommentsCubit, CommentsState>(
                buildWhen: (previous, current) =>
                    previous.inputText != current.inputText,
                builder: (context, state) {
                  if (state.inputText.isEmpty && _controller.text.isNotEmpty) {
                    _controller.clear();
                  }

                  return TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Добавить коментарий',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(fontSize: 14),
                    onChanged: context.read<CommentsCubit>().inputChanged,
                    onFieldSubmitted: (_) => _submit(context),
                  );
                },
              ),
            ),
            BlocBuilder<CommentsCubit, CommentsState>(
              buildWhen: (previous, current) =>
                  previous.canSubmit != current.canSubmit,
              builder: (context, state) {
                return IconButton(
                  onPressed: state.canSubmit
                      ? () {
                          _submit(context);
                        }
                      : null,
                  icon: Icon(
                    Icons.send_rounded,
                    color: state.canSubmit
                        ? Colors.black
                        : Colors.grey.shade300,
                    size: 22,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    context.read<CommentsCubit>().addComment();
    _controller.clear();
  }
}
