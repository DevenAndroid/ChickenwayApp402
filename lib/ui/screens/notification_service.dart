import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';


class NotificationService {
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings =
  const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings darwinInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true);
  AndroidNotificationDetails androidNotificationDetails =
  const AndroidNotificationDetails(
      "chicken",
      "chicken_app",
      priority: Priority.max,
      importance: Importance.max);
  DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
    presentSound: true,
  );
  initializeNotification() async {
    requestNotificationPermissions();
    InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings, iOS: darwinInitializationSettings);
    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {

          // log(response.payload.toString());
          // Map<dynamic, dynamic> map = jsonDecode(response.payload.toString());
        }
      },
    ).catchError((e) {
      throw Exception(e);
    });
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // Notification permissions granted
    } else if (status.isDenied) {
      // Notification permissions denied
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
    }
  }



  showSimpleNotification({
    required title,
    required body,
  }) {
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    localNotificationsPlugin.show(
        int.parse(DateTime.now()
            .millisecondsSinceEpoch
            .toString()
            .substring(DateTime.now().millisecondsSinceEpoch.toString().length - 5)),
        title,
        body,
        notificationDetails);
  }

  showNotificationWithPayLoad({
    required title,
    required body,
    required payload,
  }) {
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    localNotificationsPlugin
        .show(
        int.parse(DateTime.now()
            .millisecondsSinceEpoch
            .toString()
            .substring(DateTime.now().millisecondsSinceEpoch.toString().length - 5)),
        title,
        body,
        notificationDetails,
        payload: payload)
        .catchError((e) {
      throw Exception(e);
    });
  }

  hideAllNotifications(){
    localNotificationsPlugin.cancelAll();
  }

  showNotificationWithProgress({
    required title,
    required body,
    required payload,
    required int maxProgress,
    required int progress,
    required int progressId,
  }) {
    final AndroidNotificationDetails androidNotificationDetailsProgress = AndroidNotificationDetails(
        "dirise_channel", "dirise_channel_app",
        channelDescription: 'progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress);
    final NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetailsProgress);
    localNotificationsPlugin.show(progressId, title, body, notificationDetails, payload: payload).catchError((e) {
      throw Exception(e);
    });
  }
}