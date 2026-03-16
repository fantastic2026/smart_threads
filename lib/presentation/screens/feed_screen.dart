import 'package:flutter/material.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/presentation/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      Post(
        id: '1',
        content: 'Coffee was great!',
        authorId: 'alex',
        createdAt: '',
        likes: 5,
      ),
      Post(
        id: '2',
        content: 'Had a great day!',
        authorId: 'aigerim',
        createdAt: '',
        likes: 5,
      ),
      Post(
        id: '3',
        content: 'Developing Flutter app',
        authorId: 'marat',
        createdAt: '',
        likes: 5,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Threads',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(post: post);
        },
        separatorBuilder: (_, _) => Divider(height: 1,),
        itemCount: posts.length,
      ),
    );
  }
}
