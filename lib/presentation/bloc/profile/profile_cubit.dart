import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/user.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:smart_threads/presentation/bloc/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final PostRepository _postRepository;

  ProfileCubit(this._postRepository) : super(const ProfileState());

  ///load profile
  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final posts = await _postRepository.getPostsByUser(userId);

      final user = _getMockUser(userId, posts.length);

      emit(
        state.copyWith(status: ProfileStatus.success, user: user, posts: posts),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Не удалось загрузить данные',
          status: ProfileStatus.failure,
        ),
      );
    }
  }

  /// _getMockUser
  User _getMockUser(String userId, int postsCount) {
    final mockUsers = {
      'me': User(
        id: 'me',
        username: 'me',
        avatarUrl: '',
        bio: 'Flutter Developer',
        postCount: postsCount,
      ),
      'aigerim': User(
        id: 'aigerim',
        username: 'aigerim',
        avatarUrl: '',
        bio: 'Люблю кофе и Flutter',
        postCount: postsCount,
      ),
      'marat': User(
        id: 'marat',
        username: 'marat',
        avatarUrl: '',
        bio: 'Backend developer',
        postCount: postsCount,
      ),
    };

    return mockUsers[userId] ?? User(id: '', username: '  ', avatarUrl: '');
  }
}
