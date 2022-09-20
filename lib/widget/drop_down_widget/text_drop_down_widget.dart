import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';

class AppDropdownInput<T> extends StatelessWidget {
  final String hintText;
  final List options;
  final value;
  final getLabel;
  final changed;

  AppDropdownInput({
    this.hintText = 'Please select an Option',
    this.options = const [],
    required this.getLabel,
    required this.value,
    required this.changed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            child: DropdownButton<dynamic>(
                value: value, //selected
                iconSize: 24,
                elevation: 16,
                style: blackMediumGalano12,
                onChanged: (newValue) {
                  changed(newValue);
                },
                items: [
                  DropdownMenuItem(
                    value: hintText,
                    child: Text(
                      hintText.toString(),
                      style: blackMediumGalano12,
                    ),
                  ),
                  ...options.map<DropdownMenuItem>((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: blackMediumGalano12,
                      ),
                    );
                  }).toList(),
                ]),
          ),
        ],
      ),
    );
  }
}
