import 'package:flutter/material.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Accio title, top bar title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Arrow
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'ACCIO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48), // Placeholder for symmetry (Optional)
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned text input bar at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            // Container for bottom box (AKA bottom App Bar)
            child: Container(
              // These settings affect the bottom "box" the text input and icons are in
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 67, 66, 70),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    spreadRadius: 6,
                  ),
                ],
              ),
              // Here are the contents of the bottom box container
              child: Row(
                children: [
                  Expanded(
                    // this container is for the rounded rectangle containing the
                    // text input message and icons
                    child: Container( 
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 116, 114, 114), // Background color for the entire container
                        borderRadius: BorderRadius.circular(30), // Rounded edges
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              // this style changes the text that the user inputs
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Type a message",
                                // this style changes the text that is first shown in text field
                                hintStyle: TextStyle(
                                  color: Colors.white
                                ),
                                border: InputBorder.none, // Remove default text field border
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.camera_alt, color: Colors.white),
                        ],
                      )
                    )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
