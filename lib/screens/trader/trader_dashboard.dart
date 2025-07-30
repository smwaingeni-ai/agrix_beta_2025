import 'package:flutter/material.dart';

class TraderDashboard extends StatelessWidget {
  const TraderDashboard({super.key});

  final List<_DashboardTile> dashboardTiles = const [
    _DashboardTile(
      icon: Icons.storefront,
      label: 'View Market Listings',
      route: '/market',
    ),
    _DashboardTile(
      icon: Icons.add_box,
      label: 'Post New Product',
      route: '/market/add',
    ),
    _DashboardTile(
      icon: Icons.history,
      label: 'Transaction Log',
      route: '/transactions',
    ),
    _DashboardTile(
      icon: Icons.chat,
      label: 'Inquiries & Chat',
      route: '/chat',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Trader Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trader Modules',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: dashboardTiles
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
                '📦 Manage inventory, connect with buyers, track sales,\nand grow your agri-trade footprint.',
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
  final IconData icon;
  final String label;
  final String route;

  const _DashboardTile({
    required this.icon,
    required this.label,
    required this.route,
  });
}
