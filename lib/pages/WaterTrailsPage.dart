import 'package:flutter/material.dart';
import '../components/GenericComponents.dart' as components;

class WaterTrailsPage extends StatefulWidget {
  const WaterTrailsPage({super.key});

  @override
  _WaterTrailsPageState createState() => _WaterTrailsPageState();
}

class _WaterTrailsPageState extends State<WaterTrailsPage> with TickerProviderStateMixin {
  final List<RipplePoint> _ripplePoints = [];

  @override
  void initState() {
    super.initState();
  }

  // Handle dragging (finger movement)
  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      // Add ripple point with an animation controller for each new point
      _ripplePoints.add(RipplePoint(
        position: details.localPosition,
        controller: AnimationController(
          vsync: this,
          duration: const Duration(seconds: 1), // Ripple lasts 1 second
        )..forward(), // Start the animation immediately
      ));
    });

    // Remove the ripple after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (_ripplePoints.isNotEmpty) {
          _ripplePoints.removeAt(0); // Safely remove the oldest ripple point
        }
      });
    });
  }

  @override
  void dispose() {
    for (var point in _ripplePoints) {
      point.controller.dispose(); // Dispose of controllers
    }
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
                image: AssetImage('assets/WaterTrailsBG.JPG'),  // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gesture detector to track finger movement
          GestureDetector(
            onPanUpdate: _handleDrag,  // Trigger ripples as the user drags
            child: CustomPaint(
              painter: RipplePainter(_ripplePoints),
              child: Container(),
            ),
          ),
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

// Class to represent the ripple point with an animation controller
class RipplePoint {
  final Offset position;
  final AnimationController controller;

  RipplePoint({required this.position, required this.controller});
}

// Custom painter to draw ripples on the canvas
class RipplePainter extends CustomPainter {
  final List<RipplePoint> ripplePoints;

  RipplePainter(this.ripplePoints);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal.shade300.withOpacity(0.8)  // Light blue color for ripples
      ..style = PaintingStyle.stroke  // Outline style for ripples
      ..strokeWidth = 1.5;  // Ripple outline thickness

    for (var point in ripplePoints) {
      // Get the current radius from the animation controller
      final radius = Tween<double>(begin: 0, end: 50).animate(CurvedAnimation(
        parent: point.controller,
        curve: Curves.easeOut, // Ease out for smooth growing effect
      ));

      // Draw multiple circles with different radii from the same point
      const List<double> rippleMultipliers = [0.25, 0.75, 1.25]; // Different size multipliers for the ripples

      for (double multiplier in rippleMultipliers) {
        // Draw circles with varying sizes based on the current animation value
        canvas.drawCircle(point.position, radius.value * multiplier, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;  // Repaint whenever ripple points are updated
  }
}
