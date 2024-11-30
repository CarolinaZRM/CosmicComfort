import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

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
                components.buildHeader(title: "Instructions", context: context),
                const SizedBox(height: 20), // Space below the title

                // Scrollable Container
                Expanded(
                  child: Container(
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
                    child: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Interactive Mode Feature
                          Text(
                            'Interactive Mode',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            """Interactive Mode consists of 4 features; they serve as digital fidget toys to help pass time or work as a distraction. 
Water Ripples: By tapping on the screen, water ripples will appear wherever it has been tapped.

Water Trails: By dragging your finger along the screen, water trails will follow your finger.  

Pop Its: A digital popit. Pop and unpop the bubbles by tapping them.""",
                          ),
                          SizedBox(height: 10), // Add spacing

                          // Music Feature
                          Text(
                            'Music',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'The music page consists of a square grid. To hear a sound play, simply press any square. Only one sound will play at a time; if you want to listen to another sound, simply click on it, and the previous one will automatically stop playing. If you want to pause the currently playing music, press the same square again.',
                          ),
                          SizedBox(height: 10), // Add spacing

                          // Calendar Feature
                          Text(
                            'Calendar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'This is a color-coded calendar. There is a distinct color for different emotions; the user can color code the days in the calendar to match their emotions and see a history of how they felt along the days. By double-tapping a specific day, you can access the mood log.',
                          ),
                          SizedBox(height: 10), // Add spacing

                          // Mood Log Feature
                          Text(
                            'Mood Log',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'The Mood Log allows you to choose a color for your emotion on the chosen day and journal your thoughts or feelings for the day. Logging how you feel is optional; you can simply choose a color to represent the emotion for the day and be done with it if you so wish.',
                          ),
                          SizedBox(height: 10), // Add spacing

                          // Fake Call Feature
                          Text(
                            'Fake Call Feature',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'This feature makes simulated phone calls. After customizing your settings (caller name, caller picture, and delay time), you can hit the "start call" to commence the simulated call. It works just like a regular call would.',
                          ),
                          SizedBox(height: 10), // Add spacing

                          // Self-Care Reminders Feature
                          Text(
                            'Self-Care Reminders Feature',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'This feature reminds you to take time for self-care with customizable reminders. While reminders for nutrition and hydration are the focal point of the feature, you can add any custom reminders by setting reminder label, time, date and/or frequency.',
                          ),
                          SizedBox(height: 10), // Add spacing
                          
                        ],
                      ),
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
}
