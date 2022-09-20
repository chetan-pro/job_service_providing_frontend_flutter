// ignore_for_file: void_checks, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class DynamicDropDownListOfFields extends StatelessWidget {
  String? label;
  List? dropDownList;
  dynamic selectingValue;
  Function? setValue;
  bool isValidDrop;
  int? widthRatio;
  String? alertMsg;
  bool isJobList;
  DynamicDropDownListOfFields(
      {Key? key,
      required this.label,
      required this.dropDownList,
      required this.selectingValue,
      required this.setValue,
      this.widthRatio,
      this.isValidDrop = true,
      this.isJobList = false,
      this.alertMsg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Container(
      width: !Responsive.isDesktop(context)
          ? double.infinity
          : Sizeconfig.screenWidth! / (widthRatio ?? 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MyAppColor.white),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: SizedBox(
            child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                validator: (value) {
                  if (selectingValue == null) return "Select ${label}";
                  return null;
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!isValidDrop) {
                    return showSnack(
                        context: context, msg: "$alertMsg", type: 'error');
                  }
                  if (!dropDownList!.isNotEmpty &&
                      label == DropdownString.selectCity) {
                    showSnack(
                        context: context,
                        msg: AlertString.selectState,
                        type: 'error');
                  }
                },
                value:
                    "${selectingValue != null ? isJobList ? selectingValue.jobTitle : selectingValue.name : label}",
                icon: IconFile.arrow,
                iconSize: !Responsive.isDesktop(context) ? 25 : 20,
                elevation: 16,
                style: blackDarkM14(),
                onChanged: (String? newValue) => setValue!(newValue),
                items: [
                  DropdownMenuItem<String>(
                    value: label,
                    child: Text(
                      "$label",
                      style: !Responsive.isDesktop(context)
                          ? blackDarkO40M14
                          : blackDarkO40M12,
                    ),
                  ),
                  ...dropDownList!.map(
                    (value) {
                      return DropdownMenuItem(
                        value: isJobList ? value.id.toString() : value.name,
                        child: Text(
                          "${isJobList ? value.jobTitle : value.name}",
                          style: blackDarkM14(),
                        ),
                      );
                    },
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
