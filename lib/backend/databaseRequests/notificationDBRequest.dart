import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding
import 'package:connectivity_plus/connectivity_plus.dart';

// TODO: Should be replaced by heroku url when deploying
//String baseURL = "https://cosmiccomfort-8656a323f8dc.herokuapp.com"; //for android emulator
String baseURL = "http://10.0.2.2:3000";
// String baseURL = "http://127.0.0.1:3000";
// String baseURL = "http://localhost:3000";

// Internet connectivity (Should be more general)
Future<void> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    print('Connected to the internet');
  } else {
    print('No internet connection');
  }
}

// TODO: implement to save reminders on db
// Future<void> sendData() async {
//   final response = await http.post(
//     Uri.parse('https://jsonplaceholder.typicode.com/posts'),
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode({
//       'title': 'Flutter HTTP',
//       'body': 'Learning how to make HTTP requests in Flutter.',
//       'userId': 1,
//     }),
//   );

//   if (response.statusCode == 201) {
//     // Successfully created resource
//     print('Response: ${response.body}');
//   } else {
//     // Handle error
//     print('Failed to post data: ${response.statusCode}');
//   }
// }

// TODO: implement to update notifications
// Future<void> updateData(int id) async {
//   final response = await http.put(
//     Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode({
//       'title': 'Updated Title',
//       'body': 'Updated body content.',
//       'userId': 1,
//     }),
//   );

//   if (response.statusCode == 200) {
//     print('Updated data: ${response.body}');
//   } else {
//     print('Failed to update data: ${response.statusCode}');
//   }
// }



Future<void> updateNotificationSettings(String userId, {bool? selfCarePerm, bool? logReminderPerm}) async {
  dynamic jsonBody = {
      "theme": "light",
      "font_size": 20,
  };
  if (selfCarePerm != null) { jsonBody["self_care"] = selfCarePerm; }
  if (logReminderPerm != null) { jsonBody["log_reminder"] = logReminderPerm; }  
  
  final response = await http.put(
    Uri.parse("$baseURL/account_settings/user/$userId"),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(jsonBody),
  );
  if (response.statusCode == 200) {
    print("Updated user permissions!");
  } else {
    print("Failed to update user permisions");
  }
}

Future<Map<String, dynamic>?> fetchNotificationPermisions(String userId) async {
    final response = await http.get(
        Uri.parse("$baseURL/account_settings/user/$userId"),
    );

  if (response.statusCode == 200) {
    // Successfully received data
    final Map<String, dynamic> data = json.decode(response.body);
    print('Fetched data: $data');

    print('self_care: ${data["self_care"]}, log_reminder: ${data["log_reminder"]}');
    return data;
  } else {
    // Handle error
    print('Failed to load data: ${response.statusCode}; ${response.body}');
    return null;
  } 
}