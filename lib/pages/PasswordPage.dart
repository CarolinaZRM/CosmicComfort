import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class PasswordChangePage extends StatelessWidget {
  const PasswordChangePage({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Header
                  components.buildHeader(title: "Change Password", context: context),
                  //------

                  const SizedBox(height: 40), // Space below the title

                  const Text(
                    "Make sure to not include personal information.",
                    style: TextStyle(
                      color: Colors.white
                    )
                  ),

                  const SizedBox(height: 20),
                  
                  //TODO: this will be matched with DB ig
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Current Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  //TODO: this will be saved in DB
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  //TODO: this text will need to match the one above
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                 
                 const SizedBox(height: 20),

                  // Button to change password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 105.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Handle password change logic
                          },
                          child: const Text('Change Password'),
                        ),
                      ]
                    )
                  ) 
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}

