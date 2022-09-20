// ignore_for_file: avoid_print

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../candidate/theme_modeule/new_text_style.dart';
import '../../candidate/theme_modeule/text_style.dart';

class BuildDropdown extends StatelessWidget {
  ValueChanged onChanged;
  String defaultValue, dropdownHint;
  String? selectedValue;
  List<String> itemsList;
  double height;

  BuildDropdown(
      {Key? key,
      required this.itemsList,
      required this.defaultValue,
      required this.dropdownHint,
      required this.onChanged,
      required this.height,
      this.selectedValue});

  @override
  build(BuildContext context) {
    return DropdownButtonFormField2(
      value: selectedValue ?? dropdownHint,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none),
      ),
      isExpanded: false,
      hint: Text(
        dropdownHint,
        style: blackMedium14,
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 20,
      buttonHeight: height,
      buttonPadding: const EdgeInsets.only(left: 10, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: [
        DropdownMenuItem<String>(
          value: dropdownHint,
          child: Text(dropdownHint, style: blackMedium14),
        ),
        ...itemsList
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item.replaceAll('_',' '),
                    style: blackMedium14,
                  ),
                ))
            .toList()
      ],
      onChanged: (value) {
        onChanged(value);
      },
      onSaved: (value) {
        onChanged(value);
      },
    );
  }
}
