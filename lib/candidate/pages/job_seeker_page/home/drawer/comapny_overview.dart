import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/url_laucher.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

class OverViewCompany extends StatefulWidget {
  UserData? userData;
  OverViewCompany({Key? key, this.userData}) : super(key: key);

  @override
  _OverViewCompanyState createState() => _OverViewCompanyState();
}

class _OverViewCompanyState extends State<OverViewCompany> {
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    return ListView(
      children: [
        SizedBox(
          height: Sizeconfig.screenHeight! / 20,
        ),
        !Responsive.isDesktop(context)
            ? Column(
                children: [
                  _companysector(styles, 'EMAIL', '${widget.userData!.email}'),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UrlLauncherWidget(
                                  url: '${widget.userData!.companyLink}')));
                    },
                    child: _companysector(styles, 'Company Website',
                        '${widget.userData!.companyLink}'),
                  ),
                  _companysector(
                      styles, 'CONTACT NUMBERS', '${widget.userData!.mobile}'),
                  _companysector(
                      styles, 'STATE', '${widget.userData!.state!.name}'),
                  _companysector(
                      styles, 'CITY', '${widget.userData!.city!.name}'),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _companysector(styles, 'COMPANY SECTOR', 'Private'),
                  _companysector(styles, 'COMPANY LINK',
                      '${widget.userData!.companyLink}'),
                  _companysector(styles, 'EMAIL', '${widget.userData!.email}'),
                  _companysector(
                      styles, 'CONTACT NUMBERS', '${widget.userData!.mobile}'),
                  SizedBox(
                    width: 3,
                  ),
                  _companysector(styles, 'LOCATION',
                      '${widget.userData!.city!.name}, ${widget.userData!.state!.name}'),
                ],
              ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 1,
              horizontal: !Responsive.isDesktop(context)
                  ? 9
                  : Sizeconfig.screenWidth! / 16),
          child: Container(
            padding: EdgeInsets.all(15),
            //height: Sizeconfig.screenHeight! / 11,
            width: 100,
            color: MyAppColor.greynormal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ABOUT COMPANY',
                  style: styles.headline1!
                      .copyWith(color: MyAppColor.greylight, fontSize: 13),
                ),
                Text(
                  '${widget.userData!.companyDescription}',
                  style: styles.headline1!.copyWith(
                      color: MyAppColor.greylight,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: Sizeconfig.screenHeight! / 20,
        ),
        Footer(),
        Container(
          alignment: Alignment.center,
          color: MyAppColor.normalblack,
          height: 30,
          width: double.infinity,
          child: Text(Mystring.hackerkernel,
              style: Mytheme.lightTheme(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: MyAppColor.white)),
        ),
      ],
    );
  }

  Padding _companysector(TextTheme styles, String text, String private) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 1, horizontal: !Responsive.isDesktop(context) ? 9 : 4),
      child: Container(
        padding: EdgeInsets.all(10),
        height: Sizeconfig.screenHeight! / 11,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5.9,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: styles.headline1!
                  .copyWith(color: MyAppColor.greylight, fontSize: 13),
            ),
            Text(
              private,
              style: styles.headline1!.copyWith(
                  color: MyAppColor.greylight,
                  fontSize: 13,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
