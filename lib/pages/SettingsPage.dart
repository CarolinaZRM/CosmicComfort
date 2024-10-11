import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Dropdown state variables
  String? selectedNotification = 'Notifications';
  String? selectedFakeChatSetting = 'Fake Chat Settings';
  String? selectedHelp = 'Help';
  String? selectedDisclaimer = 'Disclaimer'; // delete this line
  // Dropdown options
  final List<String> notificationOptions = ['Notifications', 'Enabled', 'Disabled'];
  final List<String> fakeCallOptions = ['Fake Call Settings', 'Silent', 'Ringing'];
  final List<String> fakeChatOptions = ['Fake Chat Settings', 'Enabled', 'Disabled'];
  final List<String> helpOptions = ['Help', 'FAQ', 'Contact Support'];
  final List<String> disclaimerOptions = ['Disclaimer']; // delete this line

  final String disclaimerText = "This app is intended for general informational and wellness purposes only and is not a substitute for professional psychiatric or psychological help. It should not be used as a replacement for diagnosis, treatment, or therapy for depression, anxiety, or any other mental health conditions. If you are experiencing symptoms of depression, anxiety, or any mental health crisis, please consult a licensed mental health professional. In case of an emergency, contact your local emergency services immediately.";
  final String creditsText = 
  '''
        Software Engineering Capstone Project 
        Fall, 2024 \n
        Application Developers: 
        Carolina Z. Rodríguez 
        Oniel A. Plaza Pérez 
        Jeremy Cabán Acevedo \n
        Background Artist:
        @Walls.Ai
  ''';

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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          icon: Icons.help,
                          label: 'Help',
                          value: selectedHelp,
                          items: helpOptions,
                          onChanged: (newValue) {
                            setState(() {
                              selectedHelp = newValue;
                            });
                          },
                        ),

                        // Disclaimer text dropdown menu
                        const SizedBox(height: 20),
                        buildOnlyTextDropdown(context, 
                          icon: Icons.info, 
                          label: 'Disclaimer', 
                          dropdownText: disclaimerText
                        ),

                        // Credits text dropdown menu
                        const SizedBox(height: 20),
                        buildOnlyTextDropdown(
                          context, 
                          icon: Icons.contacts, 
                          label: 'Credits', 
                          dropdownText: creditsText
                        )

                        
                      ],
                    ),
                  )
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper/template method for text only dropdown menus. 
  Widget buildOnlyTextDropdown(BuildContext context, {
    required IconData icon,
    required String label,
    required String dropdownText,
    
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ExpansionTile(
              leading: Icon(icon, color: Colors.black),
              tilePadding: EdgeInsets.zero,
              title: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      dropdownText,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      )
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