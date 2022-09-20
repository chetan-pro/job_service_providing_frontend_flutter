import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';

class PriceFilterSlider extends StatelessWidget {
  Function? isOpen;
  String label;
  Function onSelecting;
  RangeValues currentRangeValues;
  PriceFilterSlider(
      {Key? key,
      required this.currentRangeValues,
      required this.label,
      this.isOpen,
      required this.onSelecting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 2),
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.only(left: 30, right: 30, top: 24, bottom: 12)
          : EdgeInsets.only(left: 10, right: 10),
      color: MyAppColor.simplegrey,
      child: Column(
        children: [
          Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                  iconColor: MyAppColor.blackdark,
                  title: Text(label, style: blackDarkR18),
                  children: [
                    RangeSlider(
                      values: currentRangeValues,
                      max: 100,
                      divisions: 5,
                      activeColor: MyAppColor.orangedark,
                      labels: RangeLabels(
                        currentRangeValues.start.round().toString(),
                        currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        onSelecting(values);
                      },
                    )
                  ])),
        ],
      ),
    );
  }
}
