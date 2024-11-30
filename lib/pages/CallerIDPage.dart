import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'package:http/http.dart' as http;
import 'dart:convert';

// Global variable to store fake call settings
Map<String, dynamic>? globalFakeCallSettings;

class CallerIDPage extends StatefulWidget {
  const CallerIDPage({Key? key}) : super(key: key);

  @override
  State<CallerIDPage> createState() => _CallerIDPageState();
}

class _CallerIDPageState extends State<CallerIDPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true; // To indicate loading state

  @override
  void initState() {
    super.initState();
    fetchCallerSettings();
  }

  // Fetch settings from the database
  Future<void> fetchCallerSettings() async {
    try {
      final response = await http.get(Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/fake_call/6746b179762320454d2cd3a2'));
      if (response.statusCode == 200) {
        setState(() {
          globalFakeCallSettings = json.decode(response.body);
          _nameController.text = globalFakeCallSettings?['caller_name'] ?? 'Unknown';
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch settings');
      }
    } catch (e) {
      print('Error fetching settings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Update settings in the database
  Future<void> updateCallerSettings(String newName) async {
    if (globalFakeCallSettings != null && globalFakeCallSettings?['_id'] != null) {
      globalFakeCallSettings?['caller_name'] = newName;
      // Create a copy of the global settings and remove the _id
      final Map<String, dynamic> updateData = Map.from(globalFakeCallSettings!);
      final String id = updateData.remove('_id'); // Remove the _id field from the body
      updateData.remove('__v');
      try {
        final response = await http.put(
          Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/fake_call/$id'), // Use _id in the URL
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updateData), // Send body without _id
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Caller name updated successfully!')),
          );
        }
      } catch (e) {
        print('Error updating settings: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update Caller Name')),
        );
      }
    } else {
      print('No valid _id in globalFakeCallSettings');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid fake call settings ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    components.buildHeader(title: "Caller ID", context: context),
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/testPic.jpg',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Placeholder for editing picture
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Caller Name',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Caller Name...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await updateCallerSettings(_nameController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(200, 69, 68, 121),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}