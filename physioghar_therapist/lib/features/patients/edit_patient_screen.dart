import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/patient_model.dart';
import '../../providers/patient_update_provider.dart';

class EditPatientScreen extends ConsumerStatefulWidget {
  final PatientModel patient;

  const EditPatientScreen({super.key, required this.patient});

  @override
  ConsumerState<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends ConsumerState<EditPatientScreen> {
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController genderController;
  late final TextEditingController phoneController;
  late final TextEditingController conditionController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.patient.name);

    ageController = TextEditingController(text: widget.patient.age.toString());

    genderController = TextEditingController(text: widget.patient.gender);

    phoneController = TextEditingController(text: widget.patient.phone);

    conditionController = TextEditingController(text: widget.patient.condition);
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    phoneController.dispose();
    conditionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(patientUpdateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Patient')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Patient Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cake),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: genderController,
            decoration: const InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.people),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: conditionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Condition',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.medical_services),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: updateState.isLoading
                  ? null
                  : () async {
                      final name = nameController.text.trim();

                      final age = int.tryParse(ageController.text.trim());

                      final gender = genderController.text.trim();

                      final phone = phoneController.text.trim();

                      final condition = conditionController.text.trim();

                      if (name.isEmpty ||
                          age == null ||
                          gender.isEmpty ||
                          phone.isEmpty ||
                          condition.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields.'),
                          ),
                        );
                        return;
                      }

                      final updatedPatient = widget.patient.copyWith(
                        name: name,
                        age: age,
                        gender: gender,
                        phone: phone,
                        condition: condition,
                      );

                      await ref
                          .read(patientUpdateProvider.notifier)
                          .updatePatient(updatedPatient);

                      if (!mounted) {
                        return;
                      }

                      final result = ref.read(patientUpdateProvider);

                      if (result.hasError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to update patient: ${result.error}',
                            ),
                          ),
                        );
                        return;
                      }

                      if (result.hasValue && result.value != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Patient updated successfully.'),
                          ),
                        );

                        Navigator.pop(context, result.value);
                      }
                    },
              icon: updateState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(updateState.isLoading ? 'Saving...' : 'Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
