import 'package:smart_threads/data/models/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteCommentDataSource {
  final SupabaseClient _client;

  RemoteCommentDataSource(this._client);

  /// get comments
  Future<List<CommentModel>> getComments(String postId) async {
    final response = await _client
        .from('comments')
        .select()
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    final list = (response as List)
        .map((json) => CommentModel.fromJson(json))
        .toList();

    return list;
  }

  /// add comment
  Future<void> addComment(CommentModel comment) async {
    await _client.from('comments').insert({
      'post_id' : comment.postId,
      'author_id' : comment.authorId,
      'content' : comment.content,
     });
  }
}
