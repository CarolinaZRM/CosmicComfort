import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordChangePage extends StatelessWidget {
  const PasswordChangePage({super.key});

  Future<void> updatePassword(String password, BuildContext context) async {
    //fr
    final response = await http.post(
        Uri.parse("http://localhost:3000/user/"),
        //Uri.parse("http://127.0.0.1:3000/user/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "password": password,
        }),
      );
  
  }

  //**
  // final response = await http.post(
      //   Uri.parse("http://localhost:3000/user/login"),
      //   //Uri.parse("http://127.0.0.1:3000/user/"),
      //   headers: {"Content-Type": "application/json"},
      //   body: jsonEncode({
      //     "username": username,
      //     "password": password,
      //   }),
      // );
  //
  // */

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
                  
                  //TODO: Make this so that it will fetch current password from DB, if they don't match it won't update the password
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

                  //TODO: this new password will be updated in DB
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
                            //fr
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

