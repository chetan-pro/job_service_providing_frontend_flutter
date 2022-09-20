// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:isolate';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/skill_tag_widget.dart';
import 'package:hindustan_job/candidate/model/candidate_data_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/subscription_list.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/chatscreen.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/api_services/subscription_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/chat_contacts_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/select_file.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CandidateProfileView extends ConsumerStatefulWidget {
  dynamic applicants;
  JobsTwo? job;
  bool isUserDataFlag;
  CandidateProfileView(
      {Key? key,
      required this.applicants,
      this.job,
      required this.isUserDataFlag})
      : super(key: key);

  @override
  _CandidateProfileViewState createState() => _CandidateProfileViewState();
}

class _CandidateProfileViewState extends ConsumerState<CandidateProfileView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool switchToggle = false;
  TextEditingController resume = TextEditingController();
  TextEditingController reason = TextEditingController();
  bool isEmailShow = false;
  bool isCVShow = false;
  ReceivePort _port = ReceivePort();
  JobsTwo? selectedJob;
  int? userId;
  @override
  void initState() {
    super.initState();
    ref.read(jobData).removeFalse();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.job != null) {
        reason.text = widget.job!.reason ?? '';
        ref.read(jobData).updateStatus(widget.job!.companyStatus,
            candidateStatus: widget.job!.candidateStatus);
      } else {
        ref.read(jobData).fetchOpenJob(context);
      }
      ref.read(jobData).fetchCandidateData(context, true,
          candidateId: userId,
          jobId: widget.job != null ? widget.job!.id : null);
    });

    userId =
        widget.isUserDataFlag ? widget.applicants.id : widget.applicants.userId;

    if (!kIsWeb) {
      IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      _port.listen((dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        int progress = data[2];
        setState(() {});
      });
      FlutterDownloader.registerCallback(downloadCallback);
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  int indexFile = 0;
  downloadFile(downloadImage) async {
    if (kIsWeb) {
      return downloadFileOnWeb(downloadImage);
    }
    await checkPermission();
    try {
      Directory? downloadsDirectory =
          await DownloadsPathProvider.downloadsDirectory;
      await FlutterDownloader.enqueue(
        url: downloadImage,
        savedDir: downloadsDirectory!.path,
        fileName:
            "${DateTime.now().millisecondsSinceEpoch}_Hindustaan-jobs${downloadImage.split('/').last}",
        showNotification: true,
        openFileFromNotification: true,
      );
    } catch (e) {
      toast("Permission required to download file in folder : ${e.toString()}");
    }
  }

  var offerLetterFile;

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      CandidateProfileModel? candidateProfile = ref.watch(jobData).candidate;

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
          body: candidateProfile == null
              ? loaderIndicator(context)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal:
                                Responsive.isDesktop(context) ? 20 : 20),
                        child: Responsive.isDesktop(context)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  profileCardContainer(
                                      candidateProfile, widget.job),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: containBody(
                                          styles, candidateProfile)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  rightCardContainer(),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Applicants Details",
                                    style: blackDarkR18,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  profileCardContainer(
                                      candidateProfile, widget.job),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  containBody(styles, candidateProfile),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  rightCardContainer(),
                                ],
                              ),
                      ),
                      Footer(),
                    ],
                  ),
                ));
    });
  }

  containBody(styles, CandidateProfileModel candidate) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        SizedBox(
          child: DefaultTabController(
              length: 3,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tab(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                            width: Sizeconfig.screenWidth,
                            height: Sizeconfig.screenHeight! * 0.5,
                            child: TabBarView(
                                physics: ClampingScrollPhysics(),
                                children: [
                                  workExperienceContainer(styles, candidate),
                                  educationCertificateContainer(
                                      styles, candidate),
                                  questionsAnswer(candidate.answers!),
                                ])),
                      )
                    ]),
              )),
        ),
      ],
    );
  }

  educationCertificateContainer(styles, CandidateProfileModel candidate) {
    return Center(
      child: SizedBox(
          width: Sizeconfig.screenWidth,
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "EDUCATION & QUALIFICATION",
                      style: blackDarkM18(),
                    ),
                  ),
                  Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: List.generate(
                        candidate.education!.length,
                        (index) => educationCard(candidate.education![index]),
                      )),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("........."),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "CERTIFICATION",
                      style: blackDarkM18(),
                    ),
                  ),
                  Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: List.generate(
                        candidate.certifications!.length,
                        (index) =>
                            certificateCard(candidate.certifications![index]),
                      )),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("........."),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "SKILLS LIST",
                      style: blackDarkM18(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    width: double.infinity,
                    color: MyAppColor.lightGrey,
                    child: Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: List.generate(
                            candidate.userSkills!.length,
                            (index) => SkillTag(
                                text:
                                    "${candidate.userSkills![index].skillSubCategory!.name}"))),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  workExperienceContainer(styles, CandidateProfileModel candidate) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: SizedBox(
          width: Sizeconfig.screenWidth,
          child: Center(
            child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: List.generate(
                  candidate.workExperiences!.length,
                  (index) => workCard(true, candidate.workExperiences![index]),
                )),
          )),
    );
  }

  certificateCard(Certifications certifications) {
    return SizedBox(
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width / 5
          : MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: MyAppColor.greynormal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/cap.png',
                  height: 15,
                ),
                Text(
                  "${certifications.title}",
                  style: blackBold16,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            color: MyAppColor.greynormal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${certifications.instituteName}",
                  style: blackBold14,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: MyAppColor.grayplane,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Year of Passing",
                  style: blackDarkM14(),
                ),
                Text(
                  "${certifications.yearOfAchievingCertificate}",
                  style: blackBold14,
                )
              ],
            ),
          ),
          Container(
            color: MyAppColor.grayplane,
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Download Certificate",
                  style: blackDarkM14(),
                ),
                InkWell(
                  onTap: () async {
                    await downloadFile(currentUrl(certifications.file));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    color: MyAppColor.chipcolor,
                    child: Row(
                      children: [
                        Icon(
                          Icons.download,
                          color: MyAppColor.white,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Download',
                          style: whiteBoldGalano12,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  educationCard(Education education) {
    return SizedBox(
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width / 5
          : MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: MyAppColor.greynormal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/cap.png',
                  height: 15,
                ),
                Text(
                  "${education.educationDatum!.name}",
                  style: blackBold16,
                ),
                Text(
                  "Specialization: Mechanical",
                  style: chipColorM14(),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            color: MyAppColor.greynormal,
            child: Row(
              children: [
                Image.asset(
                  'assets/university.png',
                  height: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Patel Science & Tech University",
                  style: blackBold14,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: MyAppColor.grayplane,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Year of Passing",
                  style: blackDarkM14(),
                ),
                Text(
                  "2014",
                  style: blackBold14,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  workCard(isActive, WorkExperiences workExperiences) {
    return SizedBox(
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width / 5
          : MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: MyAppColor.greynormal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${workExperiences.jobTitle}",
                  style: blackBold20,
                ),
                Text(
                  "${workExperiences.companyName}",
                  style: chipColorM14(),
                ),
                // Wrap(
                //   runSpacing: 10,
                //   spacing: 10,
                //   children: List.generate(7, (index) => HashTag(text: "hero")),
                // )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 1),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: MyAppColor.greynormal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Job Description",
                  style: chipColorM14(),
                ),
                Text(
                  "${workExperiences.jobDescription}",
                  style: titleHeadGrey16,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: isActive ? MyAppColor.logoBlue : MyAppColor.grayplane,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: workExperiences.currentlyEmployed == 'Y'
                ? Text(
                    "${formatDate(workExperiences.updatedAt)} - Currently Employed",
                    style: whiteRegular14,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Work Duration",
                        style: whiteRegular14,
                      ),
                      Text(
                        "${formatDate(workExperiences.dateOfJoining)}-${formatDate(workExperiences.dateOfResigning)}",
                        style: whiteRegular14,
                      )
                    ],
                  ),
          )
        ],
      ),
    );
  }

  TabController? _control;

  TabBar secondTab(TextTheme styles) {
    return TabBar(
      isScrollable: true,
      indicatorColor: MyAppColor.orangelight,
      indicatorWeight: 2.5,
      controller: _control,
      labelColor: MyAppColor.white,
      unselectedLabelColor: Colors.white,
      tabs: [
        tabText('Applicants\nApplied'),
        tabText('Applicants\nShort-listed'),
        tabText('Applicants given\nJob Offers'),
        tabText('Applicants\naccepted Offers'),
        tabText('Hired\nApplicants'),
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

  questionsAnswer(List<Answers> answers) {
    return ListView(
        children: List.generate(
            answers.length,
            (index) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 14),
                  padding: const EdgeInsets.all(20),
                  color: MyAppColor.lightGrey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Question #${index + 1}",
                        style: chipColorM12(),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${answers[index].question!.questions}",
                        style: blackDarkM18(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        color: MyAppColor.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Answer Given by Applicant",
                              style: chipColorM12(),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Text(
                              "${answers[index].answer}",
                              style: blackDarkM18(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )));
  }

  TabBar _tab() {
    return TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: MyAppColor.orangelight,
        labelColor: Colors.black,
        labelStyle: const TextStyle(
          fontSize: 12,
        ),
        tabs: [
          Text(
            "Work Experience",
            textAlign: TextAlign.center,
            style: blackDark12,
          ),
          Text("Education & Skills",
              textAlign: TextAlign.center, style: blackDark12),
          Text("Questions & Response",
              textAlign: TextAlign.center, style: blackDark12),
        ]);
  }

  rightCardContainer() {
    return Consumer(builder: (context, ref, child) {
      bool isShortListed = ref.watch(jobData).isShortListed;
      bool isRejectedByCandidate = ref.watch(jobData).isRejectedByCandidate;
      bool isRejected = ref.watch(jobData).isRejected;
      bool isOfferSend = ref.watch(jobData).isOfferSend;
      bool isAccepted = ref.watch(jobData).isAccepted;

      return SizedBox(
        width: !Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.22,
        child: Column(
          children: [
            Container(
              color: MyAppColor.grayplane,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Text(
                "ACTIONS",
                style: titleHeadGrey16,
              ),
            ),
            widget.job != null || isOfferSend
                ? Column(children: [
                    !isOfferSend
                        ? rejectedBox(isRejected, isShortListed)
                        : SizedBox(),
                    isAccepted || isRejectedByCandidate || isRejected
                        ? const SizedBox()
                        : sendOfferLetterToApplicantsBox(isOfferSend)
                  ])
                : sendOfferLetterJobSeekerBox(isOfferSend),
            messageBox()
          ],
        ),
      );
    });
  }

  rejectedBox(isRejected, isShortListed) {
    return Container(
        margin: const EdgeInsets.only(top: 1),
        color: MyAppColor.greynormal,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: isRejected
            ? Column(
                children: [
                  Text(
                    "The following Applicant has applied for your Job Post. But you rejected its applications.",
                    style: blackDarkSemibold14,
                  ),
                  Text(
                    "Reason :- ${reason.text}",
                    style: blackDarkSemibold14,
                  ),
                ],
              )
            : shortListingRejectBox(isShortListed));
  }

  shortListingRejectBox(isShortListed) {
    return Column(
      children: [
        Text(
          "The following Applicant has applied for your Job Post. Please select your response.",
          style: blackDarkSemibold14,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            rejectButton(
              text: "REJECT ",
            ),
            InkWell(
                onTap: () async {
                  await ref.read(jobData).changeCandidateStatus(context,
                      jobId: widget.job!.id,
                      userId: userId,
                      companyStatus: isShortListed
                          ? CompanyStatus.pending
                          : CompanyStatus.shortListed);
                },
                child: backColorButton(
                    Responsive.isDesktop(context)
                        ? isShortListed
                            ? "REMOVE FROM\nSHORTLIST"
                            : "ADD TO SHORT\nLIST"
                        : isShortListed
                            ? "REMOVE FROM SHORTLIST"
                            : "ADD TO SHORT LIST",
                    margin: 0.0,
                    isExpand: kIsWeb ? null : true,
                    padding: 15.0))
          ],
        )
      ],
    );
  }

  sendOfferLetterToApplicantsBox(isOfferSend) {
    return Container(
        margin: const EdgeInsets.only(top: 1),
        color: MyAppColor.greynormal,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            isOfferSend
                ? Text(
                    "You have sent Offer Letter to this Applicant. How would you like to proceed.",
                    textAlign: TextAlign.center,
                    style: blackDarkSemibold14,
                  )
                : Text(
                    "Would you like to send the Offer Letter to the following Applicant.",
                    style: blackDarkSemibold14,
                  ),
            const SizedBox(
              height: 20,
            ),
            isOfferSend
                ? rejectButton(
                    text: "REJECT THE APPLICANT",
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => StatefulBuilder(
                                    builder: (BuildContext context,
                                            StateSetter innerSetState) =>
                                        selectFileForOffer(innerSetState)));
                          },
                          child: backColorButton("SEND JOB OFFER LETTER",
                              margin: 0.0,
                              padding: 25.0,
                              color: MyAppColor.orangelight))
                    ],
                  )
          ],
        ));
  }

  sendOfferLetterJobSeekerBox(isOfferSend) {
    return Container(
        margin: const EdgeInsets.only(top: 1),
        color: MyAppColor.greynormal,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            isOfferSend
                ? Text(
                    "You have sent Offer Letter to this Applicant. How would you like to proceed.",
                    textAlign: TextAlign.center,
                    style: blackDarkSemibold14,
                  )
                : Text(
                    "Would you like to send the Offer Letter to the following JobSeeker.",
                    style: blackDarkSemibold14,
                  ),
            const SizedBox(
              height: 20,
            ),
            Consumer(builder: (context, ref, child) {
              List jobs = ref.watch(jobData).openJobs;
              return DynamicDropDownListOfFields(
                  label: "Select Job Post",
                  isJobList: true,
                  dropDownList: jobs,
                  selectingValue: null,
                  setValue: (value) {
                    if (value != "Select Job Post") {
                      selectedJob = ref
                          .read(jobData)
                          .openJobs
                          .firstWhere((job) => job.id == int.parse(value));
                    }
                  });
            }),
            SizedBox(height: 10),
            isOfferSend
                ? rejectButton(
                    text: "REJECT THE APPLICANT",
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => StatefulBuilder(
                                    builder: (BuildContext context,
                                            StateSetter innerSetState) =>
                                        selectFileForOffer(innerSetState)));
                          },
                          child: backColorButton("SEND JOB OFFER LETTER",
                              margin: 0.0,
                              padding: 25.0,
                              color: MyAppColor.orangelight))
                    ],
                  )
          ],
        ));
  }

  messageBox() {
    return Container(
        margin: const EdgeInsets.only(top: 1),
        color: MyAppColor.greynormal,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              "Would you like to have a conversation with this Applicant?",
              style: blackDarkSemibold14,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      if (Responsive.isDesktop(context)) {
                        webChatContactBox(context, chatingMessage,
                            isSingle: true,
                            oppositeUserData: widget.isUserDataFlag
                                ? widget.applicants
                                : widget.applicants.user);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      oppositeUser: widget.isUserDataFlag
                                          ? widget.applicants
                                          : widget.applicants.user!,
                                    )));
                      }
                    },
                    child: backColorButton("SEND A MESSAGE",
                        margin: 0.0,
                        padding: 25.0,
                        color: MyAppColor.floatButtonColor)),
              ],
            )
          ],
        ));
  }

  rejectButton({text}) {
    return InkWell(
      onTap: () async {
        await showDialog(
            context: context, builder: (context) => reasonOfReject());
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(width: 1, color: MyAppColor.blackdark)),
          child: Text(
            "$text",
            style: blackDarkSemibold14,
          )),
    );
  }

  profileCardContainer(CandidateProfileModel candidate, job) {
    bool candidateStatus = candidate.employeesStatus == 'N' ? false : true;

    if (widget.job != null &&
        widget.job!.companyStatus != null &&
        widget.job!.candidateStatus != null) {
      isEmailShow = true;
      isCVShow = true;
    } else if (candidate.resumeDataAccess != null) {
      isEmailShow =
          candidate.resumeDataAccess!.emailDownloaded != null ? true : false;
      isCVShow =
          candidate.resumeDataAccess!.cvDownloaded != null ? true : false;
    } else {
      isEmailShow = false;
      isCVShow = false;
    }
    return Column(
      children: [
        candidateState(candidate),
        Container(
          color: MyAppColor.grayplane,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          width: !Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width * 0.21,
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: currentUrl(candidate.image) != null
                      ? Image.network(currentUrl(candidate.image),
                          height: 100, width: 100, fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                          return Image.network(defaultImage,
                              height: 100, width: 100, fit: BoxFit.cover);
                        })
                      : Image.asset("assets/profileIcon.png")),
              const SizedBox(
                height: 20,
              ),
              Text(
                "",
                style: blackBold20,
              ),
              if (job != null)
                labelValueWhiteBackBox(
                    label: "Job Applied for", value: "${job.jobTitle}"),
              labelValueWhiteBackBox(
                  label: "Name of candidate", value: "${candidate.name}"),
              labelValueWhiteBackBox(
                  isShow: isEmailShow,
                  label: "Mobile no. of candidate",
                  value: "${candidate.mobile}"),
              labelValueWhiteBackBox(
                  isShow: isEmailShow,
                  label: "Email of candidate",
                  value: "${candidate.email}"),
              labelValueWhiteBackBox(
                  label: "Employment Status",
                  value: candidateStatus
                      ? "Currently Employed"
                      : "Currently Not Employed"),
              if (candidateStatus && candidate.currentSalary != null)
                labelValueWhiteBackBox(
                    label: "Current Salary",
                    value: "${candidate.currentSalary} per Annum"),
              if (candidateStatus && candidate.noticePeriodDays != null)
                labelValueWhiteBackBox(
                    label: "Notice Period",
                    value: "${candidate.noticePeriodDays} Days"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () async {
                        if (candidate.resume == null ||
                            userData!.userRoleType ==
                                RoleTypeConstant.companyStaff) {
                          return;
                        }
                        if (isCVShow || widget.job != null) {
                          return downloadFile(currentUrl(candidate.resume));
                        }
                        if (ref.read(companyProfile).availableCvlLimits != 0) {
                          await updateAccessDataStatus(true, true);
                          downloadFile(currentUrl(candidate.resume));
                        } else {
                          await alertBox(context,
                              "You have no limits to access candidates cv please subscribed to get access",
                              title: "Limit Reached",
                              route: SubscriptionPlans(
                                isLimitPlans: false,
                                isResumePlans: true,
                              ));
                        }
                      },
                      child: backColorButton(candidate.resume != null
                          ? "DOWNLOAD RESUME"
                          : 'RESUME NOT AVAILABLE')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  candidateState(candidateProfile) {
    return Consumer(builder: (context, ref, child) {
      bool isShortListed = ref.watch(jobData).isShortListed;
      bool isAccepted = ref.watch(jobData).isAccepted;
      bool isOfferSend = ref.watch(jobData).isOfferSend;
      bool isRejected = ref.watch(jobData).isRejected;
      bool isRejectedByCandidate = ref.watch(jobData).isRejectedByCandidate;
      return isShortListed && !isRejected && !isOfferSend
          ? shortlisted()
          : isRejected
              ? rejected("Rejected By You")
              : isOfferSend
                  ? isAccepted
                      ? hired(candidateProfile)
                      : isRejectedByCandidate
                          ? rejected("Offer Rejected By Candidate")
                          : sendOffer()
                  : SizedBox();
    });
  }

  rejected(text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(children: [
        Container(
            height: 100,
            width: !Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.10
                : MediaQuery.of(context).size.width * 0.04,
            color: MyAppColor.logoBlue,
            child: ImageIcon(
              const AssetImage("assets/box-setting.png"),
              color: MyAppColor.white,
            )),
        Container(
            height: 100,
            width: !Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.90 - 40
                : MediaQuery.of(context).size.width * 0.17,
            color: MyAppColor.pink,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$text", style: whiteR14()),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(formatDate(widget.applicants.updatedAt),
                        textAlign: TextAlign.start, style: whiteMedium12),
                  ],
                ),
              ],
            )),
      ]),
    );
  }

  hired(CandidateProfileModel? candidateProfile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(children: [
        Container(
            height: 100,
            width: !Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.10
                : MediaQuery.of(context).size.width * 0.04,
            color: MyAppColor.logoBlue,
            child: ImageIcon(
              const AssetImage("assets/box-setting.png"),
              color: MyAppColor.white,
            )),
        Container(
            height: 100,
            width: !Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.90 - 40
                : MediaQuery.of(context).size.width * 0.17,
            color: MyAppColor.pinkishOrange,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hired Applicant.", style: whiteR14()),
                if (candidateProfile!.userAppliedJobs!.isNotEmpty &&
                    candidateProfile.userAppliedJobs!.first.hiredStaff != null)
                  Text(
                      "Applicant is hired by your staff ${candidateProfile.userAppliedJobs!.first.hiredStaff!.name}.",
                      style: whiteR14()),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(formatDate(widget.applicants.updatedAt),
                        textAlign: TextAlign.start, style: whiteMedium12),
                  ],
                ),
              ],
            )),
      ]),
    );
  }

  acceptOffer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(children: [
        Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.10,
            color: MyAppColor.logoBlue,
            child: ImageIcon(
              const AssetImage("assets/box-setting.png"),
              color: MyAppColor.white,
            )),
        Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.90 - 40,
            color: MyAppColor.green,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Applicant has accepted the Offer Letter.",
                    style: whiteR14()),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(formatDate(widget.applicants.updatedAt),
                        textAlign: TextAlign.start, style: whiteMedium12),
                  ],
                ),
              ],
            )),
      ]),
    );
  }

  sendOffer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(children: [
        Container(
            height: 110,
            width: !Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.10
                : MediaQuery.of(context).size.width * 0.04,
            color: MyAppColor.pink,
            child: ImageIcon(
              const AssetImage("assets/box-setting.png"),
              color: MyAppColor.white,
            )),
        Container(
            height: 110,
            width: !Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.90 - 40
                : MediaQuery.of(context).size.width * 0.17,
            color: MyAppColor.logoBlue,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("You have sent Offer Letter to this Applicant.",
                    style: whiteR14()),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(formatDate(widget.applicants.updatedAt),
                        textAlign: TextAlign.start, style: whiteMedium12),
                  ],
                ),
              ],
            )),
      ]),
    );
  }

  shortlisted() {
    return Container(
      width: !Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * 0.21,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 2),
      color: MyAppColor.greylight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ImageIcon(
            AssetImage("assets/shortlist-image.png"),
            color: Colors.white,
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("You have Short-Listed this\nApplicant.",
                  textAlign: TextAlign.start, style: whiteRegular14),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                      formatDate(widget.isUserDataFlag
                          ? widget.applicants.userAppliedJobs[0].updatedAt
                          : widget.applicants.updatedAt),
                      textAlign: TextAlign.start,
                      style: whiteMedium12),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  backColorButton(text, {isExpand, margin, padding, color}) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: isExpand != null ? 150 : double.infinity),
      margin: EdgeInsets.only(top: margin ?? 30),
      decoration: BoxDecoration(
          color: color ?? MyAppColor.greylight,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      padding: EdgeInsets.symmetric(horizontal: padding ?? 35, vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: whiteRegular14,
      ),
    );
  }

  updateAccessDataStatus(email, cv) async {
    Map<String, dynamic> carryData = {
      "user_subscribed_id": ref.read(companyProfile).resumeAccessPlanId,
      "info_accessed_user_id": userId
    };
    if (email) {
      carryData['email_downloaded'] = 'Y';
    }
    if (cv) {
      carryData['email_downloaded'] = 'Y';
      carryData['cv_downloaded'] = 'Y';
    }
    ApiResponse response = await addResumeAccessData(context, carryData);
    if (response.status == 200) {
      ref.read(jobData).fetchCandidateData(
            context,
            false,
            candidateId: userId,
            jobId: widget.job != null ? widget.job!.id : null,
          );
      setState(() {});
    } else {
      return showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  labelValueWhiteBackBox({label, value, isShow}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(color: MyAppColor.greynormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: chipColorSemibold12,
          ),
          isShow != null && isShow == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "**********",
                      style: BlackDarkSb18(),
                    ),
                    InkWell(
                        onTap: () async {
                          if (ref.read(companyProfile).availableEmailLimits !=
                              0) {
                            await updateAccessDataStatus(true, false);
                          } else {
                            await alertBox(context,
                                "You have no limits to access candidates email please subscribed to get access",
                                title: "Limit Reached",
                                route: SubscriptionPlans(
                                  isLimitPlans: false,
                                  isResumePlans: true,
                                ));
                          }
                        },
                        child: Text(
                          "view",
                          style: BlackDarkSb18(),
                        ))
                  ],
                )
              : Text(
                  value,
                  style: BlackDarkSb18(),
                ),
        ],
      ),
    );
  }

  reasonOfReject() {
    return AlertDialog(
      content: SizedBox(
        height: 240,
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Reason"),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Rejection reason of candidate",
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: MyAppColor.blacklight.withOpacity(0.5),
                        width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: TextFormFieldWidget(
                  text: 'Reason',
                  control: reason,
                  isRequired: true,
                  type: TextInputType.multiline,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (reason.text == '') {
                    return;
                  }
                  Navigator.pop(context);
                  await ref.read(jobData).changeCandidateStatus(context,
                      jobId: widget.job!.id,
                      userId: userId,
                      companyStatus: CompanyStatus.rejected,
                      reason: reason.text);
                },
                child: const Text("Done"),
                style: ElevatedButton.styleFrom(
                  primary: MyAppColor.orangelight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectFileForOffer(innerSetState) {
    return AlertDialog(
      content: SizedBox(
        height: 260,
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Send Offer Letter"),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Select Offer Letter to send candidate",
                textAlign: TextAlign.center,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "File name :- ${resume.text}",
                      style: blackDarkM14(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      FilePickerResult? file = await selectFile();

                      if (file == null) return;
                      offerLetterFile = Responsive.isDesktop(context)
                          ? file.files.first
                          : File(file.paths.first!);
                      resume.text = Responsive.isDesktop(context)
                          ? file.files.first.name
                          : file.names.first!;
                      FocusScope.of(context).unfocus();
                      innerSetState(() {});
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(color: Colors.grey),
                      child: Text("Select File", style: blackDarkM14()),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (widget.job == null) {
                    if (selectedJob == null) {
                      return showSnack(
                          context: context,
                          msg: "Please select job first",
                          type: 'error');
                    }
                    await ref.read(jobData).sendOfferLetterToJobSeeker(context,
                        jobId: selectedJob!.id,
                        userId: userId,
                        companyStatus: CompanyStatus.sendOffer,
                        offerLetter: offerLetterFile);
                  } else {
                    await ref.read(jobData).sendOfferLetter(context,
                        jobId: widget.job!.id,
                        userId: userId,
                        companyStatus: CompanyStatus.sendOffer,
                        offerLetter: offerLetterFile);
                  }
                },
                child: const Text("Done"),
                style: ElevatedButton.styleFrom(
                  primary: MyAppColor.orangelight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
