enum BookingStatus { requested, upcoming, completed, cancelled }

enum BookingLocation { homeVisit, clinic }

class Booking {
  final String id;
  final String patientName;
  final String treatment;
  final DateTime dateTime;
  final BookingLocation location;
  final BookingStatus status;
  final String notes;

  Booking({
    required this.id,
    required this.patientName,
    required this.treatment,
    required this.dateTime,
    required this.location,
    required this.status,
    this.notes = '',
  });

  Booking copyWith({
    String? id,
    String? patientName,
    String? treatment,
    DateTime? dateTime,
    BookingLocation? location,
    BookingStatus? status,
    String? notes,
  }) {
    return Booking(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      treatment: treatment ?? this.treatment,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
