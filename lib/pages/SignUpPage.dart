import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/GenericComponents.dart' as components;
import 'SignInPage.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  Future<void> registerUser(String username, String email, String password, BuildContext context) async {
    try {

      // Call Backend API to Save Data in MongoDB
      final response = await http.post(
        //Uri.parse("http://<your-backend-url>/register"),
        Uri.parse("https://cosmiccomfort-8656a323f8dc.herokuapp.com/user/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "profilePicture": "assets/astronaut.jpg" // default profile picture is astronaut
        }),
      );
      //print("Body: ${body.stri}");
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body.toString()}");
      final id = jsonDecode(response.body);
      final userID = id["_id"];
      print("User ID: ${id["_id"]}");
      final stringUserID = userID.toString();
      // initialize default values in other tables for each user
      components.defaultUserSettings(stringUserID, context);


      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful.")),
        );
      } else if (response.statusCode == 409){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email is already registered.")),
        );
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save user data.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e ."))
      );
      print("error in signUpPage.dart: $e");
    }

  } // resgisterUser() end


  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/SignIn.JPG'),
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
                components.buildHeader(title: "Sign Up", context: context),
                //---
                const SizedBox(height: 85), // Space below the title
                
                // Sign-in form
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0), // box width
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3), // Background with transparency
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Username TextField
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Email TextField
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // Password TextField
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Sign In Button
                        ElevatedButton(
                          onPressed: () async {
                            await registerUser(
                              usernameController.text.trim(),
                              emailController.text.trim().toLowerCase(),
                              passwordController.text.trim(),
                              context,
                            );
                            // Send user to sign in page after successful registration
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPage()),
                            );
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
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
