import 'package:flutter/material.dart';
import 'MoodLogPage.dart';
import '../components/GenericComponents.dart' as components;

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

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

                const SizedBox(height: 40), // Space below the title
                

                components.buildPageRedirectCard(
                  icon: Icons.catching_pokemon,
                  title: "Placeholder that will lead to mood log page",
                  context: context,
                  page: const MoodLogPage()
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}