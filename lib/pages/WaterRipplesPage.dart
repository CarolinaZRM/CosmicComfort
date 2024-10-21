import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class WaterRipplesPage extends StatefulWidget {
  const WaterRipplesPage({super.key});

  @override
  _WaterRipplesPageState createState() => _WaterRipplesPageState();
}

class _WaterRipplesPageState extends State<WaterRipplesPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset? _tapPosition;
  bool _showRipple = false; // Whether to show the ripple effect
  late Animation<double> _rippleAnimation; // The ripple animation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Listen for user's tap
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showRipple = false;
        });
      }
    });
  }

  // Store tap position
  void _handleTap(TapUpDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
      _showRipple = true;
    });

    // Start the ripple animation
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                image: AssetImage('assets/WaterRipplesBG.JPG'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Ripple Effect - Only on a specific area
          GestureDetector(
            onTapUp: (details) {
              // Check if tap is outside of header area
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              Offset localOffset = renderBox.globalToLocal(details.globalPosition);
              
              // Define the header height (so that the back arrow is enabled & the ripples
              // don't get activated in that area). This edits the height of that "no-ripple"
              // area at the top of the screen
              double headerHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

              if (localOffset.dy > headerHeight) {
                _handleTap(details);
              }
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: RipplePainter(_controller.value, _tapPosition),
                  child: Container(), // Fills the screen to capture taps
                );
              },
            ),
          ),
          // Foreground content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                components.buildHeader(title: "Water Ripples", context: context),
                //------
                const SizedBox(height: 40), // Space below the title
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// This class is what draws the ripple effect
class RipplePainter extends CustomPainter {
  final double rippleRadius;
  final Offset? tapPosition;

  RipplePainter(this.rippleRadius, this.tapPosition);

  @override
  void paint(Canvas canvas, Size size) {
    if (tapPosition == null) return;

    final paint = Paint()
      ..color = const Color.fromARGB(255, 155, 191, 220).withOpacity(1 - rippleRadius)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final radius = rippleRadius * 150;
    // Draw 3 circles to ensure a better water ripple effect. 
    // You substract from radius in order to decrease the circle size.
    canvas.drawCircle(tapPosition!, radius, paint);
    canvas.drawCircle(tapPosition!, radius - 20, paint);
    canvas.drawCircle(tapPosition!, radius - 60, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}