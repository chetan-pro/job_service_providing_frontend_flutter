import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String? text;
  final String? labelText;
  final TextEditingController? control;
  bool isRequired;
  final TextInputType type;
  Function? onTap;
  ToolbarOptions? toolbar;
  bool enableInterative;
  bool enableCursor;
  bool isUrl;
  TextStyle? textStyle;
  TextStyle? styles;
  Function? onChanged;

  TextFormFieldWidget(
      {Key? key,
      this.styles,
      this.text,
      this.labelText,
      this.control,
      this.isRequired = false,
      required this.type,
      this.onTap,
      this.onChanged,
      this.toolbar,
      this.enableInterative = true,
      this.enableCursor = true,
      this.isUrl = false,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        validator: (value) {
          if (isEmpty(value) && isRequired) {
            return "Enter ${text!.toLowerCase()} ";
          }
          if (text == 'Email' ||
              text == 'Company Email' ||
              type == TextInputType.emailAddress) {
            return checkEmail(context, email: value)
                ? "Enter valid email address "
                : null;
          }
          if (isUrl && hasValidUrl(value)) {
            return 'Please enter valid url';
          }
          return null;
        },
        style: blackDarkM14(),
        onTap: () => onTap != null ? onTap!() : null,
        controller: control,
        onChanged: (value) => onChanged != null ? onChanged!(value) : {},
        toolbarOptions: toolbar ?? const ToolbarOptions(),
        keyboardType: type,
        showCursor: enableCursor,
        enableInteractiveSelection: enableInterative,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 10, bottom: 10),
          fillColor: Colors.white,
          filled: true,
          hintText: labelText ?? text,
          hintStyle: textStyle,
          labelText: "$text",
          labelStyle: !Responsive.isDesktop(context)
              ? blackDarkO40M12
              : blackDarkO40M12,
        ),
      ),
    );
  }
}
