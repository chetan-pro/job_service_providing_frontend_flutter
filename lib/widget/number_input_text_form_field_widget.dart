import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class NumberTextFormFieldWidget extends StatelessWidget {
  final String? text;
  String? stringAllow;
  final TextEditingController? control;
  final bool? isRequired;
  final TextInputType type;
  Function? onTap;
  Function? onChanged;
  ToolbarOptions? toolbar;
  bool enableInterative;
  bool enableCursor;
  int maxLength;
  bool enabled;
  TextStyle? textStyle;

  NumberTextFormFieldWidget(
      {Key? key,
      this.text,
      this.control,
      this.stringAllow,
      required this.isRequired,
      required this.type,
      this.onTap,
      this.onChanged,
      this.toolbar,
      this.enableInterative = true,
      this.enableCursor = true,
      this.maxLength = 10,
      this.enabled = true,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! : null,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        validator: (value) {
          if (isEmpty(value) && isRequired!) {
            return "Enter ${text!.toLowerCase()} ";
          }
          return null;
        },
        inputFormatters: stringAllow != null
            ? <TextInputFormatter>[]
            : <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        maxLength: maxLength,
        onTap: () => onTap != null ? onTap!() : null,
        onChanged: (value) => onChanged != null ? onChanged!(value) : {},
        enabled: enabled,
        controller: control,
        toolbarOptions: toolbar ?? const ToolbarOptions(),
        keyboardType: type,
        showCursor: enableCursor,
        enableInteractiveSelection: enableInterative,
        style: blackDarkM14(),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 10, bottom: 10),
          fillColor: Colors.white,
          filled: true,
          hintText: text,
          hintStyle: blackDarkO40M14,
          labelText: "$text",
          labelStyle: !Responsive.isDesktop(context)
              ? blackDarkO40M12
              : blackDarkO40M12,
        ),
      ),
    );
  }
}
