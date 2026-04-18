import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/data/datasourses/local_post_datasource.dart';
import 'package:smart_threads/data/repositories/post_repository_impl.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:smart_threads/injection.dart';
import 'package:smart_threads/presentation/bloc/profile/profile_cubit.dart';
import 'package:smart_threads/presentation/bloc/profile/profile_state.dart';
import 'package:smart_threads/presentation/widgets/profile_content.dart';
import 'package:smart_threads/presentation/widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  static MaterialPageRoute route(BuildContext context, String userId) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              ProfileCubit(locator<PostRepository>())
                ..loadProfile(userId),
          child: ProfileScreen(userId: userId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Text(
              state.user?.username ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfileStatus.failure) {
            return Center(
              child: Column(
                children: [
                  Text(state.errorMessage ?? 'Ошибка при получении данных'),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileCubit>().loadProfile(userId);
                    },
                    child: Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              ProfileHeader(
                user: state.user!,
                isOwnProfile: state.user?.id == 'me',
              ),
              ProfileContent(
                posts: state.posts,
                isOwnProfile: state.user?.id == 'me',
              ),
            ],
          );
        },
      ),
    );
  }
}
