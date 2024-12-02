import 'package:cosmiccomfort/pages/CalendarPage.dart';
import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'package:intl/intl.dart'; // Import intl package
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the color picker package
import 'dart:convert';
import 'package:http/http.dart' as http;

class MoodLogPage extends StatefulWidget {
  const MoodLogPage({super.key, this.date, this.globalCalendar});
  final DateTime? date;
  final Map<String, dynamic>? globalCalendar; // Global variable

  @override
  _MoodLogPageState createState() => _MoodLogPageState();
}

class _MoodLogPageState extends State<MoodLogPage> {
  String _selectedMood = 'Happy'; // Default mood selection
  Color _selectedColor = Colors.yellow; // Default mood color
  TextEditingController _thoughtsController = TextEditingController(); // Controller for text input
  DateTime selectedDate = DateTime.now();

  // For custom mood feature
  // List<Map<String, dynamic>> moodList = [
  //   {'mood': 'Happy', 'color': const Color(0xFFFFEB3B)},
  //   {'mood': 'Sick', 'color': const Color(0xFF4CAF50)},
  //   {'mood': 'Sad', 'color': const Color(0xFF2196F3)},
  //   {'mood': 'Tired', 'color': const Color(0xFF9E9E9E)},
  //   {'mood': 'Angry', 'color': const Color(0xFFF44336)},
  //   {'mood': 'Anxious', 'color': const Color(0xFFFF9800)},
  //   {'mood': 'Average', 'color': const Color(0xFF9C27B0)},
  // ];
  List<Map<String, String>> moodList = [
    { "mood": "Happy", "color": "#FFFFEB3B"},
    { "mood": "Sick", "color": "#FF4CAF50"},
    { "mood": "Sad", "color": "#FF2196F3"},
    { "mood": "Tired", "color": "#FF9E9E9E"},
    { "mood": "Angry", "color": "#FFF44336"},
    { "mood": "Anxious", "color": "#FFFF9800"},
    { "mood": "Average", "color": "#FF9C27B0"}
  ];

  Color _customColor = Colors.pink; // Initial color for custom mood
  TextEditingController _customMoodController = TextEditingController(); // Controller for custom mood name

  @override
  void initState() {
    super.initState();

    // Use the provided date or default to today
    selectedDate = widget.date ?? selectedDate;

    // Initialize mood, color, and description based on globalCalendar
    _initializeMoodLog();
  }

  @override
  void dispose() {
    _saveMoodLog();
    _thoughtsController.dispose(); // Dispose the text controller to free up resources
    _customMoodController.dispose();
    super.dispose();
  }

  void _initializeMoodLog() {
    if (globalCalendar != null && globalCalendar!.containsKey('date_colors')) {
      List<Map<String, dynamic>> entries = List<Map<String, dynamic>>.from(globalCalendar!['date_colors']);

      // Check if the selected date is in the globalCalendar
      Map<String, dynamic>? matchedEntry = entries.firstWhere(
        (entry) {
          DateTime entryDate = DateTime.parse(entry['date']); // Ensure date parsing
          return isSameDate(entryDate, selectedDate);
        },
        orElse: () => {},
      );

      if (matchedEntry.isNotEmpty) {
        // Assign the values from the matched entry
        setState(() {
          _selectedMood = matchedEntry['mood'] ?? _selectedMood;
          _selectedColor = Color(int.parse((matchedEntry['color'] ?? '0xFFFFFFFF').replaceFirst('#', '0x')));
          // _selectedColor = Color(int.parse(matchedEntry['color'] ?? '0xFFFFFFFF'));
          _thoughtsController.text = matchedEntry['description'] ?? '';
          // print(moodList);
          // moodList = globalCalendar?['mood_list'];
          // print(moodList);
        });
      } else {
        // Assign default values
        _setDefaultValues();
      }
    } else {
      // Assign default values if no globalCalendar is available
      _setDefaultValues();
    }
  }

  void _setDefaultValues() {
    setState(() {
      _selectedMood = 'Happy';
      _selectedColor = const Color(0xFFFFEB3B);
      _thoughtsController.text = '';
    });
  }

  // Helper function to compare dates ignoring time
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _saveMoodLog() {
    if (globalCalendar == null) return;

    // Ensure the globalCalendar has the `entries` key
    if (!globalCalendar!.containsKey('date_colors')) {
      globalCalendar!['date_colors'] = [];
    }

    List<Map<String, dynamic>> entries = List<Map<String, dynamic>>.from(globalCalendar!['date_colors']);

    // Check if an entry for the selected date exists
    int existingIndex = entries.indexWhere((entry) {
      DateTime entryDate = DateTime.parse(entry['date']);
      return isSameDate(entryDate, selectedDate);
    });

    // print(_selectedColor);

    Map<String, dynamic> newEntry = {
      'date': selectedDate.toIso8601String(),
      'color': '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      'mood': _selectedMood,
      'description': _thoughtsController.text,
    };

    if (existingIndex != -1) {
      // Update the existing entry
      entries[existingIndex] = newEntry;
    } else {
      // Add a new entry
      entries.add(newEntry);
    }

    // Save back to the globalCalendar
    globalCalendar!['date_colors'] = entries;

    // Optionally log for debugging
    // print('Updated globalCalendar: ${globalCalendar}');

    updateCalendar(globalCalendar);
  }

  // Method to update the calendar in the database
  Future<void> updateCalendar(Map<String, dynamic>? newCalendar) async {
    final userID = newCalendar?['user_id'];
    if (globalCalendar != null && globalCalendar?['_id'] != null) {

      final Map<String, dynamic> updateData = Map.from(newCalendar!);
      // print(updateData);
      updateData.remove('_id'); // Remove the _id field from the body
      updateData.remove('__v');
      for (var entry in updateData['date_colors']) {
        entry.remove('_id'); // Remove the '_id' attribute
      }
      for (var entry in updateData['mood_list']) {
        entry.remove('_id'); // Remove the '_id' attribute
      }

      final response = await http.put(
        Uri.parse('http://localhost:3000/calendar/user/$userID'),
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
                                // ...moodList.map((moodData) => moodRadioButton(moodData['mood'], moodData['color'])).toList(),
                                // customMoodButton(), // Button to add a new custom mood
                                ...moodList.map((moodData) {
                                  String? mood = moodData['mood'];
                                  String? colorString = moodData['color'];
                                  return moodRadioButton(
                                    mood ?? 'Unknown', // Default mood if null
                                    Color(int.parse(colorString!.replaceFirst('#', '0x'))) // Convert color string to Color
                                  );
                                }).toList(),
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
              _selectedColor = color; //implement function
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
                      'color': _customColor.toString(),
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
