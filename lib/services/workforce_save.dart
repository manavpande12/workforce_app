import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

Future<void> savedWorker(String otherUserId, Function(String, bool) msg) async {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return;

  final favRef =
      FirebaseFirestore.instance.collection('saved').doc(currentUserId);

  try {
    await favRef.set({
      'saved': FieldValue.arrayUnion([otherUserId]),
    }, SetOptions(merge: true));

    msg("User Added Successfully In Saved WorkForce Tab!", false);
  } catch (e) {
    msg("Failed to save user: $e", true);
  }
}

Future<void> unsavedWorker(
    String otherUserId, Function(String, bool) msg) async {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return;

  final favRef =
      FirebaseFirestore.instance.collection('saved').doc(currentUserId);

  try {
    // Remove the user from the saved array
    await favRef.set({
      'saved': FieldValue.arrayRemove([otherUserId]),
    }, SetOptions(merge: true));

    final snapshot = await favRef.get();
    if (snapshot.exists) {
      List<dynamic>? savedList = snapshot.data()?['saved'];
      // If the saved array is empty, delete the document
      if (savedList == null || savedList.isEmpty) {
        await favRef.delete();
      }
    }

    msg("User Removed Successfully From Saved WorkForce Tab!", false);
  } catch (e) {
    msg("Failed to remove user: $e", true);
  }
}

Stream<List<Map<String, dynamic>>> fetchSavedWorkers() {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('saved')
      .doc(currentUserId)
      .snapshots()
      .switchMap((snapshot) {
    if (!snapshot.exists) return Stream.value([]);

    List<dynamic> savedWorkerIds = snapshot.data()?['saved'] ?? [];
    if (savedWorkerIds.isEmpty) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: savedWorkerIds.take(10).toList())
        .snapshots()
        .map((workerDocs) {
      return workerDocs.docs.map((workerDoc) {
        Map<String, dynamic> worker = workerDoc.data();
        return {
          "workerId": workerDoc.id,
          "name": worker["name"] ?? "Unknown",
          "dpImageUrl": worker["dpImageUrl"] ?? "",
          "profileImageUrl": worker["imageUrl"] ?? "",
          "age": worker["age"]?.toString() ?? "N/A",
          "experience": worker["experience"]?.toString() ?? "N/A",
        };
      }).toList();
    });
  });
}
