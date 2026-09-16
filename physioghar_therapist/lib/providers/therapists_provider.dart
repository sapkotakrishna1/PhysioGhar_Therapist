import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/therapist_model.dart';
import 'dashboard_provider.dart';

class TherapistNotifier extends AsyncNotifier<TherapistModel> {
  @override
  Future<TherapistModel> build() async {
    final apiService = ref.read(apiServiceProvider);

    final data = await apiService.getTherapist();

    return TherapistModel.fromJson(data);
  }

  Future<void> updateTherapist(TherapistModel updatedTherapist) async {
    state = const AsyncLoading();

    try {
      final apiService = ref.read(apiServiceProvider);

      final data = await apiService.updateTherapist(
        name: updatedTherapist.name,
        phone: updatedTherapist.phone,
        email: updatedTherapist.email,
        specialization: updatedTherapist.specialization,
        experience: updatedTherapist.experience,
        bio: updatedTherapist.bio,
        isAvailable: updatedTherapist.isAvailable,
      );

      state = AsyncData(TherapistModel.fromJson(data));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final therapistProvider =
    AsyncNotifierProvider<TherapistNotifier, TherapistModel>(
      TherapistNotifier.new,
    );
