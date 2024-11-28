import 'package:flutter/material.dart';
import 'CallerIDPage.dart';
import 'RingtonePage.dart';
import 'CallTime.dart';
import 'CallDelayPage.dart';
import 'AndroidCallPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String, dynamic>? globalFakeCallSettings; // Global variable

class FakeCallPage extends StatefulWidget {
  const FakeCallPage({Key? key}) : super(key: key);

  @override
  State<FakeCallPage> createState() => _FakeCallPageState();
}

class _FakeCallPageState extends State<FakeCallPage> {
  int selectedTime = 5; // Default value, will be updated from DB
  String contactName = "Unknown"; // Default value for contact name
  bool isLoading = true; // Flag to show loading state

  @override
  void initState() {
    super.initState();
    fetchSettingsFromDB();
  }

  // Function to fetch settings and contact name from the database
  Future<void> fetchSettingsFromDB() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:9000/fake_call/6746b179762320454d2cd3a2'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        globalFakeCallSettings = data;
        setState(() {
          selectedTime = data['call_time'] ?? 5; // Default to "5" if null
          contactName = data['caller_name'] ?? "Unknown"; // Default to "Unknown" if null
          isLoading = false; // Data loaded successfully
        });
      } else {
        throw Exception('Failed to fetch settings');
      }
    } catch (e) {
      print('Error fetching settings: $e');
      setState(() {
        isLoading = false; // Stop loading even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading spinner
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 60.0, 10.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with Back Arrow and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Fake Call Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 20),

                // Time Card
                buildCustomCard(
                  icon: Icons.schedule,
                  title: "Time",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CallTimePage()),
                    ).then((_) => fetchSettingsFromDB());
                  },
                ),

                // Caller ID Card
                buildCustomCard(
                  icon: Icons.person,
                  title: "Caller ID",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CallerIDPage()),
                    ).then((_) => fetchSettingsFromDB());
                  },
                ),

                // Ringtone Card
                buildCustomCard(
                  icon: Icons.music_note,
                  title: "Ringtone",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RingtonePage()),
                    ).then((_) => fetchSettingsFromDB());
                  },
                ),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (globalFakeCallSettings != null) {
                        bool playRingtone = globalFakeCallSettings?['ringtone'] ?? false;
                        String? ringtoneName = globalFakeCallSettings?['ring_name'];

                        if (selectedTime > 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallDelayPage(
                                contactName: contactName,
                                time: selectedTime,
                                playRingtone: playRingtone,
                                ringtoneName: ringtoneName,
                              ),
                            ),
                          ).then((_) => fetchSettingsFromDB());
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AndroidCallPage(
                                contactName: contactName,
                                waited: false,
                              ),
                            ),
                          ).then((_) => fetchSettingsFromDB());
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121),
                    ),
                    child: const Text(
                      'Start Call',
                      style: TextStyle(fontSize: 20, color: Colors.white),
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

  Widget buildCustomCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right_outlined),
        onTap: onTap,
      ),
    );
  }
}