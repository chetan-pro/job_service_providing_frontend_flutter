// ignore_for_file: unused_import

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownsCheck extends StatefulWidget {
  const DropdownsCheck({Key? key}) : super(key: key);

  @override
  _DropdownsCheckState createState() => _DropdownsCheckState();
}

class _DropdownsCheckState extends State<DropdownsCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(
            'State',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
            });
          },
          buttonHeight: 40,
          buttonWidth: 140,
          itemHeight: 40,
        ),
      ),
    );
  }
}

String? selectedValue;
List<String> items = [
  'Item1',
  'Item2',
  'Item3',
  'Item4',
  'Item5',
  'Item6',
  'Item7',
  'Item8',
];
