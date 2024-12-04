import 'package:cosmiccomfort/notification/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/GenericComponents.dart' as components;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class MissingEntryError implements Exception {
  final String message;
  MissingEntryError(this.message);

  @override
  String toString() => message; // Return the message without "Exception:"
}

class CustomReminderSetupPage extends StatefulWidget {
  const CustomReminderSetupPage({Key? key}) : super(key: key);

  @override
  State<CustomReminderSetupPage> createState() => _CustomReminderSetupPageState();
}

class _CustomReminderSetupPageState extends State<CustomReminderSetupPage> {
  bool timeToggle = false;
  bool dateToggle = false;
  bool showRepeatOptions = false;
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String? selectedFrequency = "Daily";
  int? repeatInterval; // Interval in days for the "Every" dropdown

  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  // String? titleText;
  // String? messageText;

  String? userId;

  Future<String?> getUserIdFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) return null;

      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['id'];
    } catch (e) {
      return null;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white))),
    );
  }

  Future<void> fetchUserId() async {
    String? fetchedUserId = await getUserIdFromToken();
    if (fetchedUserId == null) {
      userId = "673d3790e3262ad583bced63";
      _showError("User ID not found. Please log in again. defaulted to: 673d3790e3262ad583bced63");
      return;
    } else {
      userId = fetchedUserId;
    }
  }

  @override
  void initState() {
    super.initState();
    // fetch userId
    fetchUserId();
  }

  // Frequency options
  final List<String> frequencyOptions = ["Hourly", "Daily", "Weekly", "Monthly"];
  
  // Interval options for "Every" dropdown
  final Map<String, List<int>> frequencyInterval = {
    "Hourly": List<int>.generate(12, (index) => (index + 1)), 
    "Daily": List<int>.generate(31, (index) => (index + 1)), 
    "Weekly":List<int>.generate(2, (index) => (index + 1)), 
    "Monthly":List<int>.generate(6, (index) => (index + 1))
  };

  final Map<String, String> intervalWord = {
    "Hourly": "hour", 
    "Daily": "day", 
    "Weekly": "week", 
    "Monthly": "month"
  };
  
  //final List<int> intervalOptions = List<String>.generate(31, (index) => (index + 1)); // 1 to 31 days

  // Card with a toggle switch and optional selected value display
  Widget buildToggleCard(String title, bool value, ValueChanged<bool> onChanged, {String? displayValue, VoidCallback? onTapDisplay}) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color.fromARGB(255, 92, 50, 129),
            ),
          ),
          if (value && displayValue != null)
            GestureDetector(
              onTap: onTapDisplay,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    decoration: TextDecoration.underline, // Underline the text
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTextCard(String title, {VoidCallback? onTap, TextEditingController? controller}) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: onTap, // Optional tap handling
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Enter text",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Regular card without toggle
  Widget buildSimpleCard(String title, {bool isDropdown = false, VoidCallback? onTap}) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: isDropdown
            ? Icon(
                showRepeatOptions ? Icons.keyboard_arrow_down : Icons.chevron_right_outlined,
                color: const Color.fromARGB(255, 92, 50, 129),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    } 
    // cancel was selected
    else if (pickedTime == null) {
      setState(() {
        selectedTime = null;
        timeToggle = false;
      });
      print(selectedTime);
    }
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    } 
    // cancel was selected
    else if (pickedDate == null) {
      setState(() {
        selectedDate = null;
        dateToggle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    components.buildHeader(title: "Custom Reminder", context: context),
                    const SizedBox(height: 40), // Space below the title

                    buildToggleCard(
                      "Time",
                      timeToggle,
                      (value) {
                        setState(() {
                          timeToggle = value;
                        });
                        if (value) {
                          _pickTime();
                        } else {
                          setState(() {
                            selectedTime = null;
                          });
                        }
                      },
                      displayValue: selectedTime != null
                          ? "Selected Time: ${selectedTime!.format(context)}"
                          : null,
                      onTapDisplay: _pickTime, // Allow tapping on the text to re-edit
                    ),
                    buildToggleCard(
                      "Date",
                      dateToggle,
                      (value) {
                        setState(() {
                          dateToggle = value;
                        });
                        if (value) {
                          _pickDate();
                        } else {
                          setState(() {
                            selectedDate = null;
                          });
                          
                        }
                      },
                      displayValue: selectedDate != null
                          ? "Selected Date: ${DateFormat.yMMMMd().format(selectedDate!)}"
                          : null,
                      onTapDisplay: _pickDate, // Allow tapping on the text to re-edit
                    ),
                    buildTextCard("Title:", controller: titleController),
                    buildTextCard("Message:", controller: messageController),
                    buildSimpleCard(
                      "Repeat",
                      isDropdown: true,
                      onTap: () {
                        setState(() {
                          showRepeatOptions = !showRepeatOptions;
                        });
                        if (!showRepeatOptions) {
                          setState(() {
                            selectedFrequency = "Daily";
                            repeatInterval = null;
                          });
                        }
                      },
                    ),
                    if (showRepeatOptions) ...[
                      Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: const Text("Frequency", style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: DropdownButton<String>(
                            value: selectedFrequency,
                            hint: const Text("Select Frequency"),
                            items: frequencyOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedFrequency = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: const Text("Every", style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: DropdownButton<int>(
                            value: repeatInterval,
                            hint: Text("Select ${intervalWord[selectedFrequency]}"),
                            items: frequencyInterval[selectedFrequency]?.map((int interval) {
                              return DropdownMenuItem<int>(
                                value: interval,
                                child: Text("$interval ${intervalWord[selectedFrequency]}(s)"),
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              setState(() {
                                repeatInterval = value;
                              });
                            },
                          ),
                        ),
                      ),  
                    ],
                    Center(
                    child: ElevatedButton(
                      onPressed: () async { 
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text("${NotificationService().formatDateTime(selectedDate!, selectedTime, -4)}")),
                        // )
                        // Create Notification!
                        try {
                          if (userId == null) {
                            throw MissingEntryError('Please login to use this feature!');
                          }
                          if (selectedTime == null) {
                            throw MissingEntryError('Please select a notification time!');
                          }
                          if (selectedDate == null) {
                            throw MissingEntryError('Please select a notification date!');
                          }
                          if (titleController.text.trim() == "") {
                            throw MissingEntryError('Please provide a notification title!');
                          }
                          if (messageController.text.trim() == "") {
                            throw MissingEntryError('Please provide a notification message!');
                          }
                          if (showRepeatOptions && repeatInterval == null){
                            throw MissingEntryError('Please select an interval!');
                          }

                          http.Response response = await NotificationService().createDBNotificationEntry(
                            userId: userId!, 
                            title: titleController.text.trim(), 
                            body: messageController.text.trim(), 
                            startTime: selectedTime!, 
                            startDate: selectedDate!, 
                            reminderType: "self_care", 
                            intervalType: selectedFrequency != null ? 
                                selectedFrequency!.trim().toLowerCase()
                                : "daily", 
                            interval: repeatInterval ?? 1
                          );

                          if (response.statusCode == 201) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Succesfully created reminder!')),
                            );
                          } else if (response.statusCode == 400) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You already created a reminder with the same title!')),
                            );
                          } else {
                            throw Exception('Status Code: ${response.statusCode} Message: ${response.body}');
                          }
                          
                        } catch (e) {
                            
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${e.toString()}')),
                          );
                        }
                        
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        backgroundColor: const Color.fromARGB(200, 69, 68, 121),
                      ),
                      child: const Text(
                        'Create reminder!',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  ],
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}