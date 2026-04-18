import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_threads/data/models/comment_model.dart';
import 'package:smart_threads/data/models/post_model.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/domain/repositories/auth_repository.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:smart_threads/injection.dart';
import 'package:smart_threads/presentation/bloc/auth/auth_cubit.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_cubit.dart';
import 'package:smart_threads/presentation/widgets/auth_wrapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['API_URL'] ?? '',
    anonKey: dotenv.env['API_KEY'] ?? '',
  );

  await Hive.initFlutter();
  Hive.registerAdapter(PostModelAdapter());
  Hive.registerAdapter(CommentModelAdapter());
  await _seedData();

  await setupDependencies();

  runApp(const MyApp());
}

Future<void> _seedData() async {
  final box = await Hive.openBox<PostModel>('posts');

  final posts = [
    Post(
      id: '1',
      content: 'Красивый день в Астана!',
      authorId: '1',
      createdAt: DateTime.now().toString(),
      likes: 3,
    ),
    Post(
      id: '2',
      content: 'Workng on my Flutter project!',
      authorId: '2',
      createdAt: DateTime.now().toString(),
      likes: 6,
    ),
    Post(
      id: '3',
      content: 'Знакомьтесь, это мой новый пост!',
      authorId: '3',
      createdAt: DateTime.now().toString(),
      likes: 9,
    ),
  ];

  await box.putAll(
    posts.asMap().map(
      (key, post) => MapEntry(post.id, PostModel.fromEntity(post)),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(locator<AuthRepository>())..checkAuth()),
        BlocProvider(create: (_) => FeedCubit(locator<PostRepository>())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const AuthWrapper(),
      ),
    );
  }
}
