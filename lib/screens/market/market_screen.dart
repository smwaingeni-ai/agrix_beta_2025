// /lib/screens/market/market_screen.dart

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
    final items = await MarketService.loadItems();
    setState(() {
      _items = items;
      _loading = false;
    });
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
        builder: (_) => MarketDetailScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agri Market'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _openForm,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No market items available.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: item.hasImage
                            ? Image.asset(item.imagePath, width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported),
                        title: Text(item.title),
                        subtitle: Text('${item.category} • Posted: ${item.displayDate}'),
                        trailing: Text('ZMW ${item.price.toStringAsFixed(2)}'),
                        onTap: () => _openDetails(item),
                      ),
                    );
                  },
                ),
    );
  }
}
