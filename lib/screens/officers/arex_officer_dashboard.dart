import 'package:flutter/material.dart';

class ArexOfficerDashboard extends StatelessWidget {
  const ArexOfficerDashboard({super.key});

  final List<_DashboardTile> dashboardTiles = const [
    _DashboardTile(icon: Icons.task_alt, label: 'Add Task', route: '/task_entry'),
    _DashboardTile(icon: Icons.agriculture, label: 'Field Assessment', route: '/field_assessment'),
    _DashboardTile(icon: Icons.school, label: 'Training Log', route: '/training_log'),
    _DashboardTile(icon: Icons.assignment_turned_in, label: 'Program Tracking', route: '/program_tracking'),
    _DashboardTile(icon: Icons.eco_outlined, label: 'Sustainability Log', route: '/sustainability_log'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AREX Officer Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AREX Officer Modules',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: dashboardTiles.map((tile) => _buildTile(context, tile)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, _DashboardTile tile) {
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, tile.route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green.shade800,
          padding: const EdgeInsets.all(16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tile.icon, size: 30),
            const SizedBox(height: 8),
            Text(tile.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          ],
        ),
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
