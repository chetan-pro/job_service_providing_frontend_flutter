import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/filter_section/check_box_with_label_widget.dart';

class FilterSection1 extends StatelessWidget {
  Function? isOpen;
  String label;
  List list;
  Function onTap;
  Function onSelecting;
  FilterSection1(
      {Key? key,
      required this.label,
      required this.list,
      required this.onTap,
      this.isOpen,
      required this.onSelecting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 2),
      padding: !Responsive.isDesktop(context)
          ? const EdgeInsets.only(left: 30, right: 30, top: 24, bottom: 12)
          : const EdgeInsets.only(left: 10, right: 10),
      color: MyAppColor.graydf,
      child: Column(
        children: [
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              onExpansionChanged: (value) =>
                  isOpen != null ? isOpen!(value) : null,
              iconColor: MyAppColor.blackdark,
              title: Text(
                label,
                style: !Responsive.isDesktop(context)
                    ? blackDarkR18
                    : blackDarkR16,
              ),
              children: List.generate(
                  list.length,
                  (index) => CheckBoxWithLabel(
                      label: "${list[index].name}",
                      value: list[index].isSelected,
                      onSelect: (value) {
                        onSelecting(value, index);
                      })),
            ),
          ),
        ],
      ),
    );
  }
}
