import 'package:flutter/material.dart';

class TraderDashboard extends StatelessWidget {
  const TraderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Trader Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.storefront),
              label: const Text('View Market Listings'),
              onPressed: () => Navigator.pushNamed(context, '/market'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_box),
              label: const Text('Post New Product/Listing'),
              onPressed: () => Navigator.pushNamed(context, '/market/add'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('View Transaction Log'),
              onPressed: () => Navigator.pushNamed(context, '/transactions'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.chat),
              label: const Text('Trader Inquiries & Chats'),
              onPressed: () => Navigator.pushNamed(context, '/chat'),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            const Text(
              '📦 Manage inventory, connect with buyers, track sales, and grow your agri-trade footprint.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
