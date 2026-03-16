import 'package:hive_ce/hive_ce.dart';
import 'package:smart_threads/domain/entities/post.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class PostModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final String authorId;
  @HiveField(3)
  final String createdAt;
  @HiveField(4)
  final int likes;

  PostModel({
    required this.id,
    required this.content,
    required this.authorId,
    required this.createdAt,
    required this.likes,
  });

  Post toEntity() {
    return Post(
      id: id,
      content: content,
      authorId: authorId,
      createdAt: createdAt,
      likes: likes,
    );
  }
}
