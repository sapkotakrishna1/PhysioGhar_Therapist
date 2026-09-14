import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() {
    return _ScheduleScreenState();
  }
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  final List<String> timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  final Map<String, String> slotStatuses = {
    '09:00 AM': 'OPEN',
    '10:00 AM': 'BOOKED',
    '11:00 AM': 'OPEN',
    '12:00 PM': 'BLOCKED',
    '01:00 PM': 'OPEN',
    '02:00 PM': 'BOOKED',
    '03:00 PM': 'OPEN',
    '04:00 PM': 'OPEN',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule & Availability')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSlotDialog,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
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

            ...timeSlots.map(
              (time) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSlotCard(time),
              ),
            ),
          ],
        ),
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

  Widget _buildSlotCard(String time) {
    final status = slotStatuses[time] ?? 'OPEN';

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
        _showSlotOptions(time);
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
            child: Text(time, style: Theme.of(context).textTheme.titleMedium),
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

  void _showSlotOptions(String time) {
    final status = slotStatuses[time];

    if (status == 'BOOKED') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This slot is already booked.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time, style: Theme.of(context).textTheme.headlineSmall),

                const SizedBox(height: 20),

                ListTile(
                  leading: Icon(
                    status == 'BLOCKED' ? Icons.lock_open : Icons.block,
                  ),
                  title: Text(
                    status == 'BLOCKED' ? 'Unblock Slot' : 'Block Slot',
                  ),
                  onTap: () {
                    setState(() {
                      slotStatuses[time] = status == 'BLOCKED'
                          ? 'OPEN'
                          : 'BLOCKED';
                    });

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddSlotDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Schedule Slot'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Time',
              hintText: 'e.g. 05:00 PM',
              border: OutlineInputBorder(),
            ),
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
                final time = controller.text.trim();

                if (time.isEmpty) {
                  return;
                }

                if (timeSlots.contains(time)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This time slot already exists.'),
                    ),
                  );
                  return;
                }

                setState(() {
                  timeSlots.add(time);
                  slotStatuses[time] = 'OPEN';
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Schedule slot added successfully.'),
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String _dayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return days[date.weekday - 1];
  }
}
