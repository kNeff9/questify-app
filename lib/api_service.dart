import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.12.133:5000";

  static Future<void> addTask(String title, String? description, double? lat, double? lon) async {

    final url = Uri.parse("$baseUrl/tasks");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "description": description,
        "latitude" : lat,
        "longitude" : lon,
        "title" : title
      })
      );
    
    if (response.statusCode != 200) {
      throw Exception("Failed to add task");
    }
  }



  static Future<List<String>> fetchTasks() async {

    
    final url = Uri.parse("$baseUrl/tasks");
    
    final response = await http.get(url).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> tasks = jsonDecode(response.body);
      return tasks.map<String>((task) => task['title'] as String).toList();
    } else {
      throw Exception("Failed to Fetch Tasks");
    }

  }
}