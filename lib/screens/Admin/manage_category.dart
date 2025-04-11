import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/screens/Admin/add_category.dart';
import 'package:workforce_app/services/get_category_data.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_conf_msg.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({super.key});

  @override
  State<ManageCategoryScreen> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
  Map<String, dynamic>? _lastDeletedCategory;
  String? _lastDeletedCategoryId;
  String? _lastDeletedImageUrl;
  Timer? _deleteTimer;

  // Function to delete category from Firestore & Storage
  Future<void> _deleteCategory(String docId, String iconUrl) async {
    try {
      // Fetch and store category details before deletion
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('category')
          .doc(docId)
          .get();

      _lastDeletedCategory = userDoc.data() as Map<String, dynamic>?;
      _lastDeletedCategoryId = docId;
      _lastDeletedImageUrl = iconUrl;

      await FirebaseFirestore.instance
          .collection('category')
          .doc(docId)
          .delete();

      // Show Snackbar with UNDO option
      if (mounted) {
        context.showSnackBar(
          "Category will delete in  5 second.",
          actionLabel: "UNDO",
          onActionPressed: _undoDelete,
          isError: false,
        );
      }

      // Start a delayed deletion after 5 seconds
      _deleteTimer = Timer(const Duration(seconds: 5), () async {
        try {
          // Delete image from Firebase Storage
          if (_lastDeletedImageUrl != null) {
            await FirebaseStorage.instance
                .refFromURL(_lastDeletedImageUrl!)
                .delete();
          }
          if (mounted) {
            context.showSnackBar("Category deleted successfully!",
                isError: false);
          }
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          if (mounted) {
            context.showSnackBar("Error deleting category: $e", isError: true);
          }
        } finally {
          _lastDeletedCategory = null;
          _lastDeletedCategoryId = null;
          _lastDeletedImageUrl = null;
        }
      });
    } catch (e) {
      if (mounted) {
        context.showSnackBar("Error scheduling category deletion: $e",
            isError: true);
      }
    }
  }

  Future<void> _undoDelete() async {
    if (_lastDeletedCategory == null || _lastDeletedCategoryId == null) return;

    try {
      // Cancel the deletion process
      _deleteTimer?.cancel();

      // Restore document in Firestore
      await FirebaseFirestore.instance
          .collection('category')
          .doc(_lastDeletedCategoryId!)
          .set(_lastDeletedCategory!);

      if (mounted) {
        context.showSnackBar("Category restored successfully", isError: false);
      }
      //refresh Ui
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar("Error restoring category: $e", isError: true);
      }
    } finally {
      _lastDeletedCategory = null;
      _lastDeletedCategoryId = null;
      _lastDeletedImageUrl = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? bgrey
                    : grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Manage Category",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 30,
                        color: black,
                      ),
                      onPressed: () {
                        AddCategory.show(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Fetch & Display Categories
            Expanded(
              child: StreamBuilder<Map<String, List<Map<String, String>>>>(
                stream: fetchGroupedCategories(),
                builder: (ctx, snapshot) {
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
                    return const Center(child: Text("No categories found"));
                  }

                  final groupedCategories = snapshot.data!;

                  return ListView.builder(
                    itemCount: groupedCategories.length,
                    itemBuilder: (ctx, index) {
                      String categoryName =
                          groupedCategories.keys.elementAt(index);
                      List<Map<String, String>> items =
                          groupedCategories[categoryName]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Header
                          Container(
                            margin: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? bgrey
                                  : grey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                categoryName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 14),
                              ),
                            ),
                          ),

                          // Sub Items (Titles under each Category)
                          Column(
                            children: items.map((item) {
                              return Dismissible(
                                key: Key(item['docId']!), // Ensure docId exists
                                confirmDismiss: (direction) async {
                                  return await showConfirmationDialog(
                                    context: context,
                                    title: "Confirm Delete",
                                    content:
                                        "Are you sure you want to delete this category?",
                                  );
                                },
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(Icons.delete, color: white),
                                ),
                                onDismissed: (_) => _deleteCategory(
                                    item['docId']!, item['iconUrl']!),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? bgrey
                                            : grey,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl: item['iconUrl']!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          ShimmerLoadingCard(
                                              width: 40, height: 40),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error, color: red),
                                    ),
                                    title: Text(
                                      item['title']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
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
