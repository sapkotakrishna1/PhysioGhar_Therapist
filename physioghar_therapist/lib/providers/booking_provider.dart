import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/booking.dart';

class BookingNotifier extends Notifier<List<Booking>> {
  @override
  List<Booking> build() {
    return List<Booking>.from(MockData.bookings);
  }

  List<Booking> get upcomingBookings {
    return state
        .where((booking) => booking.status == BookingStatus.upcoming)
        .toList();
  }

  List<Booking> get requestedBookings {
    return state
        .where((booking) => booking.status == BookingStatus.requested)
        .toList();
  }

  List<Booking> get completedBookings {
    return state
        .where((booking) => booking.status == BookingStatus.completed)
        .toList();
  }

  void updateBooking(Booking updatedBooking) {
    state = [
      for (final booking in state)
        if (booking.id == updatedBooking.id) updatedBooking else booking,
    ];
  }

  void acceptBooking(String id) {
    final booking = state.firstWhere((item) => item.id == id);

    updateBooking(booking.copyWith(status: BookingStatus.upcoming));
  }

  void completeBooking(String id, {String remarks = ''}) {
    final booking = state.firstWhere((item) => item.id == id);

    updateBooking(
      booking.copyWith(status: BookingStatus.completed, notes: remarks),
    );
  }

  void updateRemarks(String id, String remarks) {
    final booking = state.firstWhere((item) => item.id == id);

    updateBooking(booking.copyWith(notes: remarks));
  }

  void declineBooking(String id) {
    final booking = state.firstWhere((item) => item.id == id);

    updateBooking(booking.copyWith(status: BookingStatus.cancelled));
  }
}

final bookingProvider = NotifierProvider<BookingNotifier, List<Booking>>(
  BookingNotifier.new,
);
