import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/tasks/task_model.dart'; // Ensure OfficerTask is correctly defined

class OfficerTasksScreen extends StatefulWidget {
  const OfficerTasksScreen({super.key});

  @override
  State<OfficerTasksScreen> createState() => _OfficerTasksScreenState();
}

class _OfficerTasksScreenState extends State<OfficerTasksScreen> {
  final List<OfficerTask> _tasks = [
    OfficerTask(
      title: '🧪 Inspect Field in Region A',
      description: 'Check maize crop progress and pest control.',
      status: 'Pending',
    ),
    OfficerTask(
      title: '🐄 Monitor Livestock Health',
      description: 'Review cattle health reports from Farm B.',
      status: 'In Progress',
    ),
    OfficerTask(
      title: '📦 Verify Input Distribution',
      description: 'Ensure fertilizer delivery was completed.',
      status: 'Completed',
    ),
  ];

  void _markTaskAsCompleted(int index) {
    setState(() => _tasks[index].status = 'Completed');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ "${_tasks[index].title}" marked as completed.'),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle_outline;
      case 'In Progress':
        return Icons.timelapse;
      default:
        return Icons.pending_actions;
    }
  }

  Widget _buildTaskTile(int index) {
    final task = _tasks[index];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(_statusIcon(task.status), color: _statusColor(task.status), size: 30),
        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(task.description),
            const SizedBox(height: 6),
            Text(
              'Status: ${task.status}',
              style: TextStyle(
                color: _statusColor(task.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: task.status != 'Completed' ? () => _markTaskAsCompleted(index) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🗂 Officer Task Log'),
        centerTitle: true,
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                '🎉 No tasks available.\nYou are all caught up!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) => _buildTaskTile(index),
            ),
    );
  }
}
