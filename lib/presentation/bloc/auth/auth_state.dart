import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_threads/domain/entities/auth_user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    AuthUser? user,
    String? errorMessage,
  }) = _AuthState;
}
