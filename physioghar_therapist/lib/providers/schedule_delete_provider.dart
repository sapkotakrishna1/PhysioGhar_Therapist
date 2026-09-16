import 'package:flutter_riverpod/flutter_riverpod.dart';

//import '../services/api_service.dart';
import 'dashboard_provider.dart';
import 'schedules_provider.dart';

final scheduleDeleteProvider =
    NotifierProvider<ScheduleDeleteNotifier, AsyncValue<bool>>(
      ScheduleDeleteNotifier.new,
    );

class ScheduleDeleteNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() {
    return const AsyncData(false);
  }

  Future<bool> deleteSchedule(int scheduleId) async {
    state = const AsyncLoading();

    try {
      final apiService = ref.read(apiServiceProvider);

      await apiService.deleteSchedule(scheduleId);

      state = const AsyncData(true);

      ref.invalidate(schedulesProvider);

      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      return false;
    }
  }
}
