import 'package:flutter/material.dart';
import '../pages/settings/TextIDPage.dart';
import '../pages/InstructionsPage.dart';
import '../notification/notifications.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State variables for notifications toggles
  bool isSelfCareReminderEnabled = false;
  bool isLogReminderEnabled = false;

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
        isLogReminderEnabled = data["log_reminder"] ?? false;
      });
    }
  }
  // State variables for Fake Chat Settings and Help dropdowns
  String selectedFakeChatOption = 'Text ID'; // Default selected option// Default selected option

  // Fake Chat Settings and Help dropdown options
  final List<String> fakeChatOptions = ['Text ID'];
  final List<String> helpOptions = ['Press here for instructions on how to use the app'];

  final String disclaimerText = '''This app is intended for general informational and wellness purposes only and is not a substitute for professional psychiatric or psychological help. It should not be used as a replacement for diagnosis, treatment, or therapy for depression, anxiety, or any other mental health conditions. If you are experiencing symptoms of depression, anxiety, or any mental health crisis, please consult a licensed mental health professional. In case of an emergency, contact your local emergency services immediately.''';

  final String creditsText = '''
  Software Engineering Capstone Project 
  Fall, 2024 \n
  Application Developers: 
  Carolina Z. Rodríguez 
  Oniel A. Plaza Pérez 
  Jeremy Cabán Acevedo \n
  Background Artist:
  @Walls.Ai
  ImagiGraphStudio \n
  Ringtones:
  vibritherabjit123
  skylar.mianlind
  ''';

  // Method to navigate to the Text ID page
  void _navigateToTextIDPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TextIDPage()),
    );
  }

  // Method to navigate to the Instructions page
  void _navigateToInstructionsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InstructionsPage()),
    );
  }

  // Generic method for building a dropdown with optional switches
  Widget buildDropdown({
    required IconData icon,
    required String label,
    List<Widget>? children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.black),
        children: children ?? [],
      ),
    );
  }

  // Notifications dropdown builder with toggles
  Widget buildNotificationsDropdown() {
    return buildDropdown(
      icon: Icons.notifications,
      label: 'Notifications',
      children: [
        buildSwitchTile(
          label: 'Self-care Reminders',
          value: isSelfCareReminderEnabled,
          onChanged: (value) => setState(() {
            // TODO: get userId via login
            String userId = "673d3790e3262ad583bced63";
            NotificationService().updateNotificationPermissions(
                        userId, 
                        selfCarePerm: value,
                        
                      );
            isSelfCareReminderEnabled = value;
            // unschedule notifications
            if (!value) {
              NotificationService().cancelAllNotifications();
            }
          }),
        ),
        buildSwitchTile(
          label: 'Log Reminders',
          value: isLogReminderEnabled,
          onChanged: (value) => setState(() {
            String userId = "673d3790e3262ad583bced63";
            NotificationService().updateNotificationPermissions(
                        userId, 
                        logReminderPerm: value
                      );
            isLogReminderEnabled = value;
          }),
        ),
      ],
    );
  }

  // Helper method to build switch tiles for dropdowns
  Widget buildSwitchTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(label),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  // Help dropdown builder
  Widget buildHelpDropdown() {
    return buildDropdown(
      icon: Icons.help,
      label: 'Help',
      children: helpOptions.map((option) {
        return ListTile(
          title: Text(option),
          onTap: () {
            // Take to corresponding page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InstructionsPage()),
        );
          },
        );
      }).toList(),
    );
  }

  // Text-only dropdown builder for Disclaimer and Credits
  Widget buildTextDropdown({
    required IconData icon,
    required String label,
    required String text,
  }) {
    return buildDropdown(
      icon: icon,
      label: label,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image or gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'), // Gradient background
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 60.0, 10.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // To balance the row
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildNotificationsDropdown(),
                        const SizedBox(height: 20),
                        buildHelpDropdown(),
                        const SizedBox(height: 20),
                        buildTextDropdown(
                          icon: Icons.info,
                          label: 'Disclaimer',
                          text: disclaimerText,
                        ),
                        const SizedBox(height: 20),
                        buildTextDropdown(
                          icon: Icons.contacts,
                          label: 'Credits',
                          text: creditsText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}