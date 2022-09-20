// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/header/back_text_widget.dart';
import 'package:hindustan_job/candidate/model/contract_type_model.dart';
import 'package:hindustan_job/candidate/model/education_model.dart';
import 'package:hindustan_job/candidate/model/employment_type_model.dart';
import 'package:hindustan_job/candidate/model/experience_filter_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
// import 'package:hindustan_job/candidate/model/job_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/job_schedule_model.dart';
import 'package:hindustan_job/candidate/model/job_type_model.dart';
import 'package:hindustan_job/candidate/pages/resume_builder_form.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/candidate/model/skill_category.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/work_from_home_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/job_view_page.dart';
import 'package:hindustan_job/candidate/pages/landing_page/search_job_here.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/customjob_alert.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/cards/dynamic_job_card_widget.dart';
import 'package:hindustan_job/widget/drop_down_widget/text_drop_down_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vrouter/vrouter.dart';

import 'drawer/drawer_jobseeker.dart';

class FilterJobPage extends ConsumerStatefulWidget {
  String? flag;
  Map<String, dynamic>? data;
  bool isFromConnectedRoutes;
  bool isFromSearch;
  FilterJobPage(
      {Key? key,
      this.flag,
      this.data,
      this.isFromSearch = true,
      required this.isFromConnectedRoutes})
      : super(key: key);
  static const String route = '/filter-job-page';

  @override
  ConsumerState<FilterJobPage> createState() => _FilterJobPageState();
}

class _FilterJobPageState extends ConsumerState<FilterJobPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  WFHType? selectedWFH;
  ExperienceFilter? selectedExperienceFilter;
  ContractType? selectedContractType;
  EmploymentType? selectedEmploymentType;
  JobType? selectedJobType;
  JobScheduleType? selectedJobScheduleType;
  List<Industry> selectedIndustry = [];
  List<Education> selectedEducations = [];
  List<Sector> selectedMultiSector = [];
  List<States> selectedState = [];
  List<Skill> selectedSkills = [];
  List<JobType> jobTypes = [];
  var filterJobData = {};
  List<Skill> selectskill = [];

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      filterJobData = widget.data!;
    }
    if (kIsWeb) {
      ref.read(editProfileData).checkSubscription();
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(listData).clearData();
      ref.read(jobData).fetchFilterJobs(context, filterJobData, page: page);
      ref.read(listData).fetchData(context);
    });
  }

  filterJobs(
      {filterByIndustry,
      filterBySector,
      filterByState,
      filterByExpFrom,
      filterByExpTo,
      filterByJobType,
      filterByWorkFromHome,
      filterByEmploymentType,
      filterByContractType,
      filterByJobSchedule}) async {
    filterJobData = {
      "filter_by_industry": filterByIndustry,
      "filter_by_sector": filterBySector,
      "filter_by_state": filterByState,
      "filter_by_exp_from": filterByExpFrom,
      "filter_by_exp_to": filterByExpTo,
      "filter_by_job_type": filterByJobType,
      "filter_by_work_from_home": filterByWorkFromHome,
      'filter_by_employment_type': filterByEmploymentType,
      'filter_by_contract_type': filterByContractType,
      'filter_by_job_schedule': filterByJobSchedule,
    };
    filterJobData = removeNullEmptyKey(filterJobData);
    page = 1;
    await ref.read(jobData).fetchFilterJobs(context, filterJobData, page: page);
    Navigator.pop(context);
  }

  int page = 1;

  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    page = 1;
    await ref.read(jobData).fetchFilterJobs(context, filterJobData, page: page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    // return;
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    page += 1;
    await ref.read(jobData).fetchFilterJobs(context, filterJobData, page: page);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    final size = MediaQuery.of(context).size;
    Sizeconfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _drawerKey,
        drawer: Drawer(
          child: DrawerJobSeeker(),
        ),
        backgroundColor: MyAppColor.backgroundColor,
        appBar: widget.isFromConnectedRoutes
            ? PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: BackWithText(text: 'SEARCH RESULT FOR JOB SEEKER'))
            : CustomAppBar(
                context: context,
                drawerKey: _drawerKey,
                back: 'SEARCH RESULT FOR JOB SEEKER',
              ),
        body: !Responsive.isDesktop(context)
            ? Consumer(builder: (context, watch, child) {
                // List<JobsTwo> filterJobs = ref.watch(jobData).filterJobsList;

                List<JobsTwo> filterJobs = ref.watch(jobData).filterJobsList;
                return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext? context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("pull up load");
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else {
                        body = Text("No more Data");
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _customjob(styles),
                              _resumeBuilder(styles),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 10),
                          child: Text(
                            'Search Result',
                            style: blackRegularGalano14,
                          ),
                        ),
                        if (!Responsive.isDesktop(context))
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // if (!Responsive.isDesktop(context))
                                InkWell(
                                  onTap: () async {
                                    await bottomFilterSheet();
                                  },
                                  child: Icon(
                                    Icons.filter_alt_outlined,
                                    color: MyAppColor.blackdark,
                                    size: 30,
                                  ),
                                ),
                                sortByrelevence(),
                              ],
                            ),
                          ),
                        if (!Responsive.isDesktop(context))
                          Column(
                            children: List.generate(
                              filterJobs.length,
                              (index) => InkWell(
                                  onTap: () {
                                    if (kIsWeb) {
                                      context.vRouter.to(
                                          '/hindustaan-jobs/job-view-page/${filterJobs[index].id}/filter',
                                          queryParameters: {
                                            "offerLetter":
                                                filterJobs[index].offerLetter!,
                                            "candidateStatus": filterJobs[index]
                                                .candidateStatus!,
                                            "companyStatus": filterJobs[index]
                                                .companyStatus!,
                                            "reason": filterJobs[index].reason!,
                                          });
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JobViewPage(
                                              id: filterJobs[index].id,
                                              candidateStatus: filterJobs[index]
                                                  .candidateStatus,
                                              companyStatus: filterJobs[index]
                                                  .companyStatus,
                                              offerletter:
                                                  filterJobs[index].offerLetter,
                                              reason: filterJobs[index].reason,
                                              isFromSearch:
                                                  widget.isFromSearch),
                                        ),
                                      );
                                    }
                                    return;
                                  },
                                  child: DynamicJobCard(
                                    job: filterJobs[index],
                                    cardState: CardState.filter,
                                  )),
                            ),
                          ),
                        if (filterJobs.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 10),
                            child: Text(
                              'No Data Found',
                              style: blackRegularGalano14,
                            ),
                          ),
                        // Footer(),
                        // Container(
                        //   alignment: Alignment.center,
                        //   color: MyAppColor.normalblack,
                        //   height: 30,
                        //   width: double.infinity,
                        //   child: Text(Mystring.hackerkernel,
                        //       style: Mytheme.lightTheme(context)
                        //           .textTheme
                        //           .headline1!
                        //           .copyWith(color: MyAppColor.white)),
                        // ),
                      ],
                    ),
                  ),
                );
              })
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SerchJobHere(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer(builder: (context, watch, child) {
                          List<Industry> industry =
                              ref.watch(listData).industry;
                          List<States> states = ref.watch(listData).state;
                          List<Skill> skills =
                              ref.watch(listData).skillCategory;
                          List<Sector> multiSector =
                              ref.watch(listData).multiSector;
                          List<Education> educations =
                              ref.watch(listData).educations;
                          List<WFHType> whfTypes = ref.watch(listData).wfhList;
                          List<ContractType> contractTypes =
                              ref.watch(listData).contractType;
                          List<ExperienceFilter> experienceFilters =
                              ref.watch(listData).experienceFilter;
                          List<JobScheduleType> jobScheduleTypes =
                              ref.watch(listData).jobSchedule;
                          List<EmploymentType> employmentTypes =
                              ref.watch(listData).employmentType;
                          Function onSelectIndustry =
                              ref.watch(listData).onSelectIndustry;
                          Function onSelectSector =
                              ref.watch(listData).onSelectSector;
                          Function onSelectLocation =
                              ref.watch(listData).onSelectLocation;
                          Function onSelectSkills =
                              ref.watch(listData).onSelectSkills;
                          Function onSelectEducations =
                              ref.watch(listData).onSelectEducation;
                          Function onSelectWFH =
                              ref.watch(listData).onSelectWFHType;
                          Function isRadioChanged =
                              ref.watch(listData).radioChanged;
                          return Expanded(
                            flex: 5,
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 50, right: 20, top: 20),
                              margin: EdgeInsets.only(left: 40, right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    padding: paddingAll10,
                                    color: MyAppColor.simplegrey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Filters',
                                          style: blackDarkR12(),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Clear all Filters',
                                              style: blackdarkM10,
                                            ),
                                            Icon(
                                              Icons.clear,
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  filterSectoin1(
                                      label: 'JOB INDUSTRY',
                                      list: industry,
                                      onSelecting: (value, index) {
                                        if (selectedIndustry
                                            .contains(industry[index])) {
                                          selectedIndustry
                                              .remove(industry[index]);
                                        } else {
                                          selectedIndustry.add(industry[index]);
                                        }
                                        onSelectIndustry(context,
                                            value: value, index: index);
                                      }),
                                  filterSectoin1(
                                      label: 'JOB SECTOR',
                                      list: multiSector,
                                      isOpen: (value) {
                                        if (multiSector.isEmpty) {
                                          return toast("Select Industry First");
                                        }
                                      },
                                      onSelecting: (value, index) {
                                        if (selectedMultiSector
                                            .contains(multiSector[index])) {
                                          selectedMultiSector
                                              .remove(multiSector[index]);
                                        } else {
                                          selectedMultiSector
                                              .add(multiSector[index]);
                                        }
                                        onSelectSector(context,
                                            value: value, index: index);
                                      }),
                                  filterSectoin1(
                                      label: 'Location',
                                      list: states,
                                      onSelecting: (value, index) {
                                        if (selectedState
                                            .contains(states[index])) {
                                          selectedState.remove(states[index]);
                                        } else {
                                          selectedState.add(states[index]);
                                        }
                                        onSelectLocation(context,
                                            value: value, index: index);
                                      }),
                                  filterSectoin1(
                                      label: 'SKILLS REQUIRED',
                                      list: skills,
                                      onSelecting: (value, index) {
                                        if (selectedSkills
                                            .contains(skills[index])) {
                                          selectedSkills.remove(skills[index]);
                                        } else {
                                          selectedSkills.add(skills[index]);
                                        }
                                        onSelectSkills(context,
                                            value: value, index: index);
                                      }),
                                  filterSectionRadio(
                                      label: 'EXPERIENCE REQUIRED',
                                      list: experienceFilters,
                                      selectedValue: selectedExperienceFilter,
                                      onSelecting: (value, index) {
                                        selectedExperienceFilter =
                                            experienceFilters[index];
                                        isRadioChanged(value);
                                      }),
                                  filterSectoin1(
                                      label: 'EDUCATION REQUIRED',
                                      list: educations,
                                      onSelecting: (value, index) {
                                        if (selectedEducations
                                            .contains(educations[index])) {
                                          selectedEducations
                                              .remove(educations[index]);
                                        } else {
                                          selectedEducations
                                              .add(educations[index]);
                                        }
                                        onSelectEducations(context,
                                            value: value, index: index);
                                      }),
                                  filterSectionRadio(
                                      label: 'EMPLOYMENT TYPE',
                                      list: employmentTypes,
                                      selectedValue: selectedEmploymentType,
                                      onSelecting: (value, index) {
                                        selectedEmploymentType =
                                            employmentTypes[index];
                                        isRadioChanged(value);
                                      }),
                                  filterSectionRadio(
                                      label: 'CONTRACT TYPE',
                                      list: contractTypes,
                                      selectedValue: selectedContractType,
                                      onSelecting: (value, index) {
                                        selectedContractType =
                                            contractTypes[index];
                                        isRadioChanged(value);
                                      }),
                                  filterSectionRadio(
                                      label: 'WORK SCHEDULE',
                                      list: jobScheduleTypes,
                                      selectedValue: selectedJobScheduleType,
                                      onSelecting: (value, index) {
                                        selectedJobScheduleType =
                                            jobScheduleTypes[index];
                                        isRadioChanged(value);
                                      }),
                                  filterSectionRadio(
                                      label: 'WORK FROM HOME',
                                      list: whfTypes,
                                      selectedValue: selectedWFH,
                                      onSelecting: (value, index) {
                                        selectedWFH = whfTypes[index];
                                        isRadioChanged(value);
                                      }),
                                  InkWell(
                                    onTap: () async {
                                      try {
                                        String industryIds = selectedIndustry
                                            .map((e) => e.id)
                                            .toList()
                                            .join(",");
                                        String sectorIds = selectedMultiSector
                                            .map((e) => e.id)
                                            .toList()
                                            .join(",");
                                        String stateIds = selectedState
                                            .map((e) => e.id)
                                            .toList()
                                            .join(",");
                                        await filterJobs(
                                            filterByIndustry: industryIds,
                                            filterBySector: sectorIds,
                                            filterByState: stateIds,
                                            filterByContractType:
                                                selectedContractType?.key,
                                            filterByEmploymentType:
                                                selectedEmploymentType?.key,
                                            filterByJobSchedule:
                                                selectedJobScheduleType?.key,
                                            filterByWorkFromHome:
                                                selectedWFH?.key,
                                            filterByExpFrom:
                                                selectedExperienceFilter?.from,
                                            filterByExpTo:
                                                selectedExperienceFilter?.from);
                                      } catch (e) {}
                                    },
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 40),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: MyAppColor.blackdark)),
                                        child: Text('DONE')),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        Consumer(builder: (context, watch, child) {
                          List<JobsTwo> filterJobs =
                              ref.watch(jobData).filterJobsList.isEmpty
                                  ? ref.watch(jobData).recommendJobs
                                  : ref.watch(jobData).filterJobsList;
                          return Expanded(
                            flex: 12,
                            child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _customjob(styles),
                                        SizedBox(
                                          width: Sizeconfig.screenWidth! / 95,
                                        ),
                                        _resumeBuilder(styles)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        width: Sizeconfig.screenWidth! / 1.5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Search Result for "Motion Designer"',
                                                  style: blackDarkR12(),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 25.0),
                                              child: sortByrelevence(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      runSpacing: 8,
                                      spacing: 8,
                                      children: List.generate(
                                        filterJobs.length,
                                        (index) => InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      JobViewPage(
                                                    id: filterJobs[index].id,
                                                    reason: filterJobs[index]
                                                        .reason,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: DynamicJobCard(
                                              job: filterJobs[index],
                                              cardState: CardState.filter,
                                            )),
                                      ),
                                    ),
                                  ),
                                  if (filterJobs.isEmpty)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 30.0, horizontal: 10),
                                      child: Text(
                                        'No Data Found',
                                        style: blackRegularGalano14,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     IconButton(
                    //       onPressed: () {},
                    //       icon: Icon(Icons.expand_more),
                    //     ),
                    //     Text(
                    //       'Sort by Relevance',
                    //       style: blackMediumGalano14,
                    //     ),
                    //   ],
                    // ),
                    Footer(),
                  ],
                ),
              ),
      ),
    );
  }

  Container _customjob(TextStyle styles) {
    return Container(
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth! / 2 - 15
          : Sizeconfig.screenWidth! / 4.8,
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 3.5
          : Sizeconfig.screenHeight! / 6,
      color: MyAppColor.orangelight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Responsive.isMobile(context))
                    Text(
                      'Get Free Custom\nJob Alerts',
                      textAlign: TextAlign.center,
                      style: !Responsive.isDesktop(context)
                          ? whiteSb16()
                          : whiteSb12(),
                    ),
                  if (Responsive.isDesktop(context))
                    Text(
                      'Get Free Custom Job Alerts',
                      style: !Responsive.isDesktop(context)
                          ? whiteSb16()
                          : whiteSb12(),
                    ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 18,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 130,
                        child: OutlinedButton(
                          onPressed: () {
                            if (kIsWeb) {
                              context.vRouter
                                  .to("/job-seeker/custom-job-alert");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomJobAlerts(
                                            isFromConnectedRoutes: true,
                                          )));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GET ALERTS',
                                style: !Responsive.isDesktop(context)
                                    ? whiteR12()
                                    : whiteR10(),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Image.asset(
                                'assets/get-alert-icon.png',
                                height: 16,
                              )
                            ],
                          ),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: MyAppColor.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 00,
            right: 00,
            child: Image.asset(
              'assets/get-alert-image-up.png',
              height: 20,
            ),
          ),
          Positioned(
            bottom: 00,
            left: 00,
            child: Image.asset(
              'assets/get-alert-image-down.png',
              height: 18,
            ),
          )
        ],
      ),
    );
  }

  Container _resumeBuilder(TextStyle styles) {
    return Container(
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth! / 2 - 8
          : Sizeconfig.screenWidth! / 4.8,
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 3.5
          : Sizeconfig.screenHeight! / 6,
      color: MyAppColor.darkBlue,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Responsive.isMobile(context))
                    Text(
                      'Professional\nResume Builder',
                      textAlign: TextAlign.center,
                      style: !Responsive.isDesktop(context)
                          ? whiteSb16()
                          : whiteSb12(),
                    ),
                  if (Responsive.isDesktop(context))
                    Text(
                      '     Professional  Resume Builder',
                      style: !Responsive.isDesktop(context)
                          ? whiteSb16()
                          : whiteSb12(),
                    ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 18,
                  ),
                  SizedBox(
                    // width: 130,
                    child: OutlinedButton(
                      onPressed: () {
                        if (kIsWeb) {
                          context.vRouter.to('/hindustaan-jobs/resume-builder');
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResumeBuilder(
                                        isFromConnectedRoutes: true,
                                      )));
                        }
                        return;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: !Responsive.isDesktop(context)
                                ? const EdgeInsets.all(5.0)
                                : EdgeInsets.symmetric(horizontal: 0),
                            child: Text(
                              'GET STARTED',
                              style: !Responsive.isDesktop(context)
                                  ? whiteR12()
                                  : whiteR10(),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Image.asset(
                            'assets/get-started-icon.png',
                            height: 16,
                          )
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: MyAppColor.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 00,
            right: 00,
            child: Image.asset(
              'assets/get-started-image-up.png',
              height: 18,
            ),
          ),
          Positioned(
            bottom: 00,
            left: 00,
            child: Image.asset(
              'assets/get-started-image-down.png',
              height: 18,
            ),
          )
        ],
      ),
    );
  }

  String sortBy = 'Sort by Relevance';
  Widget sortByrelevence() {
    return AppDropdownInput(
      hintText: 'Sort by Relevance',
      options: [
        'Ascending',
        'Descending',
      ],
      value: sortBy,
      changed: (String value) async {
        sortBy = value;
        if (sortBy != 'Sort by Relevance') {
          var newFilter = Map.of(filterJobData);
          newFilter['direction'] = value;
          newFilter['order_by'] = 'id';
          ref.read(jobData).fetchFilterJobs(context, newFilter, page: 1);
        }
        setState(() {});
      },
      getLabel: (String value) => value,
    );
  }

  bottomFilterSheet() {
    return showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (_) => StatefulBuilder(
              builder: (context, StateSetter setState) {
                return Consumer(builder: (context, ref, child) {
                  List<Industry> industry = ref.watch(listData).industry;
                  List<States> states = ref.watch(listData).state;
                  List<Skill> skills = ref.watch(listData).skillCategory;
                  List<Sector> multiSector = ref.watch(listData).multiSector;
                  List<Education> educations = ref.watch(listData).educations;
                  List<WFHType> whfTypes = ref.watch(listData).wfhList;
                  List<ContractType> contractTypes =
                      ref.watch(listData).contractType;
                  List<ExperienceFilter> experienceFilters =
                      ref.watch(listData).experienceFilter;
                  List<JobScheduleType> jobScheduleTypes =
                      ref.watch(listData).jobSchedule;
                  List<EmploymentType> employmentTypes =
                      ref.watch(listData).employmentType;
                  List<JobType> jobTypes = ref.watch(listData).jobTypes;
                  Function onSelectIndustry =
                      ref.watch(listData).onSelectIndustry;
                  Function onSelectSector = ref.watch(listData).onSelectSector;
                  Function onSelectLocation =
                      ref.watch(listData).onSelectLocation;
                  Function onSelectSkills = ref.watch(listData).onSelectSkills;
                  Function onSelectEducations =
                      ref.watch(listData).onSelectEducation;
                  Function onSelectWFH = ref.watch(listData).onSelectWFHType;
                  Function isRadioChanged = ref.watch(listData).radioChanged;
                  String isRadio = ref.watch(listData).isRadioValue;
                  return FractionallySizedBox(
                    heightFactor: 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: Stack(
                        children: [
                          ListView(
                            children: [
                              filterHead(),
                              filterSectoin1(
                                  label: 'JOB INDUSTRY',
                                  list: industry,
                                  onSelecting: (value, index) {
                                    if (selectedIndustry
                                        .contains(industry[index])) {
                                      selectedIndustry.remove(industry[index]);
                                    } else {
                                      selectedIndustry.add(industry[index]);
                                    }
                                    onSelectIndustry(context,
                                        value: value, index: index);
                                  }),
                              filterSectoin1(
                                  label: 'JOB SECTOR',
                                  list: multiSector,
                                  isOpen: (value) {
                                    if (multiSector.isEmpty) {
                                      return toast("Select Industry First");
                                    }
                                  },
                                  onSelecting: (value, index) {
                                    if (selectedMultiSector
                                        .contains(multiSector[index])) {
                                      selectedMultiSector
                                          .remove(multiSector[index]);
                                    } else {
                                      selectedMultiSector
                                          .add(multiSector[index]);
                                    }
                                    onSelectSector(context,
                                        value: value, index: index);
                                  }),
                              // sliderSectoin1(
                              //     label: 'SALARY', setState: setState),
                              filterSectoin1(
                                  label: 'Location',
                                  list: states,
                                  onSelecting: (value, index) {
                                    if (selectedState.contains(states[index])) {
                                      selectedState.remove(states[index]);
                                    } else {
                                      selectedState.add(states[index]);
                                    }
                                    onSelectLocation(context,
                                        value: value, index: index);
                                  }),
                              filterSectoin1(
                                  label: 'SKILLS REQUIRED',
                                  list: skills,
                                  onSelecting: (value, index) {
                                    if (selectedSkills
                                        .contains(skills[index])) {
                                      selectedSkills.remove(skills[index]);
                                    } else {
                                      selectedSkills.add(skills[index]);
                                    }
                                    onSelectSkills(context,
                                        value: value, index: index);
                                  }),
                              filterSectionRadio(
                                  label: 'EXPERIENCE REQUIRED',
                                  list: experienceFilters,
                                  selectedValue: selectedExperienceFilter,
                                  onSelecting: (value, index) {
                                    selectedExperienceFilter =
                                        experienceFilters[index];
                                    isRadioChanged(value);
                                  }),
                              filterSectoin1(
                                  label: 'EDUCATION REQUIRED',
                                  list: educations,
                                  onSelecting: (value, index) {
                                    if (selectedEducations
                                        .contains(educations[index])) {
                                      selectedEducations
                                          .remove(educations[index]);
                                    } else {
                                      selectedEducations.add(educations[index]);
                                    }
                                    onSelectEducations(context,
                                        value: value, index: index);
                                  }),
                              filterSectionRadio(
                                  label: 'EMPLOYMENT TYPE',
                                  list: employmentTypes,
                                  selectedValue: selectedEmploymentType,
                                  onSelecting: (value, index) {
                                    selectedEmploymentType =
                                        employmentTypes[index];
                                    isRadioChanged(value);
                                  }),
                              filterSectionRadio(
                                  label: 'JOB TYPE',
                                  list: jobTypes,
                                  selectedValue: selectedJobType,
                                  onSelecting: (value, index) {
                                    selectedJobType = jobTypes[index];
                                    isRadioChanged(value);
                                  }),
                              filterSectionRadio(
                                  label: 'CONTRACT TYPE',
                                  list: contractTypes,
                                  selectedValue: selectedContractType,
                                  onSelecting: (value, index) {
                                    selectedContractType = contractTypes[index];
                                    isRadioChanged(value);
                                  }),
                              filterSectionRadio(
                                  label: 'WORK SCHEDULE',
                                  list: jobScheduleTypes,
                                  selectedValue: selectedJobScheduleType,
                                  onSelecting: (value, index) {
                                    selectedJobScheduleType =
                                        jobScheduleTypes[index];
                                    isRadioChanged(value);
                                  }),
                              filterSectionRadio(
                                  label: 'WORK FROM HOME',
                                  list: whfTypes,
                                  selectedValue: selectedWFH,
                                  onSelecting: (value, index) {
                                    selectedWFH = whfTypes[index];
                                    isRadioChanged(value);
                                  }),
                              InkWell(
                                onTap: () async {
                                  String industryIds = selectedIndustry
                                      .map((e) => e.id)
                                      .toList()
                                      .join(",");
                                  String sectorIds = selectedMultiSector
                                      .map((e) => e.id)
                                      .toList()
                                      .join(",");
                                  String stateIds = selectedState
                                      .map((e) => e.id)
                                      .toList()
                                      .join(",");
                                  try {
                                    await filterJobs(
                                        filterByIndustry: industryIds,
                                        filterBySector: sectorIds,
                                        filterByState: stateIds,
                                        filterByContractType:
                                            selectedContractType?.key,
                                        filterByEmploymentType:
                                            selectedEmploymentType?.key,
                                        filterByJobSchedule:
                                            selectedJobScheduleType?.key,
                                        filterByJobType: selectedJobType?.id,
                                        filterByWorkFromHome: selectedWFH?.key,
                                        filterByExpFrom:
                                            selectedExperienceFilter?.from,
                                        filterByExpTo:
                                            selectedExperienceFilter?.from);
                                  } catch (error) {}
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 40),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: MyAppColor.blackdark)),
                                    child: Text('DONE')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ));
  }

  filterHead() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 30, right: 12, top: 13, bottom: 12),
      color: MyAppColor.simplegrey,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:
          // ignore: prefer_const_literals_to_create_immutables
          [
        Text(
          'Filters',
          style: blackRegularGalano14,
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Text(
                'Clear all Filters',
                style: blackRegularGalano14,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Icon(Icons.close),
              )
            ],
          ),
        ),
      ]),
    );
  }

  filterSectoin1({label, list, onTap, isOpen, onSelecting}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 2),
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.only(left: 30, right: 30, top: 24, bottom: 12)
          : EdgeInsets.only(left: 10, right: 10),
      color: MyAppColor.graydf,
      child: Column(
        children: [
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              onExpansionChanged: (value) =>
                  isOpen != null ? isOpen(value) : null,
              iconColor: MyAppColor.blackdark,
              title: Text(
                label,
                style: !Responsive.isDesktop(context)
                    ? blackDarkR18
                    : blackDarkR16,
              ),
              children: List.generate(
                  list.length,
                  (index) => checkBoxWithLabel(
                      label: "${list[index].name}",
                      value: list[index].isSelected,
                      onSelect: (value) {
                        onSelecting(value, index);
                      })),
            ),
          ),
        ],
      ),
    );
  }

  filterSectionRadio({label, list, onTap, isOpen, onSelecting, selectedValue}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 2),
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.only(left: 30, right: 30, top: 24, bottom: 12)
          : EdgeInsets.only(left: 10, right: 10),
      color: MyAppColor.graydf,
      child: Column(
        children: [
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              onExpansionChanged: (value) =>
                  isOpen != null ? isOpen(value) : null,
              iconColor: MyAppColor.blackdark,
              title: Text(label,
                  style: !Responsive.isDesktop(context)
                      ? blackDarkR18
                      : blackDarkR16),
              children: List.generate(
                  list.length,
                  (index) => RadioButton(
                        groupValue: selectedValue?.name,
                        onChanged: (v) => onSelecting(v, index),
                        text: getCapitalizeString(list[index].name),
                        value: list[index].name,
                      )),
            ),
          ),
        ],
      ),
    );
  }

  RangeValues _currentRangeValues = const RangeValues(40, 80);
  sliderSectoin1({label, list, setState}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 2),
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.only(left: 30, right: 30, top: 24, bottom: 12)
          : EdgeInsets.only(left: 10, right: 10),
      color: MyAppColor.simplegrey,
      child: Column(
        children: [
          Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                  iconColor: MyAppColor.blackdark,
                  title: Text(label, style: blackDarkR18),
                  children: [
                    RangeSlider(
                      values: _currentRangeValues,
                      max: 100,
                      divisions: 5,
                      activeColor: MyAppColor.orangedark,
                      labels: RangeLabels(
                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    )
                  ])),
        ],
      ),
    );
  }

  checkBoxWithLabel({label, value, onSelect}) {
    return Row(
      children: [
        Theme(
          data: new ThemeData.dark().copyWith(
            unselectedWidgetColor: MyAppColor.greyCheckBorderColor,
            toggleableActiveColor: MyAppColor.orangedark,
          ),
          child: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              checkColor: MyAppColor.white,
              value: value,
              onChanged: (value) {
                onSelect(value);
              }),
        ),
        Text(
          '$label',
          style: blackRegularGalano14,
        ),
      ],
    );
  }

  _back() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: Sizeconfig.screenHeight! / 20,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Container(
              height: 30,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyAppColor.backgray,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 17,
                      color: Colors.black,
                    ),
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Back",
              style: TextStyle(
                color: MyAppColor.blackdark,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text("Search Result",
                maxLines: 2, style: GoogleFonts.darkerGrotesque(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _menu() {
    return Container(
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 3 : null,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.orangelight,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Job-seeker Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.orangelight),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service provider",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          color: MyAppColor.normalblack,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service seeker",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.normalblack,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Local Hunar Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.normalblack,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: !Responsive.isDesktop(context) ? 120 : 58,
      iconTheme: IconThemeData(color: MyAppColor.blackdark),
      backgroundColor: MyAppColor.backgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _drawerKey.currentState!.openDrawer();
              },
              child: Image.asset(
                'assets/drawers.png',
                height: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                'assets/logosmall.png',
                fit: BoxFit.cover,
              ),
            ),
            if (Responsive.isDesktop(context))
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _menu(),
                ],
              )),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Row(
            children: [
              Image.asset(
                'assets/walleticon.png',
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
                child: Image.asset(
                  'assets/notificationiocn.png',
                  width: 20,
                  height: 20,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  child: ClipOval(
                    child: currentUrl(userData!.image) != null
                        ? Image.network(
                            "${currentUrl(userData!.image)}",
                            height: 36,
                            width: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/profileIcon.png',
                                height: 36,
                                width: 36,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/profileIcon.png',
                            height: 36,
                            width: 36,
                            fit: BoxFit.cover,
                          ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Column(
          children: [
            if (!Responsive.isDesktop(context)) _menu(),
            _back(),
          ],
        ),
        preferredSize: Size.fromHeight(40),
      ),
    );
  }

  void stringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? api_token = prefs.getString('USER_Token');
  }
}
