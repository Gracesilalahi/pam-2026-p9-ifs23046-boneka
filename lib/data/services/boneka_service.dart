import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class BonekaService {
  static Future<Map<String, dynamic>> getBonekas(int page) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.bonekas}?page=$page&per_page=10"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load boneka data");
    }
  }

  static Future<void> generateBonekas(String theme, int total) async {
    final response = await http.post(
      Uri.parse(ApiConstants.generate),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "theme": theme,
        "total": total
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to generate boneka data");
    }
  }
}