import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_model.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final dashboardProvider = FutureProvider<DashboardModel>((ref) async {
  final apiService = ref.read(apiServiceProvider);

  return apiService.getDashboard();
});
