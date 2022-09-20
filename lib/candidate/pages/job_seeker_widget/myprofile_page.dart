// ignore_for_file: camel_case_types, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/personal_details.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/work_experience.dart';
import 'package:hindustan_job/candidate/pages/login_page/change_password.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:vrouter/vrouter.dart';

import '../../../services/auth/auth.dart';
import '../../theme_modeule/text_style.dart';
import '../job_seeker_page/home/edit_profile.dart';
import '../landing_page/search_job_here.dart';
import 'eduacation_skills.dart';

class MyprofilePage extends ConsumerStatefulWidget {
  const MyprofilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyprofilePage> createState() => _MyprofilePageState();
}

class _MyprofilePageState extends ConsumerState<MyprofilePage>
    with SingleTickerProviderStateMixin {
  TabController? control;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editProfileData).getAllData(context);
    });
    setState(() {
      control = TabController(length: 3, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme;
    return Responsive.isMobile(context)
        ? TabBarSliverAppbar(
            length: 3,
            tabs: _tab(control: control, styles: styles),
            tabsWidgets: [
              PersonalDetails(),
              const EducationSkills(),
              const WorkExperince(),
            ],
            control: control!,
          )
        : TabBarSliverAppbar(
            toolBarHeight: 90,
            headColumn: SerchJobHere(),
            sort: editpass(context, ref),
            length: 3,
            tabs: _tab(control: control, styles: styles),
            tabsWidgets: [
              PersonalDetails(),
              const EducationSkills(),
              const WorkExperince(),
            ],
            control: control!,
          );
  }

  editpass(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        InkWell(
            onTap: () async {
              context.vRouter.to('/job-seeker/edit-profile');
              ref.read(editProfileData).calculateProfilePercent();
              setState(() {});
            },
            child: Text('Edit Profile', style: orangeDarkSb12())),
        SizedBox(
          width: 8,
        ),
        InkWell(
            onTap: () async {
              Responsive.isDesktop(context)
                  ? showDialog(
                      context: context,
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
                                  child: ChangePasswod(
                                    email: userData!.email!,
                                    flag: 'change',
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
                  : await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswod(
                                email: userData!.email!,
                                flag: 'change',
                              )));
            },
            child: Text('Change Password', style: orangeDarkSb12())),
      ],
    );
  }

  _tab({
    control,
    styles,
  }) {
    return TabBar(
      isScrollable: true,
      indicatorColor: MyAppColor.orangelight,
      labelColor: MyAppColor.blackplane,
      controller: control,
      unselectedLabelColor: MyAppColor.blackdark,
      tabs: [
        text(
          'Personal Details',
        ),
        text(
          'Education & Skills',
        ),
        text('Work Experience'),
      ],
    );
  }

  Widget text(text) => Text(
        '$text',
        textAlign: TextAlign.center,
        style: blackDark12,
      );
}
