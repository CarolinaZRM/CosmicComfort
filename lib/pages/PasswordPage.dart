import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PasswordChangePage extends StatelessWidget {
  const PasswordChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    Future<void> updatePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmController.text.trim();

    // -------- token stuff ----------
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    print("Token: $token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No token found in storage.")),
      );
      return;
    }

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out all fields!")),
      );
      return;
    }
    // make sure new password inputs match
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match, please confirm the same password.")),
      );
      return;
    }
    // grab userID
    final userId = JwtDecoder.decode(token)['id'];

    try {
      // Make API call to update the password in the database
      final response = await http.patch(
        Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/user/update-password/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully")),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        final error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update password: $error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
   }
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
                    controller: currentPasswordController,
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
                    controller: newPasswordController,
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
                    controller: confirmController,
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
                            updatePassword();
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

