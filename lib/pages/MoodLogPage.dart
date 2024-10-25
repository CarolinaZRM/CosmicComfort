import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'package:intl/intl.dart'; // Import intl package

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
      body: GestureDetector( // Added GestureDetector
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
              child: SingleChildScrollView(  // Wrap everything inside a SingleChildScrollView
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      components.buildHeader(title: "Mood Log", context: context),
                      const SizedBox(height: 40), // Space below the title
                      
                      // Test that date chosen is saved!
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ), // Text color to black
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
                              ), // Text color to black
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children: [
                                moodRadioButton('Happy', const Color.fromARGB(255, 231, 209, 17)),
                                moodRadioButton('Sick', Colors.green),
                                moodRadioButton('Sad', Colors.blue),
                                moodRadioButton('Tired', Colors.grey),
                                moodRadioButton('Angry', Colors.red),
                                moodRadioButton('Anxious', Colors.orange),
                                moodRadioButton('Average', Colors.purple),
                                moodRadioButton('Custom', Colors.black),
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

  // Helper function to create mood radio buttons
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
          activeColor: color,
        ),
        Text(
          mood,
          style: const TextStyle(color: Colors.black), // Text color in black for better readability
        ),
      ],
    );
  }
}