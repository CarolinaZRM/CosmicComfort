import 'package:flutter/material.dart';

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
// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ PLACEHOLDER ∘₊✧──────✧₊∘∘₊✧──────✧₊∘



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

// ∘₊✧──────✧₊∘∘₊✧──────✧₊∘ PLACEHOLDER ∘₊✧──────✧₊∘∘₊✧──────✧₊∘