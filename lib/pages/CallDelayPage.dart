import 'dart:async';
import 'package:flutter/material.dart';
import 'AndroidCallPage.dart';
//import '../components/GenericComponents.dart' as components;
class CallDelayPage extends StatefulWidget {
  const CallDelayPage({Key? key, this.contactName, this.time}) : super(key: key);
  final String? contactName;
  final int? time;
  @override
  State<CallDelayPage> createState() => _CallDelayPageState();
}

class _CallDelayPageState extends State<CallDelayPage> {
  int timeElapsed = 0; // Store the time elapsed for the call (in seconds)
  int timeLimit = 0;
  String contact = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startCallTimer();
    contact = widget.contactName ?? "Unkown Caller";
    timeLimit = widget.time ?? 0;
    
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to start the timer for the call duration
  void startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeElapsed += 1;
        if(timeElapsed == timeLimit){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AndroidCallPage(contactName: contact, waited: true),
            ),
          );
        }
        
      });
    });
  }

  
  // Format time into hh:mm:ss or mm:ss
  String formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600; // Total hours
    final minutes = (totalSeconds % 3600) ~/ 60; // Remaining minutes
    final seconds = totalSeconds % 60; // Remaining seconds

    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
          ),

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
              
          //     Padding(
          //       padding: const EdgeInsets.only(top: 100.0),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
                    
          //           components.buildHeader(context: context, title: "Wait"),
                    
          //           Text(
          //             formatTime(timeElapsed),
          //             style: const TextStyle(
          //               fontSize: 24,
          //               color: Colors.white70,
          //             ),
          //           ),

          //         ]
          //       )
          //     )
          //   ]
          // ),

        ],
      ),
    );
  }
}
