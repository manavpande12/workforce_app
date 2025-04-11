import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';

class CustomDropdownInput extends StatefulWidget {
  final String labelText;
  final void Function(String?)? onSaved;
  final List<String> options;

  final String? selectedValue;
  final Icon? defaultIcon;

  const CustomDropdownInput({
    super.key,
    required this.labelText,
    this.onSaved,
    required this.options,
    this.selectedValue,
    this.defaultIcon,
  });

  @override
  State<CustomDropdownInput> createState() => _CustomDropdownInputState();
}

class _CustomDropdownInputState extends State<CustomDropdownInput> {
  String? selectedValue;
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    if (widget.selectedValue != null &&
        widget.options.contains(widget.selectedValue)) {
      selectedValue = widget.selectedValue;
    } else {
      selectedValue = null; // Ensure there's no invalid selected value
    }
  }

  // Validator Function
  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select one option.';
    }
    return null;
  }

  Icon getPrefixIcon(String? value) {
    switch (value) {
      case "Male":
        return Icon(Icons.male, color: Colors.blue);
      case "Female":
        return Icon(Icons.female, color: Colors.pink);
      case "Other":
        return Icon(Icons.transgender, color: Colors.purple);
      default:
        return widget.defaultIcon ??
            Icon(Icons.arrow_drop_down, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      constraints: BoxConstraints(
        maxHeight: _dropdownKey.currentState?.hasError == true ? 80 : 55,
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          key: _dropdownKey,
          style: Theme.of(context).textTheme.titleSmall,
          decoration: InputDecoration(
            labelStyle: Theme.of(context).textTheme.titleSmall,
            prefixIcon: getPrefixIcon(selectedValue),
            prefixIconColor:
                Theme.of(context).brightness == Brightness.dark ? white : black,
            errorStyle:
                Theme.of(context).textTheme.titleSmall!.copyWith(color: red),
            filled: true,
            fillColor:
                Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            maintainHintHeight: true,
          ),
          hint: Text(
            widget.labelText,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onSaved?.call(value);
          },
          validator: _validateInput,
          dropdownColor:
              Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
          value: selectedValue,
          items: widget.options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: Theme.of(context).textTheme.titleSmall!,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          isExpanded: true,
        ),
      ),
    );
  }
}
