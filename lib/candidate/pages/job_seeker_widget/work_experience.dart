// ignore_for_file: avoid_print, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/current_job_model.dart';
import 'package:hindustan_job/candidate/model/work_experience_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/edit_profile.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import 'card_workex.dart';
import 'card_workexperience.dart';

class WorkExperince extends StatefulWidget {
  const WorkExperince({Key? key}) : super(key: key);

  @override
  _WorkExperinceState createState() => _WorkExperinceState();
}

class _WorkExperinceState extends State<WorkExperince> {
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;

    Sizeconfig().init(context);
    return Consumer(
      builder: (context, ref, child) {
        List<WorkExperience> workExperiences =
            ref.watch(editProfileData).workExperiences;
        var currentJobModel = ref.watch(editProfileData).currentJobModel;
        return !Responsive.isDesktop(context)
            ? ListView(
                children: [
                  if (currentJobModel != null &&
                      currentJobModel.companyName != null)
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'ACTIVE JOB',
                          style: styles.headline1!.copyWith(
                              fontSize: 18,
                              color: MyAppColor.blackdark,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: CardWorkexperience(
                          data: currentJobModel.jobTitle,
                          companyName: currentJobModel.companyName,
                        ),
                      ),
                      _description(styles, des: currentJobModel.jobDescription),
                      SizedBox(
                        height: 2,
                      ),
                      _workExperienceCard(styles,
                          salary: currentJobModel.currentSalary),
                      SizedBox(
                        height: 2,
                      ),
                      _joining(styles,
                          date: dateFormat(currentJobModel.dateOfJoining)),
                      SizedBox(
                        height: 2,
                      ),
                      if (currentJobModel.noticePeriod == 'Y')
                        _period(styles,
                            noticePeriod: currentJobModel.noticePeriodDays,
                            type: currentJobModel.noticePeriod),
                    ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      '.  .  .  .  .  .  .  .  .  .  .  .',
                      style: styles.headline1!.copyWith(
                          fontSize: 25, color: MyAppColor.greyfulldark),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  workExperience(styles),
                  Column(
                    children: List.generate(
                        workExperiences.length,
                        (index) =>
                            workExperinceCard(workExperiences[index], styles)),
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
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 00),
                                child: activeJob(styles),
                              ),
                              if (currentJobModel != null)
                                Column(
                                  children: [
                                    if (Responsive.isDesktop(context))
                                      SizedBox(
                                        height: 15,
                                      ),
                                    CardWorkEx(
                                      description: currentJobModel.companyName,
                                      text: currentJobModel.jobTitle,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    _description(styles,
                                        des: currentJobModel.jobDescription),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    _workExperienceCard(styles,
                                        salary: currentJobModel.currentSalary),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    _joining(
                                      styles,
                                      date: dateFormat(
                                          currentJobModel.dateOfJoining),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    if (currentJobModel.noticePeriod == 'Y')
                                      _period(styles,
                                          noticePeriod:
                                              currentJobModel.noticePeriodDays,
                                          type: currentJobModel.noticePeriod),
                                  ],
                                ),
                              SizedBox(
                                height: 200,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WORK EXPERIENCE',
                                style: !Responsive.isDesktop(context)
                                    ? companyNameM14()
                                    : companyNameM11(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runAlignment: WrapAlignment.start,
                                alignment: WrapAlignment.start,
                                // runSpacing: 15,
                                // spacing: 15,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        workExperiences.length,
                                        (index) => workExperinceCard(
                                            workExperiences[index], styles)),
                                  ),
                                  // Column(
                                  //   children: [
                                  //     CardWorkEx(
                                  //       text: currentJobModel.jobTitle,
                                  //     ),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     _description(styles,
                                  //         des: currentJobModel.jobDescription),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     _work(styles),
                                  //   ],
                                  // ),
                                  // Column(
                                  //   children: [
                                  //     CardWorkEx(
                                  //       text: currentJobModel.jobTitle,
                                  //     ),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     _description(styles,
                                  //         des: currentJobModel.jobDescription),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     _work(styles),
                                  //   ],
                                  // ),
                                  // Column(
                                  //   children: [
                                  //     CardWorkEx(
                                  //       text: currentJobModel.jobTitle,
                                  //     ),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     _description(styles,
                                  //         des: currentJobModel.jobDescription),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     _work(styles),
                                  //   ],
                                  // ),
                                  // Column(
                                  //   children: [
                                  //     CardWorkEx(
                                  //       text: currentJobModel.jobTitle,
                                  //     ),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     _description(styles,
                                  //         des: currentJobModel.jobDescription),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     _work(styles),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Footer(),
                  ],
                ),
              );
      },
    );
  }

  Widget activeJob(TextTheme styles) {
    return Text(
      'ACTIVE JOB',
      style: companyNameM11(),
      textAlign: TextAlign.start,
    );
  }

  Widget workExperience(TextTheme styles) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: !Responsive.isDesktop(context) ? 15 : 00),
      child: Text(
        'WORK EXPERIENCE',
        style: styles.headline1!.copyWith(
            fontSize: 18,
            color: MyAppColor.blackdark,
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    );
  }

  workExperinceCard(WorkExperience data, styles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: !Responsive.isDesktop(context) ? 40 : 00),
          child: CardWorkexperience(
              companyName: data.companyName, data: data.jobTitle),
        ),
        _description(styles, des: data.jobDescription),
        SizedBox(
          height: 2,
        ),
        _joining(styles, date: dateFormat(data.dateOfJoining)),
        SizedBox(
          height: 2,
        ),
        _resigning(styles, date: dateFormat(data.dateOfResigning)),
        SizedBox(
          height: 2,
        ),
        // _period(styles),
      ],
    );
  }

  Widget _description(TextTheme styles, {des}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: !Responsive.isDesktop(context) ? 8 : 0),
      child: Container(
        padding: EdgeInsets.all(!Responsive.isDesktop(context) ? 20 : 10),
        color: MyAppColor.greynormal,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Description',
              style: !Responsive.isDesktop(context)
                  ? companyNameM14()
                  : companyNameM11(),
            ),
            SizedBox(
              height: 15,
            ),
            // if (!Responsive.isDesktop(context))
            Text(
              "${des}",
              textAlign: TextAlign.justify,
              style: !Responsive.isDesktop(context)
                  ? blackDarkR16
                  : blackDarkR12(),
              //  style: styles.
              //  copyWith(
              // //     color: MyAppColor.greyfulldark, fontSize: 14),
            ),
            // if (Responsive.isDesktop(context))
            // Text(
            //   "The quick, brown fox jumps over a lazy dog. "
            //   "DJs flock by when MTV ax quiz prog. Junk MTV quiz graced"
            //   " by fox whelps. Bawds jog, flick quartz, vex nymphs. "
            //   "Waltz, bad nymph",
            //   textAlign: TextAlign.justify,
            //   style: styles.headline1!
            //       .copyWith(color: MyAppColor.greyfulldark, fontSize: 12),
            //   //  style: styles.
            //   //  copyWith(
            //   // //     color: MyAppColor.greyfulldark, fontSize: 14),
            // ),
          ],
        ),
      ),
    );
  }

  _period(TextTheme styles, {noticePeriod, type}) {
    return type != 'N'
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: Sizeconfig.screenHeight! / 17,
              width: !Responsive.isDesktop(context)
                  ? double.infinity
                  : Sizeconfig.screenWidth! / 5,
              color: MyAppColor.grayplane,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notice Period:',
                    style: !Responsive.isDesktop(context)
                        ? blackDarkR12()
                        : blackDarkR10(),
                  ),
                  Text(
                    '${noticePeriod} Days',
                    style: !Responsive.isDesktop(context)
                        ? blackdarkM12
                        : blackdarkM10,
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Padding _joining(TextTheme styles, {date}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: Sizeconfig.screenHeight! / 17,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.grayplane,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date of Joining:',
              style: !Responsive.isDesktop(context)
                  ? blackDarkR12()
                  : blackDarkR10(),
            ),
            Text(
              '$date',
              style:
                  !Responsive.isDesktop(context) ? blackdarkM12 : blackdarkM10,
            )
          ],
        ),
      ),
    );
  }

  Padding _resigning(TextTheme styles, {date}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        // height: Sizeconfig.screenHeight! / 17,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.grayplane,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date of Resigning:',
              style: !Responsive.isDesktop(context)
                  ? blackDarkR12()
                  : blackDarkR10(),
            ),
            Text(
              '$date',
              style:
                  !Responsive.isDesktop(context) ? blackdarkM12 : blackdarkM10,
            )
          ],
        ),
      ),
    );
  }

  Widget _work(TextTheme styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        // height: Sizeconfig.screenHeight! / 17,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.grayplane,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Work Duration:',
              style: !Responsive.isDesktop(context)
                  ? blackDarkR12()
                  : blackDarkR10(),
            ),
            Text(
              '26.04.2012 - 15.04.2014',
              style:
                  !Responsive.isDesktop(context) ? blackdarkM12 : blackdarkM10,
            )
          ],
        ),
      ),
    );
  }

  Widget _workExperienceCard(TextTheme styles, {salary}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: Sizeconfig.screenHeight! / 17,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.grayplane,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current Salery per Annum',
              style: !Responsive.isDesktop(context)
                  ? blackDarkR12()
                  : blackDarkR10(),
            ),
            Text(
              '₹ $salary',
              style:
                  !Responsive.isDesktop(context) ? blackdarkM12 : blackdarkM10,
            )
          ],
        ),
      ),
    );
  }
}
