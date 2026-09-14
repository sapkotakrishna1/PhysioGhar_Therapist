class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String condition;
  final List<String> history;
  final List<String> notes;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.condition,
    required this.history,
    required this.notes,
  });

  Patient copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? phone,
    String? condition,
    List<String>? history,
    List<String>? notes,
  }) {
    return Patient(
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
