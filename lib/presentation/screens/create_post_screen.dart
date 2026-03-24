import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новый пост'),
        actions: [
          TextButton(
            onPressed: () async {
              final text = _controller.text.trim();
              if (text.isEmpty) return;

              await context.read<FeedCubit>().addPost(text);
              Navigator.pop(context);
            },
            child: Text('Опубликовать'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(radius: 20, child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Что нового?',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
