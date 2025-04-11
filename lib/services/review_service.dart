import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';

Future<void> submitReview(String workerId, double rating, String review,
    String label, BuildContext context) async {
  try {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      if (context.mounted) {
        context.showSnackBar("You must be logged in to submit a review.",
            isError: true);
      }
      return;
    }

    final String userId = currentUser.uid;

    // Reference to the Firestore collection
    CollectionReference ratingsRef =
        FirebaseFirestore.instance.collection('ratings');

    // Check if the user has already reviewed this worker
    QuerySnapshot existingReviews = await ratingsRef
        .where('userId', isEqualTo: userId)
        .where('workerId', isEqualTo: workerId)
        .limit(1)
        .get();

    if (existingReviews.docs.isNotEmpty) {
      // If review exists, update it
      String reviewId = existingReviews.docs.first.id;
      await ratingsRef.doc(reviewId).update({
        'rating': rating,
        'review': review,
        'label': label,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        context.showSnackBar("Thank you for reviewing again! 😊",
            isError: false);
      }
    } else {
      // If no existing review, create a new one
      await ratingsRef.add({
        'userId': userId,
        'workerId': workerId,
        'rating': rating,
        'review': review,
        'label': label,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        context.showSnackBar("Thank you for your review! 😊", isError: false);
      }
    }
  } catch (e) {
    if (context.mounted) {
      context.showSnackBar("Error submitting review: $e", isError: true);
    }
  }
}

Stream<int> calculateAverageRating(String workerId) {
  return FirebaseFirestore.instance
      .collection('ratings')
      .where('workerId', isEqualTo: workerId)
      .snapshots()
      .map((querySnapshot) {
    if (querySnapshot.docs.isEmpty) return 0;

    int totalRating = querySnapshot.docs.fold(0, (sums, doc) {
      return sums + (doc['rating'] as num).toInt();
    });

    return (totalRating / querySnapshot.docs.length).round();
  });
}

Stream<List<Map<String, dynamic>>> fetchWorkerReviews(String workerId) {
  return FirebaseFirestore.instance
      .collection('ratings')
      .where('workerId', isEqualTo: workerId)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((querySnapshot) async {
    List<Map<String, dynamic>> reviews = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      // Fetch user details from 'users' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(data['userId'])
          .get();

      data['name'] = userDoc['name'] ?? 'Unknown User';
      data['imageUrl'] = userDoc['imageUrl'] ?? '';
      reviews.add(data);
    }

    return reviews;
  });
}
