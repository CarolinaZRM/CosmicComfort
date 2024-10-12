import 'package:flutter/material.dart';
import '../../components/GenericComponents.dart' as components;
import 'dart:io' show Platform;

class TextIDPage extends StatefulWidget {
  const TextIDPage({Key? key}) : super(key: key);

  @override
  State<TextIDPage> createState() => _TextIDPageState();
}

class _TextIDPageState extends State<TextIDPage> {
  String? os = Platform.isAndroid ? "Android" : "iOS";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image or gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'), // Gradient background
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 60.0, 10.0, 20.0),            
            child: 
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    //Header
                    components.buildHeader(title: "Text ID", context: context),
                    //------

                    const SizedBox(height: 40), // Space below the title

                    //Caller Pic and Edit button
                    Center(
                      child: Column(
                        children: [
                          //Picture
                          ClipOval(
                            child: Image.asset(
                              'assets/testPic.jpg', //TODO: this will be gotten from DB
                              width: 200,  // Same as diameter
                              height: 200,  // Same as diameter
                              fit: BoxFit.cover,  // Controls how the image fits inside the circle
                            ),
                          ),
                          //Edit
                          TextButton(
                            onPressed: () {
                              //TODO: Action to perform when the button is pressed

                            },
                            child: const Text(
                              'Edit', // Button text
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255), // Text color
                              ),
                            )
                          )
                        ],
                      )
                    ),
                    
                    const SizedBox(height: 20),

                    const Text(
                      'Contact Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 255, 255, 255)
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: TextEditingController(),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.3), // Make text semi-transparent
                        ),
                        hintText: "Contact Name...", //TODO: this will be gotten from DB
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onSubmitted: (value) {
                        //TODO: Give Functionality!
                      },
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      'Preferred OS Style',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 255, 255, 255)
                      ),
                    ),

                    buildDropdownMenu(
                      title: 'Default System OS',
                      value: os,
                      items: ['Android', 'iOS'],
                      onChanged: (value) {
                        setState(() {
                          os = value;
                        });
                      },
                    ),

                  ]
                )
              
              )
            )
            
          ),
          


        ],
      ),
    );
  }


  // Helper method to build each dropdown menu with a white box
  Widget buildDropdownMenu({
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // White background for the dropdown
          labelText: title,
          
          floatingLabelBehavior: FloatingLabelBehavior.never, // Fixes the issue of the label moving
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        hint: Text(title), // Ensure the title shows when no value is selected
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}