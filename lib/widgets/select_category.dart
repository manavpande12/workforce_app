import 'package:flutter/material.dart';
import 'package:workforce_app/services/get_category_data.dart';
import 'package:workforce_app/widgets/multi_select_list.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class SelectCategory extends StatefulWidget {
  final List<String> selectedSkills;
  final Function(List<String>)? onSelect;

  const SelectCategory({
    super.key,
    required this.selectedSkills,
    required this.onSelect,
  });

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.selectedSkills);
  }

  void _handleSelectionChanged(List<String> updatedSelection) {
    setState(() {
      selectedItems = updatedSelection;
    });
    widget.onSelect?.call(updatedSelection);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: fetchCategoryTitles(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerLoadingCard(
            height: 200,
            width: double.infinity,
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No skills available');
        }

        final titles = snapshot.data!;

        return MultiSelectList(
          title: "Please Choose A Skill",
          description:
              "We recommend adding your top 3 skills. They'll also appear in your Skills section.",
          allOptions: titles,
          selectedOptions: selectedItems,
          onSelectionChanged: _handleSelectionChanged, // Use local function
        );
      },
    );
  }
}
