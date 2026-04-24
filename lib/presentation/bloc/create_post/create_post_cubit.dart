import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/domain/repositories/auth_repository.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:smart_threads/presentation/bloc/create_post/create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _repository;
  final ImagePicker _picker;
  final AuthRepository _authRepository;

  CreatePostCubit(this._repository, this._picker, this._authRepository)
    : super(const CreatePostState());

  void contentChanged(String value) {
    emit(state.copyWith(content: value));
  }

  Future<void> pickFromGallery() async {
    print('method called');
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    print('object');
    print(file);

    if (file == null) return;

    print('got galley');
    print(file.path);

    emit(state.copyWith(imageUrl: file.path));
  }

  void removeImage() {
    emit(state.copyWith(imageUrl: null));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: CreatePostStatus.loading));

    final currentUser = _authRepository.currentUser;

    final newPost = Post(
      id: DateTime.now().millisecond.toString(),
      content: state.content.trim(),
      authorId: currentUser!.id,
      createdAt: DateTime.now().toIso8601String(),
      likes: 0,
      imageUrl: state.imageUrl,
    );

    try {
      await _repository.createPost(newPost);
      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreatePostStatus.failure,
          errorMessage: 'Ошибка создания поста',
        ),
      );
    }
  }
}
