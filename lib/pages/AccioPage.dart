import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class AccioPage extends StatelessWidget {
  const AccioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/AccioBG.JPG'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          SafeArea(
            child: Column(
              children: [
                // Header from GenericComponents
                components.buildHeader(title: "ACCIO", context: context),
                const SizedBox(height: 20),

                // Scrollable image section
                Expanded(
                  child: SingleChildScrollView(
                    child: Center( // Centered Image with expanded height
                      child: Image.asset(
                        'assets/AccioAnxietyManager.png',
                        width: MediaQuery.of(context).size.width * 0.95, // Adjusts to screen width
                        height: 1300, // Ensures image is tall enough for scrolling
                        // fit: BoxFit.cover,
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