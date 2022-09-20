// ignore_for_file: unused_import, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hindustan_job/candidate/model/contact_us.dart';
import 'package:hindustan_job/candidate/pages/landing_page/home_page.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/headers.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/widget/buttons/outline_buttons.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);
  static const String route = '/contact-us';

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  bool _contact = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController description = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return CustomHeader(
      text: "HOME / CONTACT US",
      body: ListView(
        children: [
          Center(
            child: Responsive.isDesktop(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [leftPart(), rightPart()],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [leftPart(), rightPart()],
                  ),
          ),
          if (Responsive.isDesktop(context)) Footer(),
        ],
      ),
    );
  }

  leftPart() {
    return SizedBox(
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 3
          : double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        sideTextWithPadding('Contact Us!'),
        sideTextWithPadding('Thank you for visiting HindustaanJobs!'),
        sideTextWithPadding(
            'Stucked Somewhere? Want to connect with us? We are here to help.Choose the option that works best for you. We look forward to hearing from you. Job Seekers / Home Service provider / Home Service Seeker / Local Hunar If you are any of the above and would like to contact us, call us at:'),
        sideTextWithPadding("+91 70004 15297"),
        sideTextWithPadding(
            "Recruiter / Business Partner If you are any of the above and would like to contact us, call us at:"),
        sideTextWithPadding("Toll Free: +91 72230 37803"),
        sideTextWithPadding("Official Address"),
      ]),
    );
  }

  rightPart() {
    return SizedBox(
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 3.8
          : double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: Sizeconfig.screenHeight! / 12,
          ),
          Container(
            margin: marginAll10,
            color: MyAppColor.greynormal,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: !Responsive.isDesktop(context)
                          ? paddingAll25
                          : const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      color: MyAppColor.greylight,
                      width: double.infinity,
                      child: Text('Contact Us ', style: whiteM14()),
                    ),
                    Positioned(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/contact-image.png', height: 18),
                          Image.asset(
                            'assets/contact-image-down.png',
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 00,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/contact-page-downs.png',
                              height: 18),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 00,
                      right: 00,
                      child: Image.asset('assets/contact-image-left.png',
                          height: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: !Responsive.isDesktop(context)
                      ? const EdgeInsets.all(15)
                      : const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 35),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          styles: desktopstyle,
                          textStyle: blackDarkOpacityM14(),
                          isRequired: true,
                          control: firstName,
                          text: "First Name",
                          type: TextInputType.multiline,
                        ),
                        SizedBox(
                          height: !Responsive.isDesktop(context) ? 10 : 20,
                        ),
                        TextFormFieldWidget(
                          styles: desktopstyle,
                          textStyle: blackDarkOpacityM14(),
                          isRequired: true,
                          control: lastName,
                          text: "Last Name",
                          type: TextInputType.multiline,
                        ),
                        SizedBox(
                          height: !Responsive.isDesktop(context) ? 10 : 20,
                        ),
                        TextFormFieldWidget(
                          styles: desktopstyle,
                          textStyle: blackDarkOpacityM14(),
                          isRequired: true,
                          control: emailController,
                          text: "Email",
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: !Responsive.isDesktop(context) ? 10 : 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            style: desktopstyle,
                            keyboardType: TextInputType.multiline,
                            controller: description,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Type Your message here',
                              hintStyle: blackDarkO40M14,
                              contentPadding:
                                  const EdgeInsets.only(left: 16, top: 20),
                            ),
                            minLines: !Responsive.isDesktop(context) ? 5 : 3,
                            maxLines: null,
                          ),
                        ),
                        SizedBox(
                          height: !Responsive.isDesktop(context) ? 20 : 30,
                        ),
                        ElevatedButton(
                          child: Padding(
                            padding: !Responsive.isDesktop(context)
                                ? paddingAll10
                                : const EdgeInsets.all(5),
                            child: Text('SUBMIT MESSAGE',
                                style: !Responsive.isDesktop(context)
                                    ? whiteR14()
                                    : whiteM12()),
                          ),
                          onPressed: () async {
                            if (!isFormValid(_formKey)) {
                              return;
                            }
                            await contactApi();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                MyAppColor.orangelight),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Sizeconfig.screenHeight! / 15,
          ),
        ],
      ),
    );
  }

  sideTextWithPadding(text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  contactApi() async {
    final contactData = {
      'first_name': firstName.text,
      'last_name': lastName.text,
      'email': emailController.text,
      'description': description.text
    };

    ApiResponse response = await contactUs(contactData);
    if (response.status == 200) {
      showSnack(context: context, msg: response.body!.data);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }
}
