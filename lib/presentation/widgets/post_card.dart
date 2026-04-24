import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/presentation/bloc/auth/auth_cubit.dart';
import 'package:smart_threads/presentation/screens/comments_screen.dart';
import 'package:smart_threads/presentation/screens/profile_screen.dart';
import 'package:smart_threads/presentation/widgets/like_button.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                ProfileScreen.route(context, post.authorId!),
              );
            },
            child: CircleAvatar(radius: 20, child: Icon(Icons.person)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(() {
                  final currentUser = context.read<AuthCubit>().state.user;
                  if (currentUser != null && post.authorId == currentUser.id) {
                    return currentUser.username;
                  }
                  return post.authorId ?? 'null';
                }(), style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(post.content ?? '', style: TextStyle(fontSize: 15)),
                const SizedBox(height: 10),

                if (post.imageUrl != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      post.imageUrl!,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),

                Row(
                  children: [
                    LikeButton(post: post),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => CommentsScreen.show(context, post),
                      child: Icon(Icons.mode_comment_outlined, size: 20),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.repeat, size: 20),
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
