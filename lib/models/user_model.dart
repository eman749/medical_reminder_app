class UserModel {
  final String id;
  final String name;
  final String email;
  final String? dateOfBirth;
  final String? phone;
  final String? bloodType;
  final String? password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dateOfBirth,
    this.phone,
    this.bloodType,
    this.password = '123456',
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? dateOfBirth,
    String? phone,
    String? bloodType,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      bloodType: bloodType ?? this.bloodType,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'phone': phone,
      'bloodType': bloodType,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dateOfBirth: map['dateOfBirth'],
      phone: map['phone'],
      bloodType: map['bloodType'],
      password: map['password'] ?? '123456',
    );
  }
}
