import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/booking_model.dart';
import '../../providers/booking_update_provider.dart';
import '../../providers/bookings_provider.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() {
    return _BookingsScreenState();
  }
}

class _BookingsScreenState extends ConsumerState<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Requests'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load bookings.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (bookings) {
          final requests = bookings
              .where((booking) => booking.status == 'REQUESTED')
              .toList();

          final upcoming = bookings
              .where((booking) => booking.status == 'UPCOMING')
              .toList();

          final completed = bookings
              .where((booking) => booking.status == 'COMPLETED')
              .toList();

          final cancelled = bookings
              .where((booking) => booking.status == 'CANCELLED')
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _backendBookingList(
                bookings: requests,
                emptyMessage: 'No booking requests',
              ),
              _backendBookingList(
                bookings: upcoming,
                emptyMessage: 'No upcoming sessions',
              ),
              _backendBookingList(
                bookings: completed,
                emptyMessage: 'No completed sessions',
              ),
              _backendBookingList(
                bookings: cancelled,
                emptyMessage: 'No cancelled bookings',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _backendBookingList({
    required List<BookingModel> bookings,
    required String emptyMessage,
  }) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              _showBookingDetails(booking);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text(
                          booking.patientName.isNotEmpty
                              ? booking.patientName[0]
                              : '?',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.patientName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(booking.therapistName),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 6),
                      Expanded(child: Text('${booking.date}, ${booking.time}')),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16),
                      const SizedBox(width: 6),
                      Text(_statusText(booking.status)),
                    ],
                  ),

                  if (booking.notes.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes, size: 16),
                        const SizedBox(width: 6),
                        Expanded(child: Text(booking.notes)),
                      ],
                    ),
                  ],

                  // Request actions
                  if (booking.status == 'REQUESTED') ...[
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final updatedBooking = booking.copyWith(
                                status: 'CANCELLED',
                              );

                              final result = await ref
                                  .read(bookingUpdateProvider.notifier)
                                  .updateBooking(updatedBooking);

                              if (!mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result != null
                                        ? 'Booking declined successfully'
                                        : 'Failed to decline booking',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Decline'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final updatedBooking = booking.copyWith(
                                status: 'UPCOMING',
                              );

                              final result = await ref
                                  .read(bookingUpdateProvider.notifier)
                                  .updateBooking(updatedBooking);

                              if (!mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result != null
                                        ? 'Booking accepted successfully'
                                        : 'Failed to accept booking',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Upcoming session actions
                  if (booking.status == 'UPCOMING') ...[
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showRescheduleDialog(booking);
                            },
                            icon: const Icon(Icons.schedule),
                            label: const Text('Reschedule'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showCompleteDialog(booking);
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Complete'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'REQUESTED':
        return 'Requested';

      case 'UPCOMING':
        return 'Upcoming';

      case 'COMPLETED':
        return 'Completed';

      case 'CANCELLED':
        return 'Cancelled';

      default:
        return status;
    }
  }

  Future<void> _showRescheduleDialog(BookingModel booking) async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate == null) {
      return;
    }

    selectedDate = pickedDate;

    if (!mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime == null) {
      return;
    }

    selectedTime = pickedTime;

    final formattedDate =
        '${selectedDate.year.toString().padLeft(4, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';

    final formattedTime = selectedTime.format(context);

    final updatedBooking = booking.copyWith(
      date: formattedDate,
      time: formattedTime,
    );

    final result = await ref
        .read(bookingUpdateProvider.notifier)
        .updateBooking(updatedBooking);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result != null
              ? 'Booking rescheduled successfully'
              : 'Failed to reschedule booking',
        ),
      ),
    );
  }

  void _showCompleteDialog(BookingModel booking) {
    final remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Complete Session'),
          content: TextField(
            controller: remarksController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Session remarks',
              hintText: 'Enter treatment notes or patient progress',
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
                final updatedBooking = booking.copyWith(
                  status: 'COMPLETED',
                  notes: remarksController.text.trim(),
                );

                final result = await ref
                    .read(bookingUpdateProvider.notifier)
                    .updateBooking(updatedBooking);

                if (!dialogContext.mounted) {
                  return;
                }

                Navigator.pop(dialogContext);

                if (!mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result != null
                          ? 'Session completed successfully'
                          : 'Failed to complete session',
                    ),
                  ),
                );
              },
              child: const Text('Complete'),
            ),
          ],
        );
      },
    ).then((_) {
      remarksController.dispose();
    });
  }

  void _showBookingDetails(BookingModel booking) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Session Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailItem('Patient', booking.patientName),
                _detailItem('Therapist', booking.therapistName),
                _detailItem('Date', booking.date),
                _detailItem('Time', booking.time),
                _detailItem('Status', _statusText(booking.status)),
                _detailItem(
                  'Remarks',
                  booking.notes.isEmpty ? 'No remarks added' : booking.notes,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
