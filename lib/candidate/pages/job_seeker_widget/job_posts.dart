// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/closejobs.dart';
import 'package:hindustan_job/company/home/create_job_post.dart';
import 'package:hindustan_job/company/home/openjobs.dart';
import 'package:hindustan_job/company/home/widget/createjob_findjob.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:vrouter/vrouter.dart';

import '../../../company/home/widget/home_filter_options.dart';
import '../../../constants/types_constant.dart';

class JobPosts extends StatefulWidget {
  bool isUserSubscribed;
  JobPosts({Key? key, required this.isUserSubscribed}) : super(key: key);

  @override
  State<JobPosts> createState() => _JobPostsState();
}

class _JobPostsState extends State<JobPosts> with TickerProviderStateMixin {
  TabController? jobControlller;
  @override
  void initState() {
    super.initState();
    jobControlller = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive.isMobile(context)
            ? TabBarSliverAppbar(
                length: 2,
                control: jobControlller!,
                tabs: TabBar(
                  controller: jobControlller,
                  indicatorColor: MyAppColor.orangelight,
                  labelColor: Colors.black,
                  labelStyle: const TextStyle(
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(
                      text: "Open Jobs",
                    ),
                    Tab(text: "Close Jobs"),
                  ],
                ),
                headColumn: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CreateFindJOb(
                    isUserSubscribed: widget.isUserSubscribed,
                  ),
                ),
                toolBarHeight:
                    userData!.userRoleType == RoleTypeConstant.companyStaff
                        ? 80
                        : 140,
                tabsWidgets: [
                  OpenJobs(isUserSubscribed: widget.isUserSubscribed),
                  CloseJobs(isUserSubscribed: widget.isUserSubscribed),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (Responsive.isDesktop(context))
                      Padding(
                        padding: Responsive.isDesktop(context)
                            ? EdgeInsets.symmetric(
                                horizontal: 100.0, vertical: 10)
                            : EdgeInsets.symmetric(horizontal: 10.0),
                        child: HomeFilterOptions(
                            flag: 'post',
                            isUserSubscribed: widget.isUserSubscribed),
                      ),
                    //
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!Responsive.isDesktop(context))
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: CreateFindJOb(
                                isUserSubscribed: widget.isUserSubscribed,
                              ),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (Responsive.isDesktop(context))
                            Stack(
                              children: [
                                Container(
                                  height: 50,
                                ),
                                Positioned(
                                  left: Sizeconfig.screenWidth! / 15,
                                  top: 00,
                                  child: SizedBox(
                                    width: Sizeconfig.screenWidth! / 6,
                                    child: TabBar(
                                      indicatorColor: MyAppColor.orangelight,
                                      labelColor: Colors.black,
                                      labelStyle: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      tabs: const [
                                        Tab(
                                          text: "Open Jobs",
                                        ),
                                        Tab(text: "Close Jobs"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 00, right: 00, top: 5),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: TabBarView(
                                children: [
                                  OpenJobs(
                                      isUserSubscribed:
                                          widget.isUserSubscribed),
                                  CloseJobs(
                                      isUserSubscribed:
                                          widget.isUserSubscribed),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  _resume() {
    return ElevatedButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: const [
            Icon(Icons.search),
            Text(
              'FIND RESUME',
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(primary: MyAppColor.orangelight),
    );
  }

  Widget _skill(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 8 : 4, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 9),
        height:
            Responsive.isMobile(context) ? 46 : Sizeconfig.screenHeight! / 22,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton<String>(
                value: DropdownString.skill,
                icon: IconFile.arrow,
                iconSize: Responsive.isMobile(context) ? 25 : 17,
                elevation: 16,
                style: TextStyle(color: MyAppColor.blackdark),
                underline: Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  color: MyAppColor.blackdark,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    DropdownString.sector = newValue!;
                  });
                },
                items: ListDropdown.skills
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: Responsive.isMobile(context) ? null : 11,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _salery(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 8 : 4, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 9),
        height:
            Responsive.isMobile(context) ? 46 : Sizeconfig.screenHeight! / 22,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton<String>(
                value: DropdownString.salery,
                icon: IconFile.arrow,
                iconSize: Responsive.isMobile(context) ? 25 : 17,
                elevation: 16,
                style: TextStyle(color: MyAppColor.blackdark),
                underline: Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  color: MyAppColor.blackdark,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    DropdownString.salery = newValue!;
                  });
                },
                items: ListDropdown.saleries
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: Responsive.isMobile(context) ? null : 11,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget experience(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 8 : 4, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 9),
        height:
            Responsive.isMobile(context) ? 46 : Sizeconfig.screenHeight! / 22,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton<String>(
                value: DropdownString.experience,
                icon: IconFile.arrow,
                iconSize: Responsive.isMobile(context) ? 25 : 17,
                elevation: 16,
                style: TextStyle(color: MyAppColor.blackdark),
                underline: Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  color: MyAppColor.blackdark,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    DropdownString.experience = newValue!;
                  });
                },
                items: ListDropdown.experiences
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: Responsive.isMobile(context) ? null : 11,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _location(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 8 : 4, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 9),
        height:
            Responsive.isMobile(context) ? 46 : Sizeconfig.screenHeight! / 22,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton<String>(
                value: DropdownString.location,
                icon: IconFile.arrow,
                iconSize: Responsive.isMobile(context) ? 25 : 17,
                elevation: 16,
                style: TextStyle(color: MyAppColor.blackdark),
                underline: Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  color: MyAppColor.blackdark,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    DropdownString.location = newValue!;
                  });
                },
                items: ListDropdown.locations
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.isMobile(context) ? null : 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _createJob(isUserSubscribed) {
    return ElevatedButton(
        onPressed: () {
          if (isUserSubscribed) {
            if (kIsWeb) {
              context.vRouter.to('/home-company/create-job-post');
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateJobPost(),
                ),
              );
            }
          } else {
            showSnack(
                context: context,
                msg: "You have to subscribe first for creating job");
          }
          return;
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const Icon(Icons.add),
              Text(
                'CREATE A JOB POST',
                style: !Responsive.isDesktop(context) ? whiteR14() : whiteR12(),
              ),
            ],
          ),
        ));
  }
}
