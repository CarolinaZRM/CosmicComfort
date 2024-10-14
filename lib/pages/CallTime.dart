import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class CallTimePage extends StatelessWidget {
  const CallTimePage({super.key});

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
                components.buildHeader(title: "Time", context: context),
                //------

                const SizedBox(height: 40), // Space below the title
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: [
                    
                        const Text(
                          "Select the time it will take for you to receive the call.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        buildSettingsCard(
                          title: "10 seconds",context: context,
                        ),
                        buildSettingsCard(
                          title: "30 seconds",context: context,
                        ),
                        buildSettingsCard(
                          title: "1 minute",context: context,
                        ),
                        buildSettingsCard(
                          title: "3 minutes",context: context,
                        ),
                        buildSettingsCard(
                          title: "5 minutes",context: context,
                        ),
                      ],
                    )
                    )
                )

              ],
            ),
          )
        ],
      ),
    );
  }

  //  TODO: refactor this method to make sure the setting chosen is saved
  // THIS IS A PLACEHOLDER
  Widget buildSettingsCard({
    //required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        //leading: Icon(icon, color: const Color.fromARGB(255, 92, 50, 129)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          // Take to corresponding page
          

        },
      ),
    );
  }

}