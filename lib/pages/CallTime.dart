import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/GenericComponents.dart' as components;

// Global variable to store the fake call settings
Map<String, dynamic>? globalFakeCallSettings;

class CallTimePage extends StatefulWidget {
  const CallTimePage({super.key});

  @override
  State<CallTimePage> createState() => _CallTimePageState();
}

class _CallTimePageState extends State<CallTimePage> {
  // Time options mapped to their numeric values in seconds
  final Map<String, int> timeOptions = {
    "5 seconds": 5,
    "10 seconds": 10,
    "30 seconds": 30,
    "1 minute": 60,
    "3 minutes": 180,
    "5 minutes": 300,
  };

  // Currently selected option
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    fetchSettingsFromDB();
  }

  void defineTime(int time) {
    if (time == 5) {
      setState(() {
        selectedTime = "5 seconds"; // Update the selected time
      });
    } else if (time == 10) {
        setState(() {
          selectedTime = "10 seconds"; // Update the selected time
        });    
    } else if (time == 30) {
        setState(() {
          selectedTime = "30 seconds"; // Update the selected time
        });    
    } else if (time == 60) {
        setState(() {
          selectedTime = "1 minute"; // Update the selected time
        }); 
    } else if (time == 180) {
        setState(() {
          selectedTime = "3 minutes"; // Update the selected time
        }); 
    } else if (time == 300) {
        setState(() {
          selectedTime = "5 minutes"; // Update the selected time
        }); 
    }
  }

  // Method to handle selection
  void selectTime(String title) {
    final int? timeInSeconds = timeOptions[title];
    if (timeInSeconds != null) {
      setState(() {
        selectedTime = title; // Update the selected time
      });

      // Display a confirmation message (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Time updated to $title (${timeInSeconds}s)"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Function to fetch settings and contact name from the database
  Future<void> fetchSettingsFromDB() async {
    try {
      final response = await http.get(Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/fake_call/6746b179762320454d2cd3a2'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        globalFakeCallSettings = data;
        defineTime(data['call_time']);

      } else {
        throw Exception('Failed to fetch settings');
      }
    } catch (e) {
      print('Error fetching settings: $e');
      setState(() {
      });
    }
  }

  // Method to update the call time in the database
  Future<void> updateCallTimeInDB(int? newTime) async {
    if (globalFakeCallSettings != null && globalFakeCallSettings?['_id'] != null) {
      globalFakeCallSettings?['call_time'] = newTime;
      // Create a copy of the global settings and remove the _id
      final Map<String, dynamic> updateData = Map.from(globalFakeCallSettings!);
      final String id = updateData.remove('_id'); // Remove the _id field from the body
      updateData.remove('__v');

      final response = await http.put(
        Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/fake_call/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        print("Call time updated successfully!");
      } else {
        print("Failed to update call time: ${response.body}");
      }
    }
  }

  // Called when the widget is removed from the tree
  @override
  void dispose() {
    if (globalFakeCallSettings != null && globalFakeCallSettings?['call_time'] != null) {
      updateCallTimeInDB(timeOptions[selectedTime]); // Perform the PUT operation
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          // Foreground content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                components.buildHeader(title: "Time", context: context),

                const SizedBox(height: 40), // Space below the title

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: [
                        const Text(
                          "Select the time it will take for you to receive the call.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Build time selection cards
                        ...timeOptions.keys.map((time) => buildSettingsCard(
                              title: time,
                              context: context,
                              isSelected: time == selectedTime,
                              onTap: () => selectTime(time),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Refactored method to build time option cards
  Widget buildSettingsCard({
    required String title,
    required BuildContext context,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: isSelected
            ? const Icon(Icons.check, color: Colors.green)
            : null,
        onTap: onTap, // Handle tap to select the option
      ),
    );
  }
}