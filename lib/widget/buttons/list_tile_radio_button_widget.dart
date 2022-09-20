// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/constants/colors.dart';

class ListTileRadioButton extends StatefulWidget {
  dynamic groupValue;
  dynamic value;
  dynamic text;
  Function onChanged;
  ListTileRadioButton(
      {Key? key,
      required this.groupValue,
      required this.text,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  State<ListTileRadioButton> createState() => _ListTileRadioButtonState();
}

class _ListTileRadioButtonState extends State<ListTileRadioButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          widget.text,
          style: blackDarkM12(),
        ),
        leading: Radio<dynamic>(
            value: widget.value,
            activeColor: MyAppColor.orangelight,
            groupValue: widget.groupValue,
            onChanged: (value) => widget.onChanged(value)));
  }
}
