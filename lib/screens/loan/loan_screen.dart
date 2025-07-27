import 'package:flutter/material.dart';
import 'loan_application_screen.dart';
import 'loan_list_screen.dart';

class LoanScreen extends StatelessWidget {
  const LoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💼 Loan Services'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Loan Services',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Apply for a loan using your registered farm profile. Ensure your data is complete for accurate scoring.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 40),

            // Apply for Loan
            ElevatedButton.icon(
              icon: const Icon(Icons.app_registration),
              label: const Text('Apply for Loan'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoanApplicationScreen()),
                );
              },
            ),
            const SizedBox(height: 20),

            // View Loan Applications
            OutlinedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('View My Applications'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoanListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
