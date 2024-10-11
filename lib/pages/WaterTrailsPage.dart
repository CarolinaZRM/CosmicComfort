import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class WaterTrailsPage extends StatelessWidget {
  const WaterTrailsPage({super.key});

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
                //Header
                components.buildHeader(title: "Interactive", context: context),
                //------

                const SizedBox(height: 40), // Space below the title
                
                const Text("Water Trails Page Content"),

              ],
            ),
          )
        ],
      ),
    );
  }
}