import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Getters
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> _ensureInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  Future<void> registerCitizen({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required GeoPoint location,
  }) async {
    await _ensureInitialized();
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _createUserDoc(
      uid: credential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      role: 'citizen',
      address: address,
      location: location,
    );

    await _sendEmailVerification(credential.user!);
    await _auth.signOut();
  }

  Future<void> registerWorker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required GeoPoint location,
    required String skill,
    required bool available,
  }) async {
    await _ensureInitialized();
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _createUserDoc(
      uid: credential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      role: 'worker',
      address: address,
      location: location,
      skill: skill,
      available: available,
    );

    await _sendEmailVerification(credential.user!);
    await _auth.signOut();
  }

  Future<String> loginAndFetchRole({
    required String email,
    required String password,
  }) async {
    try {
      await _ensureInitialized();
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User not found. Please try again.',
        );
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message:
              'Email not verified. Verification link sent. Please verify before logging in.',
        );
      }

        await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'isEmailVerified': true});

        final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        throw FirebaseAuthException(
          code: 'profile-missing',
          message: 'Profile not found. Please contact support.',
        );
      }

      final data = doc.data() as Map<String, dynamic>;
      final role = data['role'] as String?;
      if (role == null) {
        throw FirebaseAuthException(
          code: 'role-missing',
          message: 'Role not set for this account.',
        );
      }

      return role;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    }
  }

  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No signed-in user to resend verification.',
      );
    }
    await user.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _createUserDoc({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String role,
    required String address,
    required GeoPoint location,
    String? skill,
    bool? available,
  }) async {
    final data = <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'location': location,
      'isEmailVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (role == 'worker') {
      data['skill'] = skill;
      data['available'] = available;
    }

    await _firestore.collection('users').doc(uid).set(data);
  }

  Future<void> _sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  /// User-friendly error messages for Firebase Auth exceptions
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'email-already-in-use':
        return 'Email is already registered. Please login instead.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'user-disabled':
        return 'User account has been disabled.';
      case 'user-not-found':
        return 'User not found. Please check your email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'email-not-verified':
        return 'Email not verified. Check your inbox for verification link.';
      case 'profile-missing':
        return 'User profile not found. Please contact support.';
      case 'role-missing':
        return 'User role not set. Please contact support.';
      case 'requires-recent-login':
        return 'Please login again to perform this action.';
      case 'user-null':
        return 'User not found. Please try again.';
      default:
        return e.message ?? 'Authentication error occurred. Please try again.';
    }
  }
}
