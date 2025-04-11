import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

List<String> categoryNames = [
  "Home Service",
  "Repair",
  "Events",
  "Education",
  "Construction",
  "Delivery & Security",
  "Food"
];

//Title
Stream<List<String>> fetchCategoryTitles() {
  return FirebaseFirestore.instance
      .collection('category')
      .orderBy("title")
      .snapshots() // Listen for real-time updates
      .map((snapshot) =>
          snapshot.docs.map((doc) => doc['title'] as String).toList());
}

//Category
Stream<List<String>> fetchCategoryNames() {
  return FirebaseFirestore.instance
      .collection('category')
      .orderBy("category")
      .snapshots()
      .map((snapshot) {
    List<String> categoryNames = [];
    for (var doc in snapshot.docs) {
      String categoryName = doc['category'];
      if (!categoryNames.contains(categoryName)) {
        categoryNames.add(categoryName);
      }
    }
    return categoryNames;
  });
}

//Title With Icons
Stream<List<Map<String, String>>> fetchCategoryTitlesWithIcons() {
  return FirebaseFirestore.instance
      .collection('category')
      .orderBy("title")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            return {
              'title': doc['title'] as String,
              'iconUrl': doc['iconUrl'] as String,
            };
          }).toList());
}

//Grouped Category Filter
Stream<Map<String, List<Map<String, String>>>> fetchGroupedCategories() {
  return FirebaseFirestore.instance
      .collection('category')
      .orderBy("category")
      .snapshots()
      .map((snapshot) {
    Map<String, List<Map<String, String>>> groupedCategories = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final category = data['category'] ?? 'Uncategorized';
      final title = data['title'] ?? 'Untitled';
      final iconUrl = data['iconUrl'] ?? '';

      if (!groupedCategories.containsKey(category)) {
        groupedCategories[category] = [];
      }

      groupedCategories[category]!.add({
        'title': title,
        'iconUrl': iconUrl,
        'docId': doc.id,
      });
    }

    return groupedCategories;
  });
}
