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

  final Map<DateTime, Color> dateColors = {}; // Dynamic date-color map

  @override
  void initState() {
    super.initState();
    fetchSettingsFromDB(); // Fetch initial calendar data from the database
  }

  void setGlobalCalendar(Map<String, dynamic>? newCalendar) {
    globalCalendar = newCalendar;
  }

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

  Future<void> fetchSettingsFromDB() async {
    try {
      final userID = await getUserIdFromToken();
      if (userID == null) {
        _showError("User ID not found. Please log in again.");
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/calendar/user/$userID'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          // globalCalendar = data;
          setGlobalCalendar(data);
          populateDateColors(data); // Update dateColors with server data
        });
      } else {
        throw Exception('Failed to fetch calendar: ${response.statusCode}');
      }
    } catch (e) {
      _showError("Failed to load calendar data. Please try again.");
      print('Error fetching calendar: $e');
    }
    // print(globalCalendar);
  }

  void populateDateColors(Map<String, dynamic> data) async {
    if (data.containsKey('date_colors')) {
      final fetchedColors = data['date_colors'] as List;

      fetchedColors.forEach((entry) {
        final date = DateTime.parse(entry['date']);
        final colorString = entry['color'] as String;

        final colorValue = int.parse(colorString.replaceFirst('#', ''), radix: 16);
        dateColors[date] = Color(0xFF000000 | colorValue); // Ensure alpha channel is set
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white))),
    );
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
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        focusedDay: _focusedDay,
                        calendarFormat: CalendarFormat.month,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          if (selectedDay != _selectedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodLogPage(date: selectedDay),
                              ),
                            ).then((_) {
                              // Refetch data when returning from MoodLogPage
                              print('refetching');
                              Future.delayed(const Duration(seconds: 3), () {
                                fetchSettingsFromDB();
                              });
                            });
                          }
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final color = dateColors[day];
                            return color != null
                                ? Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color,
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