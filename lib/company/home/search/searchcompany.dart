// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, unused_import, non_constant_identifier_names, must_be_immutable, prefer_final_fields, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/skill_tag_widget.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/contract_type_model.dart';
import 'package:hindustan_job/candidate/model/education_model.dart';
import 'package:hindustan_job/candidate/model/employment_type_model.dart';
import 'package:hindustan_job/candidate/model/experience_filter_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/job_schedule_model.dart';
import 'package:hindustan_job/candidate/model/job_type_model.dart';
import 'package:hindustan_job/candidate/model/key_value_model.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/candidate/model/skill_category.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/model/work_from_home_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/candidate_profile.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/company/home/widget/createjob_findjob.dart';
import 'package:hindustan_job/company/home/widget/search.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/bottom_sheet_utility_functions.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/buttons/submit_elevated_button.dart';
import 'package:hindustan_job/widget/checkbox/customchekbox.dart';
import 'package:hindustan_job/widget/drop_down_widget/custom_dropdown.dart';
import 'package:hindustan_job/widget/drop_down_widget/pop_picker.dart';
import 'package:hindustan_job/widget/filter_section/filter_section_one_widget.dart';
import 'package:hindustan_job/widget/filter_section/filter_section_two_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:flutter/scheduler.dart';
import 'package:hindustan_job/widget/search_widget.dart/candidate_search_widget.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widget/drop_down_widget/text_drop_down_widget.dart';

class SearchCompany extends ConsumerStatefulWidget {
  Map<String, dynamic>? data;
  bool isUserSubscribed;
  bool isNotApplied;
  SearchCompany(
      {Key? key,
      this.data,
      this.isNotApplied = false,
      required this.isUserSubscribed})
      : super(key: key);

  @override
  ConsumerState<SearchCompany> createState() => _SearchCompanyState();
}

class _SearchCompanyState extends ConsumerState<SearchCompany> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int group = 1;

  bool _isSelected = false;
  bool Selected = false;
  bool Selecteds = false;
  int val = -1;
  double start = 40.0;
  double end = 60.0;
  Map<String, dynamic> filterCandidateData = {};

  int page = 1;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    page = 1;
    ref.read(jobData).fetchJobAppliedCandidates(context,
        filterData: filterCandidateData, page: page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    page += 1;
    ref.read(jobData).fetchJobAppliedCandidates(context,
        filterData: filterCandidateData, page: page);
    _refreshController.loadComplete();
  }

  List a = [];

  WFHType? selectedWFH;
  ExperienceFilter? selectedExperienceFilter;
  ContractType? selectedContractType;
  EmploymentType? selectedEmploymentType;
  JobType? selectedJobType;
  JobScheduleType? selectedJobScheduleType;
  List<Industry> selectedIndustry = [];
  List<Education> selectedEducations = [];
  List<KeyValue> selectedApplicationStatus = [];
  List<Sector> selectedMultiSector = [];
  List<States> selectedState = [];
  List<City> selectedCity = [];
  TextEditingController pincodeController = TextEditingController();
  List<Skill> selectedSkills = [];
  List<JobType> jobTypes = [];
  List<Skill> selectskill = [];
  @override
  void initState() {
    super.initState();
    filterCandidateData = widget.data ?? {};
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(jobData).fetchJobAppliedCandidates(context,
          filterData: widget.data ?? {}, page: 1);
      ref.read(listData).clearData();
      ref.read(listData).fetchData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      backgroundColor: MyAppColor.backgroundColor,
      appBar: CompanyAppBar(
        back: 'HOME (COMPANY ADMIN) / SEARCH APPLICANTS',
        drawerKey: _drawerKey,
        isWeb: Responsive.isDesktop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (Responsive.isDesktop(context))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              width: Sizeconfig.screenWidth! / 1.2,
                              color: MyAppColor.greynormal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      RadioButton(
                                        text: "Search by name",
                                        groupValue: group,
                                        onChanged: (value) => setState(() {
                                          group = value;
                                        }),
                                        value: 1,
                                      ),
                                      RadioButton(
                                        text: "Search by Mobile Number",
                                        groupValue: group,
                                        onChanged: (value) => setState(() {
                                          group = value;
                                        }),
                                        value: 2,
                                      ),
                                      RadioButton(
                                        text: "Search by Email",
                                        groupValue: group,
                                        onChanged: (value) => setState(() {
                                          group = value;
                                        }),
                                        value: 3,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: Sizeconfig.screenWidth! / 4,
                                        child: TextfieldWidget(
                                          text: 'Search Applicants here..',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      _resume(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                !Responsive.isDesktop(context)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            if (!widget.isNotApplied)
                              CandidateSearch(
                                isNavigate: true,
                                isNotApplied: widget.isNotApplied,
                                isUserSubscribed: widget.isUserSubscribed,
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Search Result for "${widget.isNotApplied ? 'Not Applied' : 'Applied'}"',
                                    style: blackDarkR14(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await bottomFilterSheet();
                                    },
                                    child: Icon(Icons.filter_alt_outlined),
                                  ),
                                  sortByrelevence(context),
                                ],
                              ),
                            ),
                            Consumer(builder: (context, ref, child) {
                              List jobAppliedCandidates =
                                  ref.watch(jobData).jobAppliedCandidates;
                              return SizedBox(
                                  height: widget.isNotApplied
                                      ? MediaQuery.of(context).size.height - 280
                                      : 300,
                                  child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    header: WaterDropHeader(),
                                    footer: CustomFooter(
                                      builder: (BuildContext? context,
                                          LoadStatus? mode) {
                                        Widget body;
                                        if (mode == LoadStatus.idle) {
                                          body = Text("pull up load");
                                        } else if (mode == LoadStatus.loading) {
                                          body = CupertinoActivityIndicator();
                                        } else if (mode == LoadStatus.failed) {
                                          body =
                                              Text("Load Failed!Click retry!");
                                        } else if (mode ==
                                            LoadStatus.canLoading) {
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
                                    child: ListView.builder(
                                        itemCount: jobAppliedCandidates.length,
                                        itemBuilder: (BuildContext context,
                                                index) =>
                                            InkWell(
                                              onTap: () {
                                                if (widget.isNotApplied) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CandidateProfileView(
                                                                applicants:
                                                                    jobAppliedCandidates[
                                                                        index],
                                                                isUserDataFlag:
                                                                    true,
                                                              )));
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CandidateProfileView(
                                                                applicants:
                                                                    jobAppliedCandidates[
                                                                        index],
                                                                isUserDataFlag:
                                                                    true,
                                                                job: jobAppliedCandidates[
                                                                        index]
                                                                    .userAppliedJobs[
                                                                        0]
                                                                    .jobPost,
                                                              )));
                                                }
                                              },
                                              child: jobAppliedCandidates
                                                      .isNotEmpty
                                                  ? SearchWidget(
                                                      text: jobAppliedCandidates[
                                                                      index]
                                                                  .userAppliedJobs!
                                                                  .length >
                                                              0
                                                          ? 'applied'
                                                          : '',
                                                      candidate:
                                                          jobAppliedCandidates[
                                                              index],
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 30.0,
                                                              horizontal: 10),
                                                      child: Text(
                                                        'No Data Found',
                                                        style:
                                                            blackRegularGalano14,
                                                      ),
                                                    ),
                                            )),
                                  ));
                            }),
                          ],
                        ),
                      )
                    : Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 00),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 20, top: 20),
                                margin: EdgeInsets.only(left: 40, right: 20),
                                child: Consumer(builder: (context, ref, child) {
                                  List<States> states =
                                      ref.watch(listData).state;
                                  List<City> city = ref.watch(listData).city;

                                  List<Skill> skills =
                                      ref.watch(listData).skillCategory;
                                  List<Education> educations =
                                      ref.watch(listData).educations;
                                  List<Industry> industry =
                                      ref.watch(listData).industry;
                                  List<KeyValue> applicationStatus =
                                      ref.watch(listData).applicationStatus;
                                  List<ExperienceFilter> experienceFilters =
                                      ref.watch(listData).experienceFilter;
                                  Function onSelectSkills =
                                      ref.watch(listData).onSelectSkills;
                                  Function onSelectEducations =
                                      ref.watch(listData).onSelectEducation;
                                  Function onSelectApplicationStatus = ref
                                      .watch(listData)
                                      .onSelectApplicationStatus;
                                  Function isRadioChanged =
                                      ref.watch(listData).radioChanged;
                                  Function onSelectIndustry =
                                      ref.watch(listData).onSelectIndustry;
                                  return Column(
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
                                      SizedBox(
                                        height: 2,
                                      ),
                                      FilterSection1(
                                          label: 'JOB INDUSTRY',
                                          list: industry,
                                          onTap: () {},
                                          onSelecting: (value, index) {
                                            if (selectedIndustry
                                                .contains(industry[index])) {
                                              selectedIndustry
                                                  .remove(industry[index]);
                                            } else {
                                              selectedIndustry
                                                  .add(industry[index]);
                                            }
                                            onSelectIndustry(context,
                                                value: value, index: index);
                                          }),
                                      locationFilter(
                                          states: states,
                                          pincodeController: pincodeController,
                                          city: city),
                                      if (!widget.isNotApplied)
                                        FilterSection1(
                                          label: 'APPLICATION STATUS',
                                          list: applicationStatus,
                                          onSelecting: (value, index) {
                                            if (selectedApplicationStatus
                                                .contains(
                                                    applicationStatus[index])) {
                                              selectedApplicationStatus.remove(
                                                  applicationStatus[index]);
                                              selectedApplicationStatus.remove(
                                                  applicationStatus[index]);
                                            } else {
                                              selectedApplicationStatus.add(
                                                  applicationStatus[index]);
                                            }
                                            onSelectApplicationStatus(context,
                                                value: value, index: index);
                                          },
                                          onTap: () {},
                                        ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      FilterSection1(
                                        label: 'SKILLS REQUIRED',
                                        list: skills,
                                        onSelecting: (value, index) {
                                          if (selectedSkills
                                              .contains(skills[index])) {
                                            selectedSkills
                                                .remove(skills[index]);
                                          } else {
                                            selectedSkills.add(skills[index]);
                                          }
                                          onSelectSkills(context,
                                              value: value, index: index);
                                        },
                                        onTap: () {},
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      // Container(
                                      //   color: MyAppColor.graydf,
                                      //   child: ExpansionTile(
                                      //     title: Text(
                                      //       'SALARY',
                                      //       style: !Responsive.isDesktop(context)
                                      //           ? blackDarkR16
                                      //           : blackDarkR14(),
                                      //     ),
                                      //     children: [
                                      //       SliderTheme(
                                      //         data: SliderTheme.of(context).copyWith(
                                      //           activeTrackColor: Colors.orange,
                                      //           thumbColor: Colors.black12,
                                      //         ),
                                      //         child: RangeSlider(
                                      //           inactiveColor: MyAppColor.white,
                                      //           activeColor: MyAppColor.orangelight,
                                      //           values: RangeValues(start, end),
                                      //           labels:
                                      //               RangeLabels(start.toString(), end.toString()),
                                      //           onChanged: (value) {
                                      //             setState(
                                      //               () {
                                      //                 start = value.start;
                                      //                 end = value.end;
                                      //               },
                                      //             );
                                      //           },
                                      //           min: 10.0,
                                      //           max: 80.0,
                                      //         ),
                                      //       ),
                                      //       Text(
                                      //         "₹ 3.56 -  "
                                      //         "8.46 Lakh per Annum: ",
                                      //         style: blackDarkR12(),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      SizedBox(
                                        height: 2,
                                      ),

                                      SizedBox(
                                        height: 2,
                                      ),

                                      FilterSection2(
                                          label: 'EXPERIENCE REQUIRED',
                                          list: experienceFilters,
                                          selectedValue:
                                              selectedExperienceFilter,
                                          onSelecting: (value, index) {
                                            selectedExperienceFilter =
                                                experienceFilters[index];
                                            isRadioChanged(value);
                                          }),
                                      SizedBox(height: 2),
                                      FilterSection1(
                                        label: 'EDUCATION',
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
                                        },
                                        onTap: () {},
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          String applicationStatusKeys =
                                              selectedApplicationStatus
                                                  .map((e) => e.key)
                                                  .toList()
                                                  .join(",");
                                          String educationIds =
                                              selectedEducations
                                                  .map((e) => e.id)
                                                  .toList()
                                                  .join(",");
                                          String skillsId = selectedSkills
                                              .map((e) => e.id)
                                              .toList()
                                              .join(",");
                                          String stateIds = selectedState
                                              .map((e) => e.id)
                                              .toList()
                                              .join(",");
                                          String cityIds = selectedCity
                                              .map((e) => e.id)
                                              .toList()
                                              .join(",");
                                          String industryIds = selectedIndustry
                                              .map((e) => e.id)
                                              .toList()
                                              .join(",");
                                          filterCandidateData = {
                                            "pincode": pincodeController.text,
                                            "industry_id": industryIds,
                                            "state_id": stateIds,
                                            "cities": cityIds,
                                            "education": educationIds,
                                            "skill": skillsId,
                                            "application_status":
                                                applicationStatusKeys
                                          };
                                          if (widget.isNotApplied) {
                                            filterCandidateData["candidate"] =
                                                "NOT_APPLIED";
                                          }
                                          Map<String, dynamic> filterCandidate =
                                              removeNullEmptyKey(
                                                  filterCandidateData);
                                          page = 1;
                                          ref
                                              .read(jobData)
                                              .fetchJobAppliedCandidates(
                                                  context,
                                                  filterData: filterCandidate,
                                                  page: page);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 40),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color:
                                                        MyAppColor.blackdark)),
                                            child: Text('DONE')),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                            Expanded(
                              flex: 12,
                              child: Container(
                                margin: EdgeInsets.only(right: 30),
                                // width: Sizeconfig.screenWidth! / 1.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 65),
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
                                          sortByrelevence(context),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Consumer(builder: (context, ref, child) {
                                      List jobAppliedCandidates = ref
                                          .watch(jobData)
                                          .jobAppliedCandidates;
                                      return Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          runAlignment: WrapAlignment.start,
                                          alignment: WrapAlignment.start,
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: List.generate(
                                            jobAppliedCandidates.length,
                                            (index) => InkWell(
                                              onTap: () {
                                                if (widget.isNotApplied) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CandidateProfileView(
                                                                applicants:
                                                                    jobAppliedCandidates[
                                                                        index],
                                                                isUserDataFlag:
                                                                    true,
                                                              )));
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CandidateProfileView(
                                                                applicants:
                                                                    jobAppliedCandidates[
                                                                        index],
                                                                isUserDataFlag:
                                                                    true,
                                                                job: jobAppliedCandidates[
                                                                        index]
                                                                    .userAppliedJobs[
                                                                        0]
                                                                    .jobPost,
                                                              )));
                                                }
                                              },
                                              child: SearchWidget(
                                                  text: jobAppliedCandidates[
                                                                  index]
                                                              .userAppliedJobs!
                                                              .length >
                                                          0
                                                      ? 'applied'
                                                      : '',
                                                  candidate:
                                                      jobAppliedCandidates[
                                                          index]),
                                            ),
                                          ));
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                //     // radioResponse(),
              ],
            ),

            // SizedBox(
            //   height: 50,
            // ),
            // Footer()
          ],
        ),
      ),
    );
  }

  bottomFilterSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext bottomContext, setState) {
          return FractionallySizedBox(
            heightFactor: 0.7,
            child: SingleChildScrollView(
              child: Consumer(builder: (context, ref, child) {
                List<States> states = ref.watch(listData).state;
                List<City> city = ref.watch(listData).city;

                List<Skill> skills = ref.watch(listData).skillCategory;
                List<Education> educations = ref.watch(listData).educations;
                List<Industry> industry = ref.watch(listData).industry;
                List<KeyValue> applicationStatus =
                    ref.watch(listData).applicationStatus;
                List<ExperienceFilter> experienceFilters =
                    ref.watch(listData).experienceFilter;
                Function onSelectSkills = ref.watch(listData).onSelectSkills;
                Function onSelectEducations =
                    ref.watch(listData).onSelectEducation;
                Function onSelectApplicationStatus =
                    ref.watch(listData).onSelectApplicationStatus;
                Function isRadioChanged = ref.watch(listData).radioChanged;
                Function onSelectIndustry =
                    ref.watch(listData).onSelectIndustry;
                return Column(
                  children: [
                    Container(
                      padding: paddingAll10,
                      color: MyAppColor.simplegrey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    SizedBox(
                      height: 2,
                    ),
                    FilterSection1(
                        label: 'JOB INDUSTRY',
                        list: industry,
                        onTap: () {},
                        onSelecting: (value, index) {
                          if (selectedIndustry.contains(industry[index])) {
                            selectedIndustry.remove(industry[index]);
                          } else {
                            selectedIndustry.add(industry[index]);
                          }
                          onSelectIndustry(context, value: value, index: index);
                        }),
                    locationFilter(
                        states: states,
                        pincodeController: pincodeController,
                        city: city),
                    if (!widget.isNotApplied)
                      FilterSection1(
                        label: 'APPLICATION STATUS',
                        list: applicationStatus,
                        onSelecting: (value, index) {
                          if (selectedApplicationStatus
                              .contains(applicationStatus[index])) {
                            selectedApplicationStatus
                                .remove(applicationStatus[index]);
                            selectedApplicationStatus
                                .remove(applicationStatus[index]);
                          } else {
                            selectedApplicationStatus
                                .add(applicationStatus[index]);
                          }
                          onSelectApplicationStatus(context,
                              value: value, index: index);
                        },
                        onTap: () {},
                      ),
                    SizedBox(
                      height: 2,
                    ),
                    FilterSection1(
                      label: 'SKILLS REQUIRED',
                      list: skills,
                      onSelecting: (value, index) {
                        if (selectedSkills.contains(skills[index])) {
                          selectedSkills.remove(skills[index]);
                        } else {
                          selectedSkills.add(skills[index]);
                        }
                        onSelectSkills(context, value: value, index: index);
                      },
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    FilterSection2(
                        label: 'EXPERIENCE REQUIRED',
                        list: experienceFilters,
                        selectedValue: selectedExperienceFilter,
                        onSelecting: (value, index) {
                          selectedExperienceFilter = experienceFilters[index];
                          isRadioChanged(value);
                        }),
                    SizedBox(height: 2),
                    FilterSection1(
                      label: 'EDUCATION',
                      list: educations,
                      onSelecting: (value, index) {
                        if (selectedEducations.contains(educations[index])) {
                          selectedEducations.remove(educations[index]);
                        } else {
                          selectedEducations.add(educations[index]);
                        }
                        onSelectEducations(context, value: value, index: index);
                      },
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        String applicationStatusKeys = selectedApplicationStatus
                            .map((e) => e.key)
                            .toList()
                            .join(",");
                        String educationIds = selectedEducations
                            .map((e) => e.id)
                            .toList()
                            .join(",");
                        String skillsId =
                            selectedSkills.map((e) => e.id).toList().join(",");
                        String stateIds =
                            selectedState.map((e) => e.id).toList().join(",");
                        String cityIds =
                            selectedCity.map((e) => e.id).toList().join(",");
                        String industryIds = selectedIndustry
                            .map((e) => e.id)
                            .toList()
                            .join(",");

                        filterCandidateData = {
                          // "work_experience_range[0]":
                          //     selectedExperienceFilter?.from,
                          // "work_experience_range[1]":
                          //     selectedExperienceFilter?.to,
                          // "salary_range[0]": start.round() * 10000,
                          // "salary_range[1]": end.round() * 10000,
                          "pincode": pincodeController.text,
                          "industry_id": industryIds,
                          "state_id": stateIds,
                          "cities": cityIds,
                          "education": educationIds,
                          "skill": skillsId,
                          "application_status": applicationStatusKeys
                        };
                        if (widget.isNotApplied) {
                          filterCandidateData["candidate"] = "NOT_APPLIED";
                        }
                        Map<String, dynamic> filterCandidate =
                            removeNullEmptyKey(filterCandidateData);
                        page = 1;
                        ref.read(jobData).fetchJobAppliedCandidates(context,
                            filterData: filterCandidate, page: page);
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: MyAppColor.blackdark)),
                          child: Text('DONE')),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  locationFilter({states, city, pincodeController}) {
    return InkWell(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (_) => StatefulBuilder(
                  builder: (context, StateSetter setState) {
                    return AlertDialog(
                      backgroundColor: MyAppColor.backgroundColor,
                      title: Text(
                        "Location",
                        style: blackdarkM12,
                      ),
                      insetPadding: EdgeInsets.all(0),
                      content: SizedBox(
                        width: !Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width * 0.75
                            : MediaQuery.of(context).size.width / 3.5,
                        child: SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                                children: List.generate(
                                    selectedState.length,
                                    (index) => HashTag(
                                        showHide: true,
                                        text: "${selectedState[index].name}"))),
                            InkWell(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (_) => PopPicker(
                                          title: 'States',
                                          list: states,
                                          flag: 'state',
                                          allReadySelected: selectedState,
                                        ));
                                setState(() {});
                              },
                              child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Text("Select State",
                                      style: blackDarkO40M14)),
                            ),
                            Wrap(
                                spacing: 5,
                                children: List.generate(
                                    selectedCity.length,
                                    (index) => HashTag(
                                        showHide: true,
                                        text: "${selectedCity[index].name}"))),
                            InkWell(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (_) => PopPicker(
                                          title: 'City',
                                          list: city,
                                          flag: 'city',
                                          allReadySelected: selectedCity,
                                        ));
                                setState(() {});
                              },
                              child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Text("Select City",
                                      style: blackDarkO40M14)),
                            ),
                            TextFormFieldWidget(
                              textStyle: blackDarkO40M14,
                              text: 'Pincode',
                              control: pincodeController,
                              isRequired: true,
                              type: TextInputType.multiline,
                            ),
                          ],
                        )),
                      ),
                      actions: <Widget>[
                        SubmitElevatedButton(
                          label: "Done",
                          onSubmit: () async {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                ));
      },
      child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 2),
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12),
          color: MyAppColor.graydf,
          child: Text(
            'Location',
            style: !Responsive.isDesktop(context) ? blackDarkR18 : blackDarkR16,
          )),
    );
  }

  _resume() {
    return ElevatedButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 12,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              'SEARCH APPLICANTS',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(primary: MyAppColor.applecolor),
    );
  }

  salery() {
    return Container(
      color: MyAppColor.grayplane,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Currently Salary per Annum:',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM10,
          ),
          Text(
            '₹ 8,50,000',
            style: !Responsive.isDesktop(context)
                ? blackDarkSb12()
                : blackDarkSb10(),
          ),
        ],
      ),
    );
  }

  chief() {
    return Container(
      color: MyAppColor.graydf,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock,
            color: MyAppColor.companyNameColor,
            size: 13,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Chief Motion Designer & Animation\nEngineer',
            style: !Responsive.isDesktop(context)
                ? blackDarkSb12()
                : blackDarkSb10(),
          ),
        ],
      ),
    );
  }

  succces() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      color: MyAppColor.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/offer-letter-image.png',
            height: 18,
            fit: BoxFit.cover,
          ),
          Text(
            'You Received Offer Letter',
          ),
        ],
      ),
    );
  }

  flag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      color: MyAppColor.grayplane,
      child: Row(
        children: [
          Image.asset(
            'assets/applied-succes-image.png',
            height: 18,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'You Applied',
            style: greylightBoldGalano10,
          ),
        ],
      ),
    );
  }

  Widget containerMan({String? text}) {
    return SizedBox(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: MyAppColor.greynormal,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    text == 'applied' ? flag() : succces(),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 00),
                  child: Column(
                    children: [
                      details(context),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SkillTag(text: 'java'),
                          SizedBox(
                            width: 4,
                          ),
                          SkillTag(text: 'java'),
                          SizedBox(
                            width: 4,
                          ),
                          SkillTag(text: 'java'),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: !Responsive.isDesktop(context) ? 10 : 8,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'Bhopal Madhaya Pradesh',
                                style: !Responsive.isDesktop(context)
                                    ? blackDarkSb10()
                                    : blackDarkSb8(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'View profile',
                                style: !Responsive.isDesktop(context)
                                    ? orangeDarkSb10()
                                    : orangeDarkSb8(),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: MyAppColor.orangedark,
                                size: Responsive.isMobile(context) ? 14 : 16,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          salery(),
          SizedBox(
            height: 2,
          ),
          chief()
        ],
      ),
    );
  }

  details(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: !Responsive.isDesktop(context) ? 50 : 30,
          width: !Responsive.isDesktop(context) ? 50 : 30,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/male.png'), fit: BoxFit.cover),
            color: MyAppColor.applecolor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('John Kumar Cena',
                  style: !Responsive.isDesktop(context)
                      ? blackDarkM16()
                      : blackDarkSb14()),
              Text(
                'Experience: 3+ Years',
                style: !Responsive.isDesktop(context)
                    ? blackDarkSb9()
                    : blackDarkSb8(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String sortValue = "Sort by relevance";

  Widget sortByrelevence(context) {
    return AppDropdownInput(
      hintText: "Sort by relevance",
      options: ['Ascending', 'Descending'],
      value: sortValue,
      changed: (String value) async {
        sortValue = value;
        setState(() {});
        if (value != 'Sort by relevance') {
          ref.read(jobData).fetchJobAppliedCandidates(context,
              filterData: {"sortBy": value}, page: page);
        }
      },
      getLabel: (String value) => value,
    );
  }

  Widget filtersClear({List<Widget>? childrens, String? text}) {
    return Container(
      color: MyAppColor.graydf,
      child: ExpansionTile(
        title: Text(
          text!,
          style: !Responsive.isDesktop(context) ? blackDarkR16 : blackDarkR14(),
        ),
        children: childrens!,
      ),
    );
  }

  Widget searchHere() {
    return ElevatedButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 12,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              'SEARCH APPLICANTS',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(primary: MyAppColor.applecolor),
    );
  }
}
