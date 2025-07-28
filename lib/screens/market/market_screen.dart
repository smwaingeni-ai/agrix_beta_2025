import 'dart:io'; // ✅ Required for Image.file()

import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/market/market_item.dart';
import 'package:agrix_beta_2025/services/market/market_service.dart';
import 'package:agrix_beta_2025/screens/market/market_item_form.dart';
import 'package:agrix_beta_2025/screens/market/market_detail_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<MarketItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    try {
      final items = await MarketService.loadItems();
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading market items: $e');
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed to load market items')),
        );
      }
    }
  }

  void _addItem(MarketItem item) async {
    await MarketService.addItem(item);
    _loadItems();
  }

  void _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarketItemForm(onSubmit: _addItem),
      ),
    );
  }

  void _openDetails(MarketItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarketDetailScreen(marketItem: item),
      ),
    );
  }

  Widget _buildCard(MarketItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: item.hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  File(item.imagePath),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              )
            : const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${item.category} • ${item.displayDate}'),
        trailing: Text(
          'ZMW ${item.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => _openDetails(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Agri Market'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: _loadItems,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(
                  child: Text(
                    '📭 No market items available. Tap + to add.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadItems,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _items.length,
                    itemBuilder: (context, index) => _buildCard(_items[index]),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('New Listing'),
      ),
    );
  }
}
