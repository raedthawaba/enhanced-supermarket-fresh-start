part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class MarkAllAsRead extends NotificationEvent {}

class ClearNotifications extends NotificationEvent {}