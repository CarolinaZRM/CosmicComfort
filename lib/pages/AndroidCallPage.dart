import 'dart:async';
import 'package:marquee/marquee.dart';
import 'package:flutter/material.dart';

class AndroidCallPage extends StatefulWidget {
  const AndroidCallPage({Key? key, this.waited, this.contactName}) : super(key: key);
  final String? contactName;
  final bool? waited;
  @override
  State<AndroidCallPage> createState() => _AndroidCallPageState();
}

class _AndroidCallPageState extends State<AndroidCallPage> {
  int timeElapsed = 0; // Store the time elapsed for the call (in seconds)
  String contact = ""; // Store the contact name
  bool isMuted = false; // State for mute button
  bool isSpeakerOn = false; // State for speaker button
  bool waited = false;
  Timer? _timer;
  bool shouldScroll = false;

  @override
  void initState() {
    super.initState();
    startCallTimer();
    waited = widget.waited ?? false;
    contact = widget.contactName ?? "Unkown Caller";
    //Account for names with only spaces
    contact = contact.trim();
    if( contact == "" ){
      contact = "Unkown Caller";
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to start the timer for the call duration
  void startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeElapsed += 1;
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
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Contact Name and Call Timer
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Contact Name
                    
                    const SizedBox(height: 10),

                    // Contact Name (use scrolling if necessary)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final textSize = _textSize(contact, const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ));
                        // If the text overflows, show a marquee, else show normal text
                        return textSize.width > constraints.maxWidth
                            ? SizedBox(
                                height: 30, // Ensure height for marquee
                                child: Marquee(
                                  text: contact,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 30.0,
                                  pauseAfterRound: const Duration(seconds: 5),
                                  startPadding: 30.0,
                                  accelerationDuration: const Duration(seconds: 1),
                                  decelerationDuration: const Duration(milliseconds: 500),
                                  startAfter: const Duration(seconds: 3),
                                ),
                              )
                            : Text(
                                contact,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                      },
                    ),

                    const SizedBox(height: 10),
                    
                    // Call Timer
                    Text(
                      formatTime(timeElapsed),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Picture
              ClipOval(
                child: Image.asset(
                  'assets/testPic.jpg', // Replace with your caller's image
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(),
              // Call Actions (Mute, Speaker, End Call)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Mute Button
                  _buildActionButton(
                    icon: isMuted ? Icons.mic_off : Icons.mic,
                    label: "Mute",
                    onTap: () {
                      setState(() {
                        isMuted = !isMuted;
                      });
                    },
                    color: isMuted ? Colors.red : Colors.white,
                  ),
                  // End Call Button
                  _buildActionButton(
                    icon: Icons.call_end,
                    label: "End Call",
                    onTap: () {
                      // End the call logic
                      Navigator.pop(context); // Simulate ending the call
                      if(waited){
                        Navigator.pop(context); //if we came from the delay page
                      }
                    },
                    color: Colors.white,
                    isEndCall: true,
                  ),
                  // Speaker Button
                  _buildActionButton(
                    icon: isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                    label: "Speaker",
                    onTap: () {
                      setState(() {
                        isSpeakerOn = !isSpeakerOn;
                      });
                    },
                    color: isSpeakerOn ? Colors.green : Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 40), // Add some space at the bottom
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to calculate text size
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  // Helper method to build action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
    bool isEndCall = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: isEndCall ? 35 : 30, // Slightly larger for End Call
            backgroundColor: isEndCall ? Colors.red : Colors.grey[800],
            child: Icon(icon, color: color, size: isEndCall ? 30 : 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}