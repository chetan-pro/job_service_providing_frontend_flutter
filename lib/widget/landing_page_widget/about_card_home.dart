import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class AboutCard extends StatelessWidget {
  String image;
  String role;
  String description;
  AboutCard({
    required this.image,
    required this.role,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        height: Sizeconfig.screenHeight! / 1.7,
        width: Responsive.isMobile(context)
            ? Sizeconfig.screenWidth!
            : Sizeconfig.screenWidth! / 4.5,
        decoration: BoxDecoration(
          color: Colors.amber,
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  MyAppColor.blackplane.withOpacity(0.5), BlendMode.softLight),
              image: AssetImage(image),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Become Our',
              style: !Responsive.isDesktop(context) ? whiteM12() : whiteM10(),
            ),
            // SizedBox(height: 4),
            Text(role,
                style:
                    !Responsive.isDesktop(context) ? whiteSb18() : whiteSb14()),
            SizedBox(height: 8),
            Text(
              description,
              style: !Responsive.isDesktop(context) ? whiteR16() : whiteR12(),
            ),

            Text(
              'Subscribe For the first time',
              style: !Responsive.isDesktop(context) ? whiteR16() : whiteR12(),
            ),
            SizedBox(height: 20),
            OutlinedButton(
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
                                    child:
                                        Image.asset('assets/back_buttons.png'),
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
                    : EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text('GET STARTED',
                    style: !Responsive.isDesktop(context)
                        ? whiteR14()
                        : whiteR10()),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
