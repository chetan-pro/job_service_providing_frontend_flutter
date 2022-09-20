import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/pages/company_work_culture.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';

import 'comapny_profile_overview.dart';
import 'company_details.dart';

class CompanyProfile extends ConsumerStatefulWidget {
  const CompanyProfile({Key? key}) : super(key: key);

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends ConsumerState<CompanyProfile>
    with SingleTickerProviderStateMixin {
  TabController? control;

  @override
  void initState() {
    super.initState();
    ref.read(companyProfile).fetchCompanyImages(context);
    setState(() {
      control = TabController(length: 3, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    return Responsive.isMobile(context)
        ? TabBarSliverAppbar(
            length: 3,
            headColumn: const SizedBox(),
            toolBarHeight: 0,
            tabs: tab(styles),
            tabsWidgets: [
              CompanyDetails(),
              const ProfileOverViewCompany(),
              const CompanyWorkCulture()
            ],
            control: control!)
        : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                !Responsive.isDesktop(context)
                    ? SizedBox(
                        height: 30,
                        child: tab(styles),
                      )
                    : Stack(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            height: 35,
                            width: double.infinity,
                          ),
                          Positioned(
                            left: 70,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: Sizeconfig.screenWidth! / 4,
                                  child: tab(styles),
                                ),
                                Row(
                                  children: [],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: Sizeconfig.screenHeight,
                  child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      controller: control,
                      children: [
                        CompanyDetails(),
                        const ProfileOverViewCompany(),
                        const CompanyWorkCulture()
                      ]),
                )
              ],
            ),
          );
  }

  TabBar tab(TextTheme styles) {
    return TabBar(
      indicatorColor: MyAppColor.orangelight,
      labelColor: MyAppColor.blackplane,
      controller: control,
      unselectedLabelColor: MyAppColor.blackdark,
      tabs: [
        Text(
          'Company Details',
          style: styles.headline2!.copyWith(fontSize: 12),
        ),
        Text(
          'Overview',
          style: styles.headline2!.copyWith(fontSize: 12),
        ),
        Text('Work Culture', style: styles.headline2!.copyWith(fontSize: 12)),
      ],
    );
  }
}
