import 'package:flutter/material.dart';

class ArexOfficerDashboard extends StatelessWidget {
  const ArexOfficerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardTile> dashboardTiles = [
      _DashboardTile(
        icon: Icons.task_alt,
        label: 'Add Task',
        route: '/task_entry',
      ),
      _DashboardTile(
        icon: Icons.agriculture,
        label: 'Field Assessment',
        route: '/field_assessment',
      ),
      _DashboardTile(
        icon: Icons.school,
        label: 'Training Log',
        route: '/training_log',
      ),
      _DashboardTile(
        icon: Icons.assignment_turned_in,
        label: 'Program Tracking',
        route: '/program_tracking',
      ),
      _DashboardTile(
        icon: Icons.eco_outlined,
        label: 'Sustainability Log',
        route: '/sustainability_log',
      ),
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
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final tile = dashboardTiles[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(tile.icon, color: Colors.green.shade800),
              title: Text(
                tile.label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, tile.route),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardTile {
  final IconData icon;
  final String label;
  final String route;

  const _DashboardTile({
    required this.icon,
    required this.label,
    required this.route,
  });
}
