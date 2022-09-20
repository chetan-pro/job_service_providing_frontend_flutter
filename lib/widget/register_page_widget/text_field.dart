import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class TextfieldWidget extends StatelessWidget {
  final String? text;
  final TextEditingController? control;
  Function? onChanged;
  String? hintText;
  TextInputType? inputType;
  final TextStyle? styles;

  TextfieldWidget(
      {Key? key,
      this.inputType,
      this.text,
      this.hintText,
      this.control,
      this.styles,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: control,
      onTap: () {
      },
      style: blackDarkM14(),
      onChanged: (value) => onChanged != null ? onChanged!(value) : {},
      keyboardType: inputType ?? TextInputType.multiline,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          borderSide: BorderSide.none,
          //borderSide: const BorderSide(),
        ),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        
        contentPadding:
            EdgeInsets.only(top: 10, left: 15, right: 8, bottom: 10),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText??text,
        hintStyle:
            !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M12,
        labelText: "$text",
        labelStyle:
            !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M12,
      ),
    );
  }
}
