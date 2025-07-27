import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrix_beta_2025/models/sustainability/sustainability_log.dart';
import 'package:agrix_beta_2025/services/sustainability/sustainability_log_service.dart';

class SustainabilityLogScreen extends StatefulWidget {
  const SustainabilityLogScreen({Key? key}) : super(key: key);

  @override
  State<SustainabilityLogScreen> createState() => _SustainabilityLogScreenState();
}

class _SustainabilityLogScreenState extends State<SustainabilityLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _activityController = TextEditingController();
  final _impactController = TextEditingController();
  final _regionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<SustainabilityLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await SustainabilityLogService.loadLogs();
    setState(() => _logs = logs);
  }

  Future<void> _saveLog() async {
    if (_formKey.currentState!.validate()) {
      final log = SustainabilityLog.empty().copyWith(
        activity: _activityController.text.trim(),
        impact: _impactController.text.trim(),
        region: _regionController.text.trim(),
        date: _selectedDate,
      );

      await SustainabilityLogService.saveLog(log);

      _activityController.clear();
      _impactController.clear();
      _regionController.clear();
      setState(() => _selectedDate = DateTime.now());

      await _loadLogs();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Log saved successfully')),
      );
    }
  }

  Future<void> _deleteLog(int index) async {
    await SustainabilityLogService.deleteLog(index);
    await _loadLogs();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🗑️ Log deleted')),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  void dispose() {
    _activityController.dispose();
    _impactController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌍 Sustainability Log')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _activityController,
                    decoration: const InputDecoration(labelText: 'Activity'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Enter activity' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _impactController,
                    decoration: const InputDecoration(labelText: 'Impact'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Enter impact' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _regionController,
                    decoration: const InputDecoration(labelText: 'Region'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Enter region' : null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('📅 ${DateFormat.yMMMd().format(_selectedDate)}'),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Change'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _saveLog,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Log'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              '📋 Logged Activities',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _logs.isEmpty
                  ? const Center(child: Text('📭 No logs recorded yet.'))
                  : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(log.activity),
                            subtitle: Text(
                              '${log.impact} | ${log.region} | ${DateFormat.yMMMd().format(log.date)}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteLog(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
