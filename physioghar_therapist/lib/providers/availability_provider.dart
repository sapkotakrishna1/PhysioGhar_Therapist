import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/therapist_model.dart';
//import '../services/api_service.dart';
import 'dashboard_provider.dart';
import 'therapists_provider.dart';

class AvailabilityNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final therapistAsync = await ref.watch(therapistProvider.future);

    return therapistAsync.isAvailable;
  }

  Future<void> toggleAvailability() async {
    final currentValue = state.value ?? true;
    final newValue = !currentValue;

    state = const AsyncLoading();

    try {
      final therapist = await ref.read(therapistProvider.future);

      final apiService = ref.read(apiServiceProvider);

      final data = await apiService.updateTherapist(
        name: therapist.name,
        phone: therapist.phone,
        email: therapist.email,
        specialization: therapist.specialization,
        experience: therapist.experience,
        bio: therapist.bio,
        isAvailable: newValue,
      );

      final updatedTherapist = TherapistModel.fromJson(data);

      state = AsyncData(updatedTherapist.isAvailable);

      ref.invalidate(therapistProvider);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final availabilityProvider = AsyncNotifierProvider<AvailabilityNotifier, bool>(
  AvailabilityNotifier.new,
);
