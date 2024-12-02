import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/GenericComponents.dart' as components;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePicPage extends StatelessWidget {
  ProfilePicPage({super.key});

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
                //Header
                components.buildHeader(title: "Profile Picture", context: context),
                //------

                const SizedBox(height: 40), // Space below the title
                
                const Text(
                  "Select your preferred profile picture:",
                  style: TextStyle(
                      color: Colors.white
                  )
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: GridView.builder(
                    itemCount: picturePaths.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Handle picture selection
                          // updateProfilePicture(context, picturePaths[index]);
                          components.testUpdateProfilePicture(context, picturePaths[index]);
                          
                        },
                        child: Image.asset(picturePaths[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}