// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, prefer_const_constructors_in_immutables, unused_import, unnecessary_const

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/language_model.dart';
import 'package:hindustan_job/candidate/model/user_language_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/edit_profile.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/login_page/change_password.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/company_edit_profile.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:vrouter/vrouter.dart';

import '../../../main.dart';

class PersonalDetails extends ConsumerStatefulWidget {
  PersonalDetails({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends ConsumerState<PersonalDetails> {
  bool isSwitch = true;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkRoleType(userData!.userRoleType)
          ? ref.read(editProfileData).calculateStaffProfilePercent()
          : ref.read(editProfileData).calculateProfilePercent();
    });
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
    if (!kIsWeb) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }
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
    final styles = Mytheme.lightTheme(context).textTheme.headline2;
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      int percentProfile = ref.watch(editProfileData).percentOfProfile;
      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 15),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Your Profile is completed : ',
                      style: blackdarkM12,
                      children: <TextSpan>[
                        TextSpan(
                            text: '${percentProfile}%',
                            style: orangeDarkSb12()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: Sizeconfig.screenHeight! / 5,
            child: currentUrl(userData!.image) != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      "${currentUrl(userData!.image)}",
                    ),
                  )
                : const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage(
                      'assets/profileIcon.png',
                    ),
                  ),
          ),
          if (!Responsive.isDesktop(context) ||
              checkRoleType(userData!.userRoleType))
            SizedBox(
              width: Responsive.isMobile(context)
                  ? double.infinity
                  : Sizeconfig.screenWidth! / 4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isDesktop(context)
                        ? Sizeconfig.screenWidth! / 4
                        : 15.0,
                    vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () async {
                          if (checkRoleType(userData!.userRoleType)) {
                            if (kIsWeb) {
                              context.vRouter.to("/home-company/edit-profile");
                            } else {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyEditProfile()));
                            }
                          } else {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()));
                          }
                          checkRoleType(userData!.userRoleType)
                              ? ref
                                  .read(editProfileData)
                                  .calculateStaffProfilePercent()
                              : ref
                                  .read(editProfileData)
                                  .calculateProfilePercent();
                          setState(() {});
                        },
                        child: Text('Edit Profile', style: orangeDarkSb12())),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                        onTap: () async {
                          widgetFullScreenPopDialog(
                              ChangePasswod(
                                email: userData!.email!,
                                flag: 'change',
                              ),
                              context,
                              width: Sizeconfig.screenWidth);
                        },
                        child:
                            Text('Change Password', style: orangeDarkSb12())),
                  ],
                ),
              ),
            ),
          if (Responsive.isDesktop(context))
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fullnameResponsive(styles),
                    const SizedBox(
                      width: 20,
                    ),
                    mobileNumberResponsive(styles),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _display(styles,
                        key: LabelString.gender,
                        value: userData!.gender ?? LabelString.gender,
                        margin: 20.0),
                    const SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _display(styles,
                          key: LabelString.dob,
                          value: dateFormat(userData!.dob) ?? LabelString.dob,
                          margin: 10.0),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    '.  .  .  .  .  .  .  .  .  .  .  .',
                    style: styles!
                        .copyWith(fontSize: 25, color: MyAppColor.greyfulldark),
                  ),
                ),
                userData!.userRoleType != RoleTypeConstant.company
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _display(styles,
                              key: LabelString.state,
                              value: checkUserLocationValue(userData!.state),
                              margin: 0.0),
                          const SizedBox(
                            width: 20,
                          ),
                          _display(styles,
                              key: LabelString.city,
                              value: checkUserLocationValue(userData!.city),
                              margin: 0.0),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _display(styles,
                              key: LabelString.state,
                              value: checkUserLocationValue(
                                  userData!.companyData!.state),
                              margin: 0.0),
                          const SizedBox(
                            width: 20,
                          ),
                          _display(styles,
                              key: LabelString.city,
                              value: checkUserLocationValue(
                                  userData!.companyData!.city),
                              margin: 0.0),
                        ],
                      ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _display(styles,
                        key: LabelString.pinCode,
                        value: userData!.pinCode,
                        margin: 0.0),
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 3.8,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _display(styles,
                        key: LabelString.address,
                        value: userData!.addressLine1,
                        margin: 20.0),
                    const SizedBox(
                      width: 20,
                    ),
                    _display(styles,
                        key: LabelString.flatNoBuild,
                        value: userData!.addressLine2,
                        margin: 20.0),
                  ],
                ),
                if (userData!.resume != null)
                  viewResume(styles,
                      key: "Uploaded Resume",
                      value: userData!.resume!.split('/').last,
                      margin: 20.0),
                Center(
                  child: Text(
                    '.  .  .  .  .  .  .  .  .  .  .  .',
                    style: styles.copyWith(
                        fontSize: 25, color: MyAppColor.greyfulldark),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer(builder: (context, ref, watch) {
                  List<Language> userDataLanguages =
                      ref.watch(editProfileData).userLanguages;
                  return Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: Sizeconfig.screenWidth! / 1.9,
                    child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: List.generate(
                          userDataLanguages.length,
                          (index) => _display(styles,
                              key: LabelString.languageKnown + "#${index + 1}",
                              value: userDataLanguages[index].name,
                              margin: 10.0),
                        )),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 3.8,
                    )
                  ],
                ),
                Center(
                  child: Text(
                    '.  .  .  .  .  .  .  .  .  .  .  .',
                    style: styles.copyWith(
                        fontSize: 25, color: MyAppColor.greyfulldark),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (!checkRoleType(userData!.userRoleType))
                  _notificationsjob(styles),
              ],
            ),
          if (!Responsive.isDesktop(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  fullnameResponsive(styles),
                  mobileNumberResponsive(styles),
                  _display(styles,
                      key: LabelString.gender,
                      value: checkUserValue(userData!.gender),
                      margin: 20.0),
                  _display(styles,
                      key: LabelString.dob,
                      value: dateFormat(checkUserValue(userData!.dob)),
                      margin: 10.0),
                  Center(
                    child: Text(
                      '.  .  .  .  .  .  .  .  .  .  .  .',
                      style: styles!.copyWith(
                          fontSize: 25, color: MyAppColor.greyfulldark),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  userData!.userRoleType == RoleTypeConstant.companyStaff
                      ? Column(
                          children: [
                            _display(styles,
                                key: LabelString.state,
                                value: checkUserLocationValue(
                                    userData!.companyData!.state),
                                margin: 20.0),
                            _display(styles,
                                key: LabelString.city,
                                value: checkUserLocationValue(
                                    userData!.companyData!.city),
                                margin: 20.0),
                            _display(styles,
                                key: LabelString.pinCode,
                                value: checkUserValue(
                                    userData!.companyData!.pinCode),
                                margin: 20.0),
                            _display(styles,
                                key: LabelString.address,
                                value: userData!.companyData!.addressLine1,
                                margin: 20.0),
                            _display(styles,
                                key: LabelString.flatNoBuild,
                                value: userData!.companyData!.addressLine2,
                                margin: 20.0),
                          ],
                        )
                      : Column(
                          children: [
                            _display(styles,
                                key: LabelString.state,
                                value: checkUserLocationValue(userData!.state),
                                margin: 20.0),
                            _display(styles,
                                key: LabelString.city,
                                value: checkUserLocationValue(userData!.city),
                                margin: 20.0),
                            _display(styles,
                                key: LabelString.pinCode,
                                value: checkUserValue(userData!.pinCode),
                                margin: 20.0),
                            _display(styles,
                                key: LabelString.address,
                                value: userData!.addressLine1,
                                margin: 20.0),
                            _display(styles,
                                key: LabelString.flatNoBuild,
                                value: userData!.addressLine2,
                                margin: 20.0),
                            if (userData!.resume != null)
                              viewResume(styles,
                                  key: "Uploaded Resume",
                                  value: userData!.resume!.split('/').last,
                                  margin: 20.0),
                          ],
                        ),
                  if (userData!.userRoleType == RoleTypeConstant.companyStaff)
                    _display(styles,
                        key: LabelString.myDesignation,
                        value: userData!.yourDesignation,
                        margin: 20.0),
                  Center(
                    child: Text(
                      '.  .  .  .  .  .  .  .  .  .  .  .',
                      style: styles.copyWith(
                          fontSize: 25, color: MyAppColor.greyfulldark),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!checkRoleType(userData!.userRoleType))
                    Column(children: [
                      Consumer(builder: (context, ref, watch) {
                        List<Language> userDataLanguages =
                            ref.watch(editProfileData).userLanguages;
                        return Column(
                            children: List.generate(
                          userDataLanguages.length,
                          (index) => _display(styles,
                              key: LabelString.languageKnown + "#${index + 1}",
                              value: userDataLanguages[index].name,
                              margin: 10.0),
                        ));
                      }),
                      Center(
                        child: Text(
                          '.  .  .  .  .  .  .  .  .  .  .  .',
                          style: styles.copyWith(
                              fontSize: 25, color: MyAppColor.greyfulldark),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (!checkRoleType(userData!.userRoleType))
                        _notificationsjob(styles),
                    ])
                ],
              ),
            ),
          if (!checkRoleType(userData!.userRoleType))
            const SizedBox(
              height: 60,
            ),
          Footer(),
        ],
      );
    });
  }

  Widget mobileNumberResponsive(TextStyle? styles) {
    return _display(styles,
        key: LabelString.mobileNumber,
        value: checkUserValue(userData!.mobile),
        margin: 20.0);
  }

  Widget fullnameResponsive(TextStyle? styles) {
    return _display(styles,
        key: LabelString.fullName, value: userData!.name, margin: 20.0);
  }

  _notificationsjob(TextStyle styles) {
    return Consumer(builder: (context, ref, child) {
      bool isuserDataAvailableForJob =
          ref.watch(editProfileData).isUserAvailableForJob;
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: !Responsive.isDesktop(context) ? 8 : 0),
        child: Container(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.only(left: 15)
              : const EdgeInsets.all(12),
          width: !Responsive.isDesktop(context)
              ? double.infinity
              : Sizeconfig.screenWidth! / 2,
          height: Responsive.isMobile(context)
              ? Sizeconfig.screenHeight! / 10
              : null,
          color: MyAppColor.greynormal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available for Job',
                style: !Responsive.isDesktop(context)
                    ? blackDarkM14()
                    : blackdarkM12,
              ),
              Switch(
                value: isuserDataAvailableForJob,
                onChanged: (value) {
                  ref
                      .read(editProfileData)
                      .addStatusAvailableForJob(value ? 'Y' : 'N');
                },
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _display(TextStyle? styles, {value, key, margin}) {
    return Container(
      margin: EdgeInsets.only(bottom: margin),
      padding: Responsive.isMobile(context)
          ? const EdgeInsets.only(left: 15)
          : const EdgeInsets.all(10),
      width: Responsive.isMobile(context)
          ? double.infinity
          : Sizeconfig.screenWidth! / 4,
      height:
          Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
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
            '${getCapitalizeString(value)}',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
          ),
        ],
      ),
    );
  }

  Widget viewResume(TextStyle? styles, {value, key, margin}) {
    return Container(
      margin: EdgeInsets.only(bottom: margin),
      padding: Responsive.isMobile(context)
          ? const EdgeInsets.only(left: 15)
          : const EdgeInsets.all(10),
      width: Responsive.isMobile(context)
          ? double.infinity
          : Sizeconfig.screenWidth! / 4,
      height:
          Responsive.isMobile(context) ? Sizeconfig.screenHeight! / 10 : null,
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$key',
                style: !Responsive.isDesktop(context)
                    ? chipColorM12()
                    : chipColorM9(),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${getCapitalizeString(value)}',
                style: !Responsive.isDesktop(context)
                    ? blackDarkM14()
                    : blackdarkM12,
              ),
            ],
          ),
          InkWell(
            onTap: () {
              downloadFile(currentUrl(userData!.resume));
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: MyAppColor.grayplane,
              ),
              child: Text(
                'Preview',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
