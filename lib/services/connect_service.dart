import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveUserToChat(String otherUserId) async {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return;

  // Generate a unique and consistent chat room ID
  List<String> sortedIds = [currentUserId, otherUserId]..sort();
  String chatRoomId = sortedIds.join("_");

  final chatRef =
      FirebaseFirestore.instance.collection('chats').doc(chatRoomId);

  // Ensure both users have each other in their chat list
  await chatRef.set({
    'roomId': chatRoomId,
    'participants': sortedIds, // Store sorted UIDs as a list
    'lastMessage': 'Tap to begin chat.',
    'lastMessageTime': FieldValue.serverTimestamp(),
    'attemptBy': null,
  }, SetOptions(merge: true));
}

Stream<List<Map<String, String>>> fetchConnectedUsers() {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: currentUserId)
      .snapshots()
      .asyncMap((chatSnapshot) async {
    Map<String, String> userLastMessages = {};
    Set<String> userIds = {};

    for (var chatDoc in chatSnapshot.docs) {
      String? attemptBy = chatDoc.data()['attemptBy'] as String?;
      if (attemptBy == currentUserId) continue; // Skip deleted chats

      List<dynamic> participants = chatDoc['participants'] ?? [];
      String lastMessage = chatDoc['lastMessage']?.toString() ?? "";

      for (var userId in participants) {
        String uid = userId.toString();
        if (uid != currentUserId) {
          userIds.add(uid);
          userLastMessages[uid] = lastMessage;
        }
      }
    }

    if (userIds.isEmpty) return [];

    QuerySnapshot userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds.take(10).toList())
        .get();

    return userDocs.docs.map((userDoc) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userId = userDoc.id;
      return {
        "userId": userId,
        "name": userData['name']?.toString() ?? "Unknown",
        "imageUrl": userData['imageUrl']?.toString() ?? "",
        "lastMessage": userLastMessages[userId] ?? "", // Attach last message
      };
    }).toList();
  });
}

Future<void> deleteChat(String otherUserId) async {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return;

  final chatQuery = await FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: currentUserId)
      .get();

  DocumentSnapshot? chatDoc;
  for (var doc in chatQuery.docs) {
    List<dynamic> participants = doc['participants'] ?? [];
    if (participants.contains(otherUserId)) {
      chatDoc = doc;
      break;
    }
  }

  if (chatDoc == null) return;

  final chatRef = chatDoc.reference;
  String? attemptBy = chatDoc['attemptBy'] as String?;

  if (attemptBy == null) {
    // First attempt: Mark the deletion attempt by the current user
    await chatRef.update({'attemptBy': currentUserId});
    log("First delete attempt by $currentUserId, chat hidden for them.");
  } else if (attemptBy != currentUserId) {
    // Second attempt: Other user has already deleted, now delete the entire chat
    if (attemptBy == otherUserId) {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Delete all messages inside the chat
      QuerySnapshot messagesSnapshot =
          await chatRef.collection('messages').get();
      for (var messageDoc in messagesSnapshot.docs) {
        batch.delete(messageDoc.reference);
      }

      // Delete the chat document itself
      batch.delete(chatRef);

      await batch.commit();
      log("Chat deleted after second attempt by $currentUserId.");
    }
  }
}
