import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import 'package:agrix_beta_2025/models/market/market_item.dart';

class MarketItemForm extends StatefulWidget {
  final Function(MarketItem) onSubmit;

  const MarketItemForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<MarketItemForm> createState() => _MarketItemFormState();
}

class _MarketItemFormState extends State<MarketItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _typeController = TextEditingController();
  final _listingTypeController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerContactController = TextEditingController();
  final _investmentStatusController = TextEditingController();
  final _investmentTermController = TextEditingController();

  List<String> _contactMethods = [];
  List<String> _paymentOptions = [];
  List<String> _imagePaths = [];

  bool _isAvailable = true;
  bool _isLoanAccepted = false;
  bool _isInvestmentOpen = false;

  Future<void> _pickImages() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _imagePaths = pickedFiles.map((file) => file.path).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error picking images: $e')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final marketItem = MarketItem(
        id: _uuid.v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        category: _categoryController.text.trim(),
        contact: _ownerContactController.text.trim(),
        imagePath: _imagePaths.isNotEmpty ? _imagePaths.first : '',
        imagePaths: _imagePaths,
        listingType: _listingTypeController.text.trim(),
        location: _locationController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        ownerContact: _ownerContactController.text.trim(),
        investmentStatus: _investmentStatusController.text.trim(),
        investmentTerm: _investmentTermController.text.trim(),
        contactMethods: _contactMethods,
        paymentOptions: _paymentOptions,
        isAvailable: _isAvailable,
        isLoanAccepted: _isLoanAccepted,
        isInvestmentOpen: _isInvestmentOpen,
        postedAt: DateTime.now(),
      );

      widget.onSubmit(marketItem);
      Navigator.pop(context);
    }
  }

  Widget _buildChipsSection(String title, List<String> options, List<String> selected, Function(List<String>) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    selected.add(option);
                  } else {
                    selected.remove(option);
                  }
                  onChanged(List.from(selected));
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _typeController.dispose();
    _listingTypeController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _ownerNameController.dispose();
    _ownerContactController.dispose();
    _investmentStatusController.dispose();
    _investmentTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const contactOptions = ['Phone', 'SMS', 'WhatsApp', 'Email'];
    const paymentOptions = ['Cash', 'Bank Transfer', 'QR Code', 'Debit Card', 'Loan'];

    return Scaffold(
      appBar: AppBar(title: const Text('🛒 Create Market Listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _typeController, decoration: const InputDecoration(labelText: 'Type'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _listingTypeController, decoration: const InputDecoration(labelText: 'Listing Type'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price (ZMW)'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _ownerNameController, decoration: const InputDecoration(labelText: 'Owner Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _ownerContactController, decoration: const InputDecoration(labelText: 'Owner Contact'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _investmentStatusController, decoration: const InputDecoration(labelText: 'Investment Status')),
              TextFormField(controller: _investmentTermController, decoration: const InputDecoration(labelText: 'Investment Term')),

              _buildChipsSection("📞 Contact Methods", contactOptions, _contactMethods, (v) => _contactMethods = v),
              _buildChipsSection("💳 Payment Options", paymentOptions, _paymentOptions, (v) => _paymentOptions = v),

              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Available'),
                  Switch(value: _isAvailable, onChanged: (val) => setState(() => _isAvailable = val)),
                  const SizedBox(width: 16),
                  const Text('Loan Accepted'),
                  Switch(value: _isLoanAccepted, onChanged: (val) => setState(() => _isLoanAccepted = val)),
                ],
              ),
              Row(
                children: [
                  const Text('Investment Open'),
                  Switch(value: _isInvestmentOpen, onChanged: (val) => setState(() => _isInvestmentOpen = val)),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.image),
                label: const Text("Pick Images"),
              ),
              const SizedBox(height: 8),
              if (_imagePaths.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: _imagePaths.map((p) => Image.file(File(p), width: 60, height: 60, fit: BoxFit.cover)).toList(),
                ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Listing'),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
