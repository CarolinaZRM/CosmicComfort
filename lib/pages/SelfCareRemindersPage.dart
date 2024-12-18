import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'CustomReminderSetupPage.dart';
import '../notification/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class SelfCareRemindersPage extends StatefulWidget {
  const SelfCareRemindersPage({Key? key}) : super(key: key);

  @override
  State<SelfCareRemindersPage> createState() => _SelfCareRemindersPageState();
}

class _SelfCareRemindersPageState extends State<SelfCareRemindersPage> {
  bool drinkWaterSelected = false;
  bool eatSomethingSelected = false;
  bool logMoodSelected = false;
  bool showNewReminderCard = false;
  bool isSelfCareReminderEnabled = false;
  List<dynamic>? reminders;
  Set<String>? pendingNotifs;
  String? userId;
  Map<String, bool> customSelected = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> setPending() async {
    List<PendingNotificationRequest> pendingNotifications = await NotificationService().getPendingNotifications(printOut: false);
    Set<String> pending = pendingNotifications.map((notification) => notification.title!).toSet();
    setState(() {
      pendingNotifs = pending;
    });
  }

  // Prepare and initialize the page variables and data
  Future<void> _initialize() async {
    await _fetchUserId();
    await _loadNotificationPermissions();
    await _fetchUserReminders(userId);
    await checkActiveBaseNotifications();
    await setPending();
    // print(userId);
    // print(reminders);
  }

  Future<void> checkActiveBaseNotifications() async {
    NotificationService notifService = NotificationService();
    List<PendingNotificationRequest> pendingNotifications = await notifService.getPendingNotifications(printOut: false);
    Set<String> pending = pendingNotifications.map((notification) => notification.title!).toSet();
    if (isSelfCareReminderEnabled) {
      if (pending.contains("Drink Water")) {
        setState(() {
          drinkWaterSelected = true;
        });
      }
      if (pending.contains("Eat Something")) {
        setState(() {
          eatSomethingSelected = true;
        });
      }
      if (pending.contains("Log your mood")) {
        setState(() {
          logMoodSelected = true;
        });
      }
      pendingNotifs = pending;
    } else {
      notifService.cancelAllNotifications();
    }
  }

  Future<String?> getUserIdFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) return null;

      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['id'];
    } catch (e) {
      return null;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white))),
    );
  }

  Future<void> _fetchUserId() async {
    String? fetchedUserId = await getUserIdFromToken();
    if (fetchedUserId == null) {
      // userId = "673d3790e3262ad583bced63";
      // _showError("User ID not found. Please log in again. defaulted to: 673d3790e3262ad583bced63");
      return;
    } else {
      userId = fetchedUserId;
    }
  }

  Future<void> _fetchUserReminders(String? userId) async {
    if (userId == null) { return; }
    http.Response response = await NotificationService().fetchUserNotifications(userId);
    dynamic responseBody = jsonDecode(response.body);
    if (responseBody is List<dynamic>) {
      List<dynamic> remindersData = responseBody;
      reminders = remindersData;
    } else if (responseBody is Map<String, dynamic> && responseBody.containsKey('message')){
      reminders = null;
    }
  }

  Future<void> _loadNotificationPermissions() async {
    // TODO: get user_id from loggedin user
    //final userId = "673d3790e3262ad583bced63"; // Replace with dynamic user ID retrieval
    if (userId != null) {
      final data = await NotificationService().getNotificationPermisions(userId!);
      if (data != null) {
        //print('${data["self_care"]}, ${data["log_reminder"]}');
        setState(() {
          isSelfCareReminderEnabled = data["self_care"] ?? false;
        });
      }
    }
    
  }

  // Pop-up to see next scheduled instance
  void showNextInstance( 
    String title, 
    DateTime startDate, 
    String intervalType,
    int interval 
    ){
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text("${NotificationService().getNextInstanceOfNotification(
            title, 
            startDate, 
            intervalType, 
            interval
          )} ")
        );
      }
    );
  }

  // Pop-up to delete reminder
  void showDeleteDialog(String userId, title) {
    showDialog(
      context: context, // Provide a BuildContext here
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete reminder?"),
          content: const Text("Please confirm if you want to delete this reminder!"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                NotificationService notifService = NotificationService();
                await notifService.deleteDbNotificationEntry(userId, title);
                // re-fetch reminders to refresh the page
                await _fetchUserReminders(userId);
                // Cancel existing pending notifications
                await notifService.cancelNotificationsByTitle(title);
                await setPending();
                // Close the dialog and refresh
                setState(() {});
                
              },
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }

  // Custom card widget with a radio toggle on the right
  Widget buildSelfCareCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required ValueChanged<bool> onChanged,
    required bool displayDelete,
    required DateTime startDate,
    required String intervalType,
    required int interval,
    VoidCallback? deleteCallback
  }) { 
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(200, 0, 0, 0)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: displayDelete ? Row(
          mainAxisSize: MainAxisSize.min, // Ensures the row is only as wide as its children
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 105, 103, 103)),
              onPressed: deleteCallback // Calls the delete callback
            ),
            IconButton(
              icon: const Icon(Icons.schedule, color: Color.fromARGB(255, 54, 70, 244)),
              onPressed: () {
                showNextInstance(
                  title,
                  startDate,
                  intervalType,
                  interval
                );
              } 
            ),
            Switch(
              value: isSelected,
              onChanged: onChanged,
              activeColor: const Color.fromARGB(255, 92, 50, 129),
            ),
          ],
        ): Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.schedule, color: Color.fromARGB(255, 54, 70, 244)),
              onPressed: () {
                showNextInstance(
                  title,
                  startDate,
                  intervalType,
                  interval
                );
              } 
            ),
            Switch(
              value: isSelected,
              onChanged: onChanged,
              activeColor: const Color.fromARGB(255, 92, 50, 129),
            ),
          ]
        )
      ),
    );
  }

  // Custom Reminders Card
  Widget buildCustomRemindersCard() {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.add_alert, color: Color.fromARGB(200, 0, 0, 0)),
        title: const Text(
          "Custom Reminders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          showNewReminderCard
              ? Icons.keyboard_arrow_down // Arrow icon
              : Icons.keyboard_arrow_right, // Collapsed arrow
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        onTap: () async {
          if (userId != null) {
            setState(() {
              showNewReminderCard = !showNewReminderCard;
            });
            if (showNewReminderCard) {
              await _fetchUserReminders(userId);
            }
            setState(() {});
          } else {
            _showError("Please login to use this feature!");
          }
          
        },
      ),
    );
  }

  // New Reminder Card (appears when Custom Reminders is tapped)
  Widget buildNewReminderCard(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.add_circle_outline_outlined, color: Color.fromARGB(255, 0, 0, 0)),
        title: const Text(
          "New Reminder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomReminderSetupPage(),
            ),
          );
          setState(() {
              showNewReminderCard = false;
          });
        },
      ),
    );
  }

  Duration timeOfDayToDuration(TimeOfDay timeOfDay) {
    return Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
  }

  Widget buildDBReminderCards(BuildContext context) {
    // NotificationService notifService = NotificationService();
    // List<PendingNotificationRequest> pendingNotifications = await notifService.getPendingNotifications(printOut: false);
    // Set<String> pending = pendingNotifications.map((notification) => notification.title!).toSet();
    return reminders != null ? 
    ListView(
      children: reminders!.map((reminder) {
        NotificationService notifService = NotificationService();
        bool isSelected = customSelected[reminder['title']+"Selected"] = pendingNotifs != null ? pendingNotifs!.contains(reminder["title"]): false;
        DateTime unformatedDate = notifService.unformatDate(reminder["start_datetime"])["DateTime"];
        TimeOfDay unformatedTime = notifService.unformatDate(reminder["start_datetime"])["TimeOfDay"];
        return buildSelfCareCard(
          title: reminder["title"], 
          icon: Icons.alarm, 
          isSelected: isSelected,
          displayDelete: true,
          startDate: unformatedDate.add(timeOfDayToDuration(unformatedTime)),
          intervalType: reminder["interval_type"],
          interval: reminder["interval"],
          deleteCallback: () => showDeleteDialog(reminder['user_id'], reminder['title']),
          onChanged: (value) async {
              bool permission = await notifService.checkAndRequestExactAlarmPermission(context, showPopup: true);
              if (permission) {
                if (value) {
                  // DateTime unformatedDate = notifService.unformatDate(reminder["start_datetime"])["DateTime"];
                  // TimeOfDay unformatedTime = notifService.unformatDate(reminder["start_datetime"])["TimeOfDay"];
                  // print(unformatedTime);
                  // print(unformatedDate);
                  await notifService.createNotifications( 
                    title: reminder["title"], 
                    body: reminder["title"], 
                    startTime: unformatedTime,
                    date: unformatedDate, 
                    context: context, 
                    notifPermission: isSelfCareReminderEnabled, 
                    intervalType: reminder["interval_type"],
                    interval: reminder["interval"]
                  );
                  await setPending();
                } else {
                  // Cancel custom notifications
                  await notifService.cancelNotificationsByTitle(reminder["title"]);
                  await setPending();
                }
                if (isSelfCareReminderEnabled){
                  setState(() {
                    isSelected = value;
                  });
                } else {
                  _showError("Enable 'selfcare reminders' in settings!");
                }
                
              }
            },
          );
      }).toList(),
    ) : const SizedBox(height: 1,);
  }

  //helper method to get today at a specific hour
  DateTime getTodayAt(int time) {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time, 0, 0).add(Duration(hours: 4)); //account for offset
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  components.buildHeader(title: "Self-Care Reminders", context: context),
                  const SizedBox(height: 40), // Space below the title

                  buildSelfCareCard(
                    title: "Drink Water",
                    icon: Icons.local_drink,
                    isSelected: drinkWaterSelected,
                    displayDelete: false,
                    startDate: getTodayAt(7),
                    intervalType: "hourly",
                    interval: 3,
                    onChanged: (value) async {
                      NotificationService notifService = NotificationService();
                      bool permission = await notifService.checkAndRequestExactAlarmPermission(context, showPopup: true);
                      if (permission) {
                        if (value) {
                          
                          notifService.createNotifications( 
                            title: 'Drink Water', 
                            body: 'Remember to stay hydrated!', 
                            startTime: TimeOfDay(hour:7+4, minute:0), //+4 since its formated in UTC-4
                            date: DateTime.now(), 
                            context: context, 
                            notifPermission: isSelfCareReminderEnabled, 
                            intervalType: "hourly",
                            interval: 3
                          );
                          setPending();
                        } else {
                          // Cancel "Drink Water" notifications
                          notifService.cancelNotificationsByTitle("Drink Water");
                          setPending();
                        }
                        if (isSelfCareReminderEnabled){
                          setState(() {
                            drinkWaterSelected = value;
                          });
                        } else {
                          _showError("Enable 'selfcare reminders' in settings!");
                        }
                        
                      }
                    },
                  ),
                  buildSelfCareCard(
                    title: "Eat Something",
                    icon: Icons.fastfood,
                    isSelected: eatSomethingSelected,
                    displayDelete: false,
                    startDate: getTodayAt(7),
                    intervalType: "hourly",
                    interval: 5,
                    onChanged: (value) async {
                      NotificationService notifService = NotificationService();
                      bool permission = await notifService.checkAndRequestExactAlarmPermission(context, showPopup: true);
                      if (permission) {
                        if (value) {
                          notifService.createNotifications(
                            //id: 1, 
                            title: 'Eat Something', 
                            body: 'Keep up with your meals!', 
                            startTime: TimeOfDay(hour:7+4, minute: 0), 
                            date: DateTime.now(), 
                            context: context, 
                            notifPermission: isSelfCareReminderEnabled, 
                            intervalType: "hourly",
                            interval: 5
                          );
                          setPending();
                        } else {
                          // Cancel "Eat Something" notifications
                          notifService.cancelNotificationsByTitle("Eat Something");
                          setPending();
                        }
                        if (isSelfCareReminderEnabled){
                          setState(() {
                            eatSomethingSelected = value;
                          });
                        } else {
                          _showError("Enable 'selfcare reminders' in settings!");
                        }
                      }
                    },
                  ),
                  buildSelfCareCard(
                    title: "Log your mood",
                    icon: Icons.menu_book,
                    isSelected: logMoodSelected,
                    displayDelete: false,
                    startDate: getTodayAt(19),
                    intervalType: "daily",
                    interval: 1,
                    onChanged: (value) async {
                      NotificationService notifService = NotificationService();
                      bool permission = await notifService.checkAndRequestExactAlarmPermission(context, showPopup: true);
                      if (permission) {
                        if (value) {
                          
                          notifService.createNotifications(
                            //id: 1, 
                            title: 'Log your mood', 
                            body: 'Keep track of how you\'re feeling!', 
                            startTime: TimeOfDay(hour:19+4, minute: 0), 
                            date: DateTime.now(), 
                            context: context, 
                            notifPermission: isSelfCareReminderEnabled, 
                            intervalType: "daily",
                            interval: 1
                          );
                          setPending();
                        } else {
                          // Cancel "Log your mood" notifications
                          notifService.cancelNotificationsByTitle("Log your mood");
                          setPending();
                        }
                        if (isSelfCareReminderEnabled){
                          setState(() {
                            logMoodSelected = value;
                          });
                        } else {
                          _showError("Enable 'selfcare reminders' in settings!");
                        }
                      }
                    },
                  ),
                  buildCustomRemindersCard(),
                  if (showNewReminderCard) buildNewReminderCard(context),
                  
                  if (showNewReminderCard) Expanded(
                    child: buildDBReminderCards(context),
                  ),
                                   


                  // Notification Testing!------------------------------------------
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Create instant notification
                      
                  //     NotificationService().showNotification(
                  //       0, 
                  //       "New Notification", 
                  //       "Test Notification",
                  //       isSelfCareReminderEnabled
                  //     );
                      
                  //     // Test edit notification perms
                  //     // String userId = "673d3790e3262ad583bced63";
                  //     // NotificationService().updateNotificationPermissions(
                  //     //   userId, 
                  //     //   // selfCarePerm: false,
                  //     //   logReminderPerm: true
                  //     // );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  //     backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                  //   ),
                  //   child: const Text(
                  //     'Test instant permissions',
                  //     style: TextStyle(fontSize: 20, color: Colors.white),
                  //   ),
                  // ),
                  // Schedule a notification
                  // // --------------------------
                  // ElevatedButton(
                  //   onPressed: () {
                      
                  //     final DateTime scheduledTime = DateTime.now().add(const Duration(minutes: 1));
                  //     //var scheduledTime = tz.local;
                      
                  //     NotificationService().scheduleNotification(
                  //       1,
                  //       "New Scheduled Notification", 
                  //       "Test Notification",
                  //       scheduledTime, 
                  //       context,
                  //       isSelfCareReminderEnabled
                  //     );
                      
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  //     backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                  //   ),
                  //   child: const Text(
                  //     'Test Schedule Notifications',
                  //     style: TextStyle(fontSize: 20, color: Colors.white),
                  //   ),
                  // ),
                  // // --------------------------
                  // Test Periodic notifications
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     NotificationService notifService = NotificationService();
                  //     bool permission = await notifService.checkAndRequestExactAlarmPermission(context, showPopup: true);
                  //     if (permission) {
                  //       notifService.showPeriodicNotification(
                  //         2,
                  //         "New Periodic Notification", 
                  //         "Test Notification",
                  //         context,
                  //         isSelfCareReminderEnabled,
                  //         "every_minute",
                  //         "test_channel"                        
                  //       );
                  //     }  
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  //     backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                  //   ),
                  //   child: const Text(
                  //     'Test Periodic Notifications',
                  //     style: TextStyle(fontSize: 20, color: Colors.white),
                  //   ),
                  // ),
                  // // --------------------------
                  // Test create notifications
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Now user user_id
                  //     NotificationService NotifService = NotificationService();
                  //     NotifService.createNotifications(
                  //       //id: 1, 
                  //       title: 'Test', 
                  //       body: 'Test schedule notifications', 
                  //       startTime: TimeOfDay.now(), 
                  //       date: DateTime.now(), 
                  //       context: context, 
                  //       notifPermission: isSelfCareReminderEnabled, 
                  //       intervalType: "daily"
                  //     );
                    
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  //     backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                  //   ),
                  //   child: const Text(
                  //     'Test create notifications',
                  //     style: TextStyle(fontSize: 20, color: Colors.white),
                  //   ),
                  // ),
                  // Test cancel ALL notifications!
                  // ElevatedButton(
                  //   onPressed: () {
                      
                  //     NotificationService().cancelAllNotifications();
                    
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  //     backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                  //   ),
                  //   child: const Text(
                  //     'Test Cancel ALL Notifications',
                  //     style: TextStyle(fontSize: 20, color: Colors.white),
                  //   ),
                  // ),

                  // ElevatedButton(
                  //   onPressed: () {
                      
                  //     NotificationService().getPendingNotifications(printOut: true);
                    
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  //     backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                  //   ),
                  //   child: const Text(
                  //     'Test Pending Notifications',
                  //     style: TextStyle(fontSize: 20, color: Colors.white),
                  //   ),
                  // ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}