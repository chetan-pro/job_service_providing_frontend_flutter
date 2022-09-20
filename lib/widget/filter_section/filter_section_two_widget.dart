import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/filter_section/check_box_with_label_widget.dart';

class FilterSection2 extends StatelessWidget {
  Function? isOpen;
  String label;
  List list;
  Function? onTap;
  var selectedValue;
  Function onSelecting;
  FilterSection2(
      {Key? key,
      required this.label,
      required this.list,
      this.onTap,
      this.isOpen,
      required this.selectedValue,
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
      color: MyAppColor.graydf,
      child: Column(
        children: [
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              onExpansionChanged: (value) =>
                  isOpen != null ? isOpen!(value) : null,
              iconColor: MyAppColor.blackdark,
              title: Text(label,
                  style: !Responsive.isDesktop(context)
                      ? blackDarkR18
                      : blackDarkR16),
              children: List.generate(
                  list.length,
                  (index) => RadioButton(
                        groupValue: selectedValue?.name,
                        onChanged: (v) => onSelecting(v, index),
                        text: getCapitalizeString(list[index].name),
                        value: list[index].name,
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
