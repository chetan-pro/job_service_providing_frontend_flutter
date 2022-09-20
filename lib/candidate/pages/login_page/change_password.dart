// ignore_for_file: unused_import, prefer_const_constructors, avoid_unnecessary_containers, duplicate_import, must_be_immutable

import 'dart:convert';

import 'dart:io';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hindustan_job/candidate/pages/landing_page/home_page.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
// import 'package:hindustan_job/routes/auto_routes.gr.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/register_page_widget/password_widget.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:http/http.dart' as http;
import 'package:hindustan_job/candidate/pages/landing_page/home_page.dart';

import 'login_page.dart';

class ChangePasswod extends StatefulWidget {
  String email;
  String flag;
  ChangePasswod({Key? key, required this.email, required this.flag})
      : super(key: key);

  @override
  State<ChangePasswod> createState() => _ForgetPasswodState();
}

class _ForgetPasswodState extends State<ChangePasswod> {
  TextEditingController otpController = TextEditingController();
  TextEditingController prePwdController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController cnfpwdController = TextEditingController();

  resetYourPassword({otp, password, confirmPassword}) async {
    if (otp == '') {
      return showSnack(context: context, msg: "Enter OTP", type: 'error');
    }
    if (checkPassword(context,
        password: password, confirmPassword: confirmPassword)) return;
    final resetPasswordData = {
      'otp': otp,
      'password': password,
      'confirm_password': confirmPassword,
      'email': widget.email.trim()
    };
    ApiResponse response = await resetPassword(resetPasswordData);
    if (response.status == 200) {
      showSnack(context: context, msg: response.body!.message, type: 'success');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      showSnack(context: context, msg: "OTP is not valid", type: 'error');
    }
  }

  changeYourPassword({previousPassword, password, confirmPassword}) async {
    if (previousPassword == '') {
      return showSnack(
          context: context, msg: "Enter Previous Password", type: 'error');
    }
    if (checkPassword(context,
        password: password, confirmPassword: confirmPassword)) return;
    final changePasswordData = {
      'previous_password': previousPassword,
      'password': password,
      'confirm_password': confirmPassword,
      "user_role_type": userData!.userRoleType
    };
    ApiResponse response = await changePassword(changePasswordData);
    if (response.status == 200) {
      showSnack(context: context, msg: response.body!.message, type: 'success');
      Navigator.pop(context);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Scaffold(
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
                      "Change your password?",
                      style: blackdarkM12,
                    ),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 15,
                    ),
                    Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Container(
                          width: !Responsive.isDesktop(context)
                              ? Sizeconfig.screenWidth!
                              : 300,
                          child: Column(
                            children: [
                              widget.flag == 'reset'
                                  ? TextfieldWidget(
                                      control: otpController,
                                      text: 'Enter OTP',
                                    )
                                  : TextfieldWidget(
                                      control: prePwdController,
                                      text: 'Previous Password',
                                    ),
                              SizedBox(
                                height: 15,
                              ),
                              TextfieldPass(
                                control: pwdController,
                                pass: 'Enter Password',
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextfieldPass(
                                control: cnfpwdController,
                                pass: 'Confirm Password',
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: !Responsive.isDesktop(context)
                          ? Sizeconfig.screenWidth! / 1.5
                          : 120,
                      height: Sizeconfig.screenHeight! / 17,
                      child: ElevatedButton(
                        child: widget.flag == 'reset'
                            ? Text("Submit")
                            : Text("Update"),
                        style: ElevatedButton.styleFrom(
                            primary: MyAppColor.orangelight),
                        // text: 'LOG IN',
                        onPressed: () {
                          widget.flag == 'reset'
                              ? resetYourPassword(
                                  otp: otpController.text.trim(),
                                  password: pwdController.text.trim(),
                                  confirmPassword: cnfpwdController.text.trim())
                              : changeYourPassword(
                                  previousPassword:
                                      prePwdController.text.trim(),
                                  password: pwdController.text.trim(),
                                  confirmPassword:
                                      cnfpwdController.text.trim());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: Sizeconfig.screenHeight! / 20,
                  ),
                  if (!Responsive.isDesktop(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.flag == 'reset')
                          InkWell(
                            onTap: () async {
                              ApiResponse response = await resendOTP(
                                  {"email": widget.email.trim()});
                              if (response.status == 200) {
                                showSnack(
                                    context: context,
                                    msg: response.body!.message);
                              } else {
                                showSnack(
                                    context: context,
                                    msg: response.body!.message);
                              }
                            },
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(color: MyAppColor.blackdark),
                            ),
                          ),
                        SizedBox(width: 5),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () {
                              widget.flag == 'reset'
                                  ? !Responsive.isDesktop(context)
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()))
                                      : showDialog(
                                          context: context,
                                          builder: (_) => Container(
                                            constraints: BoxConstraints(
                                                maxWidth:
                                                    Sizeconfig.screenWidth! /
                                                        2.9),
                                            child: Dialog(
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              insetPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: Sizeconfig
                                                              .screenWidth! /
                                                          2.9,
                                                      vertical: 30),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(00),
                                              ),
                                              child: Container(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      margin: EdgeInsets.only(
                                                        right: 25,
                                                      ),
                                                      child: Login(),
                                                    ),
                                                    Positioned(
                                                      right: 0.0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          color: MyAppColor
                                                              .backgroundColor,
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Image.asset(
                                                              'assets/back_buttons.png'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                  : Navigator.pop(context);
                            },
                            child: Text(
                              widget.flag == 'reset' ? 'Back To Login' : 'Back',
                              style: TextStyle(color: MyAppColor.blackdark),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
