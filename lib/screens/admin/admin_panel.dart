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

  void _viewLogs() => Navigator.pushNamed(context, '/admin/logs');
  void _manageUsers() => Navigator.pushNamed(context, '/admin/users');
  void _configureModules() => Navigator.pushNamed(context, '/admin/modules');

  Widget _buildTile(String label, IconData icon, int value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('$value', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions() {
    return Column(
      children: [
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
        const SizedBox(height: 30),
        const Text(
          '🛡️ Monitor platform-wide performance, manage users and modules, and ensure system health through logs and sync tools.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛠️ Admin Control Panel'),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Run Sync',
            onPressed: _runSync,
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Clear Cache',
            onPressed: _clearCache,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<SystemStats>(
          future: futureStats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No statistics available.'));
            }

            final stats = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildTile('Total Users', Icons.people, stats.totalUsers, Colors.blue),
                      _buildTile('Active Farmers', Icons.agriculture, stats.activeFarmers, Colors.green),
                      _buildTile('Market Items', Icons.store, stats.marketItems, Colors.orange),
                      _buildTile('Pending Loans', Icons.money, stats.pendingLoans, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildAdminActions(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
