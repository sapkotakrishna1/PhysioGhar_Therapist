import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../providers/availability_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/therapist_provider.dart';
import '../../models/booking.dart';

class DashboardScreen extends ConsumerWidget {
  final ValueChanged<int>? onTabSelected;

  const DashboardScreen({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final therapist = ref.watch(therapistProvider);

    final isAvailable = ref.watch(availabilityProvider);

    final bookings = ref.watch(bookingProvider);

    final today = DateTime.now();

    final todayBookings = bookings.where((booking) {
      return booking.dateTime.year == today.year &&
          booking.dateTime.month == today.month &&
          booking.dateTime.day == today.day &&
          booking.status == BookingStatus.upcoming;
    }).toList();

    final upcomingRequests = bookings
        .where((booking) => booking.status == BookingStatus.requested)
        .length;

    final completedSessions = bookings
        .where((booking) => booking.status == BookingStatus.completed)
        .length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, therapist.name),

              const SizedBox(height: 24),

              Text(
                DateFormat('EEEE, d MMMM yyyy').format(today),
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              _buildAvailabilityCard(context, ref, isAvailable),

              const SizedBox(height: 24),

              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      context,
                      'Today',
                      todayBookings.length.toString(),
                      Icons.calendar_today_outlined,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _summaryCard(
                      context,
                      'Requests',
                      upcomingRequests.toString(),
                      Icons.notifications_none,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _summaryCard(
                      context,
                      'Completed',
                      completedSessions.toString(),
                      Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text(
                "Today's Schedule",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 12),

              if (todayBookings.isEmpty)
                const AppCard(child: Text('No sessions scheduled for today.'))
              else
                ...todayBookings.map(
                  (booking) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _sessionCard(context, booking),
                  ),
                ),

              const SizedBox(height: 16),

              Text(
                'Upcoming Requests',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 12),

              if (upcomingRequests == 0)
                const AppCard(child: Text('No upcoming booking requests.'))
              else
                ...bookings
                    .where(
                      (booking) => booking.status == BookingStatus.requested,
                    )
                    .map(
                      (booking) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _sessionCard(context, booking),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.pinePale,
          child: Text(
            name.isNotEmpty ? name[0] : 'T',
            style: const TextStyle(
              fontSize: 24,
              color: AppColors.pine,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning 👋',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(name, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  Widget _buildAvailabilityCard(
    BuildContext context,
    WidgetRef ref,
    bool isAvailable,
  ) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.pinePale : AppColors.mist,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.circle,
              color: isAvailable ? AppColors.pine : AppColors.inkMute,
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Availability',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  isAvailable ? 'You are available' : 'You are unavailable',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          Switch(
            value: isAvailable,
            onChanged: (_) {
              ref.read(availabilityProvider.notifier).toggleAvailability();
            },
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.pine, size: 22),

          const SizedBox(height: 12),

          Text(value, style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 4),

          Text(title, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _sessionCard(BuildContext context, Booking booking) {
    final time = DateFormat('hh:mm a').format(booking.dateTime);

    return AppCard(
      onTap: () {
        _showSessionDetails(context, booking);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.pinePale,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              time,
              style: const TextStyle(
                color: AppColors.pine,
                fontWeight: FontWeight.bold,
              ),
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

                Text(
                  booking.treatment,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 4),

                Text(
                  booking.location == BookingLocation.homeVisit
                      ? 'Home Visit'
                      : 'Clinic',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  void _showSessionDetails(BuildContext context, Booking booking) {
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
      builder: (dialogContext) {
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
                  booking.notes.isEmpty
                      ? 'No remarks available'
                      : booking.notes,
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
