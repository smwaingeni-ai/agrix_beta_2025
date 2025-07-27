import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketInviteScreen extends StatefulWidget {
  const MarketInviteScreen({super.key});

  @override
  State<MarketInviteScreen> createState() => _MarketInviteScreenState();
}

class _MarketInviteScreenState extends State<MarketInviteScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _contacts = [
    '+263771234567',
    '+260971234567',
    '+254701234567',
  ];
  String _selectedContact = '';

  @override
  void initState() {
    super.initState();
    _selectedContact = _contacts.isNotEmpty ? _contacts.first : '';
    _messageController.text =
        "📢 Join us for AgriX Market Day! Trade, invest, lease, and connect across Africa 🌍.";
  }

  Future<void> _launch(String method, Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError("❌ Could not launch $method for $_selectedContact");
    }
  }

  Future<void> _inviteViaWhatsApp() async {
    if (_selectedContact.isEmpty) return _showError("Please select a contact.");
    final uri = Uri.parse(
        "https://wa.me/$_selectedContact?text=${Uri.encodeComponent(_messageController.text)}");
    await _launch("WhatsApp", uri);
  }

  Future<void> _inviteViaSMS() async {
    if (_selectedContact.isEmpty) return _showError("Please select a contact.");
    final uri = Uri.parse("sms:$_selectedContact?body=${Uri.encodeComponent(_messageController.text)}");
    await _launch("SMS", uri);
  }

  Future<void> _callContact() async {
    if (_selectedContact.isEmpty) return _showError("Please select a contact.");
    final uri = Uri.parse("tel:$_selectedContact");
    await _launch("Call", uri);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade400,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📨 Invite to Agri Market"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("📇 Select Contact", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedContact.isNotEmpty ? _selectedContact : null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              isExpanded: true,
              items: _contacts.map((phone) {
                return DropdownMenuItem(value: phone, child: Text(phone));
              }).toList(),
              onChanged: (val) => setState(() => _selectedContact = val ?? ''),
            ),
            const SizedBox(height: 20),
            const Text("✉️ Message", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type your invitation message...",
              ),
            ),
            const SizedBox(height: 30),
            const Text("📲 Choose an Action", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.sms, color: Colors.white),
                  label: const Text("Send SMS"),
                  onPressed: _inviteViaSMS,
                ),
                ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                  label: const Text("Send WhatsApp"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _inviteViaWhatsApp,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text("Call"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: _callContact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
