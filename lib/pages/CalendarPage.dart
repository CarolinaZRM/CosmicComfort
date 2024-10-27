import 'package:flutter/material.dart';
import 'MoodLogPage.dart';
import '../components/GenericComponents.dart' as components;
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key,}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  // TODO: ALL dates must be obtained from DB and formatted as such
  final Map<DateTime, Color> dateColors = {
    DateTime.utc(2024, 10, 23): Colors.blue,
    DateTime.utc(2024, 10, 29): Colors.red,
    DateTime.utc(2024, 10, 3): Colors.green,
  };

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
                //Header
                components.buildHeader(title: "Calendar", context: context),
                //------

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
                        availableCalendarFormats: const {      // Restrict formats to only month
                          CalendarFormat.month: 'Month',
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (selectedDay == _selectedDay){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodLogPage(date: selectedDay,),
                              ),
                            );
                          }
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });

                          // Call your method with the selected date
                          //_runMethodForSelectedDate(selectedDay);
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