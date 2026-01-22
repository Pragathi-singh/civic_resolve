import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import '../models/user_model.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();

  final String _usersCollection = 'users';

  /// Create a new user document in Firestore
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String role,
    required String address,
    required String city,
    required GeoPoint location,
    String? skillCategory,
    bool? isAvailable,
    String? jurisdiction,
  }) async {
    try {
      final userData = {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'address': address,
        'city': city,
        'location': location,
        'isEmailVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add role-specific fields
      if (role == 'worker' && skillCategory != null) {
        userData['skillCategory'] = skillCategory;
        userData['isAvailable'] = isAvailable ?? true;
      }

      if (role == 'authority' && jurisdiction != null) {
        userData['jurisdiction'] = jurisdiction;
      }

      await _firestore.collection(_usersCollection).doc(uid).set(userData);
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  /// Get user by UID
  Future<UserModel?> getUserByUid(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch user: $e';
    }
  }

  /// Get user stream for real-time updates
  Stream<UserModel?> getUserStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data()!);
      }
      return null;
    });
  }

  /// Update user profile
  Future<void> updateUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .update(data);
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  /// Update email verification status
  Future<void> updateEmailVerification(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update({
        'isEmailVerified': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update email verification: $e';
    }
  }

  /// Update worker availability
  Future<void> updateWorkerAvailability({
    required String uid,
    required bool isAvailable,
  }) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update({
        'isAvailable': isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update availability: $e';
    }
  }

  /// Get all workers in an area (for citizen to see nearby workers)
  Future<List<UserModel>> getNearbyWorkers({
    required GeoPoint centerLocation,
    double radiusInKm = 5,
  }) async {
    try {
      final workers = await _firestore
          .collection(_usersCollection)
          .where('role', isEqualTo: 'worker')
          .where('isAvailable', isEqualTo: true)
          .get();

      // Filter by distance (simple implementation)
      final nearbyWorkers = workers.docs
          .map((doc) => UserModel.fromFirestore(doc.data()))
          .where((worker) =>
              _calculateDistance(centerLocation, worker.location) <= radiusInKm)
          .toList();

      return nearbyWorkers;
    } catch (e) {
      throw 'Failed to fetch nearby workers: $e';
    }
  }

  /// Get all authorities (for filtering by jurisdiction)
  Future<List<UserModel>> getAuthoritiesByJurisdiction(String jurisdiction) async {
    try {
      final authorities = await _firestore
          .collection(_usersCollection)
          .where('role', isEqualTo: 'authority')
          .where('jurisdiction', isEqualTo: jurisdiction)
          .get();

      return authorities.docs
          .map((doc) => UserModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to fetch authorities: $e';
    }
  }

  /// Delete user account (soft delete - keep data for audit)
  Future<void> deleteUserAccount(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to delete account: $e';
    }
  }

  /// Calculate distance between two GeoPoints using Haversine formula
  double _calculateDistance(GeoPoint point1, GeoPoint point2) {
    const double earthRadiusKm = 6371;

    double dLat = _toRadians(point2.latitude - point1.latitude);
    double dLon = _toRadians(point2.longitude - point1.longitude);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(point1.latitude)) *
            math.cos(_toRadians(point2.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}
