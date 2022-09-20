// ignore_for_file: prefer_final_fields, unused_field, prefer_typing_uninitialized_variables, unnecessary_const, prefer_const_constructors

import 'dart:io';
import 'dart:isolate';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/header/back_text_widget.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/url_laucher.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:vrouter/vrouter.dart';

import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/specific_company.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/landing_page/search_job_here.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/enum_contants.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/api_services/jobs_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/utility/bottom_sheet_utility_functions.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/checkbox/customchekbox.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:hindustan_job/widget/select_file.dart';
import 'package:hindustan_job/widget/subscription_alert_box.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

import '../../../../widget/common_app_bar_widget.dart';

class JobViewPage extends ConsumerStatefulWidget {
  var id;
  String? flag;
  String? offerletter;
  String? companyStatus;
  String? candidateStatus;
  String? reason;
  bool isFromSearch;

  JobViewPage(
      {Key? key,
      this.id,
      this.flag,
      this.offerletter,
      this.candidateStatus,
      this.companyStatus,
      this.isFromSearch = false,
      this.reason})
      : super(key: key);

  @override
  _JobViewPageState createState() => _JobViewPageState();
}

class _JobViewPageState extends ConsumerState<JobViewPage> {
  int _radioSelected = 1;
  late String _radioVal;
  TextEditingController resume = TextEditingController();
  var resumeFile;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  JobsTwo? jobDetail;
  Resume resumeType = Resume.seperateResume;
  bool isApplied = false;
  bool _isSelected = false;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    ref.read(jobData).isApplied = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobData).removeFalse();
      ref.read(jobData).updateStatus(widget.companyStatus ?? '',
          candidateStatus: widget.candidateStatus ?? '');
      if (kIsWeb) {
        ref.read(editProfileData).checkSubscription();
      }
    });
    fetchJobDetails(widget.id);
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
      toast("${e.toString()}");
    }
  }

  fetchJobDetails(id) async {
    jobDetail = await jobDetails(context, jobId: id);
    if (jobDetail != null) {
      ref.read(jobData).updateStatus(jobDetail!.companyStatus ?? '',
          candidateStatus: jobDetail!.candidateStatus ?? '');
      _isSelected = jobDetail!.notInterested != null &&
              jobDetail!.notInterested!.status == 1
          ? true
          : false;
    }
    setState(() {});
  }

  resumeTypeValueChange(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      resumeType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    print(widget.isFromSearch);
    print(!kIsWeb);
    print(!kIsWeb && !widget.isFromSearch);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      key: _drawerKey,
      drawer: const Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: !kIsWeb && !widget.isFromSearch
          ? PreferredSize(
              child: BackWithText(text: "HOME (JOB-SEEKER) / JOB"),
              preferredSize: Size.fromHeight(50))
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(Responsive.isDesktop(context) ? 130 : 150),
              child: CommomAppBar(
                drawerKey: _drawerKey,
                back: "HOME (JOB-SEEKER) / JOB",
              ),
            ),
      body: Consumer(builder: (context, ref, child) {
        bool isApplied = ref.watch(jobData).isApplied;
        bool isAccepted = ref.watch(jobData).isAccepted;
        bool isOfferSend = ref.watch(jobData).isOfferSend;
        bool isShortListed = ref.watch(jobData).isShortListed;
        bool isRejected = ref.watch(jobData).isRejected;
        bool isRejectedByCandidate = ref.watch(jobData).isRejectedByCandidate;
        bool isCandidateSubscribed =
            ref.watch(editProfileData).isCandidateSubscribed;
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  const SizedBox(
                    height: 14,
                  ),
                  if (!Responsive.isDesktop(context)) Search(),
                  const SizedBox(
                    height: 30,
                  ),
                  if (!isCandidateSubscribed)
                    SubscriptionAlertBox(
                        isFromConnectedRoutes: !widget.isFromSearch),
                  const SizedBox(
                    height: 10,
                  ),
                  jobDetail != null
                      ? !Responsive.isDesktop(context)
                          ? Column(children: [
                              if ((isAccepted ||
                                  isRejected ||
                                  isRejectedByCandidate))
                                status(isAccepted ? "Hired" : 'Rejected',
                                    isAccepted, isRejectedByCandidate),
                              if (isApplied &&
                                  !isRejected &&
                                  !isAccepted &&
                                  !isOfferSend)
                                appliedShortlistedStatus(isShortListed),
                              if (isOfferSend &&
                                  !isAccepted &&
                                  !isRejected &&
                                  !isRejectedByCandidate)
                                offetLetterStatus(),
                              _privatesector(context, styles, jobDetail),
                              if (jobDetail!.jobTypeId == 2)
                                Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(currentUrl(
                                                jobDetail!.image))))),
                              widget.flag == 'applied' ||
                                      isApplied ||
                                      jobDetail!.jobTypeId == 2
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(top: 20),
                                      margin: const EdgeInsets.only(top: 2),
                                      color: MyAppColor.greynormal,
                                      child: Opacity(
                                        opacity: 1,
                                        child: Column(
                                          children: [
                                            if (!_isSelected)
                                              Column(
                                                children: [
                                                  resumeRadioButton(
                                                      value:
                                                          Resume.profileResume,
                                                      groupValue:
                                                          isCandidateSubscribed
                                                              ? resumeType
                                                              : null,
                                                      onChanged: (value) =>
                                                          resumeTypeValueChange(
                                                              value),
                                                      text:
                                                          'Apply with your Profile Resume\n(Recommended)'),
                                                  resumeRadioButton(
                                                      value:
                                                          Resume.seperateResume,
                                                      groupValue:
                                                          isCandidateSubscribed
                                                              ? resumeType
                                                              : null,
                                                      onChanged: (value) =>
                                                          resumeTypeValueChange(
                                                              value),
                                                      text:
                                                          'Apply with a separate Resume'),
                                                  if (isCandidateSubscribed &&
                                                      Resume.seperateResume ==
                                                          resumeType)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child:
                                                          TextFormFieldWidget(
                                                        text: 'Selected Resume',
                                                        control: resume,
                                                        isRequired: false,
                                                        type:
                                                            TextInputType.none,
                                                        onTap: () async {
                                                          FilePickerResult?
                                                              file =
                                                              await selectFile();
                                                          if (file == null) {
                                                            return;
                                                          }
                                                          setState(() {
                                                            resumeFile = kIsWeb
                                                                ? file
                                                                    .files.first
                                                                : File(file
                                                                    .paths
                                                                    .first!);
                                                            resume.text = file
                                                                .names.first!;
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  if (!_isSelected)
                                                    jobButton(
                                                        isCandidateSubscribed),
                                                  SizedBox(
                                                    height: Sizeconfig
                                                            .screenHeight! /
                                                        40,
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                              if (jobDetail!.jobTypeId == 2)
                                keyValueResponse(
                                    key: 'DeadLine',
                                    value: '${jobDetail!.deadline}'),
                              if (jobDetail!.jobTypeId == 2)
                                keyValueResponse(
                                    key: 'Organization',
                                    value: jobDetail?.organization ?? ''),
                              if (jobDetail!.jobTypeId == 2)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UrlLauncherWidget(
                                                url:
                                                    '${jobDetail!.advertiseLink}')));
                                  },
                                  child: keyValueResponse(
                                      key: 'Advertise Link',
                                      value: '${jobDetail!.advertiseLink}'),
                                ),
                              if (jobDetail!.jobTypeId == 2)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UrlLauncherWidget(
                                                url:
                                                    '${jobDetail!.officialWebsite}')));
                                  },
                                  child: keyValueResponse(
                                      key: 'Official Website',
                                      value: jobDetail?.officialWebsite ?? ''),
                                ),
                              locationResponse(),
                              if (jobDetail!.jobTypeId != 2)
                                unlockResponseCompany(
                                    styles, isCandidateSubscribed),
                              descriptionResponse(styles),
                              skillREsponse(),
                              if (jobDetail!.experienceRequired == 'Y')
                                _applyjob(
                                    styles,
                                    'EXPERIENCED REQUIRED',
                                    experienceShow(
                                        expFrom: jobDetail!.expFrom,
                                        expTo: jobDetail!.expTo)),
                              if (jobDetail!.educationRequired == 'Y' &&
                                  jobDetail!.educationDatum != null)
                                _applyjob(styles, 'EDUCATION REQUIRED',
                                    jobDetail!.educationDatum!.name.toString()),
                              _applyjob(
                                  styles,
                                  'EMPLOYMENT TYPE',
                                  findValueConstant(
                                      list: ListDropdown.employmentType,
                                      keyValue: jobDetail!.employmentType)),
                              _applyjob(styles, 'CONTRACT TYPE',
                                  '${getCapitalizeString(jobDetail!.contractType)}: ${jobDetail!.contractDuration ?? 0} Months'),
                              _applyjob(
                                  styles,
                                  'WORK FROM HOME',
                                  findValueConstant(
                                      list: ListDropdown.wfh,
                                      keyValue: jobDetail!.workFromHome)),
                              _applyjob(
                                  styles,
                                  'WORK SCHEDULE',
                                  findValueConstant(
                                      list: ListDropdown.jobSchedule,
                                      keyValue: jobDetail!.jobSchedule)),
                              if (jobDetail!.jobTimeFrom != null &&
                                  jobDetail!.jobTimeTo != null)
                                _applyjob(styles, 'TIMING',
                                    "${jobDetail!.jobTimeFrom!}  to  ${jobDetail!.jobTimeTo!}"),
                              _applyjob(styles, 'Applicants Applied',
                                  '${jobDetail!.appliedUserCount}'),
                              CustomcheckBox(
                                  term: '',
                                  label: 'not interested in this job',
                                  padding: const EdgeInsets.all(0),
                                  value: _isSelected,
                                  onChanged: (bool newvalue) async {
                                    _isSelected = newvalue;
                                    await ref.read(jobData).addInNotInterested(
                                        context, widget.id, widget.flag);

                                    await fetchJobDetails(widget.id);
                                    setState(() {});
                                  })
                            ])
                          : Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: Sizeconfig.screenWidth! / 1.3,
                                    child: Column(
                                      children: [
                                        SerchJobHere(),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                children: [
                                                  if (isAccepted || isRejected)
                                                    // if (widget.candidateStatus ==
                                                    //         CandidateStatus
                                                    //             .acceptOffer ||
                                                    //     (jobDetail!.userAppliedJob !=
                                                    //             null &&
                                                    //         jobDetail!
                                                    //                 .userAppliedJob!
                                                    //                 .candidateStatus ==
                                                    //             CandidateStatus
                                                    //                 .acceptOffer))
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 2),
                                                      color:
                                                          MyAppColor.greylight,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const ImageIcon(
                                                            const AssetImage(
                                                                "assets/shortlist-image.png"),
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                              isAccepted
                                                                  ? "You are Hired"
                                                                  : "You are Rejected",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style:
                                                                  whiteRegular14)
                                                        ],
                                                      ),
                                                    ),
                                                  if ((widget.flag ==
                                                              'applied' ||
                                                          widget.flag ==
                                                              'shortList' ||
                                                          jobDetail!
                                                                  .userAppliedJob !=
                                                              null ||
                                                          isApplied) &&
                                                      !isOfferSend)
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 2),
                                                      color:
                                                          MyAppColor.greylight,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ImageIcon(
                                                            AssetImage(widget
                                                                        .flag ==
                                                                    'shortList'
                                                                ? "assets/shortlist-image.png"
                                                                : "assets/applied-succes-image.png"),
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          widget
                                                                      .flag ==
                                                                  'shortList'
                                                              ? Text(
                                                                  "You have been Short-Listed by the \nRecruiter for this Job.",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      whiteRegular14)
                                                              : Text(
                                                                  "You have successfully applied for this Job.",
                                                                  style:
                                                                      whiteRegular14),
                                                        ],
                                                      ),
                                                    ),
                                                  if (widget.flag ==
                                                          'offerLetter' &&
                                                      !isAccepted &&
                                                      !isRejectedByCandidate &&
                                                      widget.candidateStatus !=
                                                          CandidateStatus
                                                              .acceptOffer)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 2.0),
                                                      child: Row(children: [
                                                        Container(
                                                            height: 165,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.10,
                                                            color:
                                                                MyAppColor.pink,
                                                            child: ImageIcon(
                                                              const AssetImage(
                                                                  "assets/box-setting.png"),
                                                              color: MyAppColor
                                                                  .white,
                                                            )),
                                                        Expanded(
                                                          child: Container(
                                                              height: 165,
                                                              color: MyAppColor
                                                                  .logoBlue,
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 20,
                                                                  horizontal:
                                                                      16),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "You have Received the Offer Letter for this Job by the Recruiters.",
                                                                      style:
                                                                          whiteR14()),
                                                                  // if (widget.offerletter != null)
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      await downloadFile(
                                                                          currentUrl(
                                                                        widget
                                                                            .offerletter,
                                                                      ));
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .download,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                            "download offer letter",
                                                                            style:
                                                                                whiteR14()),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              await ref.read(jobData).acceptRejectOffer(context, jobId: widget.id, status: CandidateStatus.rejectOffer);
                                                                            },
                                                                            child: Container(
                                                                                decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(5)),
                                                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                                child: Row(
                                                                                  children: [
                                                                                    const Icon(Icons.cancel, color: Colors.white, size: 18),
                                                                                    const SizedBox(width: 8),
                                                                                    Text("REJECT", style: whiteR14()),
                                                                                  ],
                                                                                ))),
                                                                        InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              await ref.read(jobData).acceptRejectOffer(context, jobId: widget.id, status: CandidateStatus.acceptOffer);
                                                                            },
                                                                            child: Container(
                                                                                decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(5)),
                                                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                                child: Row(
                                                                                  children: [
                                                                                    const Icon(Icons.arrow_circle_up_outlined, color: Colors.white, size: 18),
                                                                                    const SizedBox(width: 8),
                                                                                    Text("ACCEPT", style: whiteR14()),
                                                                                  ],
                                                                                )))
                                                                      ])
                                                                ],
                                                              )),
                                                        ),
                                                      ]),
                                                    ),
                                                  _privatesector(context,
                                                      styles, jobDetail),
                                                  widget.flag == 'applied' ||
                                                          isApplied
                                                      ? Container()
                                                      : Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 2),
                                                          color: MyAppColor
                                                              .greynormal,
                                                          child: Opacity(
                                                            opacity: 1,
                                                            child: Column(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        resumeRadioButton(
                                                                            value: Resume
                                                                                .profileResume,
                                                                            groupValue: isCandidateSubscribed
                                                                                ? resumeType
                                                                                : null,
                                                                            onChanged: (value) =>
                                                                                resumeTypeValueChange(value),
                                                                            text: 'Apply with your Profile Resume (Recommended)'),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        resumeRadioButton(
                                                                            value: Resume
                                                                                .seperateResume,
                                                                            groupValue: isCandidateSubscribed
                                                                                ? resumeType
                                                                                : null,
                                                                            onChanged: (value) =>
                                                                                resumeTypeValueChange(value),
                                                                            text: 'Apply with a separate Resume'),
                                                                      ],
                                                                    ),
                                                                    if (isCandidateSubscribed &&
                                                                        Resume.seperateResume ==
                                                                            resumeType)
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            TextFormFieldWidget(
                                                                          text:
                                                                              'Selected Resume',
                                                                          control:
                                                                              resume,
                                                                          isRequired:
                                                                              false,
                                                                          type:
                                                                              TextInputType.none,
                                                                          onTap:
                                                                              () async {
                                                                            FilePickerResult?
                                                                                file =
                                                                                await selectFile();
                                                                            if (file ==
                                                                                null) {
                                                                              return;
                                                                            }
                                                                            setState(() {
                                                                              resumeFile = kIsWeb ? file.files.first : File(file.paths.first!);
                                                                              resume.text = file.names.first!;
                                                                              FocusScope.of(context).unfocus();
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    jobButton(
                                                                        isCandidateSubscribed),
                                                                    SizedBox(
                                                                      height:
                                                                          Sizeconfig.screenHeight! /
                                                                              40,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                  isApplied ||
                                                          widget.flag ==
                                                              'shortList' ||
                                                          jobDetail!
                                                                  .userAppliedJob !=
                                                              null
                                                      ? Container()
                                                      : Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 00),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 0),
                                                          // height: Sizeconfig.screenHeight! / 5,
                                                          width: Sizeconfig
                                                              .screenWidth,
                                                          color: MyAppColor
                                                              .greynormal,
                                                          child: Opacity(
                                                            opacity: 1,
                                                            child: Column(
                                                              children: [
                                                                if (!isCandidateSubscribed)
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              6,
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              15),
                                                                      child:
                                                                          subscribeAlertBox(
                                                                        'Subscribe to Apply',
                                                                      )),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            locationResponse(),
                                                      ),
                                                      Expanded(
                                                        child: unlockResponseCompany(
                                                            styles,
                                                            isCandidateSubscribed),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            descriptionResponse(
                                                                styles),
                                                      ),
                                                    ],
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.only(
                                                  //           top: 3.0),
                                                  //   child: descriptionResponse(
                                                  //       styles),
                                                  // ),
                                                  skillREsponse(),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          color: MyAppColor
                                                              .greynormal,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (jobDetail!
                                                                      .experienceRequired ==
                                                                  'Y')
                                                                _applyjob(
                                                                  styles,
                                                                  'EXPERIENCED REQUIRED',
                                                                  experienceShow(
                                                                      expFrom:
                                                                          jobDetail!
                                                                              .expFrom,
                                                                      expTo: jobDetail!
                                                                          .expTo),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color: MyAppColor
                                                              .greynormal,
                                                          child: Column(
                                                            children: [
                                                              if (jobDetail!
                                                                      .educationRequired ==
                                                                  'Y')
                                                                _applyjob(
                                                                    styles,
                                                                    'EDUCATION REQUIRED',
                                                                    jobDetail!
                                                                        .educationDatum!
                                                                        .name
                                                                        .toString()),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          color: MyAppColor
                                                              .greynormal,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              _applyjob(
                                                                  styles,
                                                                  'EMPLOYMENT TYPE',
                                                                  findValueConstant(
                                                                      list: ListDropdown
                                                                          .employmentType,
                                                                      keyValue:
                                                                          jobDetail!
                                                                              .employmentType)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color: MyAppColor
                                                              .greynormal,
                                                          child: _applyjob(
                                                              styles,
                                                              'CONTRACT TYPE',
                                                              '${getCapitalizeString(jobDetail!.contractType)}: ${jobDetail!.contractDuration} Months'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          color: MyAppColor
                                                              .greynormal,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              _applyjob(
                                                                  styles,
                                                                  'WORK FROM HOME',
                                                                  findValueConstant(
                                                                      list: ListDropdown
                                                                          .wfh,
                                                                      keyValue:
                                                                          jobDetail!
                                                                              .workFromHome)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color: MyAppColor
                                                              .greynormal,
                                                          child: Column(
                                                            children: [
                                                              _applyjob(
                                                                  styles,
                                                                  'WORK SCHEDULE',
                                                                  findValueConstant(
                                                                      list: ListDropdown
                                                                          .jobSchedule,
                                                                      keyValue:
                                                                          jobDetail!
                                                                              .jobSchedule)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                flex: 2, child: SizedBox()),
                                          ],
                                        ),
                                        CustomcheckBox(
                                            term: '',
                                            label: 'not interested in this job',
                                            padding: const EdgeInsets.all(0),
                                            value: _isSelected,
                                            onChanged: (bool newvalue) async {
                                              _isSelected = newvalue;
                                              await ref
                                                  .read(jobData)
                                                  .addInNotInterested(context,
                                                      widget.id, widget.flag);

                                              await fetchJobDetails(widget.id);
                                              setState(() {});
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : loaderIndicator(context),
                  SizedBox(
                    height: Sizeconfig.screenHeight! / 18,
                  ),
                  // if (!Responsive.isDesktop(context))
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 13),
                  //     child: simillarJobs(styles),
                  //   ),
                ],
              ),
            ),
            // LatestJObsSlider(),
            // if (!Responsive.isDesktop(context))
            // Column(
            //   children: [
            //     SizedBox(
            //       height: 40,
            //       width: Sizeconfig.screenWidth! / 2.5,
            //       child: viewAlllButtons(context),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: Sizeconfig.screenHeight! / 13,
            // ),
            Footer(),
          ],
        );
      }),
    );
  }

  Padding skillREsponse() {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        color: MyAppColor.greynormal,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          skillsetsRequired(),
          const SizedBox(
            height: 12,
          ),
          Wrap(
              runSpacing: 10.0,
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: List.generate(
                  jobDetail!.jobPostSkills!.length,
                  (index) => tagChip(
                        text: jobDetail!
                            .jobPostSkills![index].skillSubCategories!.name,
                        action: 'Add',
                      ))),
        ]),
      ),
    );
  }

  Container descriptionResponse(TextStyle styles) {
    return Container(
      width: Sizeconfig.screenHeight! / 1.3,
      padding: const EdgeInsets.all(15),
      color: MyAppColor.greynormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          jobDescription(styles),
          Container(
            height: Sizeconfig.screenHeight! / 3,
            width: double.infinity,
            child: SingleChildScrollView(
              child: description(styles, jobDetail!.jobDescription),
            ),
          ),
        ],
      ),
    );
  }

  Container unlockResponseCompany(
      TextStyle styles, bool isCandidateSubscribed) {
    return Container(
      padding: const EdgeInsets.all(15),
      // height: Sizeconfig.screenHeight! / 5,
      // width: Sizeconfig.screenWidth,
      color: MyAppColor.greylight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              companyText(styles),
              isCandidateSubscribed
                  ? lakshyaCorporations(greySemibold14, jobDetail!.name)
                  : InkWell(
                      onTap: () {
                        alertBox(context,
                            "You are not subscribed user please click on yes if want to subscribe",
                            title: 'Subscribe Now',
                            route: SubscriptionPlans(
                              isValidityPlan: true,
                            ));
                      },
                      child: subscribeAlertBox(
                        'Subscribe to Unloack Company Info',
                      )),
            ],
          ),
          if (isCandidateSubscribed) arrowButton(widget.id)
        ],
      ),
    );
  }

  Container locationResponse() {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 2),
      color: MyAppColor.greynormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              iconLocation(),
              jobLocation(blackDark12, 'JOB LOCATION'),
            ],
          ),
          jobLocation(blackDarkSemiBold16,
              '${locationShow(city: jobDetail!.city, state: jobDetail!.state)}'),
        ],
      ),
    );
  }

  Container keyValueResponse({key, value}) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 2),
      color: MyAppColor.greynormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              jobLocation(blackDark12, '$key'),
            ],
          ),
          jobLocation(blackDarkSemiBold16, '$value'),
        ],
      ),
    );
  }

  Widget tagChip({
    text,
    onTap,
    action,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff755F55),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 14,
            child: Icon(
              Icons.edit,
              size: 18.0,
              color: Color(0xff755F55),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              '$text',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  offetLetterStatus() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(children: [
        Container(
            height: 165,
            width: MediaQuery.of(context).size.width * 0.10,
            color: MyAppColor.pink,
            child: ImageIcon(
              const AssetImage("assets/box-setting.png"),
              color: MyAppColor.white,
            )),
        Container(
            height: 165,
            width: MediaQuery.of(context).size.width * 0.90 - 16,
            color: MyAppColor.logoBlue,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "You have Received the Offer Letter for this Job by the Recruiters.",
                    style: whiteR14()),
                // if (widget.offerletter != null)
                InkWell(
                  onTap: () async {
                    await downloadFile(currentUrl(widget.offerletter));
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 15,
                      ),
                      Text("download offer letter", style: whiteR14()),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () async {
                            await ref.read(jobData).acceptRejectOffer(context,
                                jobId: widget.id,
                                status: CandidateStatus.rejectOffer);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.cancel,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Text("REJECT", style: whiteR14()),
                                ],
                              ))),
                      InkWell(
                          onTap: () async {
                            await ref.read(jobData).acceptRejectOffer(context,
                                jobId: widget.id,
                                status: CandidateStatus.acceptOffer);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.arrow_circle_up_outlined,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Text("ACCEPT", style: whiteR14()),
                                ],
                              )))
                    ])
              ],
            )),
      ]),
    );
  }

  appliedShortlistedStatus(isShortListed) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 2),
      color: MyAppColor.greylight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage(widget.flag == 'shortList'
                ? "assets/shortlist-image.png"
                : "assets/applied-succes-image.png"),
            color: Colors.white,
          ),
          const SizedBox(
            width: 5,
          ),
          isShortListed
              ? Text(
                  "You have been Short-Listed by the \nRecruiter for this Job.",
                  textAlign: TextAlign.start,
                  style: whiteRegular14)
              : Text("You have successfully applied for this Job.",
                  style: whiteRegular14),
        ],
      ),
    );
  }

  status(text, isAccepted, isRejectedByCandidate) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 2),
      color: MyAppColor.greylight,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ImageIcon(
                const AssetImage("assets/shortlist-image.png"),
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                  isRejectedByCandidate
                      ? "You are rejected this job"
                      : "You are $text",
                  textAlign: TextAlign.start,
                  style: whiteRegular14)
            ],
          ),
          if (!isAccepted && !isRejectedByCandidate)
            Text("Reason : ${widget.reason}",
                textAlign: TextAlign.start, style: whiteRegular14)
        ],
      ),
    );
  }

  subscribeAlertBox(text) {
    return Row(
      children: [
        Icon(
          Icons.lock,
          color: MyAppColor.orangedark,
          size: 13,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          '$text',
          style: orangeLightBold14,
        )
      ],
    );
  }

  resumeRadioButton({text, value, groupValue, onChanged}) {
    return Row(
      children: [
        Radio<dynamic>(
          activeColor: MyAppColor.orangelight,
          value: value,
          groupValue: groupValue,
          onChanged: (value) => onChanged(value),
        ),
        Text("$text", style: blackDark13),
      ],
    );
  }

  Text bhopalMadhyaPradesh(TextStyle styles) =>
      Text('Bhopal, Madhya Pradesh, India', style: styles);

  Text jobLocation(TextStyle styles, text) {
    return Text(
      text,
      style: styles,
    );
  }

  Icon iconLocation() {
    return const Icon(
      Icons.location_on,
      size: 15,
    );
  }

  OutlinedButton viewAlllButtons(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(
        Mystring.viewAll,
        style: Mytheme.lightTheme(context).textTheme.headline1,
      ),
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
    );
  }

  Text simillarJobs(TextStyle styles) {
    return Text(
      'SIMILAR JOBS',
      style: styles,
    );
  }

  Text notInterest(TextStyle styles) {
    return Text('not interested in this job',
        style: styles.copyWith(color: MyAppColor.orangelight));
  }

  Image imageInterest() {
    return Image.asset(
      'assets/interestJob.png',
      height: 18,
    );
  }

  Text skillsetsRequired() => Text('SKILLSETS REQUIRED', style: blackDark12);

  description(TextStyle styles, description) {
    return Html(
      data: description,
    );
  }

  Text jobDescription(TextStyle styles) {
    return Text(
      'JOB DESCRIPTIONS',
      style: blackDark12,
    );
  }

  OutlinedButton arrowButton(id) {
    return OutlinedButton(
        style:
            OutlinedButton.styleFrom(side: BorderSide(color: MyAppColor.white)),
        onPressed: () {
          if (kIsWeb) {
            context.vRouter.to(
                '/hindustaan-jobs/specific-company/${jobDetail!.userId.toString()}');
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpecificCompany(
                          companyId: jobDetail!.userId.toString(),
                        )));
          }
          return;
        },
        child: Icon(
          Icons.arrow_forward,
          color: MyAppColor.white,
          size: 25,
        ));
  }

  Text lakshyaCorporations(TextStyle styles, name) {
    return Text(
      getCapitalizeString(name),
      style: styles.copyWith(color: MyAppColor.backgroundColor),
    );
  }

  Text companyText(TextStyle styles) {
    return Text('COMPANY', style: greyRegular12);
  }

  Radio<int> radiobutton() {
    return Radio(
        value: 2,
        activeColor: MyAppColor.orangelight,
        groupValue: _radioSelected,
        onChanged: (value) {});
  }

  ElevatedButton jobButton(isCandidateSubscribed) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyAppColor.orangelight,
        ),
        onPressed: !isCandidateSubscribed
            ? () {
                alertBox(context,
                    "You are not subscribed user please click on yes if want to subscribe",
                    title: 'Subscribe Now',
                    route: SubscriptionPlans(
                      isValidityPlan: true,
                    ));
              }
            : () async {
                if (Resume.seperateResume == resumeType && resumeFile == null) {
                  return showSnack(
                      context: context, msg: "Select Resume", type: 'error');
                } else if (Resume.profileResume == resumeType &&
                    userData!.resume == null) {
                  return showSnack(
                      context: context,
                      msg: "Upload Resume in your profile to apply on jobs",
                      type: 'error');
                } else {
                  var answers = await questionAndAnswerDialog(
                      context, jobDetail!.questions,
                      title: 'Company Questions');
                  if (answers != 'Cancel' && jobDetail!.questions != null) {
                    List ans = answers.split(',');
                    for (var i = 0; i < jobDetail!.questions!.length; i++) {
                      await addJobPostAnswer(context,
                          answer: ans[i],
                          questionId: jobDetail!.questions![i].id);
                    }
                    ref
                        .read(jobData)
                        .applyJob(context, jobId: widget.id, file: resumeFile);
                  }
                }
              },
        child: Text(
            isCandidateSubscribed ? 'APPLY FOR THIS JOB' : 'Subscribe to apply',
            style: TextStyle(color: MyAppColor.backgroundColor)));
  }

  Padding _applyjob(TextStyle styles, String text, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.all(15),
        // height: Sizeconfig.screenHeight!,
        width: Sizeconfig.screenWidth,
        color: MyAppColor.greynormal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: blackDark13,
            ),
            Text(
              "$number",
              style: blackDarkSemiBold16,
            ),
          ],
        ),
      ),
    );
  }

  Row sectrResponse(JobsTwo? jobs) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageIcon(AssetImage('assets/bag_icn.png'),
            size: 15, color: MyAppColor.applecolor),
        SizedBox(
          width: 5,
        ),
        Text(
          (jobs!.jobType != null
              ? "${jobs.jobType!.name} Sector Job".toUpperCase()
              : ''),
          style: appleColorSemiBold12,
        ),
      ],
    );
  }

  Text jobSaleryResponse(JobsTwo jobs) {
    return Text(
      '${salaryShow(jobs.salary, jobs.salaryFrom, jobs.salaryTo)}',
      style: blackDarkR16.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Wrap wrapResponse(JobsTwo jobs) {
    return Wrap(runSpacing: 10, spacing: 10, children: [
      HashTag(text: "${jobs.industry!.name}"),
      HashTag(text: "${jobs.sector!.name}"),
      HashTag(text: jobs.jobRoleType!.name!),
    ]);
  }

  Text baseSalery() {
    return Text(
      'Base Salary',
      style: blackDark12,
    );
  }

  Widget _privatesector(BuildContext context, TextStyle styles, JobsTwo? jobs) {
    return Container(
        // margin: EdgeInsets.only(
        //   left: Responsive.isDesktop(context) ? 12 : 00,
        // ),
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width / 1.5
            : 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: MyAppColor.greynormal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                await ref
                    .read(jobData)
                    .likeUnlike(context, jobDetail!.id, widget.flag);
                fetchJobDetails(jobDetail!.id);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 20,
                    color: jobDetail!.userLikedJob != null
                        ? MyAppColor.pink
                        : MyAppColor.gray,
                    child: Image.asset(
                      'assets/heart.png',
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: Responsive.isMobile(context) ? 10 : 6,
            // ),
            Container(
              padding: !Responsive.isDesktop(context)
                  ? EdgeInsets.all(15)
                  : EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Responsive.isDesktop(context))
                      Column(
                        children: [
                          sectrResponse(jobs),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  getCapitalizeString(
                                      nullCheckValue(jobs!.jobTitle)),
                                  style: blackDarkR16.copyWith(
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: jobSaleryResponse(jobs),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              wrapResponse(jobs),
                              baseSalery(),
                            ],
                          )
                        ],
                      ),
                    if (!Responsive.isDesktop(context)) sectrResponse(jobs),
                    SizedBox(
                      height: 7,
                    ),
                    if (!Responsive.isDesktop(context))
                      Text(getCapitalizeString(nullCheckValue(jobs!.jobTitle)),
                          style: blackDarkR16.copyWith(
                              fontWeight: FontWeight.bold)),
                    if (!Responsive.isDesktop(context))
                      SizedBox(
                        height: Responsive.isMobile(context) ? 10 : 7,
                      ),
                    if (!Responsive.isDesktop(context)) wrapResponse(jobs!),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 16 : 13,
                    ),
                    if (!Responsive.isDesktop(context))
                      jobSaleryResponse(jobs!),
                    if (!Responsive.isDesktop(context)) baseSalery(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  _appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 110,
      iconTheme: IconThemeData(color: MyAppColor.blackdark),
      backgroundColor: MyAppColor.backgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/drawers.png',
                height: 18,
              ),
            ),
            const SizedBox(
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
              const SizedBox(
                width: 10,
              ),
              Image.asset(
                'assets/notificationiocn.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/male.png',
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
            _menu(),
            // SizedBox(
            //   height: 10,
            // ),
            _back(),
          ],
        ),
        preferredSize: const Size.fromHeight(40),
      ),
    );
  }

  Container _menu() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    const SizedBox(
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
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const Text(
                      "Home-service provider",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
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
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const Text(
                      "Home-service seeker",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
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
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const Text(
                      "Local Hunar Account",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
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

  _back() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: Sizeconfig.screenHeight! / 20,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            const SizedBox(
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
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 17,
                      color: Colors.black,
                    ),
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Back",
              style: TextStyle(
                color: MyAppColor.blackdark,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text("HOME (JOB-SEEKER) / MY TRANSACTIONS",
                style: GoogleFonts.darkerGrotesque(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // Widget _myRadioButton({String title, int value, Function? onChanged}) {
  //   return RadioListTile(
  //     value: value,
  //     groupValue: _groupValue,
  //     onChanged: onChanged,
  //     title: Text(title),
  //   );
  // }
  Container _bender(TextTheme styles) {
    return Container(
      height: Sizeconfig.screenHeight! / 24,

      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: Sizeconfig.screenWidth! / 3.5,
      decoration: BoxDecoration(
        color: MyAppColor.applecolor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: MyAppColor.white,
              ),
              child: Image.asset(
                'assets/adobe-image.png',
                height: 15,
              )),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Adobe ',
            style: styles.headline1!
                .copyWith(fontSize: 13, color: MyAppColor.white),
          ),
        ],
      ),
    );
  }
}
