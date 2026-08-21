import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/core/config/api_config.dart';

class AiApiService {
  Future<String> generateResponse({
    required String message,
    required String scenario,
    required String difficulty,
    required String userLevel,
    required List<Map<String, String>> conversationHistory,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/ai/conversation',
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
        'scenario': scenario,
        'difficulty': difficulty,
        'userLevel': userLevel,
        'conversationHistory': conversationHistory,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'AI request failed: ${response.statusCode}',
      );
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final responseData =
        data['data'] as Map<String, dynamic>;

    return responseData['response'] as String;
  }
}