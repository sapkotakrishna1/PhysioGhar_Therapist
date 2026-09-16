import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physioghar_therapist/providers/therapists_provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../models/booking.dart';
import '../../providers/availability_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  final ValueChanged<int>? onTabSelected;

  const DashboardScreen({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final therapistAsync = ref.watch(therapistProvider);
    final availabilityAsync = ref.watch(availabilityProvider);
    final bookings = ref.watch(bookingProvider);
    final dashboardAsync = ref.watch(dashboardProvider);

    final today = DateTime.now();

    final todayBookings = bookings.where((booking) {
      return booking.dateTime.year == today.year &&
          booking.dateTime.month == today.month &&
          booking.dateTime.day == today.day &&
          booking.status == BookingStatus.upcoming;
    }).toList();

    final requestedBookings = bookings.where((booking) {
      return booking.status == BookingStatus.requested;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              therapistAsync.when(
                loading: () => _buildHeader(context, 'Therapist'),
                error: (error, stackTrace) =>
                    _buildHeader(context, 'Therapist'),
                data: (therapist) => _buildHeader(context, therapist.name),
              ),

              const SizedBox(height: 24),

              Text(
                DateFormat('EEEE, d MMMM yyyy').format(today),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 24),

              _buildAvailabilityCard(context, ref, availabilityAsync),

              const SizedBox(height: 28),

              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              dashboardAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stackTrace) => AppCard(
                  child: Text(
                    'Unable to load dashboard data.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                data: (dashboard) {
                  final overviewCards = [
                    _OverviewItem(
                      title: 'Today',
                      value: todayBookings.length.toString(),
                      icon: Icons.calendar_today_outlined,
                      color: const Color(0xFF607D78),
                    ),
                    _OverviewItem(
                      title: 'Requests',
                      value: dashboard.requestedBookings.toString(),
                      icon: Icons.notifications_none,
                      color: const Color(0xFF9A8C78),
                    ),
                    _OverviewItem(
                      title: 'Completed',
                      value: dashboard.completedBookings.toString(),
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF718A78),
                    ),
                    _OverviewItem(
                      title: 'Total Patients',
                      value: dashboard.totalPatients.toString(),
                      icon: Icons.people_outline,
                      color: const Color(0xFF78879A),
                    ),
                  ];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int columnCount;

                      if (constraints.maxWidth < 500) {
                        columnCount = 2;
                      } else if (constraints.maxWidth < 850) {
                        columnCount = 3;
                      } else {
                        columnCount = 4;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: overviewCards.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.15,
                        ),
                        itemBuilder: (context, index) {
                          final item = overviewCards[index];

                          return _summaryCard(
                            context,
                            title: item.title,
                            value: item.value,
                            icon: item.icon,
                            color: item.color,
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

              Text(
                "Today's Schedule",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              if (todayBookings.isEmpty)
                const AppCard(child: Text('No sessions scheduled for today.'))
              else
                ...todayBookings.map(
                  (booking) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _sessionCard(context, booking),
                  ),
                ),

              const SizedBox(height: 18),

              Text(
                'Upcoming Requests',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              if (requestedBookings.isEmpty)
                const AppCard(child: Text('No upcoming booking requests.'))
              else
                ...requestedBookings.map(
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
            name.isNotEmpty ? name[0].toUpperCase() : 'T',
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
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
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
    AsyncValue<bool> availabilityAsync,
  ) {
    return availabilityAsync.when(
      loading: () =>
          const AppCard(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AppCard(
        child: Text(
          'Unable to load availability.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (isAvailable) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isAvailable
                  ? AppColors.pine.withValues(alpha: 0.16)
                  : Colors.grey.withValues(alpha: 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? AppColors.pinePale
                      : Colors.grey.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isAvailable
                      ? Icons.check_circle_outline
                      : Icons.pause_circle_outline,
                  color: isAvailable ? AppColors.pine : Colors.grey.shade600,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Availability',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      isAvailable ? 'You are available' : 'You are unavailable',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
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
      },
    );
  }

  Widget _summaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 23),
          ),

          const SizedBox(height: 10),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  booking.treatment,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 4),

                Text(
                  booking.location == BookingLocation.homeVisit
                      ? 'Home Visit'
                      : 'Clinic',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.grey),
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

class _OverviewItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _OverviewItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}
