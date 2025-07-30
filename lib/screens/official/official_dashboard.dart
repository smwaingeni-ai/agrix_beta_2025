import 'package:flutter/material.dart';

class OfficialDashboard extends StatelessWidget {
  const OfficialDashboard({super.key});

  final List<_DashboardTile> tiles = const [
    _DashboardTile(
      label: 'View Registered Farmers',
      icon: Icons.people_alt,
      route: '/farmer_directory',
    ),
    _DashboardTile(
      label: 'Subsidy Disbursement Tracker',
      icon: Icons.attach_money,
      route: '/subsidy_tracker',
    ),
    _DashboardTile(
      label: 'View Land Contracts',
      icon: Icons.article,
      route: '/contracts/list',
    ),
    _DashboardTile(
      label: 'Program Impact Reports',
      icon: Icons.analytics,
      route: '/program_tracking',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Government Official Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Official Modules',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: tiles
                      .map((tile) => _buildTile(context, tile))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                '📊 Access national agri-program insights, validate farmer activity, '
                'monitor subsidies, and support data-driven policy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
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
          foregroundColor: Colors.green[800],
          padding: const EdgeInsets.all(16),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tile.icon, size: 30),
            const SizedBox(height: 8),
            Text(
              tile.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTile {
  final String label;
  final IconData icon;
  final String route;

  const _DashboardTile({
    required this.label,
    required this.icon,
    required this.route,
  });
}
