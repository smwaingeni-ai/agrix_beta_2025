import 'package:flutter/material.dart';

class OfficialDashboard extends StatelessWidget {
  const OfficialDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'label': 'View Registered Farmers',
        'icon': Icons.people_alt,
        'route': '/farmer_directory',
      },
      {
        'label': 'Subsidy Disbursement Tracker',
        'icon': Icons.attach_money,
        'route': '/subsidy_tracker',
      },
      {
        'label': 'View Land Contracts',
        'icon': Icons.article,
        'route': '/contracts/list',
      },
      {
        'label': 'View Program Impact Reports',
        'icon': Icons.analytics,
        'route': '/program_tracking',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Government Official Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: actions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = actions[index];
                  return ElevatedButton.icon(
                    icon: Icon(item['icon']),
                    label: Text(item['label']),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, item['route']);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            const Text(
              '📊 Access national agri-program insights, validate farmer activity, monitor subsidies, and support data-driven policy.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
