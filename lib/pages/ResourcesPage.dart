import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar-like structure for the title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Resources',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48), // Placeholder for symmetry (Optional)
                    ],
                  ),
                ),
                // List of emergency contacts
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: [
                        buildEmergencyContactTile(
                          icon: Icons.phone_in_talk,
                          title: 'Suicide Prevention Lifeline',
                          subtitle: 'For Puerto Rican citizens',
                          contactNumber: '1-800-981-0023',
                        ),
                        buildEmergencyContactTile(
                          icon: Icons.phone_in_talk,
                          title: 'National Suicide Prevention Lifeline',
                          subtitle: 'For US citizens',
                          contactNumber: '1-800-273-8255',
                        ),
                        buildEmergencyContactTile(
                          icon: Icons.security_outlined,
                          title: 'Police',
                          subtitle: 'Call if in immediate danger',
                          contactNumber: '787-343-2020',
                        ),
                        buildEmergencyContactTile(
                          icon: Icons.local_hospital,
                          title: 'Ambulance',
                          subtitle: 'In case of accidents',
                          contactNumber: '787-343-2222',
                        ),
                        buildEmergencyContactTile(
                          icon: Icons.local_fire_department_rounded,
                          title: 'Fire Department',
                          subtitle: 'In case of fire',
                          contactNumber: '787-724-0124',
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

  // Helper method to build each emergency contact tile
  Widget buildEmergencyContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String contactNumber,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9), // White box with slight opacity
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(
          contactNumber,
          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          _makePhoneCall(contactNumber);
        },
      ),
    );
  }

  // Function to initiate phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      // Handle the error or show a message to the user if the call can't be made
      // print("Error making call: $e");
    }
  }
}