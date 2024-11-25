import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'CustomReminderSetupPage.dart';
import '../notification/notifications.dart';

class SelfCareRemindersPage extends StatefulWidget {
  const SelfCareRemindersPage({Key? key}) : super(key: key);

  @override
  State<SelfCareRemindersPage> createState() => _SelfCareRemindersPageState();
}

class _SelfCareRemindersPageState extends State<SelfCareRemindersPage> {
  bool drinkWaterSelected = false;
  bool eatSomethingSelected = false;
  bool takeMedicationSelected = false;
  bool showNewReminderCard = false;
  bool isSelfCareReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPermissions();
  }

  Future<void> _loadNotificationPermissions() async {
    // TODO: get user_id from loggedin user
    final userId = "673d3790e3262ad583bced63"; // Replace with dynamic user ID retrieval
    final data = await NotificationService().getNotificationPermisions(userId);
    

    if (data != null) {
      print('${data["self_care"]}, ${data["log_reminder"]}');
      setState(() {
        isSelfCareReminderEnabled = data["self_care"] ?? false;
      });
    }
  }

  // Custom card widget with a radio toggle on the right
  Widget buildSelfCareCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required ValueChanged<bool> onChanged,
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
        trailing: Switch(
          value: isSelected,
          onChanged: onChanged,
          activeColor: const Color.fromARGB(255, 92, 50, 129),
        ),
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
        onTap: () {
          setState(() {
            showNewReminderCard = !showNewReminderCard;
          });
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onChanged: (value) {
                      setState(() {
                        drinkWaterSelected = value;
                      });
                    },
                  ),
                  buildSelfCareCard(
                    title: "Eat Something",
                    icon: Icons.fastfood,
                    isSelected: eatSomethingSelected,
                    onChanged: (value) {
                      setState(() {
                        eatSomethingSelected = value;
                      });
                    },
                  ),
                  buildSelfCareCard(
                    title: "Take Medication",
                    icon: Icons.medical_services,
                    isSelected: takeMedicationSelected,
                    onChanged: (value) {
                      setState(() {
                        takeMedicationSelected = value;
                      });
                    },
                  ),
                  buildCustomRemindersCard(),
                  if (showNewReminderCard) buildNewReminderCard(context),


                  // Notification Testing!------------------------------------------
                  ElevatedButton(
                    onPressed: () {
                      // Create instant notification
                      if (isSelfCareReminderEnabled){
                        NotificationService().showNotification(
                          0, 
                          "New Notification", 
                          "Test Notification"
                        );
                      }
                      // Test edit notification perms
                      // String userId = "673d3790e3262ad583bced63";
                      // NotificationService().updateNotificationPermissions(
                      //   userId, 
                      //   // selfCarePerm: false,
                      //   logReminderPerm: true
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                    ),
                    child: const Text(
                      'Test instant permissions',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  // Schedule a notification
                  ElevatedButton(
                    onPressed: () {
                      
                      final DateTime scheduledTime = DateTime.now().add(const Duration(minutes: 1));
                      //var scheduledTime = tz.local;
                      if (isSelfCareReminderEnabled){
                        NotificationService().scheduleNotification(
                          1,
                          "New Scheduled Notification", 
                          "Test Notification",
                          scheduledTime, 
                          context
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                    ),
                    child: const Text(
                      'Test Schedule Notifications',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  // Test Periodic notifications
                  ElevatedButton(
                    onPressed: () {
                      if (isSelfCareReminderEnabled){
                        NotificationService().showPeriodicNotification(
                          2,
                          "New Periodic Notification", 
                          "Test Notification",
                          context                         
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                    ),
                    child: const Text(
                      'Test Periodic Notifications',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  // Test notification permisions
                  ElevatedButton(
                    onPressed: () {
                      // Now user user_id
                      NotificationService().getNotificationPermisions('673d3790e3262ad583bced63');
                    
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                    ),
                    child: const Text(
                      'Test Notification Permisions',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      
                      NotificationService().cancelAllNotifications();
                    
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                    ),
                    child: const Text(
                      'Test Cancel ALL Notifications',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      
                      NotificationService().getPendingNotifications();
                    
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                    ),
                    child: const Text(
                      'Test Pending Notifications',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}