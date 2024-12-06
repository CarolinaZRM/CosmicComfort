import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../components/GenericComponents.dart' as components;
import 'package:shared_preferences/shared_preferences.dart';

class UsernameChangePage extends StatelessWidget {
  const UsernameChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    Future<void> _saveUsername() async {
      final newUsername = usernameController.text.trim();
      final confirmUsername = confirmController.text.trim();

      if (newUsername.isEmpty || confirmUsername.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill out both fields!")),
        );
        return;
      }

      if (newUsername != confirmUsername) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usernames do not match, please confirm the same username.")),
        );
        return;
      }

      // grab userID
      final prefs = await SharedPreferences.getInstance();
      print("This is the prefs variable: $prefs");
      // test -----
      final token = prefs.getString('authToken');
      print("Token before logout: $token");

      if (token == null) {
        print("No token found in storage.");
        return null;
      }
      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print("Decoded Token: $decodedToken");

      // Extract the userID field
      final userID = decodedToken['id']; // Adjust this based on token payload
      print("UserID extracted from token: $userID");

      
      // Make API call to update the username in the database
      try {
        final response = await http.patch(
          Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/user/update-username/$userID'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({'username': newUsername }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          // check if new token is returned
          if (responseData['token'] != null){
            // update token
            await prefs.setString('authToken', responseData['token']);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Username updated successfully")),
          );
          Navigator.pop(context, newUsername); // Pass the new username back to ProfilePage
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update username: ${response.body}")),
          );
          print("Failed to update username: ${response.body}");
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
                  // Header
                  components.buildHeader(title: "Change username", context: context),
                  //------

                  const SizedBox(height: 40), // Space below the title

                  const Text(
                    "Make sure to not include personal information.",
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'New Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: confirmController,
                    decoration: InputDecoration(
                      hintText: 'Confirm New Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 105.0),
                    child: ElevatedButton(
                      onPressed: _saveUsername,
                      child: const Text('Change Username'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
