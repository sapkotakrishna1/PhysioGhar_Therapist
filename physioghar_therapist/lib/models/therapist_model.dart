class TherapistModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String specialization;
  final int experience;
  final String bio;
  final bool isAvailable;

  TherapistModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.specialization,
    required this.experience,
    required this.bio,
    required this.isAvailable,
  });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    return TherapistModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      specialization: json['specialization'] ?? '',
      experience: json['experience'] ?? 0,
      bio: json['bio'] ?? '',
      isAvailable: json['is_available'] ?? true,
    );
  }

  TherapistModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? specialization,
    int? experience,
    String? bio,
    bool? isAvailable,
  }) {
    return TherapistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      bio: bio ?? this.bio,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
