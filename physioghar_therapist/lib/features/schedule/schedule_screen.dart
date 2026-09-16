import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../models/schedule_model.dart';
import '../../providers/schedule_create_provider.dart';
import '../../providers/schedule_delete_provider.dart';
import '../../providers/schedule_update_provider.dart';
import '../../providers/schedules_provider.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() {
    return _ScheduleScreenState();
  }
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final schedulesAsync = ref.watch(schedulesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule & Availability')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSlotDialog,
        child: const Icon(Icons.add),
      ),
      body: schedulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load schedule.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (schedules) {
          final selectedSchedules = schedules
              .where((schedule) => _isSameDate(schedule.date, selectedDate))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Date',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 12),

                _buildDateSelector(),

                const SizedBox(height: 24),

                Text(
                  'Available Time Slots',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 12),

                if (selectedSchedules.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text('No schedule slots for this date.'),
                    ),
                  )
                else
                  ...selectedSchedules.map(
                    (schedule) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSlotCard(schedule),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));

          final isSelected =
              date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.pine : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.pine : AppColors.mist,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayName(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.inkMid,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotCard(ScheduleModel schedule) {
    final status = schedule.status;

    Color statusColor;

    if (status == 'BOOKED') {
      statusColor = AppColors.amber;
    } else if (status == 'BLOCKED') {
      statusColor = AppColors.danger;
    } else {
      statusColor = AppColors.pine;
    }

    return AppCard(
      onTap: () {
        _showSlotOptions(schedule);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.pinePale,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.access_time, color: AppColors.pine),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.time,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                if (schedule.patientName != null &&
                    schedule.patientName!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    schedule.patientName!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSlotOptions(ScheduleModel schedule) {
    if (schedule.status == 'BOOKED') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This slot is already booked.')),
      );

      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  schedule.time,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: Icon(
                    schedule.status == 'BLOCKED'
                        ? Icons.lock_open
                        : Icons.block,
                  ),
                  title: Text(
                    schedule.status == 'BLOCKED'
                        ? 'Unblock Slot'
                        : 'Block Slot',
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    final newStatus = schedule.status == 'BLOCKED'
                        ? 'OPEN'
                        : 'BLOCKED';

                    final updatedSchedule = schedule.copyWith(
                      status: newStatus,
                    );

                    final result = await ref
                        .read(scheduleUpdateProvider.notifier)
                        .updateSchedule(updatedSchedule);

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result != null
                              ? newStatus == 'BLOCKED'
                                    ? 'Slot blocked successfully'
                                    : 'Slot unblocked successfully'
                              : 'Failed to update schedule',
                        ),
                      ),
                    );
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Delete Slot',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    _confirmDeleteSchedule(schedule);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteSchedule(ScheduleModel schedule) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Schedule Slot?'),
          content: Text(
            'Are you sure you want to delete '
            '${schedule.time} on ${schedule.date}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                final success = await ref
                    .read(scheduleDeleteProvider.notifier)
                    .deleteSchedule(schedule.id);

                if (!mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Schedule slot deleted successfully'
                          : 'Failed to delete schedule slot',
                    ),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSlotDialog() {
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Schedule Slot'),
          content: TextField(
            controller: timeController,
            decoration: const InputDecoration(
              labelText: 'Time',
              hintText: 'e.g. 2:00 PM',
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
                final time = timeController.text.trim();

                if (time.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a time.')),
                  );
                  return;
                }

                final formattedDate =
                    '${selectedDate.year.toString().padLeft(4, '0')}-'
                    '${selectedDate.month.toString().padLeft(2, '0')}-'
                    '${selectedDate.day.toString().padLeft(2, '0')}';

                final newSchedule = ScheduleModel(
                  id: 0,
                  date: formattedDate,
                  time: time,
                  status: 'OPEN',
                );

                final result = await ref
                    .read(scheduleCreateProvider.notifier)
                    .createSchedule(newSchedule);

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
                          ? 'Schedule slot added successfully'
                          : 'Failed to add schedule slot',
                    ),
                  ),
                );
              },
              child: const Text('Add Slot'),
            ),
          ],
        );
      },
    ).then((_) {
      timeController.dispose();
    });
  }

  bool _isSameDate(String scheduleDate, DateTime date) {
    final parsedDate = DateTime.tryParse(scheduleDate);

    if (parsedDate == null) {
      return false;
    }

    return parsedDate.year == date.year &&
        parsedDate.month == date.month &&
        parsedDate.day == date.day;
  }

  String _dayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return days[date.weekday - 1];
  }
}
