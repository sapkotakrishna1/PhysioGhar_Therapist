import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/schedule_model.dart';
//import '../services/api_service.dart';
import 'dashboard_provider.dart';
import 'schedules_provider.dart';

final scheduleCreateProvider =
    NotifierProvider<ScheduleCreateNotifier, AsyncValue<ScheduleModel?>>(
      ScheduleCreateNotifier.new,
    );

class ScheduleCreateNotifier extends Notifier<AsyncValue<ScheduleModel?>> {
  @override
  AsyncValue<ScheduleModel?> build() {
    return const AsyncData(null);
  }

  Future<ScheduleModel?> createSchedule(ScheduleModel schedule) async {
    state = const AsyncLoading();

    try {
      final apiService = ref.read(apiServiceProvider);

      final createdSchedule = await apiService.createSchedule(schedule);

      state = AsyncData(createdSchedule);

      ref.invalidate(schedulesProvider);

      return createdSchedule;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      return null;
    }
  }
}
