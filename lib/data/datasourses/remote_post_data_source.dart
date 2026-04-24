import 'dart:io';

import 'package:smart_threads/data/models/post_model.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemotePostDataSource {
  final SupabaseClient _client;

  RemotePostDataSource(this._client);

  Future<List<PostModel>> getPosts() async {
    final response = await _client
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    final list = (response as List)
        .map((json) => PostModel.fromJson(json))
        .toList();

    return list;
  }

    Future<String> uploadImage(String localPath) async {
    final file = File(localPath);

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage.from('posts').upload(
          fileName,
          file,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

    final publicUrl = _client.storage
        .from('posts')
        .getPublicUrl(fileName);

    return publicUrl;
  }

  Future<void> createPost(PostModel post) async {
    await _client.from('posts').insert({
      'content': post.content,
      'author_id': post.authorId,
      'image_url': post.imageUrl,
      'likes': post.likes,
    });
  }

  Future<List<PostModel>> getPostsByUser(String authorId) async {
    final response = await _client
        .from('posts')
        .select()
        .eq('author_id', authorId)
        .order('created_at', ascending: false);

    final list = (response as List)
        .map((json) => PostModel.fromJson(json))
        .toList();

    return list;
  }
}
