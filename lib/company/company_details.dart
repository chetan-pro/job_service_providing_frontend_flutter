import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/edit_profile.dart';
import 'package:hindustan_job/candidate/pages/login_page/change_password.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/company_edit_profile.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:vrouter/vrouter.dart';

class CompanyDetails extends ConsumerStatefulWidget {
  // UserData? userData;
  CompanyDetails({Key? key}) : super(key: key);

  @override
  ConsumerState<CompanyDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends ConsumerState<CompanyDetails> {
  bool isSwitch = true;
  // UserData? user;
  @override
  void initState() {
    // TODO: implement initState
    // user = widget.userData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline2;

    Sizeconfig().init(context);
    return ListView(
      children: [
        Container(
          alignment: Alignment.center,
          height: Sizeconfig.screenHeight! / 5,
          child: currentUrl(userData!.image) != null
              ? CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    "${currentUrl(userData!.image)}",
                  ),
                )
              : CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                    'assets/profileIcon.png',
                  ),
                ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isDesktop(context) ? 365 : 10,
                vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () async {
                      if (checkRoleType(userData!.userRoleType)) {
                        if (kIsWeb) {
                          context.vRouter.to("/home-company/edit-profile");
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompanyEditProfile()));
                        }
                      }
                      setState(() {});
                    },
                    child: Text('Edit Profile', style: orangeDarkSb12())),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                    onTap: () async {
                      if (Responsive.isDesktop(context)) {
                        widgetPopDialog(
                            ChangePasswod(
                              email: userData!.email!,
                              flag: 'change',
                            ),
                            context,
                            width: Sizeconfig.screenWidth);
                      } else {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswod(
                                      email: userData!.email!,
                                      flag: 'change',
                                    )));
                      }
                    },
                    child: Text('Change Password', style: orangeDarkSb12())),
              ],
            )),
        if (Responsive.isDesktop(context))
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _display(styles,
                      key: LabelString.companyName,
                      value: userData!.name,
                      margin: 20.0),
                  _display(styles,
                      key: LabelString.companyMobileNumber,
                      value: userData!.mobile,
                      margin: 20.0),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _display(styles,
                      key: LabelString.companyEmail,
                      value: userData!.email,
                      margin: 20.0),
                  _display(styles,
                      key: LabelString.companyWebsite,
                      value: userData!.companyLink,
                      margin: 20.0),
                ],
              ),
              Center(
                child: Text(
                  '.  .  .  .  .  .  .  .  .  .  .  .',
                  style: styles!
                      .copyWith(fontSize: 25, color: MyAppColor.greyfulldark),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _display(styles,
                      key: LabelString.address,
                      value: userData!.addressLine1,
                      margin: 20.0),
                  _display(styles,
                      key: LabelString.flatNoBuild,
                      value: userData!.addressLine2,
                      margin: 20.0),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _display(styles,
                      key: LabelString.state,
                      value: userData!.state!.name,
                      margin: 20.0),
                  _display(styles,
                      key: LabelString.city,
                      value: userData!.city!.name,
                      margin: 20.0),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _display(styles,
                      key: LabelString.pinCode,
                      value: userData!.pinCode,
                      margin: 20.0),
                  _display(styles,
                      key: LabelString.industry,
                      value: userData!.industry != null
                          ? userData!.industry!.name
                          : '',
                      margin: 20.0),
                ],
              ),
              Center(
                child: Text(
                  '.  .  .  .  .  .  .  .  .  .  .  .',
                  style: styles.copyWith(
                      fontSize: 25, color: MyAppColor.greyfulldark),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _display(styles,
                      key: LabelString.myfullName,
                      value: userData!.yourFullName,
                      margin: 20.0),
                  _display(styles,
                      key: LabelString.myDesignation,
                      value: userData!.yourDesignation,
                      margin: 20.0),
                ],
              ),
            ],
          ),
        if (!Responsive.isDesktop(context))
          Column(
            children: [
              _display(styles,
                  key: LabelString.companyName,
                  value: userData!.name,
                  margin: 20.0),
              _display(styles,
                  key: LabelString.companyMobileNumber,
                  value: userData!.mobile,
                  margin: 20.0),
              _display(styles,
                  key: LabelString.companyEmail,
                  value: userData!.email,
                  margin: 20.0),
              _display(styles,
                  key: LabelString.companyWebsite,
                  value: userData!.companyLink,
                  margin: 20.0),
              Center(
                child: Text(
                  '.  .  .  .  .  .  .  .  .  .  .  .',
                  style: styles!
                      .copyWith(fontSize: 25, color: MyAppColor.greyfulldark),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _display(styles,
                  key: LabelString.address,
                  value: userData!.addressLine1,
                  margin: 20.0),
              _display(styles,
                  key: LabelString.flatNoBuild,
                  value: userData!.addressLine2,
                  margin: 20.0),
              _display(styles,
                  key: LabelString.state,
                  value: userData!.state!.name,
                  margin: 20.0),
              _display(styles,
                  key: LabelString.city,
                  value: userData!.city!.name,
                  margin: 20.0),
              _display(styles,
                  key: LabelString.pinCode,
                  value: userData!.pinCode,
                  margin: 20.0),
              Center(
                child: Text(
                  '.  .  .  .  .  .  .  .  .  .  .  .',
                  style: styles.copyWith(
                      fontSize: 25, color: MyAppColor.greyfulldark),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _display(styles,
                  key: LabelString.myfullName,
                  value: userData!.yourFullName,
                  margin: 20.0),
              _display(styles,
                  key: LabelString.myDesignation,
                  value: userData!.yourDesignation,
                  margin: 20.0),
            ],
          ),
        SizedBox(
          height: 60,
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

  Padding _notificationsjob(TextStyle styles) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 8 : 00),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 1.9,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available for Job',
              style: styles.copyWith(fontSize: 19),
            ),
            Switch(
              value: isSwitch,
              onChanged: (value) {
                setState(() {
                  isSwitch = value;
                });
              },
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Padding _language3(TextStyle styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language Known #3',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Urdu'),
          ],
        ),
      ),
    );
  }

  Padding _language2(TextStyle styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language Known #2',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('ENGLISH'),
          ],
        ),
      ),
    );
  }

  Padding _language1(TextStyle styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language Known #1',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('HINDI'),
          ],
        ),
      ),
    );
  }

  Padding _pincode(TextStyle styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'pincode',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('462003'),
          ],
        ),
      ),
    );
  }

  Padding _city(TextStyle styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'City',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Mumbai'),
          ],
        ),
      ),
    );
  }

  Padding _state(TextStyle styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'state',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Maharashtra'),
          ],
        ),
      ),
    );
  }

  Padding _date(TextStyle? styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '15.08.1947',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('15.08.1947'),
          ],
        ),
      ),
    );
  }

  Padding _gender(TextStyle? styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Male'),
          ],
        ),
      ),
    );
  }

  Padding _mobilenumber(TextStyle? styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobile Number',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('+91 987 654 3210'),
          ],
        ),
      ),
    );
  }

  Padding _name(TextStyle? styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('John Kumar Cena'),
          ],
        ),
      ),
    );
  }

  Padding _display(TextStyle? styles, {value, key, margin}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        margin: EdgeInsets.only(bottom: margin),
        padding: Responsive.isMobile(context)
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.all(10),
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        height:
            Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$key',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('${getCapitalizeString(value)}'),
          ],
        ),
      ),
    );
  }
}
