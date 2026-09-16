import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/patient_model.dart';
import '../../providers/patient_update_provider.dart';
import '../../providers/patients_provider.dart';
import 'edit_patient_screen.dart';

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(patientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Patients')),
      body: patientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load patients.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (patients) {
          if (patients.isEmpty) {
            return const Center(child: Text('No patients found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      patient.name.isNotEmpty ? patient.name[0] : '?',
                    ),
                  ),
                  title: Text(patient.name),
                  subtitle: Text(patient.condition),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PatientDetailsScreen(patient: patient);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PatientDetailsScreen extends ConsumerWidget {
  final PatientModel patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Patient',
            onPressed: () async {
              final updatedPatient = await Navigator.push<PatientModel>(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EditPatientScreen(patient: patient);
                  },
                ),
              );

              if (updatedPatient == null) {
                return;
              }

              if (!context.mounted) {
                return;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PatientDetailsScreen(patient: updatedPatient);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 12),

                  Text('Age: ${patient.age}'),

                  Text('Gender: ${patient.gender}'),

                  Text('Phone: ${patient.phone}'),

                  Text('Condition: ${patient.condition}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Patient History',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 8),

          if (patient.history.isEmpty) const Text('No history available.'),

          ...patient.history.map(
            (item) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(item.toString()),
            ),
          ),

          const SizedBox(height: 16),

          Text('Clinical Notes', style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 8),

          if (patient.notes.isEmpty) const Text('No notes added yet.'),

          ...patient.notes.asMap().entries.map((entry) {
            final noteIndex = entry.key;
            final note = entry.value.toString();

            return Card(
              child: ListTile(
                leading: const Icon(Icons.notes),
                title: Text(note),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    _showEditNoteDialog(context, ref, patient, noteIndex, note);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showEditNoteDialog(
    BuildContext context,
    WidgetRef ref,
    PatientModel patient,
    int noteIndex,
    String oldNote,
  ) {
    final controller = TextEditingController(text: oldNote);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Clinical Note'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter patient note',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedNote = controller.text.trim();

                if (updatedNote.isEmpty) {
                  return;
                }

                final updatedNotes = List<dynamic>.from(patient.notes);

                updatedNotes[noteIndex] = updatedNote;

                final updatedPatient = patient.copyWith(notes: updatedNotes);

                await ref
                    .read(patientUpdateProvider.notifier)
                    .updatePatient(updatedPatient);

                if (!context.mounted) {
                  return;
                }

                final result = ref.read(patientUpdateProvider);

                if (result.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to update note: '
                        '${result.error}',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                if (!context.mounted) {
                  return;
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PatientDetailsScreen(patient: updatedPatient);
                    },
                  ),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }
}
