import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'supermarket_channel',
    'Supermarket Notifications',
    channelDescription: 'Notifications for supermarket app',
    importance: Importance.high,
    priority: Priority.high,
  );

  static const DarwinNotificationDetails _iOSNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request permissions for iOS
    if (!kIsWeb) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to specific screen based on payload
    print('Notification tapped: ${response.payload}');
  }

  Future<void> showOrderNotification({
    required String title,
    required String message,
    required String orderId,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      _notificationDetails,
      payload: 'order_$orderId',
    );
  }

  Future<void> showDeliveryNotification({
    required String title,
    required String message,
    required String orderId,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      _notificationDetails,
      payload: 'delivery_$orderId',
    );
  }

  Future<void> showOfferNotification({
    required String title,
    required String message,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      _notificationDetails,
      payload: 'offer',
    );
  }

  Future<void> showSystemNotification({
    required String title,
    required String message,
    String? payload,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      _notificationDetails,
      payload: payload ?? 'system',
    );
  }

  Future<void> scheduleOrderReminder({
    required String title,
    required String message,
    required String orderId,
    required DateTime scheduledDate,
  }) async {
    // Use schedule instead of zonedSchedule for simpler implementation
    await _notifications.schedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      scheduledDate,
      _notificationDetails,
      payload: 'reminder_$orderId',
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> showBadgeCount(int count) async {
    if (!kIsWeb) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    }
  }

  Future<void> hideBadgeCount() async {
    if (!kIsWeb) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}