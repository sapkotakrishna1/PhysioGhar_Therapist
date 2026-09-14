import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/therapist.dart';

class TherapistNotifier extends Notifier<Therapist> {
  @override
  Therapist build() {
    return MockData.therapist;
  }

  void updateTherapist(Therapist updatedTherapist) {
    state = updatedTherapist;
  }
}

final therapistProvider = NotifierProvider<TherapistNotifier, Therapist>(
  TherapistNotifier.new,
);
