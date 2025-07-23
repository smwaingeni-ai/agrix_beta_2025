import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/logs/log_entry.dart'; // You will create this model

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  List<LogEntry> _entries = [];
  bool _loading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadLogbook();
  }

  Future<void> _loadLogbook() async {
    setState(() => _loading = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/logbook.json');

      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> rawLogs = json.decode(content);

        final logs = rawLogs
            .map((e) => LogEntry.fromJson(e))
            .where((e) => e.timestamp != null)
            .toList();

        logs.sort((a, b) => b.timestamp!.compareTo(a.timestamp!)); // Newest first

        setState(() {
          _entries = logs;
        });
      } else {
        debugPrint('📭 No logbook file found.');
        setState(() => _entries = []);
      }
    } catch (e) {
      debugPrint('❌ Error loading logbook: $e');
      setState(() => _entries = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  List<LogEntry> get _filteredEntries {
    if (_selectedFilter == 'All') return _entries;
    return _entries.where((e) => e.category == _selectedFilter).toList();
  }

  Widget _buildEntry(LogEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(
          Icons.assignment_turned_in,
          color: _iconColor(entry.category),
        ),
        title: Text(entry.result ?? '📝 No result'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🕒 ${entry.timestampFormatted}'),
            if (entry.note != null) Text('🧾 ${entry.note}'),
            if (entry.category != null) Text('📂 ${entry.category}'),
          ],
        ),
        trailing: Text(entry.cost ?? 'N/A',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _iconColor(String? category) {
    switch (category) {
      case 'Crop':
        return Colors.green;
      case 'Soil':
        return Colors.brown;
      case 'Livestock':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Crop', 'Soil', 'Livestock', 'Other'];
    return Wrap(
      spacing: 8,
      children: filters
          .map((filter) => ChoiceChip(
                label: Text(filter),
                selected: _selectedFilter == filter,
                onSelected: (_) {
                  setState(() => _selectedFilter = filter);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📓 AgriX Logbook')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? const Center(
                  child: Text(
                    '📭 No log entries found.\nScan and save results to view them here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildFilterChips(),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadLogbook,
                        child: ListView.builder(
                          itemCount: _filteredEntries.length,
                          itemBuilder: (context, index) =>
                              _buildEntry(_filteredEntries[index]),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
