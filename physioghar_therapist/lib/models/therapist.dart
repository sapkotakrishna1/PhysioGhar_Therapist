class Therapist {
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final String experience;
  final String address;
  final String avatarUrl;

  Therapist({
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.experience,
    required this.address,
    required this.avatarUrl,
  });

  Therapist copyWith({
    String? name,
    String? email,
    String? phone,
    String? specialization,
    String? experience,
    String? address,
    String? avatarUrl,
  }) {
    return Therapist(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
