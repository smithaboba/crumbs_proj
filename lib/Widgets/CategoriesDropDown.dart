import 'package:flutter/material.dart';

class CategoriesDropDown extends StatefulWidget {
  CategoriesDropDown({super.key, required this.downValueChange});

  Function downValueChange;

  @override
  State<CategoriesDropDown> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  static List<String> categories = <String>[
    "Fresh Produce",
    "Dairy and Eggs",
    "Bakery",
    "Meat and Seafood",
    "Frozen Foods",
    "Canned and Jarred Goods",
    "Pasta Rice and Grains",
    "Baking and Cooking Supplies",
    "Condiments and Sauces",
    "Snacks",
    "Beverages",
    "Cereal and Breakfast Foods",
    "Canned and Packaged Meals",
    "Household and Cleaning Supplies",
    "Personal Care and Health",
    "Pet Supplies",
    "Alcohol",
    "International Foods",
    "Organic and Health Foods"
  ];

  String dropdownValue = categories.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width * 0.92,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.all(8),
      ),
      initialSelection: categories.first,
      label: const Text("Category"),
      menuHeight: 200.0,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        widget.downValueChange(value!);
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries:
          categories.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
