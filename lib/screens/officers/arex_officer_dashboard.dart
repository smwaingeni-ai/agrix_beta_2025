import 'package:flutter/material.dart';

class ArexOfficerDashboard extends StatelessWidget {
  const ArexOfficerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardTiles = [
      {
        'icon': Icons.task_alt,
        'label': 'Add Task',
        'route': '/task_entry',
      },
      {
        'icon': Icons.agriculture,
        'label': 'Field Assessment',
        'route': '/field_assessment',
      },
      {
        'icon': Icons.school,
        'label': 'Training Log',
        'route': '/training_log',
      },
      {
        'icon': Icons.assignment_turned_in,
        'label': 'Program Tracking',
        'route': '/program_tracking',
      },
      {
        'icon': Icons.eco_outlined,
        'label': 'Sustainability Log',
        'route': '/sustainability_log',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AREX Officer Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dashboardTiles.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = dashboardTiles[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                item['icon'] as IconData,
                color: Colors.green.shade800,
              ),
              title: Text(
                item['label'] as String,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                final route = item['route'] as String?;
                if (route != null) {
                  Navigator.pushNamed(context, route);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
