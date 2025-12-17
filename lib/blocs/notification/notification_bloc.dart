import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<ClearNotifications>(_onClearNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading());
      
      // Mock notifications for now
      final notifications = <NotificationItem>[
        NotificationItem(
          id: '1',
          title: 'طلبك جاهز',
          message: 'طلبك رقم 12345 جاهز للتسليم',
          type: NotificationType.order,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
        ),
        NotificationItem(
          id: '2',
          title: 'عرض خاص',
          message: 'خصم 20% على جميع المنتجات العضوية',
          type: NotificationType.offer,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: false,
        ),
      ];
      
      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        final updatedNotifications = currentState.notifications.map((notification) {
          if (notification.id == event.notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();
        
        emit(NotificationsLoaded(notifications: updatedNotifications));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        final updatedNotifications = currentState.notifications
            .map((notification) => notification.copyWith(isRead: true))
            .toList();
        
        emit(NotificationsLoaded(notifications: updatedNotifications));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onClearNotifications(
    ClearNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationsLoaded(notifications: []));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }
}

class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object> get props => [
        id,
        title,
        message,
        type,
        timestamp,
        isRead,
      ];
}

enum NotificationType {
  order,
  offer,
  system,
  delivery,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.order:
        return 'طلب';
      case NotificationType.offer:
        return 'عرض';
      case NotificationType.system:
        return 'نظام';
      case NotificationType.delivery:
        return 'توصيل';
    }
  }
}