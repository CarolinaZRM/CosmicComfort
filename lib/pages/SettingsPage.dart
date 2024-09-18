import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Dropdown state variables
  String? selectedNotification = 'Notifications';
  String? selectedFakeCallSetting = 'Fake Call Settings';
  String? selectedFakeChatSetting = 'Fake Chat Settings';
  String? selectedHelp = 'Help';

  // Dropdown options
  final List<String> notificationOptions = ['Notifications', 'Enabled', 'Disabled'];
  final List<String> fakeCallOptions = ['Fake Call Settings', 'Silent', 'Ringing'];
  final List<String> fakeChatOptions = ['Fake Chat Settings', 'Enabled', 'Disabled'];
  final List<String> helpOptions = ['Help', 'FAQ', 'Contact Support'];

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
            padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 20.0),
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
                const SizedBox(height: 20),

                // Notifications Dropdown
                buildDropdownMenu(
                  context,
                  icon: Icons.notifications,
                  label: 'Notifications',
                  value: selectedNotification,
                  items: notificationOptions,
                  onChanged: (newValue) {
                    setState(() {
                      selectedNotification = newValue;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Fake Call Settings Dropdown
                buildDropdownMenu(
                  context,
                  icon: Icons.call,
                  label: 'Fake Call Settings',
                  value: selectedFakeCallSetting,
                  items: fakeCallOptions,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFakeCallSetting = newValue;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Fake Chat Settings Dropdown
                buildDropdownMenu(
                  context,
                  icon: Icons.chat,
                  label: 'Fake Chat Settings',
                  value: selectedFakeChatSetting,
                  items: fakeChatOptions,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFakeChatSetting = newValue;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Help Dropdown
                buildDropdownMenu(
                  context,
                  icon: Icons.help_outline,
                  label: 'Help',
                  value: selectedHelp,
                  items: helpOptions,
                  onChanged: (newValue) {
                    setState(() {
                      selectedHelp = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each dropdown menu with a white box
  Widget buildDropdownMenu(BuildContext context, {
    required IconData icon,
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // White background for the dropdown box
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Shadow for a floating effect
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 12.0),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 24,
              isExpanded: true,
              underline: const SizedBox(), // Remove the default underline
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}