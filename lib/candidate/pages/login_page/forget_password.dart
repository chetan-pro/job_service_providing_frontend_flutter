// ignore_for_file: prefer_const_constructors, unused_import, non_constant_identifier_names, avoid_unnecessary_containers

import 'dart:convert';

import 'dart:io';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:http/http.dart' as http;

import 'change_password.dart';
import 'login_page.dart';

class ForgetPasswod extends StatefulWidget {
  const ForgetPasswod({Key? key}) : super(key: key);

  @override
  State<ForgetPasswod> createState() => _ForgetPasswodState();
}

class _ForgetPasswodState extends State<ForgetPasswod> {
  TextEditingController EmailController = TextEditingController();

  forgotPassword({email}) async {
    FocusScope.of(context).unfocus();
    final forgetData = {
      'email': email,
    };
    ApiResponse response = await forgetPassword(forgetData);
    if (response.status == 200) {
      showSnack(context: context, msg: response.body!.message, type: 'success');
      !Responsive.isDesktop(context)
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePasswod(
                  email: email,
                  flag: 'reset',
                ),
              ),
            )
          : showDialog(
              context: context,
              builder: (_) => Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: EdgeInsets.symmetric(
                    horizontal: Sizeconfig.screenWidth! / 2.9, vertical: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00),
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 25),
                      color: Colors.amber,
                      child: ChangePasswod(
                        email: email,
                        flag: 'reset',
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          padding: EdgeInsets.all(5),
                          color: MyAppColor.backgroundColor,
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/back_buttons.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      body: ListView(
        children: [
          SizedBox(
            child: Image.asset('assets/loginimage.png'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 20,
                    ),
                    Text(
                      "Forgot your password?",
                      style: blackDarkSb14(),
                    ),
                    SizedBox(
                      height: !Responsive.isDesktop(context)
                          ? Sizeconfig.screenHeight! / 15
                          : Sizeconfig.screenHeight! / 10,
                    ),
                    Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: !Responsive.isDesktop(context)
                            ? emailAdress()
                            : SizedBox(
                                width: 300,
                                child: emailAdress(),
                              ),
                      ),
                    ),
                    if (Responsive.isDesktop(context)) SizedBox(height: 10),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      // width: Sizeconfig.screenWidth! / 1.5,
                      // height: Sizeconfig.screenHeight! / 17,
                      child: ElevatedButton(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10),
                          child: Text(
                            "Submit",
                            style: whiteR12(),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: MyAppColor.orangelight),
                        onPressed: () {
                          forgotPassword(email: EmailController.text);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (!Responsive.isDesktop(context))
                Column(
                  children: [
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 20,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'Back To Login',
                          style: TextStyle(color: MyAppColor.blackdark),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }

  TextfieldWidget emailAdress() {
    return TextfieldWidget(
      control: EmailController,
      text: 'Email Address',
    );
  }
}
