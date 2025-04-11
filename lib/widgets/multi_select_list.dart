import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class MultiSelectList extends StatefulWidget {
  final String title;
  final String description;
  final List<String> allOptions;
  final List<String> selectedOptions;
  final Function(List<String>)? onSelectionChanged; // Callback to notify parent

  const MultiSelectList({
    super.key,
    required this.title,
    required this.description,
    required this.allOptions,
    required this.selectedOptions,
    required this.onSelectionChanged,
  });

  @override
  State<MultiSelectList> createState() => _MultiSelectListState();
}

class _MultiSelectListState extends State<MultiSelectList> {
  late List<String> selectedItems;
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(
      widget.selectedOptions,
    );
  }

  void _addItem() {
    if (selectedItem != null && !selectedItems.contains(selectedItem)) {
      setState(() {
        selectedItems.add(selectedItem!);
        selectedItem = null;
      });
      widget.onSelectionChanged?.call(selectedItems);
    }
  }

  void _removeItem(int index) {
    setState(() {
      selectedItems.removeAt(index);
      widget.onSelectionChanged?.call(selectedItems);
    });
  }

  void _reorderItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final String item = selectedItems.removeAt(oldIndex);
      selectedItems.insert(newIndex, item);
      // Notify the parent about the update
      widget.onSelectionChanged?.call(selectedItems);
    });
  }

  String? _validateSelection() {
    if (selectedItems.isEmpty) {
      return "Please add at least one option.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          Text(
            widget.description,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.titleSmall!,
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.dark
                  ? black
                  : white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: (selectedItem != null &&
                                widget.allOptions.contains(selectedItem))
                            ? selectedItem
                            : null,
                        hint: Text(
                          "Select",
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? bgrey
                                  : grey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? bgrey
                                : grey,
                        style: Theme.of(context).textTheme.titleSmall!,
                        isExpanded: true,
                        items: widget.allOptions
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedItem = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                        icon: Icon(
                          Icons.add,
                        ),
                        onPressed: _addItem),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (int index = 0;
                            index < selectedItems.length;
                            index++)
                          ListTile(
                            key: ValueKey(selectedItems[index]),
                            title: Text(
                              selectedItems[index],
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.close_rounded, color: red),
                              onPressed: () => _removeItem(index),
                            ),
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: Icon(Icons.drag_handle),
                            ),
                          ),
                      ],
                      onReorder: (oldIndex, newIndex) =>
                          _reorderItems(oldIndex, newIndex),
                      proxyDecorator: (Widget child, int index,
                          Animation<double> animation) {
                        return Material(
                          elevation: 4,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? bgrey
                              : grey,
                          borderRadius: BorderRadius.circular(10),
                          child: child,
                        );
                      },
                    ),
                    if (_validateSelection() != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _validateSelection()!,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: red),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
