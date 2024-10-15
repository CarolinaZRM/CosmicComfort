import 'package:flutter/material.dart';
import 'CallerIDPage.dart';
import 'RingtonePage.dart';
import 'CallTime.dart';
import '../components/GenericComponents.dart' as components;
import 'CallDelayPage.dart';
import 'AndroidCallPage.dart';
class FakeCallPage extends StatefulWidget {
  const FakeCallPage({Key? key}) : super(key: key);

  @override
  State<FakeCallPage> createState() => _FakeCallPageState();
}

class _FakeCallPageState extends State<FakeCallPage> {
  // Define variables to store the dropdown selections
  //TODO: selectedTime should be from DB
  String selectedTime = "5";
  String? selectedCaller;
  String? selectedRingtone;
  String? selectedVoice;
  String? selectedWallpaper;
  String? selectedMore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'), // Your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 60.0, 10.0, 20.0),            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with Back Arrow and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Navigates back to the previous screen
                      },
                    ),
                    const Text(
                      'Fake Call Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48), // To balance the row
                  ],
                ),

                const SizedBox(height: 20), // Space below the title

                components.buildPageRedirectCard(
                  icon: Icons.schedule, 
                  title: "Time",
                  context: context,
                  page: const CallTimePage(),
                  trailingIcon: Icons.chevron_right_outlined
                ),

                components.buildPageRedirectCard(
                  icon: Icons.person, 
                  title: "Caller ID", 
                  context: context, 
                  page: const CallerIDPage(),
                  trailingIcon: Icons.chevron_right_outlined
                ),

                // This card will redirect user to the Ringtone page
                components.buildPageRedirectCard(
                  icon: Icons.music_note,
                  title: "Ringtone",
                  context: context,
                  page: const RingtonePage(),
                  trailingIcon: Icons.chevron_right_outlined //optional parameter!
                ),

                const components.RadioChoiceCard(
                  icon: Icons.radio, 
                  title: "LED Flashlight",
                  leadingIcon: Icons.flash_on_outlined, //optional parameter
                ),

                const SizedBox(height: 20), // Space below dropdowns

                // Start Call Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Trigger fake call action
                      if(int.parse(selectedTime) > 0){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          //TODO: Contact Name should be from DB
                          builder: (context) => CallDelayPage(contactName: "Hello this name is too long and will start scrolling when testing", time: int.parse(selectedTime)),
                        ),
                      );
                      }
                      else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            //TODO: Contact Name should be from DB
                            builder: (context) => AndroidCallPage(contactName: "Hello this name is too long and will start scrolling when testing", waited: false),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                    ),
                    child: const Text(
                      'Start Call',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),

                //TEST: CallerIDPage.dart
                //UNCOMMENT code below until indicated section, this will add the button to test the
                //CallIDPage, implementation for the actual callid dropdown may borrow elements from this
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // Trigger fake call action
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const CallerIDPage(),
                //         ),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                //       backgroundColor: const Color.fromARGB(200, 69, 68, 121), // Button color
                //     ),
                //     child: const Text(
                //       'Test CallerID',
                //       style: TextStyle(fontSize: 20, color: Colors.white),
                //     ),
                //   ),
                // ),
                //-------------------END TEST CALLIDPAGE-----------------------------

              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build a dropdown menu
  Widget _buildDropdownMenu({
    required String title,
    required IconData icon,
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
          prefixIcon: Icon(icon),
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