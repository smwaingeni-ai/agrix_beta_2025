import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/market/market_item.dart';

class MarketDetailScreen extends StatelessWidget {
  final MarketItem marketItem;

  const MarketDetailScreen({Key? key, required this.marketItem}) : super(key: key);

  Widget _buildImageGallery(List<String>? paths) {
    if (paths == null || paths.isEmpty) return const Text('No images provided.');

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: paths.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(paths[index]),
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChips(String title, List<String>? items) {
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: items.map((item) => Chip(label: Text(item))).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildFlagsSection() {
    return Row(
      children: [
        if (marketItem.isAvailable) const Chip(label: Text("Available")),
        if (marketItem.isLoanAccepted) const Chip(label: Text("Loan Accepted")),
        if (marketItem.isInvestmentOpen) const Chip(label: Text("Investment Open")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final postedDate = "Posted At: ${marketItem.postedAt.toLocal().toString().split('.')[0]}";

    return Scaffold(
      appBar: AppBar(title: const Text('Market Item Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              marketItem.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            _buildImageGallery(marketItem.imagePaths),
            const SizedBox(height: 16),
            _buildDetailRow("Description", marketItem.description),
            _buildDetailRow("Category", marketItem.category),
            _buildDetailRow("Type", marketItem.type),
            _buildDetailRow("Listing Type", marketItem.listingType),
            _buildDetailRow("Location", marketItem.location),
            _buildDetailRow("Price", marketItem.price.toStringAsFixed(2)),
            _buildDetailRow("Owner", marketItem.ownerName),
            _buildDetailRow("Contact", marketItem.ownerContact),
            _buildDetailRow("Investment Status", marketItem.investmentStatus),
            _buildDetailRow("Investment Term", marketItem.investmentTerm),
            const SizedBox(height: 12),
            _buildChips("Contact Methods", marketItem.contactMethods),
            _buildChips("Payment Options", marketItem.paymentOptions),
            _buildFlagsSection(),
            const SizedBox(height: 16),
            Text(postedDate, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
