import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/services/get_category_data.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/screens/search.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 20, 0),
            child: IconButton(
              onPressed: () {
                SearchScreen.show(context);
              },
              icon: const Icon(
                Icons.search_sharp,
                size: 28,
              ),
            ),
          ),
        ],
        title: const Text("All Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<Map<String, List<Map<String, String>>>>(
          stream: fetchGroupedCategories(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 3,
                itemBuilder: (ctx, index) {
                  return Column(children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ShimmerLoadingCard(
                        height: 30,
                        borderRadius: 0,
                      ),
                    ),
                    GridView.builder(
                        shrinkWrap: true, // Allows it to be inside Column
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 2.5,
                          mainAxisExtent: 120,
                        ),
                        itemCount: 6,
                        itemBuilder: (ctx, index) {
                          return ShimmerLoadingCard();
                        }),
                  ]);
                },
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No categories found"));
            }

            final groupedCategories = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupedCategories.entries.map((entry) {
                  String categoryName = entry.key;
                  List<Map<String, String>> items = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          categoryName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),

                      // GridView for categories
                      GridView.builder(
                        shrinkWrap: true, // Allows it to be inside Column
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 items per row
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 2.5,
                          mainAxisExtent: 120,
                        ),
                        itemCount: items.length,
                        itemBuilder: (ctx, index) {
                          final category = items[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                worker,
                                arguments: category['title'],
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? bgrey
                                    : grey,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withValues(alpha: 0.2),
                                    blurRadius: 2,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        colors: [
                                          yellow,
                                          red,
                                        ],
                                        radius: 0.5,
                                        tileMode: TileMode.decal,
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: category['iconUrl']!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          ShimmerLoadingCard(
                                              width: 50, height: 50),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error, color: red),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    category['title']!
                                        .split(' ')
                                        .take(1)
                                        .join(' '),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontSize: 10,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20), // Space between sections
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
