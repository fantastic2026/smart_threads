import 'package:smart_threads/data/datasourses/local_post_datasource.dart';
import 'package:smart_threads/data/datasourses/remote_post_data_source.dart';
import 'package:smart_threads/data/models/post_model.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final LocalPostDatasource _local;
  final RemotePostDataSource _remote;

  PostRepositoryImpl(this._local, this._remote);

  @override
  Future<void> createPost(Post post) async {
    final model = PostModel.fromEntity(post);

    await _remote.createPost(model);

    await _local.savePost(model);
  }

  @override
  Future<List<Post>> getFeed() async {
    try {
      final remotePosts = await _remote.getPosts();

      await _local.clear();

      for (final post in remotePosts) {
        await _local.savePost(post);
      }

      return remotePosts.map((e) => e.toEntity()).toList();
    } catch (_) {
      final models = await _local.getPosts();
      return models.map((e) => e.toEntity()).toList();
    }
  }

  @override
  Future<void> likePost(String postId) async {
    final box = await _local.getPosts();

    final model = box.firstWhere((m) => m.id == postId);

    final updated = model.copyWith(
      likes: model.isLiked ? model.likes - 1 : model.likes + 1,
      isLiked: !model.isLiked,
    );

    await _local.updatePost(updated);
  }

  @override
  Future<List<Post>> getPostsByUser(String authorId) async {
    final models = await _local.getPostsByUser(authorId);
    return models.map((m) => m.toEntity()).toList();
  }
}
