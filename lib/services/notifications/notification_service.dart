import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agrix_beta_2025/models/notifications/notification_message.dart';

/// 🔔 Service to manage local notifications using SharedPreferences.
class NotificationService {
  static const String _key = 'notifications';

  /// 🔹 Load all saved notifications
  static Future<List<NotificationMessage>> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    return jsonList.map((json) {
      try {
        return NotificationMessage.fromJson(jsonDecode(json));
      } catch (e) {
        print('❌ Error decoding notification: $e');
        return NotificationMessage.empty(); // fallback in case of corruption
      }
    }).where((n) => n.title.isNotEmpty).toList(); // exclude invalids
  }

  /// 🔹 Save a new notification
  static Future<void> saveNotification(NotificationMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await loadNotifications();

    notifications.add(message);
    final jsonList = notifications.map((n) => jsonEncode(n.toJson())).toList();

    await prefs.setStringList(_key, jsonList);
  }

  /// 🔹 Delete a specific notification by ID
  static Future<void> deleteNotification(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await loadNotifications();

    final updated = notifications.where((n) => n.id != id).toList();
    final jsonList = updated.map((n) => jsonEncode(n.toJson())).toList();

    await prefs.setStringList(_key, jsonList);
  }

  /// 🔹 Clear all saved notifications
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
