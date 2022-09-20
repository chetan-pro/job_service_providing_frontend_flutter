import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/constants/colors.dart';

class CheckBoxWithLabel extends StatelessWidget {
  String label;
  bool value;
  Function onSelect;
  CheckBoxWithLabel(
      {Key? key,
      required this.label,
      required this.value,
      required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: new ThemeData.dark().copyWith(
            unselectedWidgetColor: MyAppColor.greyCheckBorderColor,
            toggleableActiveColor: MyAppColor.orangedark,
          ),
          child: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              checkColor: MyAppColor.white,
              value: value,
              onChanged: (value) {
                onSelect(value);
              }),
        ),
        Text(
          '$label',
          style: blackRegularGalano14,
        ),
      ],
    );
  }
}
