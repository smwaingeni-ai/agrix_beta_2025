// lib/screens/admin/admin_panel.dart
import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/admin/system_stats.dart';
import 'package:agrix_beta_2025/services/admin/admin_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late Future<SystemStats> futureStats;

  @override
  void initState() {
    super.initState();
    futureStats = AdminService.getSystemStats();
  }

  void _runSync() async {
    await AdminService.runSystemSync();
    setState(() {
      futureStats = AdminService.getSystemStats();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ System sync complete')),
    );
  }

  void _clearCache() {
    AdminService.clearSystemCache();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🧹 System cache cleared')),
    );
  }

  void _viewLogs() {
    Navigator.pushNamed(context, '/admin/logs');
  }

  void _manageUsers() {
    Navigator.pushNamed(context, '/admin/users');
  }

  void _configureModules() {
    Navigator.pushNamed(context, '/admin/modules');
  }

  Widget _buildTile(String label, IconData icon, int value, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('$value', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛠️ Admin Control Panel'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _runSync,
            tooltip: 'Run System Sync',
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clearCache,
            tooltip: 'Clear Cache',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<SystemStats>(
          future: futureStats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final stats = snapshot.data!;
              return Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildTile('Total Users', Icons.people, stats.totalUsers, Colors.blue),
                      _buildTile('Active Farmers', Icons.agriculture, stats.activeFarmers, Colors.green),
                      _buildTile('Market Items', Icons.store, stats.marketItems, Colors.orange),
                      _buildTile('Pending Loans', Icons.money, stats.pendingLoans, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _manageUsers,
                    icon: const Icon(Icons.supervised_user_circle),
                    label: const Text('Manage Users'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _configureModules,
                    icon: const Icon(Icons.settings_applications),
                    label: const Text('Module Configurations'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _viewLogs,
                    icon: const Icon(Icons.list_alt),
                    label: const Text('System Logs'),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No stats available.'));
            }
          },
        ),
      ),
    );
  }
}
