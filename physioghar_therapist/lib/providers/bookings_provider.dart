import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking_model.dart';
//import '../services/api_service.dart';
import 'dashboard_provider.dart';

final bookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);

  return apiService.getBookings();
});
