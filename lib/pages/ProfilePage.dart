import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../components/GenericComponents.dart' as components;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SignInPage.dart';
import 'PasswordPage.dart';
import 'UsernamePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage>{

  String username = "Loading...";

  @override
  void initState(){
    super.initState();
    _fetchUsername();
  }

  // log user out and return to sign in page
  Future<void> logout(BuildContext context) async {
    try{
      // this variable contains cc and user token
      final prefs = await SharedPreferences.getInstance();

      print("This is the prefs variable: $prefs");
      // test -----
      final existingToken = prefs.getString('authToken');
      print("Token before logout: $existingToken");
      // -----

      // remove token from local storage
      await prefs.remove('authToken');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Succesfully logged out"))
      );
      // check if token was successfully removed. token should print null if so
      final token = await prefs.getString('authToken');
      print("Token after logout: $token");

      // Wait for 1 second before navigating to the next screen so that snackBar message can show
      await Future.delayed(const Duration(seconds: 1));
      // Clear all previous screens
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()), (route) => false,
      );
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e ."))
      );
    }
    
  }

  Future<String?> getUsernameFromToken() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        return null;
      }

      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['username'];

    } catch (e) {
      return null;
    }
  }

  // get username from token
  Future<void> _fetchUsername() async {
    // token refresh
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    
    if (token == null){
      setState(() {
        username = "Error retrieving username";
      });
      return;
    }
    final decodedToken = JwtDecoder.decode(token);

    final userID = decodedToken['id'];

    try{
        final response = await http.get(
        Uri.parse("http://localhost:3000/user/$userID"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer $token",
          },
        );

        if (response.statusCode == 200){
          final data = jsonDecode(response.body);
          setState(() {
            username = data['username'] ?? "Unknown user";
          });
        } else{
          setState(() {
            username = "Error fetching username";
          });
        }
      } catch(e){
        setState(() {
          username = "Error fetching username";
        });
      }

  }

  // Navigate to change username page and handle result
  Future<void> _navigateToChangeUsernamePage() async{
    final newUsername = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UsernameChangePage()),
    );

    if (newUsername != null && newUsername is String) {
      setState(() {
        username = newUsername;
      });
      print("Udpdated Username $username");
      await _fetchUsername();
      setState(() {});
    }
  }

  // // Determine if user is currently logged in
  // Future<bool> isUserLoggedIn() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('authToken');
  //   return token != null;
  // }
  
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
                  Text(
                    username,
                    style: const TextStyle(
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

                  components.infoTransferPageRedirectCard(
                    title: "Change Username",
                    context: context,
                    page: null,
                    trailingIcon: Icons.arrow_forward_ios,
                    onTap: _navigateToChangeUsernamePage
                  ),
                  const SizedBox(height: 45),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 140.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         // Log out Button
                        ElevatedButton(
                          onPressed: () => logout(context),
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

