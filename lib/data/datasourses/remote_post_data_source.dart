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
