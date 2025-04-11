import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/widgets/custom_conf_msg.dart';
import 'package:workforce_app/widgets/custom_list_Tile.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';
import 'package:workforce_app/widgets/search_bar.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> users = [];
  List<DocumentSnapshot> filteredUsers = [];
  Timer? _debounce;
  String? currentUserId;
  Map<String, dynamic>? _lastDeletedUser;
  String? _lastDeletedUserId;
  String? _lastDeletedImageUrl;
  String? _lastDeletedDpImageUrl;
  Timer? _deleteTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSearch);
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && mounted) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  void _filterSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          filteredUsers = users
              .where((user) =>
                  user['name']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) &&
                  user.id != currentUserId)
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _deleteUser(
      String userId, String imageUrl, String dpImageUrl) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      _lastDeletedUser = userDoc.data() as Map<String, dynamic>?;
      _lastDeletedUserId = userId;
      _lastDeletedImageUrl = imageUrl;
      _lastDeletedDpImageUrl = dpImageUrl;

      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      if (mounted) {
        context.showSnackBar(
          "User will delete in  5 second.",
          actionLabel: "UNDO",
          onActionPressed: _undoDelete,
          isError: false,
        );
      }
      // Start a delayed deletion after 5 seconds
      _deleteTimer = Timer(const Duration(seconds: 5), () async {
        try {
          // Delete document from Firestore

          // Delete image from Firebase Storage
          if (_lastDeletedImageUrl != null) {
            await FirebaseStorage.instance
                .refFromURL(_lastDeletedImageUrl!)
                .delete();
          }
          if (_lastDeletedDpImageUrl != null) {
            await FirebaseStorage.instance
                .refFromURL(_lastDeletedDpImageUrl!)
                .delete();
          }
          if (mounted) {
            context.showSnackBar("User deleted successfully!", isError: false);
          }
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          if (mounted) {
            context.showSnackBar("Error deleting user: $e", isError: true);
          }
        } finally {
          _lastDeletedUser = null;
          _lastDeletedUserId = null;
          _lastDeletedImageUrl = null;
          _lastDeletedDpImageUrl = null;
        }
      });
    } catch (e) {
      if (mounted) {
        context.showSnackBar("Error deleting user: $e", isError: true);
      }
    }
  }

  Future<void> _undoDelete() async {
    if (_lastDeletedUser == null || _lastDeletedUserId == null) return;

    try {
      // Cancel the deletion process
      _deleteTimer?.cancel();

      // Restore document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_lastDeletedUserId!)
          .set(_lastDeletedUser!);
      if (mounted) {
        context.showSnackBar("User restored successfully", isError: false);
      }
      //refresh Ui
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar("Error restoring user: $e", isError: true);
      }
    } finally {
      _lastDeletedUser = null;
      _lastDeletedUserId = null;
      _lastDeletedImageUrl = null;
      _lastDeletedDpImageUrl = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              onSearch: _filterSearch,
              hintText: "Search Users",
            ),
            const SizedBox(height: 20),

            // User List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 12,
                      itemBuilder: (ctx, index) => Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ShimmerLoadingCard(
                          borderRadius: 0,
                          height: 50,
                          width: double.infinity,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No User found"));
                  }

                  users = snapshot.data!.docs;
                  filteredUsers = users
                      .where((user) =>
                          user.id != currentUserId &&
                          user['name']
                              .toString()
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (ctx, index) {
                      final userDoc = filteredUsers[index];
                      final data = userDoc.data() as Map<String, dynamic>;
                      final userId = userDoc.id;
                      final name = data['name'] ?? 'Unnamed User';
                      final imageUrl = data['imageUrl'] ?? '';
                      final dpImageUrl = data['dpImageUrl'] ?? '';

                      return CustomListTile(
                        userId: userId,
                        name: name,
                        imageUrl: imageUrl,
                        onTap: () {
                          Navigator.pushNamed(context, viewProfile,
                              arguments: userDoc.id);
                        },
                        onConfirmDismissed: (direction) async {
                          return await showConfirmationDialog(
                            context: context,
                            title: "Confirm Delete",
                            content:
                                "Are you sure you want to delete this user?",
                          );
                        },
                        onDismissed: (direction) {
                          _deleteUser(userId, imageUrl, dpImageUrl);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
