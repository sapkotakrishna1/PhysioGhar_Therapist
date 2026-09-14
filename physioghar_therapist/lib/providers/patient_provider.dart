import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/patient_mock_data.dart';
import '../models/patient.dart';

class PatientNotifier extends Notifier<List<Patient>> {
  @override
  List<Patient> build() {
    return List<Patient>.from(PatientMockData.patients);
  }

  void addNote(String patientId, String note) {
    state = [
      for (final patient in state)
        if (patient.id == patientId)
          patient.copyWith(notes: [...patient.notes, note])
        else
          patient,
    ];
  }

  void updatePatient(Patient updatedPatient) {
    state = [
      for (final patient in state)
        if (patient.id == updatedPatient.id) updatedPatient else patient,
    ];
  }
}

final patientProvider = NotifierProvider<PatientNotifier, List<Patient>>(
  PatientNotifier.new,
);
