import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class FakeCallPicture extends StatelessWidget {
  FakeCallPicture({super.key});

  final List<String> picturePaths = [
    'assets/astronaut.jpg',
    'assets/car.jpg',
    'assets/cat.jpg',
    'assets/earth.jpg',
    'assets/moon.jpg',
    'assets/puppy.jpg'
  ];

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
                components.buildHeader(title: "Fake Call Picture", context: context),
                const SizedBox(height: 40), // Space below the title
                
                const Text(
                  "Select your preferred fake call picture:",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: GridView.builder(
                    itemCount: picturePaths.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Return the selected picture path and pop back
                          Navigator.pop(context, picturePaths[index]);
                        },
                        child: Image.asset(
                          picturePaths[index],
                          fit: BoxFit.cover,
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