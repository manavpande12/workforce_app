import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfile {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateProfile({
    required String name,
    required String email,
    required String imageUrl,
    required String dpimageUrl,
    required String gender,
    required String employed,
    required String contact,
    required String age,
    required String experience,
    required String bio,
    required double lat,
    required double lng,
    required String address,
    required List<String> skills,
    required List<String> languages,
    required bool termsAccepted,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        log("No user logged in");
        return;
      }

      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'dpImageUrl': dpimageUrl,
        'gender': gender,
        'employed': employed,
        'contact': contact,
        'age': age,
        'experience': experience,
        'bio': bio,
        'lat':lat,
        'lng':lng,
        'address':address,
        'skills': skills,
        'languages': languages,
        'termsAccepted': termsAccepted,
        'updatedAt': Timestamp.now(),
      });

      log("User profile updated successfully");
    } catch (e) {
      log("Profile update error: ${e.toString()}");
      rethrow;
    }
  }
}
