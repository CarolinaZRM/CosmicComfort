import 'package:flutter/material.dart';

Widget buildHeader({
  required String title,
  required BuildContext context
}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context); // Go back to the previous screen
        },
      ),
      Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 48), // To balance the row
    ],
  );
}

