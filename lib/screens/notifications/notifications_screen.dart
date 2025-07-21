import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/notifications/notification_message.dart';
import 'package:agrix_beta_2025/services/notifications/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationMessage> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final messages = await NotificationService.loadNotifications();
    setState(() => _notifications = messages);
  }

  Widget _buildNotificationCard(NotificationMessage message) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(Icons.notifications_active, color: Colors.green),
        title: Text(message.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.body),
            const SizedBox(height: 4),
            Text('📤 Source: ${message.source}'),
            Text('📅 ${message.date.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("📬 Opened: ${message.title}")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔔 Notifications'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _notifications.isEmpty
            ? const Center(
                child: Text(
                  'No notifications available.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) =>
                    _buildNotificationCard(_notifications[index]),
              ),
      ),
    );
  }
}
