import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking_model.dart';
//import '../services/api_service.dart';
import 'bookings_provider.dart';
import 'dashboard_provider.dart';

final bookingUpdateProvider =
    NotifierProvider<BookingUpdateNotifier, AsyncValue<BookingModel?>>(
      BookingUpdateNotifier.new,
    );

class BookingUpdateNotifier extends Notifier<AsyncValue<BookingModel?>> {
  @override
  AsyncValue<BookingModel?> build() {
    return const AsyncData(null);
  }

  Future<BookingModel?> updateBooking(BookingModel booking) async {
    state = const AsyncLoading();

    try {
      final apiService = ref.read(apiServiceProvider);

      final updatedBooking = await apiService.updateBooking(booking);

      state = AsyncData(updatedBooking);

      ref.invalidate(bookingsProvider);

      return updatedBooking;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      return null;
    }
  }
}
