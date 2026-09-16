import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/patient_model.dart';
//import '../services/api_service.dart';
import 'dashboard_provider.dart';

final patientsProvider = FutureProvider<List<PatientModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);

  return apiService.getPatients();
});
