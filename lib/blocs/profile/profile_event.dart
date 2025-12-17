part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? name;
  final String? phone;
  final String? address;
  final DateTime? birthDate;
  final Gender? gender;

  const UpdateProfile({
    this.name,
    this.phone,
    this.address,
    this.birthDate,
    this.gender,
  });

  @override
  List<Object?> get props => [
        name,
        phone,
        address,
        birthDate,
        gender,
      ];
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [
        currentPassword,
        newPassword,
        confirmPassword,
      ];
}

class UploadProfileImage extends ProfileEvent {
  final String imagePath;

  const UploadProfileImage({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

class UpdateNotificationSettings extends ProfileEvent {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;

  const UpdateNotificationSettings({
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.pushNotifications,
  });

  @override
  List<Object> get props => [
        notificationsEnabled,
        emailNotifications,
        smsNotifications,
        pushNotifications,
      ];
}

class UpdatePreferences extends ProfileEvent {
  final String language;
  final String currency;

  const UpdatePreferences({
    required this.language,
    required this.currency,
  });

  @override
  List<Object> get props => [language, currency];
}