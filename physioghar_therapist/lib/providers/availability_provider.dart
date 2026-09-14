import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvailabilityNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggleAvailability() {
    state = !state;
  }

  void setAvailability(bool value) {
    state = value;
  }
}

final availabilityProvider = NotifierProvider<AvailabilityNotifier, bool>(
  AvailabilityNotifier.new,
);
