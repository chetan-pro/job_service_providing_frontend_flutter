// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/api_services/jobs_services.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:vrouter/vrouter.dart';

class JobPreviewPage extends StatefulWidget {
  JobsTwo? jobDetail;
  var jobPostData;
  JobPreviewPage({Key? key, required this.jobDetail, this.jobPostData})
      : super(key: key);

  @override
  State<JobPreviewPage> createState() => _JobPreviewPageState();
}

class _JobPreviewPageState extends State<JobPreviewPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _groupValue = -1;

  int _radioSelected = 1;

  late String _radioVal;

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    final styleses = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: CompanyAppBar(
        back: 'HOME (COMPANY ADMIN) / JOB POSTS / PREVIEW',
        drawerKey: _drawerKey,
        isWeb: Responsive.isDesktop(context),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SizedBox(
                  height: Sizeconfig.screenHeight! / 25,
                ),
                Text("JOB POST PREVIEW", style: blackDarkM14()),
                SizedBox(
                  height: Sizeconfig.screenHeight! / 25,
                ),
                !Responsive.isDesktop(context)
                    ? Column(
                        children: [
                          _privatesector(context, styles, widget.jobDetail),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 2),
                          //   child: Container(
                          //     // height: Sizeconfig.screenHeight! / 5,
                          //     width: Sizeconfig.screenWidth,
                          //     color: MyAppColor.greynormal,
                          //     child: Column(
                          //       children: [
                          //         selectedRadioResponse(),
                          //         seprateResume(),
                          //         jobButton(),
                          //         SizedBox(
                          //           height: Sizeconfig.screenHeight! / 40,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          locationResponse(styles),
                          companyDetailsResponse(styles),
                          descriptionResponse(styles),
                          skillRequiredResponse(styleses),
                          if (widget.jobDetail!.experienceRequired == 'Y')
                            _applyjob(styles, 'EXPERIENCED REQUIRED',
                                "${calculateExperienceForEdit(widget.jobDetail!.expFrom, widget.jobDetail!.expFromType)} ${widget.jobDetail!.expFromType} - ${calculateExperienceForEdit(widget.jobDetail!.expTo, widget.jobDetail!.expToType)} ${widget.jobDetail!.expToType}"),
                          if (widget.jobDetail!.educationRequired == 'Y')
                            _applyjob(
                                styles,
                                'EDUCATION REQUIRED',
                                widget.jobDetail!.educationDatum!.name
                                    .toString()),
                          _applyjob(
                              styles,
                              'EMPLOYMENT TYPE',
                              findValueConstant(
                                  list: ListDropdown.employmentType,
                                  keyValue: widget.jobDetail!.employmentType)),
                          _applyjob(styles, 'CONTRACT TYPE',
                              '${getCapitalizeString(widget.jobDetail!.contractType)}: ${widget.jobDetail!.contractDuration ?? ''} ${widget.jobDetail!.contractDuration != null ? 'Months' : ''}'),
                          _applyjob(
                              styles,
                              'WORK FROM HOME',
                              findValueConstant(
                                  list: ListDropdown.wfh,
                                  keyValue: widget.jobDetail!.workFromHome)),
                          _applyjob(
                              styles,
                              'WORK SCHEDULE',
                              findValueConstant(
                                  list: ListDropdown.jobSchedule,
                                  keyValue: widget.jobDetail!.jobSchedule)),
                          if (widget.jobDetail!.jobTimeFrom != null &&
                              widget.jobDetail!.jobTimeTo != null)
                            _applyjob(styles, 'TIMING',
                                "${widget.jobDetail!.jobTimeFrom!}  to  ${widget.jobDetail!.jobTimeTo!}"),
                          if (widget.jobPostData != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 1.0, color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Text(
                                      "BACK TO CREATE",
                                      style: TextStyle(
                                          color: MyAppColor.greyfulldark,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Text(
                                      widget.jobDetail!.id != null
                                          ? 'SAVE EDIT JOB'
                                          : 'POST THE JOB',
                                      style: Mytheme.lightTheme(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                              color: MyAppColor.backgroundColor,
                                              fontSize: 14),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (widget.jobDetail!.id != null) {
                                      widget.jobPostData['id'] =
                                          widget.jobDetail!.id;
                                      await editAJob(
                                          context, widget.jobPostData,
                                          isFromPreview: true);
                                    } else {
                                      await addAJob(context, context.vRouter,widget.jobPostData,
                                          isFromPreview: true);
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            MyAppColor.orangelight),
                                  ),
                                ),
                              ],
                            )
                        ],
                      )
                    : SizedBox(
                        width: Sizeconfig.screenWidth! / 1.5,
                        child: Column(
                          children: [
                            _privatesector(context, styles, widget.jobDetail),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Container(
                                // height: Sizeconfig.screenHeight! / 5,
                                // width: Sizeconfig.screenWidth,
                                color: MyAppColor.greynormal,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: selectedRadioResponse(),
                                    ),
                                    Expanded(
                                      child: seprateResume(),
                                    ),
                                    Expanded(
                                      child: jobButton(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: locationResponse(styles),
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: companyDetailsResponse(styles),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            descriptionResponse(styles),
                            SizedBox(
                              height: 2,
                            ),
                            skillRequiredResponse(styleses),
                            Row(
                              children: [
                                Expanded(
                                  child: _applyjob(
                                      styles,
                                      'EMPLOYMENT TYPE',
                                      findValueConstant(
                                          list: ListDropdown.employmentType,
                                          keyValue: widget
                                              .jobDetail!.employmentType)),
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: _applyjob(styles, 'CONTRACT TYPE',
                                      '${getCapitalizeString(widget.jobDetail!.contractType)}: ${widget.jobDetail!.contractDuration ?? ''} ${widget.jobDetail!.contractDuration != null ? 'Months' : ''}'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _applyjob(
                                      styles,
                                      'WORK FROM HOME',
                                      findValueConstant(
                                          list: ListDropdown.wfh,
                                          keyValue:
                                              widget.jobDetail!.workFromHome)),
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: _applyjob(
                                      styles,
                                      'WORK SCHEDULE',
                                      findValueConstant(
                                          list: ListDropdown.jobSchedule,
                                          keyValue:
                                              widget.jobDetail!.jobSchedule)),
                                ),
                              ],
                            ),
                            if (widget.jobPostData != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1.0, color: Colors.black),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Text(
                                          "BACK TO CREATE",
                                          style: TextStyle(
                                              color: MyAppColor.greyfulldark,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Text(
                                          widget.jobDetail!.id != null
                                              ? 'SAVE EDIT JOB'
                                              : 'POST THE JOB',
                                          style: Mytheme.lightTheme(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  color: MyAppColor
                                                      .backgroundColor,
                                                  fontSize: 14),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (widget.jobDetail!.id != null) {
                                          widget.jobPostData['id'] =
                                              widget.jobDetail!.id;
                                          await editAJob(
                                              context, widget.jobPostData,
                                              isFromPreview: true);
                                        } else {
                                          await addAJob(
                                              context, context.vRouter,widget.jobPostData,
                                              isFromPreview: true);
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                MyAppColor.orangelight),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
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
      ),
    );
  }

  Padding skillRequiredResponse(TextTheme styleses) {
    var skills = widget.jobDetail!.subSkills ?? widget.jobDetail!.jobPostSkills;

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        color: MyAppColor.greynormal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: skillsetsRequired(),
            ),
            SizedBox(
              height: 12,
            ),
            Wrap(
              runSpacing: 10.0,
              spacing: 10,
              children: List.generate(
                skills.length,
                (index) => widget.jobDetail!.jobPostSkills == null
                    ? _skillsAdobe(styleses, skills[index].name)
                    : _skillsAdobe(
                        styleses, skills[index].skillSubCategories.name),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container descriptionResponse(TextStyle styles) {
    return Container(
      padding: EdgeInsets.all(15),
      height: Sizeconfig.screenHeight! / 3,
      // width: Sizeconfig.screenWidth,
      color: MyAppColor.greynormal,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            jobDescription(styles),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  description(styles, widget.jobDetail!.jobDescription),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container companyDetailsResponse(TextStyle styles) {
    return Container(
      padding: EdgeInsets.all(15),
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
              lakshyaCorporations(styles, widget.jobDetail!.name),
            ],
          ),
          arrowButton()

          // SizedBox(
          //   height: Sizeconfig.screenHeight! / 40,
          // ),
        ],
      ),
    );
  }

  Container locationResponse(TextStyle styles) {
    return Container(
      padding: EdgeInsets.all(15),
      // height: Sizeconfig.screenHeight! / 5,
      // width: Sizeconfig.screenWidth,
      color: MyAppColor.greynormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              iconLocation(),
              jobLocation(styles, 'JOB LOCATION'),
            ],
          ),
          jobLocation(styles,
              '${widget.jobDetail!.cityName ?? widget.jobDetail!.city!.name}, ${widget.jobDetail!.stateName ?? widget.jobDetail!.state!.name}'),
          // SizedBox(
          //   height: Sizeconfig.screenHeight! / 40,
          // ),
        ],
      ),
    );
  }

  ListTile seprateResume() {
    return ListTile(title: separateResume(), leading: radiobutton());
  }

  ListTile selectedRadioResponse() {
    return ListTile(
      title: applyWith(),
      leading: Radio(
        activeColor: MyAppColor.orangelight,
        value: 1,
        groupValue: _radioSelected,
        onChanged: (value) {},
      ),
    );
  }

  Widget bhopalMadhyaPradesh(TextStyle styles) =>
      Text('Bhopal, Madhya Pradesh, India', style: styles);

  Widget jobLocation(TextStyle styles, text) {
    return Text(
      '$text',
      style: styles,
    );
  }

  Icon iconLocation() {
    return Icon(
      Icons.location_on,
      size: 15,
    );
  }

  OutlinedButton viewAlllButtons(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => PrivateSectorViewAll()));
      },
      child: Text(
        Mystring.viewAll,
        style: Mytheme.lightTheme(context).textTheme.headline1,
      ),
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
    );
  }

  Image imageInterest() {
    return Image.asset(
      'assets/interestJob.png',
      height: 18,
    );
  }

  Text skillsetsRequired() => Text('SKILLSETS REQUIRED');

  description(TextStyle styles, description) {
    return Html(
      data: description,
    );
  }

  Text jobDescription(TextStyle styles) {
    return Text(
      'JOB DESCRIPTIONS',
      style: styles.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  OutlinedButton arrowButton() {
    return OutlinedButton(
        style:
            OutlinedButton.styleFrom(side: BorderSide(color: MyAppColor.white)),
        onPressed: () {},
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
    return Text(
      'COMPANY',
      style: styles.copyWith(
          color: MyAppColor.backgroundColor,
          fontSize: 13,
          fontWeight: FontWeight.w400),
    );
  }

  Radio<int> radiobutton() {
    return Radio(
        value: 2,
        activeColor: MyAppColor.orangelight,
        groupValue: _radioSelected,
        onChanged: (value) {});
  }

  Widget jobButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyAppColor.orangelight,
        ),
        onPressed: () {},
        child: Text('APPLY FOR THIS JOB',
            style: TextStyle(color: MyAppColor.backgroundColor)));
  }

  Text separateResume() => Text('Apply with a separate Resume');

  Text applyWith() {
    return Text('Apply with your Profile Resume (Recommended)');
  }

  Padding _applyjob(TextStyle styles, String text, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: EdgeInsets.all(15),
        // height: Sizeconfig.screenHeight!,
        width: Sizeconfig.screenWidth,
        color: MyAppColor.greynormal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: styles.copyWith(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            Text(
              number,
              style: styles,
            ),

            // SizedBox(
            //   height: Sizeconfig.screenHeight! / 40,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _privatesector(BuildContext context, TextStyle styles, JobsTwo? jobs) {
    return Container(
        // margin: EdgeInsets.only(
        //   left: Responsive.isDesktop(context) ? 12 : 00,
        // ),
        // width: Responsive.isDesktop(context)
        //     ? MediaQuery.of(context).size.width / 1.5
        //     : 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: MyAppColor.greynormal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  color: MyAppColor.gray,
                  child: Image.asset(
                    'assets/heart.png',
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
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

  // Widget _privatesector(BuildContext context, TextStyle styles, JobsTwo? jobs) {
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
          '${getCapitalizeString(jobs!.jobTypeName)}  SECTOR JOB',
          style: appleColorSemiBold12,
        ),
      ],
    );
  }

  Wrap wrapResponse(JobsTwo jobs) {
    return Wrap(runSpacing: 10, spacing: 10, children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: MyAppColor.greylight,
        child: Center(
          child: Text(
            "# Design",
            style: backgroundColorM10(),
          ),
        ),
      ),

      // HashTag(text: "${jobs.industry!.name}"),
      // HashTag(text: "${jobs.sector!.name}"),
      // HashTag(text: jobs.jobRoleType!.name!),
    ]);
  }

  Text baseSalery() {
    return Text(
      'Base Salary',
      style: blackDark12,
    );
  }

  Text jobSaleryResponse(JobsTwo jobs) {
    return Text(
      '₹ ${jobs.salary ?? "${doubleToIntValue(jobs.salaryFrom)} - ${doubleToIntValue(jobs.salaryTo)}"} ${jobs.paidType == 'PH' ? 'per hour' : 'per annum'}',
      style: blackDarkR16.copyWith(fontWeight: FontWeight.bold),
    );
  }

  _appbar(context) {
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
              Image.asset(
                'assets/notificationiocn.png',
                width: 20,
                height: 20,
              ),
              SizedBox(
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
            SizedBox(
              height: 10,
            ),
            _back(context),
          ],
        ),
        preferredSize: Size.fromHeight(Sizeconfig.screenHeight! / 10),
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
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service provider",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service seeker",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Local Hunar Account",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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

  _back(context) {
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
            Text("HOME (COMPANY ADMIN) / JOB POSTS / PREVIEW",
                maxLines: 2, style: GoogleFonts.darkerGrotesque(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // Widget _myRadioButton({String title, int value, Function? onChanged}) {
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
          SizedBox(
            width: 4,
          ),
          Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: MyAppColor.white,
              ),
              child: Image.asset(
                'assets/adobe-image.png',
                height: 15,
              )),
          SizedBox(
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

  Container _skillsAdobe(TextTheme styles, name) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 15, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff755F55),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 4,
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: MyAppColor.white,
            ),
            child: Image.asset(
              'assets/adobe-image.png',
              height: 15,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '$name',
            style: styles.headline1!
                .copyWith(fontSize: 13, color: MyAppColor.white),
          ),
        ],
      ),
    );
  }
}
