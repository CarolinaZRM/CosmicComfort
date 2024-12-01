import 'package:flutter/material.dart';
import 'MoodLogPage.dart';
import 'dart:convert';
import '../components/GenericComponents.dart' as components;
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic>? globalCalendar; // Global variable

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  final Map<DateTime, Color> dateColors = {}; // Updated to start empty and populate dynamically

  @override
  void initState() {
    super.initState();
    fetchSettingsFromDB(); // Fetch initial calendar data from the database
  }

  Future<String?> getUserIdFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        return null;
      }

      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['id'];
    } catch (e) {
      return null;
    }
  }

  // Function to fetch calendar data from the database
  Future<void> fetchSettingsFromDB() async {
    try {
      final userID = await getUserIdFromToken();
      if (userID == null) {
        print('No user ID found in token.');
        return;
      }
      final response = await http.get(
        Uri.parse('http://localhost:3000/calendar/user/$userID'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        globalCalendar = data;

        setState(() {
          populateDateColors(data); // Update `dateColors` with data from the server
        });
      } else {
        throw Exception('Failed to fetch calendar: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching calendar: $e');
    }
  }

  // Function to populate dateColors from fetched data
  void populateDateColors(Map<String, dynamic> data) {
    if (data.containsKey('dateColors')) {
      final fetchedColors = data['dateColors'] as List;

      // Convert server data into the `dateColors` map
      for (var entry in fetchedColors) {
        final date = DateTime.parse(entry['date']);
        final colorString = entry['color'] as String;
        
        // Remove the # prefix before parsing
        final colorValue = int.parse(colorString.replaceFirst('#', ''), radix: 16);
        dateColors[date] = Color(0xFF000000 | colorValue); // Ensure the alpha channel is set
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Calendar_MoodLogBG.JPG'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                components.buildHeader(title: "Calendar", context: context),
                const SizedBox(height: 80), // Space below the title

                // Calendar with rounded corners and white background
                Padding(
                  padding: const EdgeInsets.all(8.0), // Add some padding around the calendar
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(20), // Same radius as ClipRRect
                      ),
                      child: TableCalendar(
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        focusedDay: _focusedDay,
                        calendarFormat: CalendarFormat.month,
                        availableCalendarFormats: const { // Restrict formats to only month
                          CalendarFormat.month: 'Month',
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (selectedDay == _selectedDay) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodLogPage(date: selectedDay),
                              ),
                            );
                          }
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        calendarBuilders: CalendarBuilders(
                          // Builder for default day cells with conditional coloring
                          defaultBuilder: (context, day, focusedDay) {
                            final color = dateColors[day];
                            return color != null
                                ? Container(
                                    margin: const EdgeInsets.all(6), // Align to default circle's margins
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color, // Apply specific color
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${day.day}',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Colors.white,
                                            fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 1) * 1.15,
                                          ),
                                    ),
                                  )
                                : null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}