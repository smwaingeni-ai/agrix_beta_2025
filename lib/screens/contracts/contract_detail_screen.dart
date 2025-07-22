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
        automaticallyImplyLeading: true,
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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailTile("📄 Contract Title", contract.title),
            _buildDetailTile("📝 Description", contract.description),
            _buildDetailTile("🤝 Parties Involved", contract.parties.join(', ')),
            _buildDetailTile("💵 Amount", currencyFormatter.format(contract.amount)),
            _buildDetailTile("⏳ Duration", contract.duration),
            _buildDetailTile("🌱 Crop/Livestock Type", contract.cropOrLivestockType),
            _buildDetailTile("📍 Location", contract.location),
            _buildDetailTile("📑 Terms & Conditions", contract.terms),
            _buildContactTile(context, contract.contact),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text("Share Contract"),
              onPressed: () {
                Share.share(
                  '📄 Contract: ${contract.title}\n💵 Amount: ${currencyFormatter.format(contract.amount)}\n📞 Contact: ${contract.contact}',
                  subject: 'AgriX Contract Offer – ${contract.title}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : "N/A",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, String contact) {
    final isValid = contact.isNotEmpty && (contact.contains('@') || contact.length >= 7);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📞 Contact Info",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isValid ? contact : "N/A",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
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
          const Divider(height: 24),
        ],
      ),
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
