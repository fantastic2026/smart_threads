import 'package:flutter/material.dart';
import 'package:smart_threads/domain/entities/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.authorId,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(post.content, style: TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 20),
                    const SizedBox(width: 20),
                    const Icon(Icons.mode_comment_outlined, size: 20),
                    const SizedBox(width: 20),
                    const Icon(Icons.repeat, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
