import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _mockUrl = 'https://api.openai.com/v1/chat/completions'; // Or your actual backend endpoint
  static const String _apiKey = 'YOUR_OPENAI_OR_CUSTOM_API_KEY'; // Replace with your API key

  /// Gets a response from AgriGPT or any AI backend.
  static Future<String> getBotResponse(String userMessage) async {
    try {
      // Example using OpenAI Chat API (can be replaced with your own backend)
      final response = await http.post(
        Uri.parse(_mockUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are AgriGPT, a helpful agriculture assistant."},
            {"role": "user", "content": userMessage},
          ],
          "temperature": 0.7
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
      // Fallback mock if request fails
      return _mockBotReply(userMessage);
    }
  }

  /// Local mock response (used for offline fallback or testing)
  static String _mockBotReply(String question) {
    final lower = question.toLowerCase();
    if (lower.contains('soil')) {
      return '🪱 For soil improvement, consider adding organic compost and testing pH levels.';
    } else if (lower.contains('pest')) {
      return '🐛 For pest control, try neem oil or introduce natural predators like ladybugs.';
    } else if (lower.contains('weather')) {
      return '🌦️ Always check local forecasts and avoid planting before expected storms.';
    } else {
      return '🌽 AgriGPT: Sorry, I didn’t fully understand that. Can you rephrase or ask about crops, soil, livestock, or weather?';
    }
  }
}
