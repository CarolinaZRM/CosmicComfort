import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../components/GenericComponents.dart' as components;

class RingtonePage extends StatefulWidget {
  const RingtonePage({Key? key}) : super(key: key);

  @override
  _RingtonePageState createState() => _RingtonePageState();
}

class _RingtonePageState extends State<RingtonePage> {
  // List of ringtones and their corresponding file paths
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  components.buildHeader(title: "Ringtone", context: context),
                  
                  const SizedBox(height: 20), // Spacing below the header

                  // Ringtone Radio Switch Icon
                  const components.RadioChoiceCard(icon: Icons.radio, title: "Ringtone"),
                  //------

                    // Vibration Radio Switch Icon
                  const components.RadioChoiceCard(icon: Icons.radio, title: "Vibration"),
                  //------
                  
                  const SizedBox(height: 60), // Space below the title

                 
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
