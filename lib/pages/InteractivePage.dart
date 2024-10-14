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
                        // cards that redirect user to different page
                        components.buildPageRedirectCard(
                          icon: Icons.ads_click_outlined,
                          title: "Water Ripples",
                          context: context,
                          page: const WaterRipplesPage() 
                        ),

                        components.buildPageRedirectCard(
                          icon: Icons.water_drop,
                          title: "Water Trails",
                          context: context,
                          page: const WaterTrailsPage()
                        ),

                        components.buildPageRedirectCard(
                          icon: Icons.vibration,
                          title: "Vibrations",
                          context: context,
                          page: const VibrationsPage()
                        ),

                        components.buildPageRedirectCard(
                          icon: Icons.catching_pokemon,
                          title: "Pop Its",
                          context: context,
                          page: const PopItsPage()
                        ),
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
