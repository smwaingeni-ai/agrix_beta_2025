import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrix_beta_2025/models/programs/program.dart'; // ✅ FIXED problem, mismatch
import 'package:agrix_beta_2025/services/programs/program_service.dart';

class ProgramTrackingScreen extends StatefulWidget {
  const ProgramTrackingScreen({Key? key}) : super(key: key);

  @override
  State<ProgramTrackingScreen> createState() => _ProgramTrackingScreenState();
}

class _ProgramTrackingScreenState extends State<ProgramTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProgramService _programService = ProgramService();

  final _programNameController = TextEditingController();
  final _farmerController = TextEditingController();
  final _resourceController = TextEditingController();
  final _impactController = TextEditingController();
  final _regionController = TextEditingController();
  final _officerController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  List<ProgramLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await _programService.loadLogs();
    setState(() {
      _logs = logs;
    });
  }

  Future<void> _submitLog() async {
    if (!_formKey.currentState!.validate()) return;

    final log = ProgramLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      programName: _programNameController.text.trim(),
      farmer: _farmerController.text.trim(),
      resource: _resourceController.text.trim(),
      impact: _impactController.text.trim(),
      region: _regionController.text.trim(),
      officer: _officerController.text.trim(),
      date: _selectedDate,
    );

    await _programService.addLog(log);
    _clearForm();
    _loadLogs();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Program log recorded successfully')),
    );
  }

  void _clearForm() {
    _programNameController.clear();
    _farmerController.clear();
    _resourceController.clear();
    _impactController.clear();
    _regionController.clear();
    _officerController.clear();
    _selectedDate = DateTime.now();
  }

  Future<void> _pickDate(BuildContext context) async {
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

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Please enter $labelText' : null,
      ),
    );
  }

  Widget _buildLogCard(ProgramLog log) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(log.programName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '👤 Farmer: ${log.farmer}\n📍 Region: ${log.region}\n📈 Impact: ${log.impact}',
        ),
        trailing: Text(DateFormat.yMMMd().format(log.date)),
        isThreeLine: true,
      ),
    );
  }

  @override
  void dispose() {
    _programNameController.dispose();
    _farmerController.dispose();
    _resourceController.dispose();
    _impactController.dispose();
    _regionController.dispose();
    _officerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📌 Program Tracking'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Log Program Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_programNameController, 'Program Name'),
                  _buildTextField(_farmerController, 'Farmer / Community'),
                  _buildTextField(_resourceController, 'Resource Provided'),
                  _buildTextField(_impactController, 'Observed Impact'),
                  _buildTextField(_regionController, 'Region'),
                  _buildTextField(_officerController, 'Officer Name'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('📅 ${DateFormat.yMMMd().format(_selectedDate)}'),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => _pickDate(context),
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _submitLog,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Log'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Past Program Logs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _logs.isEmpty
                ? const Text('🚫 No logs recorded yet.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) => _buildLogCard(_logs[index]),
                  ),
          ],
        ),
      ),
    );
  }
}
