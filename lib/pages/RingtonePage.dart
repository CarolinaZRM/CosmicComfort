import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../components/GenericComponents.dart' as components;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// Global variable to store the fake call settings
Map<String, dynamic>? globalFakeCallSettings;

class RingtonePage extends StatefulWidget {
  const RingtonePage({Key? key}) : super(key: key);

  @override
  _RingtonePageState createState() => _RingtonePageState();
}

class _RingtonePageState extends State<RingtonePage> {
  final List<String> _ringtonePaths = [
    "sounds/CuteRingtone.mp3",
    "sounds/iOnlySleepAtNight.mp3",
    "sounds/KawaRingtone.mp3",
    "sounds/nightRingtone.mp3",
    "sounds/SoftMelody.mp3"
  ];

  final List<String> _ringtoneTitles = [
    'Cute',
    'I Only Sleep At Night',
    'Kawa',
    'Night',
    'Soft Melody',
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentRingtone; // Track the currently playing ringtone
  bool _isRingtoneEnabled = true; // State variable for ringtone toggle
  String? _lastSelectedRingtone; // Variable to track the last selected ringtone

  @override
  void initState() {
    super.initState();
    fetchSettingsFromDB();
  }

  // Function to toggle play/pause for a ringtone
  void _togglePlayPause(String ringtonePath) async {
    if (_currentRingtone == ringtonePath) {
      await _audioPlayer.pause();
      setState(() {
        _currentRingtone = null; // Reset when paused
      });
    } else {
      await _audioPlayer.stop(); // Stop any previous sound
      await _audioPlayer.play(AssetSource(ringtonePath));
      setState(() {
        _currentRingtone = ringtonePath; // Set the currently playing ringtone
        _lastSelectedRingtone = ringtonePath; // Update last selected ringtone
      });
    }
  }

  Future<String?> getUserIdFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        return null;
      }

      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['id'];
    } catch (e) {
      return null;
    }
  }

  // Function to fetch settings and contact name from the database
  Future<void> fetchSettingsFromDB() async {
    try {
      final userID = await getUserIdFromToken(); // Await the async function
        if (userID == null) {
          print('No user ID found in token.');
          return;
      }

      final response = await http.get(Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/fake_call/user/$userID'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        globalFakeCallSettings = data;

        // Set the state variables based on fetched data
        setState(() {
          _isRingtoneEnabled = data['ringtone'] ?? true; // Default to true if not present
          _currentRingtone = data['ring_name']; // Set current ringtone from fetched data
          _lastSelectedRingtone = data['ring_name']; // Track last selected ringtone
        });
      } else {
        throw Exception('Failed to fetch settings');
      }
    } catch (e) {
      print('Error fetching settings: $e');
      setState(() {});
    }
  }

  // Method to update the call time in the database
  Future<void> updateCallRingtoneInDB() async {
    final userID = await getUserIdFromToken(); // Await the async function
        if (userID == null) {
          print('No user ID found in token.');
          return;
      }

    if (globalFakeCallSettings != null && globalFakeCallSettings?['_id'] != null) {
      globalFakeCallSettings?['ringtone'] = _isRingtoneEnabled;

      // If ringtone is disabled, retain the last selected ringtone
      globalFakeCallSettings?['ring_name'] = _isRingtoneEnabled ? _currentRingtone : _lastSelectedRingtone;

      // Create a copy of the global settings and remove the _id
      final Map<String, dynamic> updateData = Map.from(globalFakeCallSettings!);
      updateData.remove('_id'); // Remove the _id field from the body
      updateData.remove('__v');

      final response = await http.put(
        Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/fake_call/user/$userID'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        print("Call ringtone updated successfully!");
      } else {
        print("Failed to update call time: ${response.body}");
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the player when the page is closed
    updateCallRingtoneInDB();
    
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header using generic component
                  components.buildHeader(title: "Ringtone", context: context),

                  const SizedBox(height: 20), // Spacing below the header

                  // Custom Toggle Switch Card for Ringtone
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.ring_volume),
                      title: const Text("Ringtone", style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Switch(
                        value: _isRingtoneEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _isRingtoneEnabled = value; // Update switch state
                          });
                        },
                        activeColor: const Color.fromARGB(255, 92, 50, 129), // Customize active switch color
                      ),
                    ),
                  ),

                  const SizedBox(height: 20), // Space below the title

                  const Text(
                    "Select Ringtone",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // List of ringtone options
                  Expanded(
                    child: ListView.builder(
                      itemCount: _ringtonePaths.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _togglePlayPause(_ringtonePaths[index]);
                          },
                          child: Card(
                            color: _currentRingtone == _ringtonePaths[index]
                                ? Colors.indigo.shade300 // Highlight the playing ringtone
                                : Colors.white.withOpacity(0.9),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Icon(
                                _currentRingtone == _ringtonePaths[index]
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                color: Colors.black,
                                size: 40,
                              ),
                              title: Text(
                                _ringtoneTitles[index],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
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