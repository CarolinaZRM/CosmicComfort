import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'PasswordPage.dart';

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
                    'ActualDisplayNameGoesHere',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900
                    ),
                  ),

                  // blank space between Username and User Picture
                  const SizedBox(height: 10),

                  // profile pic goes here
                  // TODO: pic will be gotten from DB
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/WaterRipplesBG.JPG',
                            width: 200,  // Same as diameter
                            height: 200,  // Same as diameter
                            fit: BoxFit.cover,  // Controls how the image fits inside the circle
                          ),
                        ),

                      ],
                    )
                  ),
                  
                  // blank space between profile picture and edit
                  const SizedBox(height: 7),

                  // TODO: this will allow user to add/change profile picture. 
                  // Functionality needed.
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 169.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Edit",
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                          )
                        ),
                      ]
                    )
                  ),


                  const SizedBox(height: 20),

                  const Text(
                    'Display Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  //TODO: add functinality to this
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'EnterDisplayNameHere',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const Text(
                    "Display Name is how the app will refer to you.",
                    style: TextStyle(
                      color: Colors.white
                    )
                  ),

                  // blank space between display name stuff and username stuff
                  const SizedBox(height: 30),
                  const Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  // Card
                  // TODO: username will be gotten from DB
                  components.ShowUserInfoCard(title: "ShowUserNameHere", context: context),
                  //------
                  const SizedBox(height: 50),

                  // Redirect user to page where they can change their password
                  components.buildPageRedirectCard(
                  title: "Change Password",
                  context: context,
                  page: const PasswordChangePage(),
                  trailingIcon: Icons.arrow_forward_ios
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

