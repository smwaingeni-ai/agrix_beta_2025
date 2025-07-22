import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agrix_africa_adt2025/models/investments/investor_profile.dart';
import 'package:agrix_africa_adt2025/services/profile/investor_service.dart';

class InvestorListScreen extends StatefulWidget {
  const InvestorListScreen({super.key});

  @override
  State<InvestorListScreen> createState() => _InvestorListScreenState();
}

class _InvestorListScreenState extends State<InvestorListScreen> {
  List<InvestorProfile> _investors = [];
  bool _loading = true;
  bool _error = false;

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
      final data = await InvestorService().loadInvestors();
      setState(() {
        _investors = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading investors: $e');
      setState(() {
        _investors = [];
        _loading = false;
        _error = true;
      });
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Could not launch $method: $contact')),
      );
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
              Text(
                '⏳ Horizons: ${investor.preferredHorizons.map((e) => e.name).join(', ')}',
              ),
            Text('📊 Status: ${investor.status.name}'),
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

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚠️ Failed to load investors.'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: _loadInvestors,
            ),
          ],
        ),
      );
    }

    if (_investors.isEmpty) {
      return const Center(child: Text('🚫 No investors found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadInvestors,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _investors.length,
        itemBuilder: (context, index) =>
            _buildInvestorCard(_investors[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investor Directory'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInvestors,
            tooltip: 'Refresh List',
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _buildContent();
        },
      ),
    );
  }
}
