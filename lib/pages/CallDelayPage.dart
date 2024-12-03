import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'AndroidCallPage.dart';

class CallDelayPage extends StatefulWidget {
  const CallDelayPage({Key? key, this.contactName, this.time, this.playRingtone = false, this.ringtoneName, this.profilePicture}) : super(key: key);
  
  final String? contactName;
  final int? time;
  final bool playRingtone;
  final String? ringtoneName;
  final String? profilePicture;

  @override
  State<CallDelayPage> createState() => _CallDelayPageState();
}

class _CallDelayPageState extends State<CallDelayPage> {
  int timeElapsed = 0; // Store the time elapsed for the call (in seconds)
  int timeLimit = 0;
  String contact = '';
  Timer? _timer;
  late AudioPlayer _audioPlayer;
  String? picture;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    startCallTimer();
    contact = widget.contactName ?? "Unknown Caller";
    timeLimit = widget.time ?? 0;
    picture = widget.profilePicture ?? 'assets/astronaut.jpg';


    // Start ringtone playback if enabled
    if (widget.playRingtone && widget.ringtoneName != null) {
      playRingtone();
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _audioPlayer.stop(); // Stop the audio playback
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }

  // Play ringtone
  Future<void> playRingtone() async {
    final String ringtonePath = '${widget.ringtoneName}';
    await _audioPlayer.play(AssetSource(ringtonePath), volume: 1.0); // Play ringtone
  }

  // Function to start the timer for the call duration
  void startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeElapsed += 1;
        if (timeElapsed == timeLimit) {
          _audioPlayer.stop(); // Stop the ringtone when timer completes
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AndroidCallPage(contactName: contact, waited: true, profilePicture: picture),
            ),
          );
        }
      });
    });
  }

  // Format time into hh:mm:ss or mm:ss
  String formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600; // Total hours
    final minutes = (totalSeconds % 3600) ~/ 60; // Remaining minutes
    final seconds = totalSeconds % 60; // Remaining seconds

    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
          ),

          // Countdown Display
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Calling ${contact}...",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  formatTime(timeElapsed),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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