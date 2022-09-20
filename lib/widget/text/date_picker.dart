import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  String text;
  String? value;
  Function? onSelect;
  var padding;
  DateTime? firstDate;
  DateTime? lastDate;
  var changeType;
  DatePicker(
      {Key? key,
      required this.text,
      this.firstDate,
      this.lastDate,
      this.value,
      this.changeType,
      this.onSelect,
      this.padding})
      : super(key: key);
  DateTime currentDate = DateTime.now();
  DateTime currentYearDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String? showValue = value;
    return Padding(
        padding: EdgeInsets.only(bottom: padding ?? 25),
        child: GestureDetector(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            var data = await showDatePicker(
              context: context,
              initialDate: currentDate,
              selectableDayPredicate: (DateTime val) {
                if (changeType != null) {
                  if (val.toString().split(' ').first ==
                      DateTime.now().toString().split(' ').first) {
                    return true;
                  }
                  var obj = changeType
                      .where((element) => element.id == val.weekday)
                      .toList();
                  return val == DateTime.now() ? true : obj.isNotEmpty;
                } else {
                  return true;
                }
              },
              firstDate: firstDate ?? DateTime(1950), // Required
              lastDate: lastDate ?? DateTime.now(),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: MyAppColor.blackdark,
                      onPrimary: MyAppColor.backgroundColor,
                      surface: MyAppColor.backgroundColor,
                      background: MyAppColor.blackdark,
                      onBackground: MyAppColor.backgroundColor,
                      onSurface: MyAppColor.blackdark,
                      onSecondary: MyAppColor.blackdark,
                    ),
                    dialogBackgroundColor: MyAppColor.backgroundColor,
                  ),
                  child: child!,
                );
              },
            );
            value = DateFormat('MM/dd/yyyy').format(data!);
            showValue = changeType != null
                ? DateFormat('yyyy-MM-dd').format(data)
                : DateFormat('dd/MM/yyyy').format(data);
            onSelect!(value, showValue);
          },
          child: Container(
            height: !Responsive.isDesktop(context) ? 50 : 45,
            // width: !Responsive.isDesktop(context)
            //     ? null
            //     : Sizeconfig.screenWidth! / 4,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: MyAppColor.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value ?? text,
                    style: value != null ? blackDarkM14() : blackDarkO40M14),
                const Icon(
                  Icons.date_range_outlined,
                  size: 15,
                ),
              ],
            ),
          ),
        ));
  }
}
