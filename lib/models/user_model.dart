import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // 'citizen', 'worker', 'authority'
  final String address;
  final String city;
  final GeoPoint location;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? skillCategory; // For workers
  final bool? isAvailable; // For workers
  final String? jurisdiction; // For authorities

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
    required this.city,
    required this.location,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    this.skillCategory,
    this.isAvailable,
    this.jurisdiction,
  });

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String? ?? '',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      role: data['role'] as String? ?? 'citizen',
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      location: data['location'] as GeoPoint? ?? 
          GeoPoint(0, 0),
      isEmailVerified: data['isEmailVerified'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      skillCategory: data['skillCategory'] as String?,
      isAvailable: data['isAvailable'] as bool?,
      jurisdiction: data['jurisdiction'] as String?,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'city': city,
      'location': location,
      'isEmailVerified': isEmailVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (skillCategory != null) 'skillCategory': skillCategory,
      if (isAvailable != null) 'isAvailable': isAvailable,
      if (jurisdiction != null) 'jurisdiction': jurisdiction,
    };
  }

  /// Create a copy with modified fields
  UserModel copyWith({
    String? name,
    String? phone,
    String? address,
    String? city,
    GeoPoint? location,
    bool? isEmailVerified,
    String? skillCategory,
    bool? isAvailable,
    String? jurisdiction,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      role: role,
      address: address ?? this.address,
      city: city ?? this.city,
      location: location ?? this.location,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      skillCategory: skillCategory ?? this.skillCategory,
      isAvailable: isAvailable ?? this.isAvailable,
      jurisdiction: jurisdiction ?? this.jurisdiction,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
