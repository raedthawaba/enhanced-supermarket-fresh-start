import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_app/models/user.dart';
import 'package:supermarket_app/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoadAuthStatus>(_onLoadAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onLoadAuthStatus(
    LoadAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final isAuthenticated = await _authRepository.isAuthenticated();
      
      if (isAuthenticated) {
        final user = await _authRepository.getCurrentUser();
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      );
      
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final user = await _authRepository.register(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
        address: event.address,
      );
      
      emit(AuthRegistered(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      await _authRepository.logout();
      
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      await _authRepository.forgotPassword(email: event.email);
      
      emit(const AuthPasswordResetSent(email: ''));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (state is! AuthAuthenticated) {
        emit(AuthError(message: 'يرجى تسجيل الدخول أولاً'));
        return;
      }

      emit(AuthLoading());
      
      final currentUser = (state as AuthAuthenticated).user;
      final updatedUser = await _authRepository.updateProfile(
        userId: currentUser.id,
        name: event.name,
        phone: event.phone,
        address: event.address,
      );
      
      emit(AuthAuthenticated(user: updatedUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}