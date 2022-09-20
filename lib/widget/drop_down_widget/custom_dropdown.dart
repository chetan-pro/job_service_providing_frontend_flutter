import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class CustomDropdown extends StatelessWidget {
  String? label;
  List? dropDownList;
  dynamic selectingValue;
  Function? setValue;
  bool isValidDrop;
  String? alertMsg;
  CustomDropdown(
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
    Sizeconfig().init(context);
    print("selectingValue");
    print(selectingValue);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MyAppColor.white),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: Container(
            child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 00),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                validator: (value) {
                  if (selectingValue == null) return "Select ${label}";
                  return null;
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
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
                value: selectingValue != null ? selectingValue.name : label,
                icon: IconFile.arrow,
                iconSize: !Responsive.isDesktop(context) ? 25 : 20,
                elevation: 16,
                style: blackDarkM14(),
                onChanged: (String? newValue) => setValue!(newValue),
                items: [
                  DropdownMenuItem<String>(
                    value: label,
                    child: Text(
                      "${label}",
                      style: !Responsive.isDesktop(context)
                          ? blackDarkO40M14
                          : blackDarkO40M12,
                    ),
                  ),
                  ...dropDownList!.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value.name.toString(),
                        child: Text(
                          "${value.name}",
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
