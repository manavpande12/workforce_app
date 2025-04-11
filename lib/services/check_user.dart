import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkTermsAccepted(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null &&
            data.containsKey('termsAccepted') &&
            data['termsAccepted'] == true) {
          log("Terms Accepted");
          return true;
        }
      }
    } catch (e) {
      log("Error checking terms: $e");
    }

    return false;
  }
}
