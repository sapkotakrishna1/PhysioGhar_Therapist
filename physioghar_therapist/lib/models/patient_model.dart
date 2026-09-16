class PatientModel {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String condition;
  final List<dynamic> history;
  final List<dynamic> notes;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.condition,
    required this.history,
    required this.notes,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      condition: json['condition'] ?? '',
      history: json['history'] ?? [],
      notes: json['notes'] ?? [],
    );
  }
  PatientModel copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    String? phone,
    String? condition,
    List<dynamic>? history,
    List<dynamic>? notes,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      condition: condition ?? this.condition,
      history: history ?? this.history,
      notes: notes ?? this.notes,
    );
  }
}
