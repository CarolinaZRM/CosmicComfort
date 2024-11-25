import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/SettingsPage.dart'; // Import the settings page file
import 'pages/ResourcesPage.dart';
import 'pages/AccioPage.dart';
import 'pages/FakeCallPage.dart';
import 'pages/InteractivePage.dart';
import 'pages/CalmingSoundsPage.dart';
import 'pages/BreathingPage.dart';
import 'pages/CalendarPage.dart';
import 'pages/SelfCareRemindersPage.dart';
import 'pages/SignInPage.dart';
import 'pages/SignUpPage.dart';
import './notification/notifications.dart';

void main() async{
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized(); 

  // Initialize Firebase
  await Firebase.initializeApp();
  print('Firebase initialized successfully');

  await NotificationService().initializeNotifications();

  // Modified so that the application screen doesn't change orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // force screen to always be in portrait mode
  ]).then((_) {
    runApp(const MyApp());
  });
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
                          MaterialPageRoute(builder: (context) => SettingsPage()),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CalendarPage(),
                              ),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InteractivePage(),
                              ),
                            );
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
                            // Action for Resources
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResourcesPage(),
                              ),
                            );
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
                            // Action for Breathing Excersises
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BreathingPage()),
                            );
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
                            // Action for Reminders
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SelfCareRemindersPage()),
                            );
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
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CalmingSoundsPage()),
                          );
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

                // Bottom navigation with fake call, accio, and user profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call, size: 40, color: Colors.white),
                      onPressed: () {
                        /// Navigate to Fake Call Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FakeCallPage()),
                          );
                      },
                    ),

                    GestureDetector(
                    onTap: () {
                      // Navigate to Accio Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccioPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/AccioIconClearBG.PNG', // Image path
                      width: 75,  // Set the width as needed
                      height: 75, // Set the height as needed
                      
                    ),
                  ),
                    IconButton(
                      icon: const Icon(Icons.person, size: 40, color: Colors.white),
                      onPressed: () {
                        //Navigate User profile
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignInPage()),
                          );
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