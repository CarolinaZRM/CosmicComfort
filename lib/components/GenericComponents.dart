import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ HEADER BAR ∘₊✧──────✧₊∘∘₊✧──────✧₊∘
Widget buildHeader({
  required String title,
  required BuildContext context
}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context); // Go back to the previous screen
        },
      ),
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 48), // To balance the row
    ],
  );
}

// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ PAGE REDIRECT CARD ∘₊✧──────✧₊∘∘₊✧──────✧₊∘
//  Helper function to build a card that will redirect user to another page once pressed
Widget buildPageRedirectCard({
  IconData? icon,
  required String title,
  required BuildContext context,
  required Widget page, // New page parameter
  IconData? trailingIcon
}) {
  return Card(
    color: Colors.white.withOpacity(0.9),
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      //leading: Icon(icon, color: const Color.fromARGB(255, 92, 50, 129)),
      leading: icon != null ? Icon(icon) : null, // Conditionally render the leading icon
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: trailingIcon != null ? Icon(trailingIcon) : null, // Conditionally render the trailing icon
      onTap: () {
        // Take to corresponding page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );

      },
    ),
  );
}

// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ INFO TRANSFER PAGE REDIRECT CARD ∘₊✧──────✧₊∘∘₊✧──────✧₊∘
// specifically for implementation made to avoid circular dependencies in ProfilePage.dart
Widget infoTransferPageRedirectCard({
  required String title,
  required BuildContext context,
  Widget? page,
  IconData? trailingIcon,
  VoidCallback? onTap, // Add the onTap callback.
}) {
  return GestureDetector(
    onTap: onTap ?? () {
      if (page != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      }
    },
    child: Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(trailingIcon),
      ),
    ),
  );
}

// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ PLACEHOLDER ∘₊✧──────✧₊∘∘₊✧──────✧₊∘
/** This function is for replacing a profile or caller ID picture. Do note, by selectedPath it is meant
 * that you must have a list with the image paths in your file.
 * Ex:  final List<String> picturePaths = [
    'assets/astronaut.jpg',
    'assets/car.jpg',
    'assets/cat.jpg',
    'assets/earth.jpg',
    'assets/moon.jpg',
    'assets/puppy.jpg'
  ];
 * 
 * also, make sure that in whatever file you're using this in, you import the following:
 * import 'package:jwt_decoder/jwt_decoder.dart';
 * import 'package:shared_preferences/shared_preferences.dart';
 * import 'package:http/http.dart' as http;
 * import 'dart:convert';
 */
///
Future<void> testUpdateProfilePicture(BuildContext context, String selectedPath) async {
    // -------- token stuff ----------
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to update profile picture: No token found.")),
      );
      print("this is the token: $token");
      return;
    }
    // grab userID
    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['id'];

    print("This is the userID: $userId");
    print("This is decoded token: $decodedToken");
    // -------- token stuff ----------

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to update profile picture: No user ID found.")),
      );
      print("This is the userID: $userId");
      return;
    }

    try {
      //
      final response = await http.patch(
      Uri.parse('https://cosmiccomfort-8656a323f8dc.herokuapp.com/user/update-profpic/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'profilePicture': selectedPath}),
      );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated!")),
      );
      Navigator.pop(context, selectedPath); // Return selected path to profile for UI update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile picture.")),
      );
    }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  } // end of updateProfilePicture()


// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ SHOW INFO CARD ∘₊✧──────✧₊∘∘₊✧──────✧₊∘
// this is a regular card whose only purpose is to show information
Widget ShowUserInfoCard({
    //required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        //leading: Icon(icon, color: const Color.fromARGB(255, 92, 50, 129)),
        title: Text(title),
      ),
    );
  }


// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ RADIO SWITCH ICON ∘₊✧──────✧₊∘∘₊✧──────✧₊∘
class RadioChoiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final IconData? leadingIcon;

  const RadioChoiceCard({
    required this.icon,
    required this.title,
    this.leadingIcon,
    Key? key,
  }) : super(key: key);

  @override
  _RadioChoiceCardState createState() => _RadioChoiceCardState();
}

class _RadioChoiceCardState extends State<RadioChoiceCard> {
  bool _isSwitched = false; // State variable for switch

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        // leading is an optional parameter. It does not need to be given upon call.
        // Below is example usage of this method
        leading: widget.leadingIcon != null ? Icon(widget.leadingIcon, color: const Color.fromARGB(255, 92, 50, 129)) : null,
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        // Replace the icon in trailing with Switch widget
        trailing: Switch(
          value: _isSwitched,
          onChanged: (bool value) {
            setState(() {
              _isSwitched = value; // Update switch state
            });
          },
          activeColor: const Color.fromARGB(255, 92, 50, 129), // Customize active switch color
        ),
        
        onTap: () {
          // Handle tap logic, if needed
          //TODO: IMPLEMENT LOGIC
        },
      ),
    );
  }
}

// Example usage
/*
USING LEADING ICON:
const components.RadioChoiceCard(
  icon: Icons.radio, 
  title: "LED Flashlight",
  leadingIcon: Icons.flash_on_outlined, //optional parameter
),

NOT USING LEADING ICON:
  const components.RadioChoiceCard(
  icon: Icons.radio, title: "Ringtone"
),
 */

// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ DEFAULT VALUES POST METHOD ∘₊✧──────✧₊∘∘₊✧──────✧₊∘
// this function is for creating initial instances of every required table for each
// user. It makes a POST to every table with initial data.
Future <void> defaultUserSettings(String userID, BuildContext context) async {
    // -------- Account Settings ----------
    try {
      final accSettingsResponse = await http.post(
        Uri.parse("https://cosmiccomfort-8656a323f8dc.herokuapp.com/account_settings/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userID,
          "theme": "dark",
          "font_size": 707,
          "self_care": false, 
          "log_reminder": false,
        }),
      );
      if (accSettingsResponse.statusCode == 201) {
        print("Default Account Settings applied successfully.");

      } else{
        print("Failed to save default calendar values.");

      }
    } catch (e) {
      print("Account Settings Error: $e .");
    }

    // -------- Calendar ----------
    try {
      final calendarResponse = await http.post(
        Uri.parse("https://cosmiccomfort-8656a323f8dc.herokuapp.com/calendar/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userID,
          "mood_list": [
            //
            { "mood": "Happy", "color": "#FFFFEB3B"},
            { "mood": "Sick", "color": "#FF4CAF50"},
            { "mood": "Sad", "color": "#FF2196F3"},
            { "mood": "Tired", "color": "#FF9E9E9E"},
            { "mood": "Angry", "color": "#FFF44336"},
            { "mood": "Anxious", "color": "#FFFF9800"},
            { "mood": "Average", "color": "#FF9C27B0"}
          ],
          "date_colors": [],
        }),
      );
      if (calendarResponse.statusCode == 201) {
        print("Default Calendar values applied successfully.");

      } else{
        print("Failed to save default calendar values.");

      }
    } catch (e) {
      print("Calendar Error: $e .");
    }

    // -------- Fake Call ----------
    try {
      final fakeCallResponse = await http.post(
        Uri.parse("https://cosmiccomfort-8656a323f8dc.herokuapp.com/fake_call"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userID,
          "caller_name": "Unknown",
          "call_time": 5,
          "ringtone": true, 
          "ring_name": "sounds/CuteRingtone.mp3",
          "profile_picture": "assets/astronaut.jpg",
        }),
      );
      if (fakeCallResponse.statusCode == 201) {
        print("Default Fake Call values applied successfully.");

       } else{
        print("Failed to save default Fake Call values.");
    
      }
    } catch (e) {
      print("Fake Call Error: $e .");
    }
  }

// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ PLACEHOLDER ∘₊✧──────✧₊∘∘₊✧──────✧₊∘