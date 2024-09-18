import 'package:flutter/material.dart';
import 'pages/SettingsPage.dart'; // Import the settings page file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Comfort',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Homescreen.JPG'), // Your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and title at the top
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Settings button on the top left
                    IconButton(
                      icon: const Icon(Icons.dehaze, color: Colors.white),
                      onPressed: () {
                        // Navigate to the Settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsPage()),
                        );
                      },
                    ),
                  ],
                ),
                const Spacer(), // To push content to the bottom
                
                // Middle content with icons/buttons (Interactive, Breathing, Music, etc.)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.calendar_today, size: 50, color: Colors.white),
                          onPressed: () {
                            // Action for the Calendar Icon
                          },
                        ),
                        const Text(
                          'Calendar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.touch_app, size: 50, color: Colors.white), // Changed interactive icon to touch_app
                          onPressed: () {
                            // Action for Interactive
                          },
                        ),
                        const Text(
                          'Interactive',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.now_widgets, size: 50, color: Colors.white),
                          onPressed: () {
                            // Action for Breathing exercise
                          },
                        ),
                        const Text(
                          'Resources',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.air, size: 50, color: Colors.white),
                          onPressed: () {
                            // Action for Music
                          },
                        ),
                        const Text(
                          'Breathing',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notes_outlined , size: 50, color: Colors.white),
                          onPressed: () {
                            // Action for Breathing exercise
                          },
                        ),
                        const Text(
                          'Self-Care',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.music_note, size: 50, color: Colors.white),
                          onPressed: () {
                            // Action for Music
                          },
                        ),
                        const Text(
                          'Music',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),

                // Bottom navigation with fake call/chat, night mode, and user profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.bubble_chart, size: 40, color: Colors.white),
                      onPressed: () {
                        // Fake Chat
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat, size: 40, color: Colors.white),
                      onPressed: () {
                        // Fake Chat
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        // Night mode action
                      },
                      child: Image.asset(
                        'assets/CosmicComfortLogo.jpeg', // Replace with your image path
                        width: 40,
                        height: 40,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.call, size: 40, color: Colors.white),
                      onPressed: () {
                        // Fake Call
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person, size: 40, color: Colors.white),
                      onPressed: () {
                        // User profile or bot
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}