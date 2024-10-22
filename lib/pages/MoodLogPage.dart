import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class MoodLogPage extends StatefulWidget {
  const MoodLogPage({super.key});

  @override
  _MoodLogPageState createState() => _MoodLogPageState();
}

class _MoodLogPageState extends State<MoodLogPage> {
  String _selectedMood = 'Happy'; // Default mood selection
  TextEditingController _thoughtsController = TextEditingController(); // Controller for text input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                components.buildHeader(title: "Mood Log", context: context),
                const SizedBox(height: 40), // Space below the title
                
                // White box for mood selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
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
                ),
                const SizedBox(height: 40),
                
                // Textfield for user thoughts
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'How was your day?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
          )
        ],
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
