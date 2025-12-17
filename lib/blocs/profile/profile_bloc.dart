import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ChangePassword>(_onChangePassword);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<UpdateNotificationSettings>(_onUpdateNotificationSettings);
    on<UpdatePreferences>(_onUpdatePreferences);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      
      // Mock profile data
      final profile = ProfileData(
        name: 'أحمد محمد',
        email: 'ahmed@example.com',
        phone: '+966501234567',
        address: 'الرياض، حي الملقا، شارع الملك فهد',
        birthDate: DateTime(1990, 5, 15),
        gender: Gender.male,
        preferences: UserPreferences(
          language: 'ar',
          currency: 'SAR',
          notificationsEnabled: true,
          emailNotifications: true,
          smsNotifications: false,
          pushNotifications: true,
        ),
      );
      
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is! ProfileLoaded) return;
      
      emit(ProfileLoading());
      
      final currentState = state as ProfileLoaded;
      final updatedProfile = currentState.profile.copyWith(
        name: event.name,
        phone: event.phone,
        address: event.address,
        birthDate: event.birthDate,
        gender: event.gender,
      );
      
      emit(ProfileLoaded(profile: updatedProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      
      // Simulate password change
      await Future.delayed(const Duration(seconds: 1));
      
      emit(const ProfilePasswordChanged());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is! ProfileLoaded) return;
      
      emit(ProfileLoading());
      
      final currentState = state as ProfileLoaded;
      final updatedProfile = currentState.profile.copyWith(
        profileImage: event.imagePath,
      );
      
      emit(ProfileLoaded(profile: updatedProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettings event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is! ProfileLoaded) return;
      
      final currentState = state as ProfileLoaded;
      final updatedProfile = currentState.profile.copyWith(
        preferences: currentState.profile.preferences.copyWith(
          notificationsEnabled: event.notificationsEnabled,
          emailNotifications: event.emailNotifications,
          smsNotifications: event.smsNotifications,
          pushNotifications: event.pushNotifications,
        ),
      );
      
      emit(ProfileLoaded(profile: updatedProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePreferences(
    UpdatePreferences event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is! ProfileLoaded) return;
      
      final currentState = state as ProfileLoaded;
      final updatedProfile = currentState.profile.copyWith(
        preferences: currentState.profile.preferences.copyWith(
          language: event.language,
          currency: event.currency,
        ),
      );
      
      emit(ProfileLoaded(profile: updatedProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}

// Profile Data Models
class ProfileData extends Equatable {
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final DateTime? birthDate;
  final Gender? gender;
  final String? profileImage;
  final UserPreferences preferences;

  const ProfileData({
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.birthDate,
    this.gender,
    this.profileImage,
    required this.preferences,
  });

  ProfileData copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? birthDate,
    Gender? gender,
    String? profileImage,
    UserPreferences? preferences,
  }) {
    return ProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        address,
        birthDate,
        gender,
        profileImage,
        preferences,
      ];
}

class UserPreferences extends Equatable {
  final String language;
  final String currency;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;

  const UserPreferences({
    required this.language,
    required this.currency,
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.pushNotifications,
  });

  UserPreferences copyWith({
    String? language,
    String? currency,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? pushNotifications,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
    );
  }

  @override
  List<Object> get props => [
        language,
        currency,
        notificationsEnabled,
        emailNotifications,
        smsNotifications,
        pushNotifications,
      ];
}

enum Gender {
  male,
  female,
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'ذكر';
      case Gender.female:
        return 'أنثى';
    }
  }
}