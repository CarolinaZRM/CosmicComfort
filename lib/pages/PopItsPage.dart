import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../components/GenericComponents.dart' as components;

class PopItsPage extends StatelessWidget {
  const PopItsPage({super.key});

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
                components.buildHeader(title: "Interactive", context: context),
                const SizedBox(height: 60), // Space below the title
                // const Text("Tap the Dots to Pop!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, )),
                
                // Pop It Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PopItGrid(), // Custom widget to create poppable bubbles
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

// Custom widget to handle popping grid with animation and sound
class PopItGrid extends StatelessWidget {
  PopItGrid({Key? key}) : super(key: key);

  Future<void> _playPopSound() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setSource(AssetSource('sounds/pop.mp3'));
    await audioPlayer.resume();
    // Dispose the audio player after the sound is done playing
    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 24, // Number of bubbles
      itemBuilder: (context, index) {
        return PopItBubble(onPopped: _playPopSound); // Bubble widget
      },
    );
  }
}

class PopItBubble extends StatefulWidget {
  final VoidCallback onPopped;

  const PopItBubble({Key? key, required this.onPopped}) : super(key: key);

  @override
  _PopItBubbleState createState() => _PopItBubbleState();
}

class _PopItBubbleState extends State<PopItBubble> with SingleTickerProviderStateMixin {
  bool isPopped = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePop() {
    setState(() {
      isPopped = !isPopped; // Toggle between popped and unpopped
    });
    widget.onPopped(); // Play sound
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handlePop,
      child: AnimatedScale(
        scale: isPopped ? 0.6 : 1.0, // Shrinks when popped, expands when unpopped
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: isPopped ? const Color.fromARGB(255, 64, 16, 96) : const Color.fromARGB(255, 92, 50, 129),
            shape: BoxShape.circle,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}