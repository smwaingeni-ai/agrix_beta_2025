import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/training/training_log.dart';
import 'package:agrix_beta_2025/services/training/training_log_service.dart';

class TrainingLogScreen extends StatefulWidget {
  const TrainingLogScreen({Key? key}) : super(key: key);

  @override
  State<TrainingLogScreen> createState() => _TrainingLogScreenState();
}

class _TrainingLogScreenState extends State<TrainingLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _facilitatorController = TextEditingController();
  final _locationController = TextEditingController();
  final _participantsController = TextEditingController();
  final _regionController = TextEditingController();

  List<TrainingLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await TrainingLogService.loadLogs();
    setState(() => _logs = logs);
  }

  Future<void> _saveLog() async {
    if (!_formKey.currentState!.validate()) return;

    final log = TrainingLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      facilitator: _facilitatorController.text.trim(),
      location: _locationController.text.trim(),
      participants: int.tryParse(_participantsController.text.trim()) ?? 0,
      region: _regionController.text.trim(),
      date: DateTime.now(),
    );

    await TrainingLogService.saveLog(log);
    _clearForm();
    await _loadLogs();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Training log saved successfully')),
    );
  }

  void _clearForm() {
    _titleController.clear();
    _facilitatorController.clear();
    _locationController.clear();
    _participantsController.clear();
    _regionController.clear();
  }

  Widget _buildLogCard(TrainingLog log) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.school, color: Colors.indigo),
        title: Text(log.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👨‍🏫 Facilitator: ${log.facilitator}'),
            Text('📍 Location: ${log.location}'),
            Text('👥 Participants: ${log.participants}'),
            Text('🌍 Region: ${log.region}'),
            Text('📅 Date: ${log.date.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _facilitatorController.dispose();
    _locationController.dispose();
    _participantsController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Training Logs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export to CSV',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📤 Export will be handled via system backend.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📝 Log New Training',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Training Title'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _facilitatorController,
                    decoration: const InputDecoration(labelText: 'Facilitator'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _participantsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Participants'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _regionController,
                    decoration: const InputDecoration(labelText: 'Region'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Training'),
                    onPressed: _saveLog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text('📖 Submitted Logs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ..._logs.map(_buildLogCard).toList(),
          ],
        ),
      ),
    );
  }
}
