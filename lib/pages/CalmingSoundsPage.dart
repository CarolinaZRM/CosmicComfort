import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CalmingSoundsPage extends StatefulWidget {
  const CalmingSoundsPage({Key? key}) : super(key: key);

  @override
  _CalmingSoundsPageState createState() => _CalmingSoundsPageState();
}

class _CalmingSoundsPageState extends State<CalmingSoundsPage> {
  final List<String> _soundPaths = [
    'sounds/just-relax.mp3',
    'sounds/relaxing-piano.mp3',
    'sounds/lo-fi-track-1.mp3',
    'sounds/lo-fi-track-2.mp3',
    'sounds/piano-orchestra.mp3',
    'sounds/ocean-orchestra.mp3'
  ];

  final List<String> _soundTitles = [
    'Just Relax',
    'Relaxing Piano',
    'Lo-Fi Track 1',
    'Lo-Fi Track 2',
    'Piano Orchestra',
    'Ocean Orchestra'
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentSound;

  // Function to toggle play/pause for a sound
  void _togglePlayPause(String soundPath) async {
    if (_currentSound == soundPath) {
      await _audioPlayer.pause();
      setState(() {
        _currentSound = null; // Reset when paused
      });
    } else {
      await _audioPlayer.stop(); // Stop any previous sound
      await _audioPlayer.play(AssetSource(soundPath));
      setState(() {
        _currentSound = soundPath; // Set the currently playing sound
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the player when the page is closed
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                    ),
                    const Text(
                      'Calming Music',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // To balance the row
                  ],
                ),
                const SizedBox(height: 16),

                // GridView for sound buttons
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of squares per row
                      childAspectRatio: 1, // Make the squares
                      crossAxisSpacing: 10, // Space between squares horizontally
                      mainAxisSpacing: 10, // Space between squares vertically
                    ),
                    itemCount: _soundPaths.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _togglePlayPause(_soundPaths[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _currentSound == _soundPaths[index]
                                ? Colors.indigo.shade300 // Highlight the playing sound
                                : Colors.white30,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _currentSound == _soundPaths[index]
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.black,
                                  size: 50,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _soundTitles[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}