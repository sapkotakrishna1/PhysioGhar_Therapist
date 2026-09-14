import 'package:flutter/material.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() {
    return _ComplaintsScreenState();
  }
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Booking Issue';

  final List<String> _categories = [
    'Booking Issue',
    'Payment Issue',
    'Patient Issue',
    'Technical Issue',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaints')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Submit a complaint',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            const Text('Tell us about any issue you are facing.'),

            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Complaint Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'Enter complaint subject',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Subject is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your complaint',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }

                if (value.trim().length < 10) {
                  return 'Please enter at least 10 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitComplaint,
                icon: const Icon(Icons.send),
                label: const Text('Submit Complaint'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitComplaint() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Complaint Submitted'),
          content: const Text(
            'Your complaint has been submitted successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    _subjectController.clear();
    _descriptionController.clear();

    setState(() {
      _selectedCategory = _categories.first;
    });
  }
}
