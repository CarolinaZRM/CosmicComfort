import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../backend/databaseRequests/notificationDBRequest.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

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

    requestAndroidPermissions();

    requestIOSPermissions();
  }

  Future<void> requestAndroidPermissions() async {
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final areNotificationsEnabled = await androidPlugin.areNotificationsEnabled();
      if (areNotificationsEnabled == null || !areNotificationsEnabled) {
        await androidPlugin.requestNotificationsPermission();
      }
    }
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
  Future<void> showNotification(int id, String title, String body, bool notifPermission) async {
    // Check if app notification permissions are enabled
    if (!notifPermission) return;
    
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
    BuildContext context,
    bool notifPermission
    ) async {
    // Check if app notification permissions are enabled
    if (!notifPermission) return;
    // Check if correct permissions are done (Android)
    bool permissions = await checkAndRequestExactAlarmPermission(context, showPopup: true);
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

  // PERIODIC NOTIFICATIONS
  Future<void> showPeriodicNotification(
    int id, 
    String title, 
    String body, 
    context, 
    bool notifPermission,
    String interval,
    String channelName
    ) async {
    // Check if app notification permissions are enabled
    if (!notifPermission) return;

    // Check if correct permissions are done
    bool permissions = await checkAndRequestExactAlarmPermission(context, showPopup: true);
    if (!permissions) return;

    Map<String, RepeatInterval> intervals = {
      "every_minute" : RepeatInterval.everyMinute,
      "hourly": RepeatInterval.hourly,
      "daily": RepeatInterval.daily,
      "weekly": RepeatInterval.weekly
    };

    //Check for valid intervals
    if (!intervals.containsKey(interval)) { 
      print("invalid interval: ${interval}");
      return; 
    }

    RepeatInterval selected_interval = intervals[interval] ?? RepeatInterval.everyMinute;
  
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      // Channel_id and channel_name should be modified to pertain to either Selfcare or moodlog reminders
      '${channelName}_id', channelName,
      importance: Importance.max,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: darwinDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id, 
      title, 
      body, 
      selected_interval, 
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
  Future<List<PendingNotificationRequest>> getPendingNotifications({required bool printOut}) async {
    final List<PendingNotificationRequest> pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (printOut) {
      for (var notification in pendingNotifications) {
        print('Notification ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}, Payload: ${notification.payload}');
      }
    }
    return pendingNotifications;
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
  Future<bool> checkAndRequestExactAlarmPermission(BuildContext context, {required bool showPopup}) async {
    String? os = Platform.isAndroid ? "Android" : "iOS";
    if (os == "iOS") { return true; } // iOS doesn't need this permission

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      //final hasExactAlarmPermission = await androidPlugin.requestExactAlarmsPermission();
      final hasExactAlarmPermission = await androidPlugin.canScheduleExactNotifications();
      if (hasExactAlarmPermission == null || !hasExactAlarmPermission) {
        // Check if context is mounte for safety
        if(context.mounted && showPopup){
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

  // Formats a given start date, start time, and a time zone into a TZDateTime,
  tz.TZDateTime combineToTZDateTime(
      DateTime date, TimeOfDay time, tz.Location location) {
    return tz.TZDateTime(
      location,
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  // Helper method to unformat the date
  List<String> dateParts(String formattedDate) {
    String time;
    String offset;
    // Extract the date part before "T"
    String date = formattedDate.split("T")[0];

    if (formattedDate.contains("+")) { //offset is positive
      // Extract the time part between "T" and "+/-"
      time = formattedDate.split("T")[1].split("+")[0];

    } else { // if (formattedDate.contains("-")) { //offset if negative
      // Extract the time part between "T" and "+/-"
      time = formattedDate.split("T")[1].split("-")[0];

    }
    // Extract the offset
    if (formattedDate.contains("+")) {
      offset = "+${formattedDate.split("T")[1].split("+")[1]}";
    } else if (formattedDate.contains("-")) {
      offset = "-${formattedDate.split("T")[1].split("-")[1]}";
    } else {
      offset = "+00:00"; // Default offset if not found
    }
    

    // Return the results as a List<String>
    print([date, time, offset]);
    return [date, time, offset];
  }

  // Helper method to unformat the date
  Map<String, dynamic> processDateTime(List<String> dateTimeParts) {
    // Extract components
    String datePart = dateTimeParts[0];
    String timePart = dateTimeParts[1];
    String offsetPart = dateTimeParts[2];

    // Parse DateTime
    DateTime dateTime = DateTime.parse('$datePart 00:00:00.000');

    // Parse TimeOfDay
    List<String> timeComponents = timePart.split(":");
    TimeOfDay timeOfDay = TimeOfDay(
      hour: int.parse(timeComponents[0]),
      minute: int.parse(timeComponents[1]),
    );
    //print("I GOT HERE------------\n$datePart,$timePart,$offsetPart");
    // Parse offset
    bool isPositive = offsetPart.startsWith("+");
    List<String> offsetComponents = offsetPart.substring(1).split(":");
    Duration offsetDuration = Duration(
      hours: int.parse(offsetComponents[0]),
      minutes: int.parse(offsetComponents[1]),
    );

    // Adjust DateTime for offset
    dateTime = isPositive
        ? dateTime.subtract(offsetDuration)
        : dateTime.add(offsetDuration);

    return {
      "DateTime": dateTime,
      "TimeOfDay": timeOfDay,
    };
  }

  Map<String, dynamic> unformatDate(String formattedDate) {
    // Extract parts
    List<String> splitDate = dateParts(formattedDate);
    // unformat date into DateTime and TimeOfDay
    return processDateTime(splitDate);
  }

  // Format Date for db entry
  String formatDateTime(DateTime selectedDate, TimeOfDay selectedTime, int offSetHours) {
    // Combine selectedDate and selectedTime into a single DateTime
    final combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  

    // Convert the DateTime to the ISO 8601 string with offset
    // Adjust the DateTime for the desired offset
    final offsetDateTime = combinedDateTime.add(Duration(hours: offSetHours));

    // Format the DateTime to ISO 8601 without the native offset
    final formattedDateTime = offsetDateTime.toUtc().toIso8601String();

    // Manually append the offset in ISO 8601 format (e.g., -04:00)
    final offsetSign = offSetHours.isNegative ? '-' : '+';
    final absOffsetHours = offSetHours.abs();
    final offsetString = '$offsetSign${absOffsetHours.toString().padLeft(2, '0')}:00';

    return '${formattedDateTime.substring(0, 19)}.000$offsetString';
  }

  Future<http.Response> fetchUserNotifications(UserId) async {
    http.Response response = await getUserNotifications(UserId);
    return response;
  }

  // Create DB Entry
  Future<http.Response> createDBNotificationEntry({
    required String userId,
    required String title,
    required String body,
    required TimeOfDay startTime,
    required DateTime startDate,
    required String reminderType,
    required String intervalType,
    required int interval
    }) async {
    //Format jsonData
    String formattedDate = formatDateTime(startDate, startTime, -4);
    dynamic jsonData = {
      "user_id": userId,
      "title": title,
      "body": body,
      "start_datetime": formattedDate,
      "reminder_type": "self_care",
      "interval_type": intervalType,
      "interval": interval
    };
    //print("$formattedDate");
    //create notification
    http.Response response = await createDBNotification(userId, jsonData: jsonData);
    //print("LOOK HERE-------------${jsonDecode(response.body)["start_datetime"]}");
    return response;
  }

  // Delete DB notification Entry
  Future<http.Response> deleteDbNotificationEntry(String userId, String title) async{
    dynamic jsonData = {
      "title": title
    };
    http.Response response = await deleteDBNotification(userId, jsonData: jsonData);
    return response;
  }

  String getNextInstanceOfNotification(
    String title, 
    DateTime startDate, 
    String intervalType,
    int interval
    ) {
      // Map of duration multipliers
      final Map<String, Duration> durationMap = {
        'daily': Duration(days: interval),
        'weekly': Duration(days: 7 * interval),
        'hourly': Duration(hours: interval),
        'monthly': Duration(days: 30 * interval), // Approximation
      };

      // Interval type validation
      if (!durationMap.containsKey(intervalType)) {
        throw ArgumentError('Invalid schedule type: $intervalType; must be "daily", "weekly", "hourly", or "monthly".');
      }

      DateTime nextInstance = startDate.subtract(Duration(hours: 4)); //account for offSet
      print(nextInstance);
      print(DateTime.now());
      print(nextInstance.isBefore(DateTime.now()));
      // Get the next instance by increasing duration till after the current time
      while(nextInstance.isBefore(DateTime.now())){
        nextInstance = nextInstance.add(durationMap[intervalType]!);
        print(nextInstance);
      }
      return "Scheduled for: \n${nextInstance.toString()}";
      
  }

  // This method will schedule all reminders for a given date
  Future<void> createNotifications({
    //required int id, 
    required String title, 
    required String body, 
    required TimeOfDay startTime,
    required DateTime date, 
    required BuildContext context,
    required bool notifPermission,
    required String intervalType,
    int interval=1
    }) async {
      // Check permissions
      bool permissions = await checkAndRequestExactAlarmPermission(context, showPopup: true);
      if (!permissions) { return; }      

      // Format Scheduled time:
      final localTimeZone = tz.getLocation('America/Puerto_Rico'); // lets use puerto rico time zone
      tz.TZDateTime scheduledTime = combineToTZDateTime(date, startTime, localTimeZone);
      //print("TZDateTime: ${scheduledTime} TEST HERE");
      
      // Map of duration multipliers
      final Map<String, Duration> durationMap = {
        'daily': Duration(days: interval),
        'weekly': Duration(days: 7 * interval),
        'hourly': Duration(hours: interval),
        'monthly': Duration(days: 30 * interval), // Approximation
      };

      // Interval type validation
      if (!durationMap.containsKey(intervalType)) {
        throw ArgumentError('Invalid schedule type: $intervalType; must be "daily", "weekly", "hourly", or "monthly".');
      }

      // We will schedule notifications up to this amount of the type
      final Map<String, Duration> scheduleLimit = {
        'daily': Duration(days: 7), // one weeks
        'weekly': Duration(days: 28), // four weeks
        'hourly': Duration(days: 1), // one days
        'monthly': Duration(days: 60), // Two months // Approximation
      };

      // Set limits
      Duration limit = scheduleLimit[intervalType]!;
      tz.TZDateTime dateLimit = scheduledTime.add(limit);

      // Initialize variables for loop
      tz.TZDateTime tempScheduledTime = scheduledTime;
      int currId = 1;

      // Create set of pending notifications
      List<PendingNotificationRequest> pendingNotifications = await getPendingNotifications(printOut: false);
      Set<int> pending = pendingNotifications.map((notification) => notification.id).toSet();

      while (tempScheduledTime.isBefore(dateLimit)) {
        bool scheduled = false;
        if (!tempScheduledTime.isBefore(tz.TZDateTime.now(localTimeZone))) {
          // Avoid scheduled ids
          while (pending.contains(currId)){ currId++; }
          // Schedule Notification!
          await scheduleNotification(
            currId, 
            title, 
            body, 
            tempScheduledTime, 
            context,
            notifPermission
          );
          scheduled = true;
        }
        // Increment to the next scheduled time
        Duration addDuration = durationMap[intervalType]!;
        tempScheduledTime = tempScheduledTime.add(addDuration);
        // only increment if scheduled
        if (scheduled) { currId++; }
        
      }
      print("finished!");
  }

  Future<void> cancelNotificationsByTitle(String title) async {
    List<PendingNotificationRequest> pendingNotifications = await getPendingNotifications(printOut: false);
    for (var notification in pendingNotifications) {
      if (notification.title == title) {
        cancelNotification(notification.id);
      }
    }
  }
}