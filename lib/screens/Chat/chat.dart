import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/providers/user_info_provider.dart';
import 'package:workforce_app/widgets/custom_list_tile.dart';
import 'package:workforce_app/services/connect_service.dart';
import 'package:workforce_app/widgets/custom_conf_msg.dart';
import 'package:workforce_app/widgets/search_bar.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredUsers = [];
  List<Map<String, String>> users = [];
  Timer? _debounce;
  String? currentUserId;

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
                  user['userId'] != currentUserId)
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SearchBarWidget(
              controller: _searchController,
              onSearch: _filterSearch,
              hintText: "Search Messages",
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                'Messages',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, String>>>(
                stream: fetchConnectedUsers(),
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
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Messages found"));
                  }

                  users = snapshot.data!;
                  filteredUsers = users
                      .where((user) =>
                          user['userId'] != currentUserId &&
                          user['name']
                              .toString()
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      var user = filteredUsers[index];

                      return CustomListTile(
                        userId: user['userId']!,
                        name: user['name']!,
                        imageUrl: user['imageUrl']!,
                        onTap: () {
                          Navigator.pushNamed(context, msg, arguments: {
                            "userId": user['userId']!,
                            "currentUserId": currentUserId,
                            "userName": user['name']!,
                            "userImage": user['imageUrl']!,
                          });
                        },
                        onConfirmDismissed: (direction) async {
                          return await showConfirmationDialog(
                            context: context,
                            title: "Confirm Delete",
                            content:
                                "Are you sure you want to delete this chats?",
                          );
                        },
                        onDismissed: (direction) {
                          deleteChat(user['userId']!);

                          setState(() {
                            users.removeWhere(
                                (u) => u['userId'] == user['userId']);
                            filteredUsers.removeWhere(
                                (u) => u['userId'] == user['userId']);
                          });
                        },
                        onSub: true,
                        sub: user['lastMessage']!,
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
