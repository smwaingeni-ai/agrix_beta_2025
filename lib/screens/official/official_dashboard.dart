import 'package:flutter/material.dart';

class OfficialDashboard extends StatelessWidget {
  const OfficialDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Government Official Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.people_alt),
              label: const Text('View Registered Farmers'),
              onPressed: () {
                Navigator.pushNamed(context, '/farmer_directory');
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_money),
              label: const Text('Subsidy Disbursement Tracker'),
              onPressed: () {
                Navigator.pushNamed(context, '/subsidy_tracker');
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.article),
              label: const Text('View Land Contracts'),
              onPressed: () {
                Navigator.pushNamed(context, '/contracts/list');
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.analytics),
              label: const Text('View Program Impact Reports'),
              onPressed: () {
                Navigator.pushNamed(context, '/program_tracking');
              },
            ),
            const SizedBox(height: 30),
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
