import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrix_beta_2025/models/programs/program.dart'; // ✅ Fixed import
import 'package:agrix_beta_2025/services/programs/program_service.dart';

class ProgramFormScreen extends StatefulWidget {
  final ProgramLog? existingProgram;

  const ProgramFormScreen({super.key, this.existingProgram});

  @override
  State<ProgramFormScreen> createState() => _ProgramFormScreenState();
}

class _ProgramFormScreenState extends State<ProgramFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _programService = ProgramService();

  late TextEditingController _programNameController;
  late TextEditingController _farmerController;
  late TextEditingController _resourceController;
  late TextEditingController _impactController;
  late TextEditingController _regionController;
  late TextEditingController _officerController;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final program = widget.existingProgram ?? ProgramLog.empty();

    _programNameController = TextEditingController(text: program.programName);
    _farmerController = TextEditingController(text: program.farmer);
    _resourceController = TextEditingController(text: program.resource);
    _impactController = TextEditingController(text: program.impact);
    _regionController = TextEditingController(text: program.region);
    _officerController = TextEditingController(text: program.officer);
    _selectedDate = program.date;
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) return;

    final log = ProgramLog(
      id: widget.existingProgram?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      programName: _programNameController.text.trim(),
      farmer: _farmerController.text.trim(),
      region: _regionController.text.trim(),
      resource: _resourceController.text.trim(),
      impact: _impactController.text.trim(),
      officer: _officerController.text.trim(),
      date: _selectedDate,
    );

    try {
      await _programService.addLog(log); // ✅ Fixed method name
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error saving program: $e')),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingProgram != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '✏️ Edit Program' : '➕ Add Program'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_programNameController, 'Program Name'),
              _buildTextField(_farmerController, 'Farmer Name'),
              _buildTextField(_regionController, 'Region'),
              _buildTextField(_resourceController, 'Resource Used'),
              _buildTextField(_impactController, 'Impact Observed'),
              _buildTextField(_officerController, 'Officer Name'),
              const SizedBox(height: 16),
              Text('📅 Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Select Date'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Save Program'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
