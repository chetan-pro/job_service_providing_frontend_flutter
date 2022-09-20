import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

import '../../candidate/dropdown/dropdown_string.dart';
import '../../config/responsive.dart';

class StaticDropDownWidget extends StatelessWidget {
  String? label;
  List? dropDownList;
  dynamic selectingValue;
  Function? setValue;
  bool isValidDrop;
  String? alertMsg;
  StaticDropDownWidget(
      {Key? key,
      required this.label,
      required this.dropDownList,
      required this.selectingValue,
      required this.setValue,
      this.isValidDrop = true,
      this.alertMsg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("selectingValue");
    print(selectingValue);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: !Responsive.isDesktop(context) ? 46 : 45,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            focusColor: MyAppColor.white,
            child: DropdownButton<String>(
              value: selectingValue ?? label,
              icon: IconFile.arrow,
              iconSize: 25,
              elevation: 16,
              style: blackDarkOpacityM12(),
              underline: Container(
                height: 3,
                width: MediaQuery.of(context).size.width,
                color: MyAppColor.white,
              ),
              onChanged: (String? newValue) => setValue!(newValue),
              items: [
                DropdownMenuItem<String>(
                  value: label,
                  child: Text(
                    label!,
                    style: blackDarkO40M14,
                  ),
                ),
                ...dropDownList!.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: blackDarkM12(),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
