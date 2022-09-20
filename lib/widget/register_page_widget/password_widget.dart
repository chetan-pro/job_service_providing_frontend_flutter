import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class TextfieldPass extends StatefulWidget {
  final String? pass;
  final TextEditingController? control;

  TextfieldPass({
    Key? key,
    this.pass,
    this.control,
  }) : super(key: key);

  @override
  State<TextfieldPass> createState() => _TextfieldPassState();
}

class _TextfieldPassState extends State<TextfieldPass> {
  bool _obscureText = true;
  bool _loader = true;

  void _visible() {
    setState(() {
      _loader = !_loader;
    });
  }

  // String _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! : null,
        child: TextFormField(
          cursorColor: Colors.white,
          obscureText: _obscureText,
          controller: widget.control,
          style: blackDarkM14(),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            suffixIcon: _loader
                ? GestureDetector(
                    onTap: () {
                      _toggle();
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      size: Responsive.isMobile(context) ? 20 : 20,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _toggle();
                    },
                    child: Icon(Icons.visibility_off),
                  ),
            contentPadding:
                EdgeInsets.only(top: 10, left: 15, right: 8, bottom: 10),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.pass,
            labelText: widget.pass,
            labelStyle: !Responsive.isDesktop(context)
                ? blackDarkO40M12
                : blackDarkO40M12,
          ),
          //   style: desktopstyle,
          //   decoration: InputDecoration(
          //     hoverColor: MyAppColor.white,
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5),
          //       borderSide: BorderSide(color: Colors.white70),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5),
          //       borderSide: BorderSide(color: Colors.white),
          //     ),

          //     fillColor: Colors.white,
          //     filled: true,
          //     labelText: widget.pass,
          //     labelStyle: !Responsive.isDesktop(context)
          //         ? blackDarkO40M12
          //         : blackDarkO40M12,
          //     hintText: widget.pass,
          //     hintStyle: !Responsive.isDesktop(context)
          //         ? blackDarkOpacityM14()
          //         : blackDarkOpacityM12(),
          //     contentPadding:
          //         EdgeInsets.only(top: 10, left: 15, right: 8, bottom: 10),
          //   ),
        ));
  }
}
