import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/loan/loan_application.dart';
import 'package:aagrix_beta_2025/services/loan/loan_application_service.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';
import 'package:intl/intl.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  List<LoanApplication> _loans = [];
  bool _loading = true;
  String? _activeFarmerId;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    try {
      final profile = await FarmerProfileService.loadActiveProfile();
      final farmerId = profile?.farmerId;
      if (farmerId == null || farmerId.isEmpty) {
        setState(() {
          _loans = [];
          _loading = false;
        });
        return;
      }

      final allLoans = await LoanApplicationService.loadLoans();
      final filtered = allLoans.where((loan) => loan.farmerId == farmerId).toList();

      setState(() {
        _loans = filtered;
        _activeFarmerId = farmerId;
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading loans: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Loan Applications')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loans.isEmpty
              ? const Center(child: Text('No loan applications found.'))
              : ListView.builder(
                  itemCount: _loans.length,
                  itemBuilder: (context, index) {
                    final loan = _loans[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.credit_score),
                        title: Text('ZMW ${loan.amount.toStringAsFixed(2)}'),
                        subtitle: Text(
                          'Status: ${loan.status}\nPurpose: ${loan.purpose}\nDuration: ${loan.durationMonths} months\nApplied: ${DateFormat.yMMMd().format(loan.applicationDate)}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
