import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../backend/databaseRequests/notificationDBRequest.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(android: androidInit, iOS: darwinInit);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
      //onDidReceiveBackgroundNotificationResponse: onSelectNotification,
    );

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final areNotificationsEnabled = await androidPlugin.areNotificationsEnabled();
      if (areNotificationsEnabled == null || !areNotificationsEnabled) {
        await androidPlugin.requestNotificationsPermission();
      }
    }

    requestIOSPermissions();
  }

  Future<void> requestIOSPermissions() async {
    final iOSPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await iOSPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> onSelectNotification(NotificationResponse response) async {
    // Handle notification tapped logic here
  }


  // instant notif
  Future<void> showNotification(int id, String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      // Channel_id and channel_name should be modified to pertain to either Selfcare or moodlog reminders
      'channel_id', 'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    // iOS Notification Details
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const platformDetails = NotificationDetails(android: androidDetails, iOS: darwinDetails);

    await flutterLocalNotificationsPlugin.show(id, title, body, platformDetails);
  }

  // Schedule a Notification 
  Future<void> scheduleNotification(
    int id, 
    String title, 
    String body, 
    DateTime scheduledDate, 
    BuildContext context
    ) async {
    // Check if correct permissions are done
    bool permissions = await checkAndRequestExactAlarmPermission(context);
    if (!permissions) return;

    // Convert scheduledDate to local timezone-aware datetime
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
        scheduledDate, tz.getLocation('America/Puerto_Rico'));
        
    print('scheduled_date (local): $scheduledDate');
    print('scheduled_time (tz.TZDateTime): $scheduledTime');
    
    const androidDetails = AndroidNotificationDetails(
      'selfcare_reminders', 'selfcare_channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    // iOS Notification Details
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );    

    const platformDetails = NotificationDetails(android: androidDetails, iOS: darwinDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    print("Notification Scheduled!");
  }

  Future<void> showPeriodicNotification(int id, String title, String body, context) async {
    // Check if correct permissions are done
    bool permissions = await checkAndRequestExactAlarmPermission(context);
    if (!permissions) return;

    const androidDetails = AndroidNotificationDetails(
      // Channel_id and channel_name should be modified to pertain to either Selfcare or moodlog reminders
      'channel_id', 'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    const platformDetails = NotificationDetails(android: androidDetails, iOS: darwinDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id, 
      title, 
      body, 
      RepeatInterval.everyMinute, 
      platformDetails, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,);
  }
  // Close specific channel notifications
  Future cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
  
  // Close all channels
  Future cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
  
  // get pending notifications, TODO: return values rather than print
  void getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (var notification in pendingNotifications) {
      print('Notification ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
    }
  }
  
  // Get notification permisions (selfcare reminders/moodlog reminders; yes/no)
  Future<Map<String, dynamic>?> getNotificationPermisions(String userId) async {
    return await fetchNotificationPermisions(userId);
  }

  // Update notification permissions
  void updateNotificationPermissions(String userId, {bool? selfCarePerm, bool? logReminderPerm}) async {
    await updateNotificationSettings(userId, selfCarePerm: selfCarePerm, logReminderPerm: logReminderPerm);
  }

  // -----Android Permissions-----
  Future<bool> checkAndRequestExactAlarmPermission(BuildContext context) async {
    
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      //final hasExactAlarmPermission = await androidPlugin.requestExactAlarmsPermission();
      final hasExactAlarmPermission = await androidPlugin.canScheduleExactNotifications();
      if (hasExactAlarmPermission == null || !hasExactAlarmPermission) {
        // Check if context is mounte for safety
        if(context.mounted){
          _showExactAlarmPermissionDialog(context, androidPlugin);
        }
        return false;
      }
    }
    return true;
  }

  void _showExactAlarmPermissionDialog(BuildContext context, AndroidFlutterLocalNotificationsPlugin androidPlugin) {
    // Replace with your app's actual context and UI
    showDialog(
      context: context, // Provide a BuildContext here
      builder: (context) {
        return AlertDialog(
          title: const Text("Exact Alarm Permission Needed"),
          content: const Text("To ensure reminders are delivered on time, please enable Exact Alarms."),
          actions: [
            TextButton(
              onPressed: () => openAppSettings(androidPlugin),
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  void openAppSettings(AndroidFlutterLocalNotificationsPlugin androidPlugin) {
    // final intent = AndroidIntent(
    //   action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
    //   data: 'package:your.package.name',
    // );
    // intent.launch();
    androidPlugin.requestExactAlarmsPermission();
  }

}