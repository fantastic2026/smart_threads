import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_threads/data/datasourses/local_comment_data_source.dart';
import 'package:smart_threads/data/datasourses/local_post_datasource.dart';
import 'package:smart_threads/data/datasourses/remote_comment_data_source.dart';
import 'package:smart_threads/data/datasourses/remote_post_data_source.dart';
import 'package:smart_threads/data/repositories/auth_repository_impl.dart';
import 'package:smart_threads/data/repositories/comment_repository_impl.dart';
import 'package:smart_threads/data/repositories/post_repository_impl.dart';
import 'package:smart_threads/domain/repositories/auth_repository.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;

Future<void> setupDependencies() async {
  /// external

  locator.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  locator.registerLazySingleton<ImagePicker>(() => ImagePicker());

  /// data sources

  locator.registerLazySingleton<LocalPostDatasource>(
    () => LocalPostDatasource(),
  );

  locator.registerLazySingleton<LocalCommentDataSource>(
    () => LocalCommentDataSource(),
  );

  locator.registerLazySingleton<RemotePostDataSource>(
    () => RemotePostDataSource(locator<SupabaseClient>()),
  );

  locator.registerLazySingleton<RemoteCommentDataSource>(
    () => RemoteCommentDataSource(locator<SupabaseClient>()),
  );

  ///repositories

  locator.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(
      locator<LocalCommentDataSource>(),
      locator<RemoteCommentDataSource>(),
    ),
  );

  locator.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      locator<LocalPostDatasource>(),
      locator<RemotePostDataSource>(),
    ),
  );

    locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator<SupabaseClient>())
  );
}
