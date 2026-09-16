class BookingModel {
  final int id;
  final int patientId;
  final String patientName;
  final String therapistName;
  final String date;
  final String time;
  final String status;
  final String notes;

  BookingModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.therapistName,
    required this.date,
    required this.time,
    required this.status,
    required this.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 0,
      patientId: json['patient_id'] ?? 0,
      patientName: json['patient_name'] ?? '',
      therapistName: json['therapist_name'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  BookingModel copyWith({
    int? id,
    int? patientId,
    String? patientName,
    String? therapistName,
    String? date,
    String? time,
    String? status,
    String? notes,
  }) {
    return BookingModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      therapistName: therapistName ?? this.therapistName,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
