// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/register_page/register_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:vrouter/vrouter.dart';

import '../job_seeker_page/home/homeappbar.dart';

class OTPConfirmPage extends StatefulWidget {
  String? email;
  String? token;
  OTPConfirmPage({
    Key? key,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  State<OTPConfirmPage> createState() => _OTPConfirmPageState();
}

class _OTPConfirmPageState extends State<OTPConfirmPage> {
  TextEditingController otpController = TextEditingController();

  otpVerification({otp}) async {
    FocusScope.of(context).unfocus();
    final otpData = {'email': widget.email, 'otp': otp};
    ApiResponse response = await emailOTPVerification(otpData);
    if (response.status == 200) {
      showSnack(context: context, msg: response.body!.message, type: 'success');
      ApiResponse profileResponse = await getProfile(widget.token);
      UserData user = UserData.fromJson(profileResponse.body!.data);
      if (response.status == 200) {
        await setUserData(user);

        if (user.userRoleType == RoleTypeConstant.companyStaff) {
          return context.vRouter.to('/home-company');
        } else if (user.userRoleType ==
                RoleTypeConstant.businessCorrespondence ||
            user.userRoleType == RoleTypeConstant.clusterManager ||
            user.userRoleType == RoleTypeConstant.fieldSalesExecutive ||
            user.userRoleType == RoleTypeConstant.advisor) {
          return context.vRouter.to("/business-partner/home");
        }
        if (user.stateId == null || user.stateId == 'null') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Signup(
                user: user,
                isUserSocialLogin: true,
              ),
            ),
          );
        } else {
          await setUserData(user);
          if (checkRoleType(user.userRoleType)) {
            context.vRouter.to('/home-company');
          } else {
            if (RoleTypeConstant.jobSeeker == user.userRoleType) {
              ConnectedRoutes.toJobSeeker(context);
            } else if (RoleTypeConstant.homeServiceProvider ==
                user.userRoleType) {
              ConnectedRoutes.toHomeServiceProvider(context);
            } else if (RoleTypeConstant.homeServiceSeeker ==
                user.userRoleType) {
              ConnectedRoutes.toHomeServiceSeeker(context);
            } else {
              ConnectedRoutes.toLocalHunar(context);
            }
          }
        }
      } else {
        await showSnack(
            context: context,
            msg: profileResponse.body!.message,
            type: 'error');
        return;
      }
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
      return;
    }
  }

  otpResend() async {
    FocusScope.of(context).unfocus();
    final resendData = {'email': widget.email};
    ApiResponse response = await resendOTP(resendData);
    if (response.status == 200) {
      showSnack(context: context, msg: response.body!.message, type: 'success');
      return;
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      "OTP Email Verification",
                      style: Mytheme.lightTheme(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 20),
                    ),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 15,
                    ),
                    Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Container(
                          // height: 55,
                          child: NumberTextFormFieldWidget(
                            control: otpController,
                            text: 'Enter OTP',
                            isRequired: true,
                            maxLength: 6,
                            type: TextInputType.number,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      width: Sizeconfig.screenWidth! / 1.5,
                      height: Sizeconfig.screenHeight! / 17,
                      child: ElevatedButton(
                        child: Text("Submit"),
                        style: ElevatedButton.styleFrom(
                            primary: MyAppColor.orangelight),
                        onPressed: () {
                          otpVerification(otp: otpController.text);
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
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () async {
                        await otpResend();
                      },
                      child: Text(
                        'Resend OTP',
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
}
