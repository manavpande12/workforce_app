import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final Map<String, String> _userImageCache = {}; // Local cache for user images

/// Function to send a message
Future<void> sendMessage({
  required String senderId,
  required String receiverId,
  required TextEditingController msgController,
}) async {
  if (msgController.text.trim().isEmpty) return;

  List<String> sortedIds = [senderId, receiverId]..sort();
  String chatRoomId = sortedIds.join("_");

  await _firestore
      .collection("chats")
      .doc(chatRoomId)
      .collection("messages")
      .add({
    "text": msgController.text.trim(),
    "senderId": senderId,
    "receiverId": receiverId,
    "timestamp": FieldValue.serverTimestamp(),
  });

  DocumentSnapshot chatDoc =
      await _firestore.collection("chats").doc(chatRoomId).get();

  Map<String, dynamic>? chatData = chatDoc.data() as Map<String, dynamic>?;

  // If `attemptBy` is not null, set it to null
  if (chatData?["attemptBy"] != null) {
    await _firestore.collection("chats").doc(chatRoomId).update({
      "attemptBy": null,
    });
  }

  // Update last message for chat list
  await _firestore.collection("chats").doc(chatRoomId).set({
    "lastMessage": msgController.text.trim(),
    "lastMessageTime": FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));

  msgController.clear();
}

/// Fetch messages along with both users' profile images
Stream<List<Map<String, dynamic>>> getMessages(
    String currentUserId, String otherUserId) async* {
  List<String> sortedIds = [currentUserId, otherUserId]..sort();
  String chatRoomId = sortedIds.join("_");

  try {
    // Fetch both user profile images only if not cached
    if (!_userImageCache.containsKey(currentUserId) ||
        !_userImageCache.containsKey(otherUserId)) {
      List<DocumentSnapshot<Map<String, dynamic>>> userDocs =
          await Future.wait([
        _firestore.collection("users").doc(currentUserId).get(),
        _firestore.collection("users").doc(otherUserId).get(),
      ]);

      _userImageCache[currentUserId] = userDocs[0].data()?["imageUrl"] ?? "";
      _userImageCache[otherUserId] = userDocs[1].data()?["imageUrl"] ?? "";
    }

    yield* _firestore
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((messageSnapshot) {
      return messageSnapshot.docs.map((message) {
        var data = message.data();
        return {
          "text": data["text"],
          "senderId": data["senderId"],
          "receiverId": data["receiverId"],
          "timestamp": data["timestamp"],
          "currentUserImageUrl":
              _userImageCache[currentUserId], // Current user's image
          "otherUserImageUrl":
              _userImageCache[otherUserId], // Other user's image
        };
      }).toList();
    });
  } catch (error) {
    log("Error fetching messages: $error");
    yield [];
  }
}
