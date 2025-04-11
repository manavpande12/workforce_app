import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/services/get_category_data.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/search_bar.dart';
import 'dart:async';

import 'package:workforce_app/widgets/shimmer_loading.dart';

class SearchScreen {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) {
        return const SearchScreenContent();
      },
    );
  }
}

class SearchScreenContent extends StatefulWidget {
  const SearchScreenContent({super.key});

  @override
  State<SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<SearchScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> categoryList = [];
  List<Map<String, String>> filteredCategories = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSearch);
    _fetchCategories();
  }

  void _fetchCategories() {
    fetchCategoryTitlesWithIcons().listen((fetchedCategories) {
      setState(() {
        categoryList = fetchedCategories;
        filteredCategories = fetchedCategories;
      });
    });
  }

  void _filterSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredCategories = categoryList
            .where((category) => category['title']!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.dark
                  ? bgrey
                  : grey,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: SearchBarWidget(
                      controller: _searchController, onSearch: _filterSearch),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // **Workers List**
          Expanded(
            child: categoryList.isEmpty
                ? ListView.builder(
                    itemCount: 12,
                    itemBuilder: (ctx, index) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: const ShimmerLoadingCard(
                        borderRadius: 0,
                        height: 50,
                        width: double.infinity,
                      ),
                    ),
                  )
                : filteredCategories.isEmpty
                    ? const Center(child: Text('No matching workers found'))
                    : ListView.builder(
                        itemExtent: 60,
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];

                          return ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: category['iconUrl']!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  ShimmerLoadingCard(width: 40, height: 40),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error, color: red),
                            ),
                            title: Text(
                              category['title']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    fontSize: 12,
                                  ),
                            ),
                            shape: Border(
                              bottom: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? bgrey
                                    : grey,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(worker,
                                  arguments: category['title']);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
