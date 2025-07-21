import 'dart:convert';
import 'package:http/http.dart' as http;

/// ChatService handles AI-based or mock responses for AgriGPT.
class ChatService {
  // Toggle this to false to disable API call and use local mock only
  static const bool useApi = false;

  // Replace with your own backend or OpenAI endpoint if available
  static const String _mockUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _apiKey = 'YOUR_OPENAI_OR_CUSTOM_API_KEY';

  /// Gets a response from AgriGPT or falls back to offline logic
  static Future<String> getBotResponse(String userMessage) async {
    if (!useApi || _apiKey == 'YOUR_OPENAI_OR_CUSTOM_API_KEY') {
      return _mockBotReply(userMessage);
    }

    try {
      final response = await http.post(
        Uri.parse(_mockUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": "You are AgriGPT, a helpful agriculture assistant."
            },
            {"role": "user", "content": userMessage},
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content.trim();
      } else {
        return '⚠️ Server error (${response.statusCode}): Unable to fetch response.';
      }
    } catch (e) {
      return _mockBotReply(userMessage);
    }
  }

  /// Local fallback response (offline or mock use)
  static String _mockBotReply(String question) {
    final lower = question.toLowerCase();
    if (lower.contains('soil')) {
      return '🪱 For soil improvement, consider adding organic compost and testing pH levels.';
    } else if (lower.contains('pest')) {
      return '🐛 For pest control, try neem oil or introduce natural predators like ladybugs.';
    } else if (lower.contains('weather')) {
      return '🌦️ Always check local forecasts and avoid planting before expected storms.';
    } else if (lower.contains('crop')) {
      return '🌾 Consider rotating crops to maintain soil nutrients and reduce disease risk.';
    } else if (lower.contains('livestock')) {
      return '🐄 Ensure livestock have access to clean water, vaccines, and shelter.';
    } else {
      return '🌽 AgriGPT: Sorry, I didn’t fully understand that. Can you rephrase or ask about crops, soil, livestock, or weather?';
    }
  }
}
