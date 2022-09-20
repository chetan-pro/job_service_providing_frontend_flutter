// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/constants/colors.dart';

class RadioButton extends StatelessWidget {
  dynamic groupValue;
  dynamic value;
  dynamic text;
  Function onChanged;
  RadioButton(
      {Key? key,
      required this.groupValue,
      required this.text,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio<dynamic>(
              activeColor: MyAppColor.orangelight,
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v)),
          Text(
            "$text",
            style: blackDarkR12(),
          )
        ],
      ),
    );
  }
}
