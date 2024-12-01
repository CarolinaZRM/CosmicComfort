import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'package:intl/intl.dart'; // Import intl package
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the color picker package

class MoodLogPage extends StatefulWidget {
  const MoodLogPage({super.key, this.date});
  final DateTime? date;

  @override
  _MoodLogPageState createState() => _MoodLogPageState();
}

class _MoodLogPageState extends State<MoodLogPage> {
  String _selectedMood = 'Happy'; // Default mood selection
  TextEditingController _thoughtsController = TextEditingController(); // Controller for text input
  DateTime selectedDate = DateTime.now();

  // For custom mood feature
  List<Map<String, dynamic>> moodList = [
    {'mood': 'Happy', 'color': Colors.yellow},
    {'mood': 'Sick', 'color': Colors.green},
    {'mood': 'Sad', 'color': Colors.blue},
    {'mood': 'Tired', 'color': Colors.grey},
    {'mood': 'Angry', 'color': Colors.red},
    {'mood': 'Anxious', 'color': Colors.orange},
    {'mood': 'Average', 'color': Colors.purple},
  ];
  Color _customColor = Colors.black; // Initial color for custom mood
  TextEditingController _customMoodController = TextEditingController(); // Controller for custom mood name

  @override
  void initState() {
    super.initState();
    selectedDate = widget.date ?? selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    // Format the selectedDate
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(selectedDate); // Example: "Monday, October 24, 2024"
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures the screen resizes when the keyboard shows up
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismisses the keyboard when tapping outside
        },
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Calendar_MoodLogBG.JPG'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Foreground content
            SafeArea(
              child: SingleChildScrollView( // Wrap everything inside a SingleChildScrollView
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      components.buildHeader(title: "Mood Log", context: context),
                      const SizedBox(height: 40), // Space below the title
                      
                      // Display the selected date
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),
                      
                      // White box for mood selector
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5), // Shadow effect
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'How do you feel today?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 6, // Add spacing between rows
                              alignment: WrapAlignment.start, // Align items to the start of the main axis
                              runAlignment: WrapAlignment.start, // Align items to the start of the cross axis
                              children: [
                                ...moodList.map((moodData) => moodRadioButton(moodData['mood'], moodData['color'])).toList(),
                                customMoodButton(), // Button to add a new custom mood
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Textfield for user thoughts
                      const Text(
                        'How was your day?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5), // Shadow effect
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _thoughtsController,
                          maxLines: 12,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Type your thoughts...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper function to create mood radio buttons with labels
  Widget moodRadioButton(String mood, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: mood,
          groupValue: _selectedMood,
          onChanged: (String? value) {
            setState(() {
              _selectedMood = value!;
            });
          },
          activeColor: color, // Assign the color to the active state
        ),
        Text(
          mood,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  // Custom mood button
  Widget customMoodButton() {
    return GestureDetector(
      onTap: () {
        _openCustomMoodDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Add padding for spacing
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'Custom',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Open dialog for custom mood creation
  void _openCustomMoodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Custom Mood'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _customMoodController,
                decoration: const InputDecoration(hintText: 'Enter mood name'),
              ),
              const SizedBox(height: 20),
              const Text('Pick a color for your mood'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showColorPicker(context); // Call the Flutter color picker dialog
                },
                style: ElevatedButton.styleFrom(backgroundColor: _customColor),
                child: const Text('Pick Color'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  if (_customMoodController.text.isNotEmpty) {
                    moodList.add({
                      'mood': _customMoodController.text,
                      'color': _customColor,
                    });
                    _customMoodController.clear(); // Clear the input for next time
                    _customColor = Colors.black; // Reset color picker
                  }
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Flutter's color picker dialog
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Mood Color'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: _customColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      _customColor = color;
                    });
                  },
                  showLabel: false, // You can enable this if you want hex value labels
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
