import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'storage_datasource.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
    String name, {
    File? profileImageFile,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      String? photoUrl;

      if (profileImageFile != null && uid != null) {
        photoUrl = await _storageService.uploadProfileImage(uid, profileImageFile);
      }

      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'role': 'admin',
        'createdAt': FieldValue.serverTimestamp(),
        'profilePicture': photoUrl,
      });

      if (name.isNotEmpty) {
        await userCredential.user?.updateDisplayName(name);
      }
      if (photoUrl != null) {
        await userCredential.user?.updatePhotoURL(photoUrl);
      }

      return userCredential;
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<bool> isAdmin(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists && doc.data()?['role'] == 'admin';
    } catch (e) {
      throw Exception('Failed to check admin status: $e');
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? name,
    String? email,
    File? profileImageFile,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      final currentUser = _auth.currentUser;

      if (name != null && name.isNotEmpty) {
        data['name'] = name;
      }
      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      }

      if (profileImageFile != null) {
        final photoUrl = await _storageService.uploadProfileImage(uid, profileImageFile);
        data['profilePicture'] = photoUrl;
        if (currentUser != null) {
          await currentUser.updatePhotoURL(photoUrl);
        }
      }

      if (email != null && currentUser != null && currentUser.email != email) {
        await currentUser.verifyBeforeUpdateEmail(email);
      }
      if (name != null && currentUser != null && currentUser.displayName != name) {
        await currentUser.updateDisplayName(name);
      }

      if (data.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(data);
      }
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw FirebaseAuthException(code: 'no-user', message: 'No authenticated user');
      }
    } catch (e) {
      throw Exception('Password update failed: $e');
    }
  }

  Future<void> reauthenticate(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
      } else {
        throw FirebaseAuthException(code: 'no-user', message: 'No authenticated user');
      }
    } catch (e) {
      throw Exception('Reauthentication failed: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}