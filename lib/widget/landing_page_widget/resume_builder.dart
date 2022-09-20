import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/image/image.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class Resume_builder extends StatelessWidget {
  const Resume_builder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Container(
      padding: EdgeInsets.all(30),
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 2.3,
      height: !Responsive.isDesktop(context)
          ? Sizeconfig.screenHeight! / 1.2
          : Sizeconfig.screenHeight! / 1.3,
      decoration: BoxDecoration(
        color: Colors.grey,
        image: Responsive.isDesktop(context)
            ? DecorationImage(
                colorFilter: new ColorFilter.mode(
                    MyAppColor.blackplane.withOpacity(0.3),
                    BlendMode.softLight),
                image: ImageFile.man,
                fit: BoxFit.cover)
            : DecorationImage(
                colorFilter: new ColorFilter.mode(
                    MyAppColor.blackplane.withOpacity(0.3),
                    BlendMode.softLight),
                image: ImageFile.man,
                fit: BoxFit.cover),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: Text('Resume Builder', style: backgroundColorR16),
              ),
            ],
          ),
          // SizedBox(
          //   height: Sizeconfig.screenHeight! / 2,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: !Responsive.isDesktop(context)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textcreate(),
                            textfill2(),
                            textget3(),
                            textsinglle4(),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textcreate(),
                            textfill2(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                textget3(),
                                textsinglle4(),
                              ],
                            ),
                          ],
                        )),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    if (!Responsive.isDesktop(context)) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      showDialog(
                        context: context,
                        routeSettings: const RouteSettings(name: Login.route),
                        builder: (_) => Container(
                          constraints: BoxConstraints(
                              maxWidth: Sizeconfig.screenWidth! / 2.9),
                          child: Dialog(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.symmetric(
                                horizontal: Sizeconfig.screenWidth! / 2.9,
                                vertical: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(00),
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
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        padding: EdgeInsets.all(5),
                                        color: MyAppColor.backgroundColor,
                                        alignment: Alignment.topRight,
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
                      );
                    }
                  },
                  child: Padding(
                    padding: !Responsive.isDesktop(context)
                        ? EdgeInsets.symmetric(horizontal: 25, vertical: 12)
                        : EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text("GET STARTED ", style: whiteR14()),
                  ),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: MyAppColor.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text textsinglle4() {
    return Text(
      'Single-Click   ',
      style: backgroundColorSb16(),
    );
  }

  Text textget3() {
    return Text(
      'Get Your Custom Resume with a',
      style: backgroundColorSb16(),
    );
  }

  Text textfill2() {
    return Text(
      'Fill-up details your Profile   ',
      style: backgroundColorSb16(),
    );
  }

  Text textcreate() {
    return Text(
      'Create a Candidate Accounts',
      style: backgroundColorSb16(),
    );
  }
}
