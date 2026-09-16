import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/providers/dashboard_provider.dart';

import '../models/patient_model.dart';
import 'patients_provider.dart';

final patientUpdateProvider =
    NotifierProvider<PatientUpdateNotifier, AsyncValue<PatientModel?>>(
      PatientUpdateNotifier.new,
    );

class PatientUpdateNotifier extends Notifier<AsyncValue<PatientModel?>> {
  @override
  AsyncValue<PatientModel?> build() {
    return const AsyncData(null);
  }

  Future<void> updatePatient(PatientModel patient) async {
    state = const AsyncLoading();

    try {
      final apiService = ref.read(apiServiceProvider);

      final updatedPatient = await apiService.updatePatient(patient);

      state = AsyncData(updatedPatient);

      // Refresh the patient list after successful update.
      ref.invalidate(patientsProvider);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
