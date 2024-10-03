import 'package:flutter/material.dart';

class FakeCallPage extends StatefulWidget {
  const FakeCallPage({Key? key}) : super(key: key);

  @override
  State<FakeCallPage> createState() => _FakeCallPageState();
}

class _FakeCallPageState extends State<FakeCallPage> {
  // Define variables to store the dropdown selections
  String? selectedTime;
  String? selectedCaller;
  String? selectedRingtone;
  String? selectedVoice;
  String? selectedWallpaper;
  String? selectedMore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'), // Your background image path
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
                        Navigator.pop(context); // Navigates back to the previous screen
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
                    const SizedBox(width: 48), // To balance the row
                  ],
                ),

                const SizedBox(height: 20), // Space below the title

                // Dropdown for Time Setting
                _buildDropdownMenu(
                  title: 'Time',
                  icon: Icons.schedule,
                  value: selectedTime,
                  items: ['10 seconds', '30 seconds', '1 minute', '5 minutes'],
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value;
                    });
                  },
                ),

                // Dropdown for Caller Setting
                _buildDropdownMenu(
                  title: 'Caller',
                  icon: Icons.person,
                  value: selectedCaller,
                  items: ['Mom', 'Boss', 'Friend', 'Unknown'],
                  onChanged: (value) {
                    setState(() {
                      selectedCaller = value;
                    });
                  },
                ),

                // Dropdown for Ringtone Setting
                _buildDropdownMenu(
                  title: 'Ringtone',
                  icon: Icons.music_note,
                  value: selectedRingtone,
                  items: ['Ringtone 1', 'Ringtone 2', 'Ringtone 3'],
                  onChanged: (value) {
                    setState(() {
                      selectedRingtone = value;
                    });
                  },
                ),

                // Dropdown for Voice Setting
                _buildDropdownMenu(
                  title: 'Voice',
                  icon: Icons.record_voice_over,
                  value: selectedVoice,
                  items: ['Voice 1', 'Voice 2', 'Voice 3'],
                  onChanged: (value) {
                    setState(() {
                      selectedVoice = value;
                    });
                  },
                ),

                // Dropdown for Wallpaper Setting
                _buildDropdownMenu(
                  title: 'Wallpaper',
                  icon: Icons.wallpaper,
                  value: selectedWallpaper,
                  items: ['Wallpaper 1', 'Wallpaper 2', 'Wallpaper 3'],
                  onChanged: (value) {
                    setState(() {
                      selectedWallpaper = value;
                    });
                  },
                ),

                // Dropdown for More Settings
                _buildDropdownMenu(
                  title: 'More',
                  icon: Icons.more_horiz,
                  value: selectedMore,
                  items: ['Option 1', 'Option 2', 'Option 3'],
                  onChanged: (value) {
                    setState(() {
                      selectedMore = value;
                    });
                  },
                ),

                const SizedBox(height: 20), // Space below dropdowns

                // Start Call Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Trigger fake call action
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
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

  // Helper function to build a dropdown menu
  Widget _buildDropdownMenu({
    required String title,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // White background for the dropdown
          labelText: title,
          prefixIcon: Icon(icon),
          floatingLabelBehavior: FloatingLabelBehavior.never, // Fixes the issue of the label moving
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        hint: Text(title), // Ensure the title shows when no value is selected
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}