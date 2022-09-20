// ignore_for_file: prefer_if_null_operators, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:intl/intl.dart';

yearPicker(BuildContext context, String text,
    {value, required Function onSelect, padding}) {
  DateTime currentDate = DateTime.now();
  DateTime currentYearDate = DateTime.now();
  return Padding(
      padding: EdgeInsets.only(bottom: padding != null ? padding : 25),
      child: GestureDetector(
        onTap: () async {
          var data = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Select Year"),
                    content: SizedBox(
                      // Need to use container to add size constraint.
                      width: 300,
                      height: 300,
                      child: YearPicker(
                        firstDate: DateTime(DateTime.now().year - 72, 1),
                        lastDate: DateTime(DateTime.now().year, 1),
                        initialDate: DateTime.now(),

                        // save the selected date to _selectedDate DateTime variable.
                        // It's used to set the previous selected date when
                        // re-showing the dialog.
                        selectedDate: currentDate,
                        onChanged: (DateTime dateTime) {
                          var year = DateFormat('yyyy').format(dateTime);
                          // close the dialog when year is selected.
                          Navigator.pop(context, year);

                          // Do something with the dateTime selected.
                          // Remember that you need to use dateTime.year to get the year
                        },
                      ),
                    ),
                  ));
          value = data;
          onSelect(value);
        },
        child: Container(
          height: !Responsive.isDesktop(context) ? 50 : 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: MyAppColor.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  value != '' && value != null ? value : text,
                  style: value != '' && value != null
                      ? blackDarkM14()
                      : blackDarkO40M14,
                ),
              ),
              Icon(
                Icons.date_range_outlined,
                size: 15,
              ),
            ],
          ),
        ),
      ));
}
