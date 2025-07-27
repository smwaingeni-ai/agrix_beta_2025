import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  List<Map<String, dynamic>> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLogbook();
  }

  Future<File> _getLogbookFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/logbook.json');
  }

  Future<void> _loadLogbook() async {
    try {
      final file = await _getLogbookFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List logs = json.decode(content);
        setState(() {
          _entries = List<Map<String, dynamic>>.from(logs.reversed);
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading logbook: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteEntry(int index) async {
    final file = await _getLogbookFile();
    final original = List<Map<String, dynamic>>.from(_entries.reversed);
    original.removeAt(_entries.length - 1 - index);
    await file.writeAsString(json.encode(original));
    _loadLogbook();
  }

  Future<void> _exportToCSV() async {
    try {
      final rows = [
        ['Timestamp', 'Result', 'Cost', 'Note'],
        ..._entries.map((e) => [
              e['timestamp'] ?? '',
              e['result'] ?? '',
              e['cost'] ?? '',
              e['note'] ?? '',
            ])
      ];
      final csv = const ListToCsvConverter().convert(rows);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/logbook_export.csv');
      await file.writeAsString(csv);
      await Share.shareXFiles([XFile(file.path)], text: 'AgriX Logbook Export');
    } catch (e) {
      debugPrint('❌ CSV Export Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to export CSV')),
      );
    }
  }

  Future<void> _shareSummary() async {
    try {
      final summary = _entries.map((e) {
        return '📅 ${e['timestamp']}\n📝 ${e['result']}\n💰 ${e['cost'] ?? 'N/A'}\n${e['note'] != null ? "🗒 ${e['note']}" : ""}';
      }).join('\n\n');

      await Share.share(summary, subject: 'AgriX Logbook Summary');
    } catch (e) {
      debugPrint('❌ Share Error: $e');
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this log entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEntry(index);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(Map<String, dynamic> entry, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.assignment_turned_in, color: Colors.green),
        title: Text(entry['result'] ?? '📝 No result description'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🕒 ${entry['timestamp']}'),
            if (entry['note'] != null) Text('🗒 Note: ${entry['note']}'),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry['cost'] ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _confirmDelete(index),
              tooltip: 'Delete Entry',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📔 AgriX Logbook'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export to CSV',
            onPressed: _exportToCSV,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Summary',
            onPressed: _shareSummary,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? const Center(
                  child: Text(
                    '📭 No log entries found.\nPerform a scan and save results to view them here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadLogbook,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) =>
                        _buildEntry(_entries[index], index),
                  ),
                ),
    );
  }
}
