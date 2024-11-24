import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'PasswordPage.dart';
import 'UsernamePage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                  components.buildHeader(title: "Profile", context: context),
                  //------

                  const SizedBox(height: 40), // Space below the title
                  
                  // TODO: Display Name should replace this text
                  const Text(
                    'Username Goes Here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900
                    ),
                  ),

                  // blank space between Username and User Picture
                  const SizedBox(height: 25),

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // profile pic goes here
                        // TODO: pic will be gotten from DB
                        ClipOval(
                          child: Image.asset(
                            'assets/WaterRipplesBG.JPG',
                            width: 200,  // Same as diameter
                            height: 200,  // Same as diameter
                            fit: BoxFit.cover,  // Controls how the image fits inside the circle
                          ),
                        ),

                        // blank space between profile picture and edit
                        const SizedBox(height: 7),
                        // TODO: this will allow user to add/change profile picture. 
                        // Functionality needed.
                        const Text("Edit",
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold
                          )
                        ),
                      ],
                    )
                  ),

                  // blank space between display name stuff and username stuff
                  const SizedBox(height: 220),
                  
                  // Redirect user to page where they can change their password
                  components.buildPageRedirectCard(
                  title: "Change Password",
                  context: context,
                  page: const PasswordChangePage(),
                  trailingIcon: Icons.arrow_forward_ios
                  ),

                  // Redirect user to page where they can change their username
                  components.buildPageRedirectCard(
                  title: "Change Username",
                  context: context,
                  page: const UsernameChangePage(),
                  trailingIcon: Icons.arrow_forward_ios
                  ),
                  const SizedBox(height: 45),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 140.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         // Log out Button
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Handle log out logic
                          },
                          child: const Text('Log out'),
                        ),
                        
                      ]
                    )
                  ),

                ],
              ),
            )
          )
        ],
      ),
    );
  }
}

