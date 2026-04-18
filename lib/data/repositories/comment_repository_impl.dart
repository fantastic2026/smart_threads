import 'package:smart_threads/data/datasourses/local_comment_data_source.dart';
import 'package:smart_threads/data/datasourses/remote_comment_data_source.dart';
import 'package:smart_threads/data/models/comment_model.dart';
import 'package:smart_threads/domain/entities/comment.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final LocalCommentDataSource _local;
  final RemoteCommentDataSource _remote;

  CommentRepositoryImpl(this._local, this._remote);

  @override
  Future<void> addComment(Comment comment) async {
    final model = CommentModel.fromEntity(comment);

    await _remote.addComment(model);

    await _local.saveComment(model);
  }

  @override
  Future<int> getCommentsCount(String postId) async {
    return await _local.getCountByPost(postId);
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    try {
      final remoteComments = await _remote.getComments(postId);

      _local.clear();

      for (final comment in remoteComments) {
        await _local.saveComment(comment);
      }

      return remoteComments.map((m) => m.toEntity()).toList();
    } catch (_) {
      final models = await _local.getCommentsByPost(postId);
      return models.map((m) => m.toEntity()).toList();
    }
  }
}
