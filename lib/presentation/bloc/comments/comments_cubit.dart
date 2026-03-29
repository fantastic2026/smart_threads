import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentRepository _repository;
  final String _postId;

  CommentsCubit(this._repository, this._postId) : super(const CommentsState());

  //load comments

  //addComment

  //input changed

}
