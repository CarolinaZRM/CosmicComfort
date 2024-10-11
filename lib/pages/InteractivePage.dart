import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;
// Separate pages for interactive modes
import 'WaterRipplesPage.dart';
import 'WaterTrailsPage.dart';
import 'VibrationsPage.dart';
import 'PopItsPage.dart';

class InteractivePage extends StatelessWidget {
  const InteractivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'),
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
                components.buildHeader(title: "Interactive", context: context),
                //------

                const SizedBox(height: 40), // Space below the title

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: [
                        buildInteractiveModeCard(
                          icon: Icons.ads_click_outlined,
                          title: "Water Ripples",
                          context: context,
                          page: const WaterRipplesPage()
                        ),
                        buildInteractiveModeCard(
                          icon: Icons.water_drop,
                          title: "Water Trails",
                          context: context,
                          page: const WaterTrailsPage()
                        ),
                        buildInteractiveModeCard(
                          icon: Icons.vibration,
                          title: "Vibrations",context: context,
                          page: const VibrationsPage()
                        ),
                        buildInteractiveModeCard(
                          icon: Icons.catching_pokemon,
                          title: "Pop Its",context: context,
                          page: const PopItsPage()
                        )
                      ],
                    )
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Method for Interactive Mode cards builder
  Widget buildInteractiveModeCard({
    required IconData icon,
    required String title,
    required BuildContext context,
    required Widget page, // New page parameter
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 92, 50, 129)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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