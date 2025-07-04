/// Dietitian Info Model
///
/// Represents dietitian information from the API
class DietitianInfo {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? specialty;
  final String? clinicName; // API returns 'clinic_name'
  final String? bio;
  final String? profilePicture; // API returns 'profile_picture'

  DietitianInfo({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.specialty,
    this.clinicName,
    this.bio,
    this.profilePicture,
  });

  factory DietitianInfo.fromJson(Map<String, dynamic> json) {
    return DietitianInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      specialty: json['specialty'],
      clinicName: json['clinic_name'], // API returns 'clinic_name'
      bio: json['bio'],
      profilePicture: json['profile_picture'], // API returns 'profile_picture'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'specialty': specialty,
      'clinic_name': clinicName,
      'bio': bio,
      'profile_picture': profilePicture,
    };
  }

  // Backward compatibility getter
  String? get location => clinicName;
  String? get avatar => profilePicture;

  @override
  String toString() {
    return 'DietitianInfo(id: $id, name: $name)';
  }
}
