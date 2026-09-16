import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/schedule_model.dart';
//import '../services/api_service.dart';
import 'dashboard_provider.dart';

final schedulesProvider = FutureProvider<List<ScheduleModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);

  return apiService.getSchedules();
});
