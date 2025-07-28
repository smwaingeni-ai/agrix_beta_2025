import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agrix_beta_2025/models/investments/investor_profile.dart';
import 'package:agrix_beta_2025/services/investments/cloud_investor_service.dart';
import 'package:agrix_beta_2025/screens/investments/investor_registration_screen.dart';
import 'package:agrix_beta_2025/models/investments/investor_status.dart';
import 'package:agrix_beta_2025/models/investments/investment_horizon.dart';

class InvestorListScreen extends StatefulWidget {
  const InvestorListScreen({super.key});

  @override
  State<InvestorListScreen> createState() => _InvestorListScreenState();
}

class _InvestorListScreenState extends State<InvestorListScreen> {
  List<InvestorProfile> _allInvestors = [];
  List<InvestorProfile> _filteredInvestors = [];
  bool _loading = true;
  bool _error = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInvestors();
  }

  Future<void> _loadInvestors() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    try {
      final data = await CloudInvestorService().loadInvestors(); // ✅ FIXED
      setState(() {
        _allInvestors = data;
        _applySearch();
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading investors: $e');
      setState(() {
        _allInvestors = [];
        _filteredInvestors = [];
        _loading = false;
        _error = true;
      });
    }
  }

  void _applySearch() {
    final query = _searchQuery.toLowerCase();
    setState(() {
      _filteredInvestors = _allInvestors.where((inv) {
        return inv.name.toLowerCase().contains(query) ||
            inv.location.toLowerCase().contains(query) ||
            inv.status.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _launchContact(String method, String contact) async {
    String url = switch (method) {
      'Call' => 'tel:$contact',
      'Message' => 'sms:$contact',
      'Email' => 'mailto:$contact',
      _ => ''
    };

    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Could not launch $method: $contact')),
        );
      }
    }
  }

  Widget _buildInvestorCard(InvestorProfile investor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Text(
            investor.name.isNotEmpty ? investor.name[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          investor.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (investor.location.isNotEmpty)
              Text('🌍 Location: ${investor.location}'),
            if (investor.interests.isNotEmpty)
              Text('💼 Interests: ${investor.interests.join(', ')}'),
            if (investor.preferredHorizons.isNotEmpty)
              Text('⏳ Horizons: ${investor.preferredHorizons.map((e) => e.label).join(', ')}'),
            Text('📊 Status: ${investor.status.label}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: 'Contact Options',
          onSelected: (value) => _launchContact(value, investor.contact),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'Call', child: Text('Call')),
            PopupMenuItem(value: 'Message', child: Text('Message')),
            PopupMenuItem(value: 'Email', child: Text('Email')),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⚠️ Failed to load investors.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadInvestors,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredInvestors.isEmpty) {
      return const Center(child: Text('🚫 No matching investors found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadInvestors,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _filteredInvestors.length,
        itemBuilder: (context, index) =>
            _buildInvestorCard(_filteredInvestors[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💼 Investor Directory'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInvestors,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _applySearch();
              },
              decoration: InputDecoration(
                hintText: '🔍 Search by name, location, or status...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const InvestorRegistrationScreen(),
            ),
          );
          if (result == true) _loadInvestors();
        },
        tooltip: 'Add New Investor',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
