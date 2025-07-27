import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/notifications/notification_message.dart';
import 'package:agrix_beta_2025/services/notifications/notification_service.dart';
import 'package:intl/intl.dart';

/// ✅ Displays alerts, updates, and system notifications
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationMessage> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final messages = await NotificationService.loadNotifications();
      setState(() {
        _notifications = messages;
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ Failed to load notifications: $e');
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading notifications')),
        );
      }
    }
  }

  Widget _buildNotificationCard(NotificationMessage message) {
    final dateText = DateFormat.yMMMd().format(message.date);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.green),
        title: Text(message.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.body),
            const SizedBox(height: 4),
            Text('📤 Source: ${message.source}', style: const TextStyle(fontSize: 12)),
            Text('📅 $dateText', style: const TextStyle(fontSize: 12)),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('📬 Opened: ${message.title}')),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: _loadNotifications,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _notifications.isEmpty
                ? const Center(
                    child: Text(
                      '📭 No notifications available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadNotifications,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) =>
                          _buildNotificationCard(_notifications[index]),
                    ),
                  ),
      ),
    );
  }
}
