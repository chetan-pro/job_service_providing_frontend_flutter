// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/candidateWidget/skill_tag_widget.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/candidate_profile.dart';
import 'package:hindustan_job/company/home/create_job_post.dart';
import 'package:hindustan_job/company/home/pages/job_preview_page.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/new_colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/api_services/jobs_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

class CompanyPostedJobView extends ConsumerStatefulWidget {
  String id;
  CompanyPostedJobView({Key? key, required this.id}) : super(key: key);

  @override
  _CompanyPostedJobViewState createState() => _CompanyPostedJobViewState();
}

class _CompanyPostedJobViewState extends ConsumerState<CompanyPostedJobView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  TabController? _control;

  bool switchToggle = false;
  JobsTwo? job;

  @override
  void initState() {
    _control = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
    fetchJobDetails(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobData).jobHistoryData(context, widget.id);
    });
  }

  fetchJobDetails(id) async {
    job = await jobDetails(context, jobId: id);
    ref.read(jobData).checkJobClosing(job!.jobStatus);
    ref.read(jobData).checkPostStatus(job!.status);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return Scaffold(
        key: _drawerKey,
        drawer: const Drawer(
          child: DrawerJobSeeker(),
        ),
        appBar: CompanyAppBar(
          drawerKey: _drawerKey,
          back: "HOME (COMPANY ADMIN) / JOB POSTS / JOB #123456",
          isWeb: Responsive.isDesktop(context),
        ),
        body: Responsive.isMobile(context)
            ? job == null
                ? loaderIndicator(context)
                : TabBarSliverAppbar(
                    length: 4,
                    tabs: _tab(),
                    headColumn: Column(
                      children: [
                        openCardContainer(),
                        containerEditDeleteJob(),
                      ],
                    ),
                    toolBarHeight: 300,
                    tabsWidgets: [
                      jobDetail(),
                      candidateStatus(styles),
                    ],
                    control: _control!,
                  )
            : SingleChildScrollView(
                child: job == null
                    ? loaderIndicator(context)
                    : Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal:
                                      Responsive.isDesktop(context) ? 80 : 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  openCardContainer(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(child: containBody(styles))
                                ],
                              )),
                          Footer(),
                        ],
                      ),
              ));
  }

  containerEditDeleteJob() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateJobPost(jobsEditId: job!.id.toString())));
                fetchJobDetails(widget.id);
              },
              child: Text('edit job', style: orangeDarkSb12())),
          const SizedBox(
            width: 30,
          ),
          InkWell(
              onTap: () async {
                var val = await alertBox(
                  context,
                  'Are you sure you want to delete this job ?',
                  title: 'Delete Job',
                );
                if (val == 'Done') {
                  ref.read(jobData).deleteJob(context, jobId: job!.id);
                }
              },
              child: Text('delete job', style: orangeDarkSb12())),
        ],
      ),
    );
  }

  containBody(styles) {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          child: DefaultTabController(
              length: 2,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: !Responsive.isDesktop(context)
                            ? Sizeconfig.screenWidth
                            : Sizeconfig.screenWidth! / 4,
                        child: _tab(),
                      ),
                      SizedBox(
                          width: Sizeconfig.screenWidth,
                          height: Sizeconfig.screenHeight,
                          child: TabBarView(controller: _control, children: [
                            jobDetail(),
                            candidateStatus(styles),
                          ]))
                    ]),
              )),
        ),
      ],
    );
  }

  candidateStatus(styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
          width: Sizeconfig.screenWidth,
          child: DefaultTabController(
              length: 6,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      color: MyAppColor.greylight,
                      padding: const EdgeInsets.only(
                        top: 24,
                      ),
                      width: Sizeconfig.screenWidth,
                      alignment: Alignment.center,
                      child: secondTab(styles),
                    ),
                    SizedBox(
                        width: Sizeconfig.screenWidth,
                        height: Sizeconfig.screenHeight,
                        child: Consumer(builder: (context, ref, child) {
                          List applicantsApplied =
                              ref.watch(jobData).applicantsApplied;
                          List applicantsShortListed =
                              ref.watch(jobData).applicantsShortListed;
                          List applicantsJobOffers =
                              ref.watch(jobData).applicantsJobOffers;
                          List applicantsAcceptedOffer =
                              ref.watch(jobData).applicantsAcceptedOffer;
                          List applicantsRejectedOffer =
                              ref.watch(jobData).applicantsRejectedOffer;
                          List applicantsRejected =
                              ref.watch(jobData).applicantsRejected;
                          return TabBarView(children: [
                            _table(applicantsApplied),
                            _table(applicantsShortListed),
                            _table(applicantsJobOffers),
                            _table(applicantsAcceptedOffer),
                            _table(applicantsRejectedOffer),
                            _table(applicantsRejected),
                          ]);
                        }))
                  ])))),
    );
  }

  _table(
    List applicants,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          if (applicants.isEmpty)
            Center(
                child: Text(
              "No Data Found",
              style: blackBold14,
            )),
          Responsive.isDesktop(context)
              ? Container(
                  //color: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Table(
                    columnWidths: {
                      0: const FlexColumnWidth(1),
                      1: const FlexColumnWidth(2),
                      2: const FlexColumnWidth(6),
                      3: const FlexColumnWidth(3),
                      4: const FlexColumnWidth(2),
                      5: const FlexColumnWidth(3),
                    },
                    border: TableBorder.all(color: Colors.white, width: 1.0),
                    children: [
                      TableRow(
                          decoration:
                              new BoxDecoration(color: MyAppColor.grayplane),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'S.No',
                                style: blackDarkSb10(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'DATE APPLIED ON',
                                style: blackDarkSb10(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 700,
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "APPLICANT'S NAME",
                                style: blackDarkSb10(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'NOTICE PERIOD',
                                style: blackDarkSb10(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Experience',
                                style: blackDarkSb10(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'ACTION',
                                style: blackDarkSb10(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]),
                      for (var index = 0; index < applicants.length; index++)
                        TableRow(
                            decoration: new BoxDecoration(
                              color: MyAppColor.greynormal,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  (index + 1).toString(),
                                  style: blackdarkM12,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "${formatDate(applicants[index].updatedAt)}",
                                  style: blackdarkM12,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '${applicants[index].user!.name}',
                                  style: blackdarkM12,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "${applicants[index].user!.noticePeriodDays} days",
                                  style: blackdarkM12,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '${applicants[index].user!.workExperienceCount} months',
                                  style: blackdarkM12,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (userData!.userRoleType ==
                                      RoleTypeConstant.companyStaff) {
                                    bool isViewApplicant = false;
                                    for (var element in userData!.permissons!) {
                                      if (element.name ==
                                          PermissionConstant.viewCandidate) {
                                        isViewApplicant = true;
                                      }
                                    }
                                    if (!isViewApplicant) {
                                      return toast(
                                          "You don't have permission to view applicant profile");
                                    }
                                  }
                                  ref.read(jobData).removeFalse();
                                  job!.companyStatus =
                                      applicants[index].companyStatus;
                                  job!.candidateStatus =
                                      applicants[index].candidateStatus;
                                  job!.reason = applicants[index].reason;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CandidateProfileView(
                                                applicants: applicants[index],
                                                isUserDataFlag: false,
                                                job: job!,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "VIEW APPLICATION",
                                    style: blackBold12,
                                  ),
                                ),
                              ),
                            ]),
                    ],
                  ),
                )
              : Column(
                  children: List.generate(
                      applicants.length,
                      (index) => InkWell(
                            onTap: () {
                              if (userData!.userRoleType ==
                                  RoleTypeConstant.companyStaff) {
                                bool isViewApplicant = false;
                                for (var element in userData!.permissons!) {
                                  if (element.name ==
                                      PermissionConstant.viewCandidate) {
                                    isViewApplicant = true;
                                  }
                                }
                                if (!isViewApplicant) {
                                  return toast(
                                      "You don't have permission to view applicant profile");
                                }
                              }
                              ref.read(jobData).removeFalse();
                              job!.companyStatus =
                                  applicants[index].companyStatus;
                              job!.candidateStatus =
                                  applicants[index].candidateStatus;
                              job!.reason = applicants[index].reason;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CandidateProfileView(
                                            applicants: applicants[index],
                                            isUserDataFlag: false,
                                            job: job!,
                                          )));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              color: MyAppColor.gray,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "#01",
                                        style: blackDark12,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              formatDate(
                                                  applicants[index].updatedAt),
                                              style: blackDarkSemibold14),
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: MyAppColor.blackdark,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    "${applicants[index].user!.name}",
                                    style: blackBold20,
                                  ),
                                  Text(
                                    "Experience: 3+ Years",
                                    style: blackDarkSemibold14,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    color: MyAppColor.grayplane,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Resume Submitted",
                                          style: blackDark12,
                                        ),
                                        Text(
                                          "Yes",
                                          style: blackDarkSemibold14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: MyAppColor.blackdark),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4))),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: const Text("VIEW APPLICATION"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )))
        ],
      ),
    );
  }

  TabBar secondTab(TextTheme styles) {
    return TabBar(
      isScrollable: true,
      indicatorColor: MyAppColor.orangelight,
      indicatorWeight: 2.5,
      labelColor: MyAppColor.white,
      unselectedLabelColor: Colors.white,
      tabs: [
        tabText('Applicants\nApplied'),
        tabText('Applicants\nShort-listed'),
        tabText('Applicants given\nJob Offers'),
        tabText('Applicants\naccepted Offers'),
        tabText('Applicants\nrejected Offers'),
        tabText('Rejected\nApplicants'),
      ],
    );
  }

  tabText(label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: blackMediumGalano12.copyWith(color: MyAppColor.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  jobDetail() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      width: Sizeconfig.screenWidth! / 2,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Job Details", style: grayLightM18()),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _display(key: "Company Name", value: "${job!.name}"),
                  ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: _display(
                          key: "Your Role in Hiring",
                          value: "${job!.jobRoleType!.name}"),
                    ),
                ],
              ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Your Role in Hiring",
                          value: "${job!.jobRoleType!.name}"),
                    ),
                  ],
                ),
              Row(
                children: [
                  Expanded(
                    child:
                        _display(key: "Job Title", value: "${job!.jobTitle}"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _displayHashTag(key: "Job Tags", values: job),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (job!.jobType != null)
                    Expanded(
                      child: _display(
                          key: "Job Sector",
                          value: "${job!.jobType!.name} Sector"),
                    ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: _display(
                          key: "Employment Type",
                          value: "${removeUnderScore(job!.employmentType)}"),
                    ),
                ],
              ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Employment Type",
                          value: "${removeUnderScore(job!.employmentType)}"),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _display(
                        key: "Contract Type", value: "${job!.contractType}"),
                  ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: _display(
                          key: "Contract Duration",
                          value: "${job!.contractDuration ?? 0} months"),
                    ),
                ],
              ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Contract Duration",
                          value: "${job!.contractDuration ?? 0} months"),
                    ),
                  ],
                ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Job Boosting State",
                          value:
                              "${job!.boostingJobStateData == null ? 'All' : job!.boostingJobStateData!.name}"),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _display(
                        key: "Job Schedule",
                        value: "${removeUnderScore(job!.jobSchedule)}"),
                  ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: _display(
                          key: "Job Time Table",
                          value: "${job!.jobTimeFrom} to ${job!.jobTimeTo}"),
                    ),
                ],
              ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Job Time Table",
                          value: "${job!.jobTimeFrom} to ${job!.jobTimeTo}"),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _display(
                        key: "Work form Home Option",
                        value: "${job!.workFromHome}"),
                  ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: _display(
                          key: "Job Location",
                          value:
                              "${locationShow(state: job!.state, city: job!.city)}"),
                    ),
                ],
              ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Job Location",
                          value:
                              "${locationShow(state: job!.state, city: job!.city)}"),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _display(
                        key: "No. of Positions Available",
                        value: "${job!.numberOfPosition}"),
                  ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(child: Container()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child:
                    Text("..........................", style: grayLightM18()),
              ),
              Text("JOB DESCRIPTION", style: grayLightM18()),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: _display(
                    key: "Job Descriptions",
                    value: job!.jobDescription,
                  )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child:
                    Text("..........................", style: grayLightM18()),
              ),
              Text("SALARY DETAILS", style: grayLightM18()),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _display(
                        key: "Salary Amount Type:",
                        value: "${removeUnderScore(job!.salaryType)}"),
                  ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: _display(
                          key: "Salary Amount",
                          value:
                              '₹ ${job!.salary ?? "${doubleToIntValue(job!.salaryFrom)} - ${doubleToIntValue(job!.salaryTo)}"} ${job!.paidType == 'PH' ? 'per hour' : 'per annum'}'),
                    ),
                ],
              ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Salary Amount",
                          value:
                              "₹ ${job!.salary ?? "${doubleToIntValue(job!.salaryFrom)} - ${doubleToIntValue(job!.salaryTo)}"} ${job!.paidType == 'PH' ? 'per hour' : 'per annum'}"),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child:
                    Text("..........................", style: grayLightM18()),
              ),
              Text("SKILLS REQUIRED", style: grayLightM18()),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _displaySkills(key: "", value: job!.jobPostSkills),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child:
                    Text("..........................", style: grayLightM18()),
              ),
              Text("APPLICANTS REQUIREMENTS & INFO", style: grayLightM18()),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _display(
                        key: "Experience Required",
                        value: job!.experienceRequired == 'N'
                            ? "No"
                            : '${calculateExperienceForEdit(job!.expFrom, job!.expFromType)} ${job!.expFromType} - ${calculateExperienceForEdit(job!.expTo, job!.expToType)} ${job!.expToType}'),
                  ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: _display(
                          key: "Education Required",
                          value: job!.educationRequired == 'N'
                              ? 'No'
                              : "${job!.educationDatum!.name}"),
                    ),
                ],
              ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Education Required",
                          value:
                              "${checkNullOverValueName(job!.educationDatum)}"),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Expanded(
                  //   child: _display(
                  //       key: "Applicant requires to submit Resume?",
                  //       value: "Yes"),
                  // ),
                  if (Responsive.isDesktop(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: _display(
                          key: "Email that Receives Applications",
                          value: job!.email ?? ''),
                    ),
                ],
              ),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    Expanded(
                      child: _display(
                          key: "Email that Receives Applications",
                          value: job!.email ?? ''),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child:
                    Text("..........................", style: grayLightM18()),
              ),
              Text("QUESTIONS FOR APPLICANTS", style: grayLightM18()),
              const SizedBox(
                height: 40,
              ),
              Column(
                  children: List.generate(
                job!.questions!.length,
                (index) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _display(
                          key: "Question",
                          value: "${job!.questions![index].questions}"),
                    ),
                  ],
                ),
              )),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayHashTag({values, key, margin}) {
    return Container(
      margin: EdgeInsets.only(bottom: margin ?? 10),
      padding: const EdgeInsets.all(10),
      color: MyAppColor.greynormal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$key',
            style:
                !Responsive.isDesktop(context) ? chipColorM12() : chipColorM9(),
          ),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
              HashTag(text: "${job!.industry!.name}"),
              HashTag(text: "${job!.sector!.name}"),
              HashTag(text: "${job!.jobRoleType!.name}"),
            ],
          )
        ],
      ),
    );
  }

  Widget _displaySkills({value, key, margin}) {
    return Container(
      margin: EdgeInsets.only(bottom: margin ?? 10),
      padding: const EdgeInsets.all(10),
      // width: Sizeconfig.screenWidth!/5,
      // height:
      //     Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
      color: MyAppColor.greynormal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$key',
            style:
                !Responsive.isDesktop(context) ? chipColorM12() : chipColorM9(),
          ),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: List.generate(
                value.length,
                (index) =>
                    SkillTag(text: value[index].skillSubCategories.name)),
          )
        ],
      ),
    );
  }

  Widget _display({value, key, margin}) {
    return Container(
      margin: EdgeInsets.only(bottom: margin ?? 10),
      padding: const EdgeInsets.all(10),
      // width: Sizeconfig.screenWidth!/5,
      // height:
      //     Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,

      color: MyAppColor.greynormal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$key',
            style:
                !Responsive.isDesktop(context) ? chipColorM12() : chipColorM9(),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            getCapitalizeString(value),
            style:
                !Responsive.isDesktop(context) ? blackDarkM18() : blackdarkM12,
          ),
        ],
      ),
    );
  }

  TabBar _tab() {
    return TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: MyAppColor.orangelight,
        labelColor: Colors.black,
        controller: _control,
        labelStyle: const TextStyle(
          fontSize: 12,
        ),
        tabs: [
          Text(
            "Job Post Info",
            style: blackDark12,
          ),
          Text("Applicants List", style: blackDark12),
        ]);
  }

  openCardContainer() {
    return Consumer(builder: (context, ref, child) {
      bool isClosed = ref.watch(jobData).isClosed;
      bool isVisible = ref.watch(jobData).isVisible;
      return SizedBox(
        width: !Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.20,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
              color: MyAppColor.greylight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isClosed ? "CLOSED" : "OPEN",
                        style: whiteMedium20,
                      ),
                      Text(
                        "JOB POST STATUS",
                        style: lightGreyTextSemiBold12,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      var carryData = {
                        "job_post_id": widget.id,
                        "job_status": isClosed ? "OPEN" : "CLOSE"
                      };
                      ref.read(jobData).changeStatusJob(context, carryData);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: AppColors.lightTextGrey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          isClosed ? "RE-OPEN" : "MARK CLOSED",
                          style: lightGreyTextSemiBold12,
                        )),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 1),
              color: MyAppColor.greynormal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Job Post Visibility",
                    style: blackDarkM18(),
                  ),
                  Switch(
                    value: isVisible,
                    onChanged: (value) {
                      var data = {
                        "status": isVisible ? 0 : 1,
                        "job_post_id": widget.id
                      };
                      ref.read(jobData).changeJobVisibility(context, data);
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                color: MyAppColor.greynormal,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobPreviewPage(
                                    jobDetail: job,
                                  )));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              width: 1, color: MyAppColor.blackdark)),
                      child: Text(
                        "PREVIEW JOB POST",
                        style: blackRegularGalano14,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
