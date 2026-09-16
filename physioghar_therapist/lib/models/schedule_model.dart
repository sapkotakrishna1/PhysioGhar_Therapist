class ScheduleModel {
  final int id;
  final String date;
  final String time;
  final String status;
  final int? patientId;
  final String? patientName;
  final String? notes;

  ScheduleModel({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    this.patientId,
    this.patientName,
    this.notes,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      notes: json['notes'],
    );
  }

  ScheduleModel copyWith({
    int? id,
    String? date,
    String? time,
    String? status,
    int? patientId,
    String? patientName,
    String? notes,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      notes: notes ?? this.notes,
    );
  }
}
