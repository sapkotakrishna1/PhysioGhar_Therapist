import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/booking.dart';
import '../../providers/booking_provider.dart';

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
    final bookings = ref.watch(bookingProvider);

    final requests = bookings
        .where((booking) => booking.status == BookingStatus.requested)
        .toList();

    final upcoming = bookings
        .where((booking) => booking.status == BookingStatus.upcoming)
        .toList();

    final completed = bookings
        .where((booking) => booking.status == BookingStatus.completed)
        .toList();

    final cancelled = bookings
        .where((booking) => booking.status == BookingStatus.cancelled)
        .toList();

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
      body: TabBarView(
        controller: _tabController,
        children: [
          _bookingList(
            bookings: requests,
            emptyMessage: 'No booking requests',
            showRequestActions: true,
          ),
          _bookingList(
            bookings: upcoming,
            emptyMessage: 'No upcoming sessions',
            showCompleteAction: true,
          ),
          _bookingList(
            bookings: completed,
            emptyMessage: 'No completed sessions',
          ),
          _bookingList(
            bookings: cancelled,
            emptyMessage: 'No cancelled bookings',
          ),
        ],
      ),
    );
  }

  Widget _bookingList({
    required List<Booking> bookings,
    required String emptyMessage,
    bool showRequestActions = false,
    bool showCompleteAction = false,
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
                      CircleAvatar(child: Text(booking.patientName[0])),
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
                            Text(booking.treatment),
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
                      Expanded(
                        child: Text(
                          DateFormat(
                            'dd MMM yyyy, hh:mm a',
                          ).format(booking.dateTime),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        booking.location == BookingLocation.homeVisit
                            ? 'Home Visit'
                            : 'Clinic',
                      ),
                    ],
                  ),

                  if (showRequestActions) ...[
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ref
                                  .read(bookingProvider.notifier)
                                  .declineBooking(booking.id);

                              _showMessage('Booking declined');
                            },
                            child: const Text('Decline'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(bookingProvider.notifier)
                                  .acceptBooking(booking.id);

                              _showMessage('Booking accepted');
                            },
                            child: const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (showCompleteAction) ...[
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _showRescheduleDialog(booking);
                            },
                            child: const Text('Reschedule'),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showCompleteDialog(booking);
                            },
                            icon: const Icon(Icons.check),
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

  void _showCompleteDialog(Booking booking) {
    final remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Complete Session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient: ${booking.patientName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const Text('Session Remarks'),

              const SizedBox(height: 8),

              TextField(
                controller: remarksController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter session remarks...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                final remarks = remarksController.text.trim();

                if (remarks.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter session remarks.'),
                    ),
                  );
                  return;
                }

                ref
                    .read(bookingProvider.notifier)
                    .completeBooking(booking.id, remarks: remarks);

                Navigator.pop(dialogContext);

                _showMessage('Session completed successfully');
              },
              child: const Text('Complete Session'),
            ),
          ],
        );
      },
    );
  }

  void _showRescheduleDialog(Booking booking) {
    DateTime selectedDate = booking.dateTime;

    TimeOfDay selectedTime = TimeOfDay.fromDateTime(booking.dateTime);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Reschedule Session'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text('Date'),
                    subtitle: Text(
                      DateFormat('EEEE, d MMMM yyyy').format(selectedDate),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );

                      if (picked != null) {
                        setDialogState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Time'),
                    subtitle: Text(selectedTime.format(context)),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );

                      if (picked != null) {
                        setDialogState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    final updatedBooking = booking.copyWith(
                      dateTime: newDateTime,
                    );

                    ref
                        .read(bookingProvider.notifier)
                        .updateBooking(updatedBooking);

                    Navigator.pop(context);

                    _showMessage('Session rescheduled successfully');
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBookingDetails(Booking booking) {
    String statusText;

    switch (booking.status) {
      case BookingStatus.requested:
        statusText = 'Requested';
        break;

      case BookingStatus.upcoming:
        statusText = 'Upcoming';
        break;

      case BookingStatus.completed:
        statusText = 'Completed';
        break;

      case BookingStatus.cancelled:
        statusText = 'Cancelled';
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Session Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailItem('Patient', booking.patientName),

                _detailItem('Treatment', booking.treatment),

                _detailItem(
                  'Date & Time',
                  DateFormat('dd MMM yyyy, hh:mm a').format(booking.dateTime),
                ),

                _detailItem(
                  'Location',
                  booking.location == BookingLocation.homeVisit
                      ? 'Home Visit'
                      : 'Clinic',
                ),

                _detailItem('Status', statusText),

                _detailItem(
                  'Remarks',
                  booking.notes.isEmpty ? 'No remarks added' : booking.notes,
                ),
              ],
            ),
          ),
          actions: [
            if (booking.status == BookingStatus.completed)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  _showEditRemarksDialog(booking);
                },
                child: const Text('Edit Remarks'),
              ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEditRemarksDialog(Booking booking) {
    final controller = TextEditingController(text: booking.notes);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Remarks'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter session remarks...',
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
                final remarks = controller.text.trim();

                if (remarks.isEmpty) {
                  return;
                }

                ref
                    .read(bookingProvider.notifier)
                    .updateRemarks(booking.id, remarks);

                Navigator.pop(dialogContext);

                _showMessage('Remarks updated successfully');
              },
              child: const Text('Save Changes'),
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
