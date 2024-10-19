import 'package:flutter/material.dart';

class BreathingPage extends StatelessWidget {
  const BreathingPage({super.key});

  // Example breathing exercise text
  final String lengthenExhale = '''
Exhaling is linked to the parasympathetic nervous system, which influences our body's ability to relax and calm down. You can follow this technique from any position that's comfortable for you, including sitting, standing, or laying down.

  1. Before you take a big, deep breath, try a thorough exhale instead. Push all the air out of your lungs, then simply let your lungs do their work inhaling air.

  2. Next, try spending a little bit longer exhaling than you do inhaling. For example, try inhaling for four seconds, then exhale for six.

  3. Try doing this for two to five minutes.
  ''';

  final String breathFocus = '''
When deep breathing is focused and slow, it can help reduce anxiety. You can do this technique by sitting or lying down in a quiet, comfortable location. Then:

  1. Notice how it feels when you inhale and exhale normally. Mentally scan your body. You might feel tension in your body that you never noticed.

  2. Take a slow, deep breath through your nose.

  3. Notice your belly and upper body expanding.

  4. Exhale in whatever way is most comfortable for you, sighing if you wish.

  5. Do this for several minutes, paying attention to the rise and fall of your belly.

  6. Choose a word to focus on and vocalize during your exhale. Words like “safe” and “calm” can be effective.

  7. Imagine your inhale washing over you like a gentle wave.

  8. Imagine your exhale carrying negative and upsetting thoughts and energy away from you.

  9. When you get distracted, gently bring your attention back to your breath and your words.
  ''';

  final String equalBreathing = '''
You can practice this exercise from a sitting or lying-down position. For this exercise, you'll be inhaling for the same amount of time as you'll be exhaling:

  1. Shut your eyes and pay attention to the way you normally breathe for several breaths.

  2. Then, slowly count 1-2-3-4 as you inhale through your nose.

  3. Exhale for the same four-second count.

  4. As you inhale and exhale, be mindful of the feelings of fullness and emptiness in your lungs.
''';

  final String breathing478 = '''
If you're having trouble sleeping, try this exercise:

  1. Start by sitting with your back straight.

  2. Place the tip of your tongue on the tissue just behind your upper front teeth. Keep your tongue there throughout the exercise.

  3. Breathe out through your mouth.

  4. Close your mouth. Breathe in through your nose while counting to 4.

  5. Hold your breath and count to 7.

  6. Breathe out through your mouth and 
  count to 8.
''';

  final String lionBreath = '''
  Lion's breath involves exhaling forcefully. To try lion's breath:

    1. Get into a kneeling position, crossing your ankles and resting your bottom on your feet. If this position isn't comfortable, sit cross-legged.

    2. Bring your hands to your knees, stretching out your arms and your fingers.

    3. Take a breath in through your nose.

    4. Breathe out through your mouth, allowing yourself to vocalize “ha.”

    5. During exhale, open your mouth as wide as you can and stick your tongue out, stretching it down toward your chin as far as it will go.

    6. Focus on the middle of your forehead (third eye) or the end of your nose while exhaling.

    7. Relax your face as you inhale again.

    8. Repeat the practice up to six times, changing the cross of your ankles when you reach the halfway point.
  ''';

  final String boxBreathing = '''
  1. To begin, expel all of the air from your chest. 

  2. Keep your lungs empty for a four-count hold. 

  3. Then, inhale through the nose for four counts. 

  4. Hold the air in your lungs for a four-count hold. 

  5. When you hold your breath, do not clamp down and create back pressure. Rather, maintain an open, neutral feeling even though you are not inhaling. 

  6. When ready, release the hold and exhale smoothly through your nose for four counts. This is one circuit of the box-breathing practice.

  7. Repeat this cycle for at least five minutes to get the full effect.  
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Text(
          'Breathing Exercises',
          style: TextStyle(
            color: Colors.white, // Title text color set to white
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      extendBodyBehindAppBar: true, // Let body extend behind AppBar
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Ombre.PNG'), // Replace with your image path
                fit: BoxFit.cover, // Make sure the image covers the entire background
              ),
            ),
          ),

          // Scrollable content
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 20.0), // Adjust padding to prevent overlap with the AppBar
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Dropdown for Breathing Instructions
                  buildTextDropdown(
                    context,
                    icon: Icons.air,
                    label: 'Lengthen Exhale',
                    dropdownText: lengthenExhale,
                  ),

                  const SizedBox(height: 20),

                  // Dropdown for Benefits of Deep Breathing
                  buildTextDropdown(
                    context,
                    icon: Icons.accessibility_new,
                    label: 'Breath Focus',
                    dropdownText: breathFocus,
                  ),

                  const SizedBox(height: 20),

                  // Dropdown for Benefits of Deep Breathing
                  buildTextDropdown(
                    context,
                    icon: Icons.view_stream_rounded,
                    label: 'Equal Breathing',
                    dropdownText: equalBreathing,
                  ),

                  const SizedBox(height: 20),

                  // Dropdown for Benefits of Deep Breathing
                  buildTextDropdown(
                    context,
                    icon: Icons.numbers_sharp,
                    label: '4-7-8 Breathing for Sleep',
                    dropdownText: breathing478,
                  ),

                  const SizedBox(height: 20),

                  // Dropdown for Benefits of Deep Breathing
                  buildTextDropdown(
                    context,
                    icon: Icons.pets_outlined,
                    label: "Lion's Breath",
                    dropdownText: lionBreath,
                  ),

                  const SizedBox(height: 20),

                  // Dropdown for Benefits of Deep Breathing
                  buildTextDropdown(
                    context,
                    icon: Icons.square_rounded,
                    label: "Box Breathing",
                    dropdownText: boxBreathing,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable method to build text-only dropdowns
  Widget buildTextDropdown(BuildContext context, {
    required IconData icon,
    required String label,
    required String dropdownText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0), // Adjusted padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Add some transparency to the container
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ExpansionTile(
              leading: Icon(icon, color: Colors.black), // Icon customization
              tilePadding: const EdgeInsets.symmetric(horizontal: 10), // Adjusted padding
              title: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 17
                ),
              ),
              trailing: const Icon(Icons.arrow_drop_down, color: Colors.black),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0), // Adjusted padding for expanded content
                  child: SingleChildScrollView(
                    child: Text(
                      dropdownText,
                      style: const TextStyle(color: Colors.black87, fontSize: 15), // Consistent text style
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}