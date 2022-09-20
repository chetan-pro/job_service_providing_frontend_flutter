import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/constants/colors.dart';

class CustomcheckBox extends StatelessWidget {
  CustomcheckBox({
    Key? key,
    required this.label,
    this.term,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  String? term;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              tristate: false,
              splashRadius: 00,
              focusColor: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              hoverColor: Colors.transparent,
              checkColor: MyAppColor.white,
              activeColor: MyAppColor.orangedark,
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
            Expanded(
                child: Row(
              children: [
                Text(
                  label,
                  style: blackDarkR12(),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  term!,
                  style: orangeDarkSb12(),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
