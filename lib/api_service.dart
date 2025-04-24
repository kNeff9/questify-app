import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = ...

  static Future<void> addTask(String title, String? description, double? lat, double? lon) async {

    final url = Uri.parse("$baseUrl/tasks");
    final repsonse = await http.post(
      url,
      headers: {"Content-Type": "application.json"},
      body: jsonEncode({
        "title": title,
        'description': description,
        'latitude': lat,
        'longitude': lon
      })
      );
  }

  static Future<void> fetchTasks() async {
    final url = Uri.parse("$baseUrl/tasks");
    final response = await http.get(url);


  }
}