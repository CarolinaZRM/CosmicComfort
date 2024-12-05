import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/GenericComponents.dart' as components;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SignUpPage.dart';
import 'ProfilePage.dart';
import '../main.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  // User session JWT stuff
  Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('authToken', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> logUserIn(String username, String password, BuildContext context) async {
 
    try{
      // Call Backend API to Save Data in MongoDB
      final response = await http.post(
        Uri.parse("http://localhost:3000/user/login"),
        //Uri.parse("http://127.0.0.1:3000/user/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body.toString()}");

      if (response.statusCode == 200) {
        // save token after successful login
        final data = jsonDecode(response.body);
        await saveToken(data['token']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful.")),
        );
        // Wait for 1 second before navigating to the next screen so that snackBar message can show
        await Future.delayed(const Duration(seconds: 1));
        // Send user to home page after successful login
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );

        fetchProtectedData(context);
      } else if (response.statusCode == 404){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password.")),
        );
      }
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e ."))
      );
      print("Error: $e");
    }

  } // end of logUserIn()

  // include token in headers for future requests
  Future<void> fetchProtectedData(BuildContext context) async {
    try{
      final token = await getToken();
      if (token == null){
        throw Exception("Token is null. User is not logged in.");
      }

      final response = await http.get(
      Uri.parse('http://localhost:3000/user/protected-route'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      );
      if(response.statusCode == 200){
        print("success! \n Protected Data: ${response.body}");
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body.toString()}");
      } else if (response.statusCode == 403){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Forbidden Access.")),
        );
      } else{ print("Failed to fetch protected data. Status: ${response.statusCode}");}
  
    } catch(e){
      // smth
    }
    
  }



  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
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
                const Center(
                  child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ),
                
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
                          onPressed: () {
                            logUserIn(
                              usernameController.text.trim(),
                              passwordController.text.trim(),
                              context,
                            );
                          },
                          child: const Text('Sign In'),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Sign Up link
                        GestureDetector(
                          onTap: () {
                            // Navigate to sign up page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(
                              color: Color.fromARGB(255, 78, 3, 140),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // components.buildPageRedirectCard(
                //   icon: Icons.abc_outlined,
                //   title: "Temp Profile view when already logged in", 
                //   context: context, 
                //   page: ProfilePage())
              ],
            ),
          )
        ],
      ),
    );
  }
}
