import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ContractDetailScreen extends StatelessWidget {
  final ContractOffer contract;

  const ContractDetailScreen({required this.contract, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(
        title: Text(contract.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export to PDF (Coming Soon)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("🚧 PDF export feature is under development."),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionHeader("📄 Contract Details"),
            _buildDetailTile("Title", contract.title),
            _buildDetailTile("Description", contract.description),
            _buildDetailTile("Crop/Livestock Type", contract.cropOrLivestockType),
            _buildDetailTile("Amount", currencyFormatter.format(contract.amount)),
            _buildDetailTile("Duration", contract.duration),
            _buildDetailTile("Location", contract.location),
            _buildDetailTile("Terms", contract.terms),

            const SizedBox(height: 20),
            _sectionHeader("👥 Parties Involved"),
            _buildDetailTile("Parties", contract.parties.join(', ')),

            const SizedBox(height: 20),
            _sectionHeader("📞 Contact Information"),
            _buildContactTile(context, contract.contact),

            const SizedBox(height: 30),
            _sectionHeader("📤 Actions"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  onPressed: () {
                    Share.share(
                      '''
📄 Contract: ${contract.title}
💵 Amount: ${currencyFormatter.format(contract.amount)}
📞 Contact: ${contract.contact}
''',
                      subject: 'AgriX Contract Offer – ${contract.title}',
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.app_registration),
                  label: const Text("Apply"),
                  onPressed: () {
                    // Placeholder for future application logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("🚧 Application feature coming soon.")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildDetailTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value.isNotEmpty ? value : "N/A"),
        leading: const Icon(Icons.info_outline, color: Colors.green),
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, String contact) {
    final isValid = contact.isNotEmpty && (contact.contains('@') || contact.length >= 7);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isValid ? contact : "N/A",
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        if (isValid)
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.call),
                label: const Text("Call"),
                onPressed: () => _launchContact("Call", contact),
              ),
              TextButton.icon(
                icon: const Icon(Icons.sms),
                label: const Text("Message"),
                onPressed: () => _launchContact("Message", contact),
              ),
              TextButton.icon(
                icon: const Icon(Icons.email),
                label: const Text("Email"),
                onPressed: () => _launchContact("Email", contact),
              ),
            ],
          ),
      ],
    );
  }

  void _launchContact(String method, String contact) async {
    String url = '';
    switch (method) {
      case 'Call':
        url = 'tel:$contact';
        break;
      case 'Message':
        url = 'sms:$contact';
        break;
      case 'Email':
        url = 'mailto:$contact';
        break;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('❌ Cannot launch $url');
    }
  }
}
