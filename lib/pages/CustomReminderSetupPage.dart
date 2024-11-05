import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/GenericComponents.dart' as components;

class CustomReminderSetupPage extends StatefulWidget {
  const CustomReminderSetupPage({Key? key}) : super(key: key);

  @override
  State<CustomReminderSetupPage> createState() => _CustomReminderSetupPageState();
}

class _CustomReminderSetupPageState extends State<CustomReminderSetupPage> {
  bool timeToggle = false;
  bool dateToggle = false;
  bool showRepeatOptions = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? selectedDate;
  String? selectedFrequency;
  int? repeatInterval; // Interval in days for the "Every" dropdown

  // Frequency options
  final List<String> frequencyOptions = ["Hourly", "Daily", "Weekly", "Monthly", "Annually"];
  // Interval options for "Every" dropdown
  final List<int> intervalOptions = List<int>.generate(31, (index) => index + 1); // 1 to 31 days

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
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
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
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      }
                    },
                    displayValue: "Selected Time: ${selectedTime.format(context)}",
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
                      }
                    },
                    displayValue: selectedDate != null
                        ? "Selected Date: ${DateFormat.yMMMMd().format(selectedDate!)}"
                        : null,
                    onTapDisplay: _pickDate, // Allow tapping on the text to re-edit
                  ),
                  buildSimpleCard(
                    "Repeat",
                    isDropdown: true,
                    onTap: () {
                      setState(() {
                        showRepeatOptions = !showRepeatOptions;
                      });
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
                          hint: const Text("Select Days"),
                          items: intervalOptions.map((int days) {
                            return DropdownMenuItem<int>(
                              value: days,
                              child: Text("$days days"),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}