// ignore_for_file: unused_element, prefer_const_constructors

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/skill_tag_widget.dart';
import 'package:hindustan_job/candidate/model/certificate_experience_model.dart';
import 'package:hindustan_job/candidate/model/education_experience_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EducationSkills extends StatefulWidget {
  const EducationSkills({Key? key}) : super(key: key);

  @override
  State<EducationSkills> createState() => _EducationSkillsState();
}

class _EducationSkillsState extends State<EducationSkills> {
  final ReceivePort _port = ReceivePort();
  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'EDUCATION & QUALIFICATION',
              style: companyNameM14(),
              textAlign: TextAlign.center,
            ),
          ),
          Consumer(builder: (context, ref, child) {
            List<EducationExperience> educationExperiences =
                ref.watch(editProfileData).educationExperiences;

            return !Responsive.isDesktop(context)
                ? Column(
                    children: List.generate(
                        educationExperiences.length,
                        (index) => educationQualificationCard(
                            styles, educationExperiences[index])),
                  )
                : Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: List.generate(
                        educationExperiences.length,
                        (index) => educationQualificationCard(
                            styles, educationExperiences[index])),
                  );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '.  .  .  .  .  .  .  .  .  .  .  .',
              style: styles.headline1!
                  .copyWith(fontSize: 25, color: MyAppColor.greyfulldark),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'CERTIFICATION',
              style: companyNameM14(),
              textAlign: TextAlign.center,
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              List<CertificateExperience> certificateExperiences =
                  ref.watch(editProfileData).certificateExperiences;
              return !Responsive.isDesktop(context)
                  ? Column(
                      children: List.generate(
                        certificateExperiences.length,
                        (index) => certificationCard(styles,
                            data: certificateExperiences[index]),
                      ),
                    )
                  : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: List.generate(
                        certificateExperiences.length,
                        (index) => certificationCard(styles,
                            data: certificateExperiences[index]),
                      ),
                    );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '.  .  .  .  .  .  .  .  .  .  .  .',
              style: styles.headline1!
                  .copyWith(fontSize: 25, color: MyAppColor.greyfulldark),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'SKILLS TEST',
              style: companyNameM14(),
              textAlign: TextAlign.center,
            ),
          ),
          _skill(context, styles),
          SizedBox(
            height: 55,
          ),
          Footer(),
        ],
      ),
    );
  }

  educationQualificationCard(styles, EducationExperience? data) {
    return Column(
      children: [
        _education(styles, data: data),
        SizedBox(
          height: 1,
        ),
        _portal_science(styles, instituteName: data!.instituteName),
        _passingyear(styles, passingYear: data.yearOfPassing),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  certificationCard(styles, {CertificateExperience? data}) {
    return Column(
      children: [
        _cirtification(styles, data: data),
        _achievement(styles, year: data!.yearOfAchievingCertificate),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Padding _skill(BuildContext context, TextTheme styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
          width: !Responsive.isDesktop(context)
              ? double.infinity
              : Sizeconfig.screenWidth! / 2.5,
          color: MyAppColor.greynormal,
          child: Wrap(
            children: [
              SizedBox(
                height: 12,
              ),
              if (userData!.userSkills != null)
                Wrap(
                    children: List.generate(
                  userData!.userSkills!.length,
                  (index) => Padding(
                    padding:
                        const EdgeInsets.only(left: 22, top: 15, bottom: 10),
                    child: SkillTag(
                        text: userData!
                            .userSkills![index].skillSubCategory!.name!),
                  ),
                ))
            ],
          )),
    );
  }

  Widget _bender(TextTheme styles) {
    return Container(
      height: Sizeconfig.screenHeight! / 24,
      width:
          !Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 3.5 : null,
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

  Widget _skillsAdobe(TextTheme styles, {text}) {
    return Container(
      height: Sizeconfig.screenHeight! / 24,
      padding: EdgeInsets.only(right: 15),
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
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '$text',
            style: whiteSb12(),
          ),
        ],
      ),
    );
  }

  Widget _achievement(TextTheme styles, {year}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: Sizeconfig.screenHeight! / 14,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.grayplane,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Year of Achievement:',
              style: styles.headline1,
            ),
            Text(
              '$year',
              style: styles.headline1,
            )
          ],
        ),
      ),
    );
  }

  Widget _cirtification(TextTheme styles, {CertificateExperience? data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.greynormal,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Icon(
                Icons.card_travel,
                size: 12,
              ),
            ),
            Column(
              children: [
                Text(
                  getCapitalizeString(data!.title),
                  style: blackDarkM14(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Divider(),
            ),
            Column(
              children: [
                Text(
                  getCapitalizeString(data.instituteName),
                  style: blackDarkM14(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Download Certificate",
                        style: blackDarkM14(),
                      ),
                      InkWell(
                        onTap: () async {
                          await downloadFile(currentUrl(data.file));
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
          ],
        ),
      ),
    );
  }

  Widget _passingyear(TextTheme styles, {passingYear}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.grayplane,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Year of Passing',
              style: blackDarkR12(),
            ),
            Text(
              '$passingYear',
              style: blackdarkM10,
            )
          ],
        ),
      ),
    );
  }

  Widget _portal_science(TextTheme styles, {instituteName}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            Image.asset(
              'assets/university.png',
              height: 15,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              getCapitalizeString(instituteName),
              style: blackdarkM12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _education(TextTheme styles, {EducationExperience? data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 5,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/cap.png',
              height: 15,
            ),
            if (data!.courses == null || data.specializations == null)
              Text(
                "${data.educationDatum!.name}",
                style: blackDarkM14(),
              ),
            if (data.courses != null)
              Text(
                "${data.courses!.name}",
                style: companyNameM11(),
              ),
            if (data.specializations != null)
              Text(
                'Specialization: ${data.specializations!.name}',
                style: blackdarkM12,
              ),
          ],
        ),
      ),
    );
  }
}
