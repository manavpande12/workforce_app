import 'dart:developer';
import 'dart:math' hide log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class GetNearby {
  static Stream<List<QueryDocumentSnapshot>> getNearbyWorkers(
      String categoryName, double radiusInKm) async* {
    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;

      Position currentPosition = await Geolocator.getCurrentPosition();

      yield* FirebaseFirestore.instance
          .collection('users')
          .where('skills', arrayContains: categoryName)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;

          if (data == null ||
              !data.containsKey('lat') ||
              !data.containsKey('lng') ||
              data['lat'] == null ||
              data['lng'] == null) {
            log("Skipping document: Missing or null 'lat'/'lng' - ID: ${doc.id}");
            return false;
          }

          if (doc.id == currentUserId) {
            log("Skipping current user: ${doc.id}");
            return false;
          }

          double userLat = data['lat'];
          double userLng = data['lng'];

          double distance = _calculateDistance(
            currentPosition.latitude,
            currentPosition.longitude,
            userLat,
            userLng,
          );

          return distance <= radiusInKm;
        }).toList();
      });
    } catch (e) {
      log("Error fetching real-time nearby workers: $e");
    }
  }

  static double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of Earth in km
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }
}
