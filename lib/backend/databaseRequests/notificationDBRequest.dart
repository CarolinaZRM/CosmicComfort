import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding
import 'package:connectivity_plus/connectivity_plus.dart';

// TODO: Should be replaced by heroku url when deploying
String baseURL = "https://cosmiccomfort-8656a323f8dc.herokuapp.com"; 
//String baseURL = "http://10.0.2.2:3000"; //for android emulator
// String baseURL = "http://127.0.0.1:3000";
// String baseURL = "http://localhost:3000";

Future<http.Response> getUserNotifications(String userId) async {
  final response = await http.get(
    Uri.parse("$baseURL/reminders/$userId")
  );
  return response;
}

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

Future<http.Response> createDBNotification(String userId, {required dynamic jsonData}) async {
  final response = await http.post(
    Uri.parse("$baseURL/reminders/"),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(jsonData),
  );
  if (response.statusCode == 201) {
    print("Created reminder!");
  } else {
    print("${response.statusCode} Failed to create reminder: ${response.body}");
  }
  return response;
}

Future<Map<String, dynamic>?> fetchNotificationPermisions(String userId) async {
    final response = await http.get(
        Uri.parse("$baseURL/account_settings/user/$userId"),
    );

  if (response.statusCode == 200) {
    // Successfully received data
    final Map<String, dynamic> data = json.decode(response.body);
    // print('Fetched data: $data');

    // print('self_care: ${data["self_care"]}, log_reminder: ${data["log_reminder"]}');
    return data;
  } else {
    // Handle error
    print('Failed to load data: ${response.statusCode}; ${response.body}');
    return null;
  } 
}