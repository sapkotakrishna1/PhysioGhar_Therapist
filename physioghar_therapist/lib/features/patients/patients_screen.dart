import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/patient_provider.dart';

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Patients')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Text(patient.name[0])),
              title: Text(patient.name),
              subtitle: Text(patient.condition),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PatientDetailsScreen(patientId: patient.id);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PatientDetailsScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailsScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientProvider);

    final patient = patients.firstWhere((item) => item.id == patientId);

    return Scaffold(
      appBar: AppBar(title: Text(patient.name)),
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
                  const SizedBox(height: 8),
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

          ...patient.history.map(
            (item) =>
                ListTile(leading: const Icon(Icons.history), title: Text(item)),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clinical Notes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: () {
                  _showAddNoteDialog(context, ref, patient.id);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (patient.notes.isEmpty) const Text('No notes added yet.'),

          ...patient.notes.asMap().entries.map((entry) {
            final noteIndex = entry.key;
            final note = entry.value;

            return Card(
              child: ListTile(
                leading: const Icon(Icons.notes),
                title: Text(note),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    _showEditNoteDialog(
                      context,
                      ref,
                      patient.id,
                      noteIndex,
                      note,
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showAddNoteDialog(
    BuildContext context,
    WidgetRef ref,
    String patientId,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Clinical Note'),
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
              onPressed: () {
                final note = controller.text.trim();

                if (note.isEmpty) {
                  return;
                }

                ref.read(patientProvider.notifier).addNote(patientId, note);

                Navigator.pop(dialogContext);
              },
              child: const Text('Save Note'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(
    BuildContext context,
    WidgetRef ref,
    String patientId,
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
              hintText: 'Edit patient note',
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
              onPressed: () {
                final updatedNote = controller.text.trim();

                if (updatedNote.isEmpty) {
                  return;
                }

                final patients = ref.read(patientProvider);

                final patient = patients.firstWhere(
                  (item) => item.id == patientId,
                );

                final updatedNotes = List<String>.from(patient.notes);

                updatedNotes[noteIndex] = updatedNote;

                final updatedPatient = patient.copyWith(notes: updatedNotes);

                ref
                    .read(patientProvider.notifier)
                    .updatePatient(updatedPatient);

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Clinical note updated successfully.'),
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
