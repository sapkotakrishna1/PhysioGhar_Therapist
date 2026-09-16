import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/schedule_model.dart';
//import '../services/api_service.dart';
import 'dashboard_provider.dart';
import 'schedules_provider.dart';

final scheduleUpdateProvider =
    NotifierProvider<ScheduleUpdateNotifier, AsyncValue<ScheduleModel?>>(
      ScheduleUpdateNotifier.new,
    );

class ScheduleUpdateNotifier extends Notifier<AsyncValue<ScheduleModel?>> {
  @override
  AsyncValue<ScheduleModel?> build() {
    return const AsyncData(null);
  }

  Future<ScheduleModel?> updateSchedule(ScheduleModel schedule) async {
    state = const AsyncLoading();

    try {
      final apiService = ref.read(apiServiceProvider);

      final updatedSchedule = await apiService.updateSchedule(schedule);

      state = AsyncData(updatedSchedule);

      ref.invalidate(schedulesProvider);

      return updatedSchedule;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      return null;
    }
  }
}
