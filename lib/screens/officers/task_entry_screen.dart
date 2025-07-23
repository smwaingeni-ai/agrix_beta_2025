import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:agrix_beta_2025/models/tasks/task_model.dart';
import 'package:aagrix_beta_2025/services/tasks/task_service.dart';

class TaskEntryScreen extends StatefulWidget {
  const TaskEntryScreen({super.key});

  @override
  State<TaskEntryScreen> createState() => _TaskEntryScreenState();
}

class _TaskEntryScreenState extends State<TaskEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitle = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String _status = 'Pending';
  bool _isSaving = false;

  @override
  void dispose() {
    _taskTitle.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newTask = Task(
      id: const Uuid().v4(),
      title: _taskTitle.text.trim(),
      description: _description.text.trim(),
      status: _status,
      createdAt: DateTime.now(),
    );

    try {
      await TaskService().saveTask(newTask);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Task saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to refresh previous screen
      }
    } catch (e) {
      debugPrint("Error saving task: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to save task. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Add Officer Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _taskTitle,
                decoration: const InputDecoration(
                  labelText: 'Task Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Task title is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Pending', 'In Progress', 'Completed']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: _isSaving
                      ? const Text('Saving...')
                      : const Text('Save Task'),
                  onPressed: _isSaving ? null : _saveTask,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
