import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/clusterManager/edit_cluster_manager.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:hindustan_job/widget/text/non_editable_text.dart';
import 'package:vrouter/vrouter.dart';

import '../candidate/dropdown/dropdown_list.dart';
import '../candidate/dropdown/dropdown_string.dart';
import '../candidate/icons/icon.dart';
import '../candidate/model/city_model.dart';
import '../candidate/model/location_pincode_model.dart';
import '../candidate/model/manager_business_details_model.dart';
import '../candidate/model/manager_personal_details_model.dart';
import '../candidate/model/state_model.dart';
import '../candidate/pages/login_page/change_password.dart';
import '../candidate/theme_modeule/new_text_style.dart';
import '../candidate/theme_modeule/text_style.dart';
import '../config/size_config.dart';
import '../constants/colors.dart';
import '../constants/label_string.dart';
import '../services/api_services/panel_services.dart';
import '../services/auth/auth.dart';
import '../services/services_constant/response_model.dart';
import '../utility/function_utility.dart';
import '../widget/body/transaparent_body.dart';
import '../widget/text/title_edit_head.dart';

class ProfileClusterManager extends ConsumerStatefulWidget {
  const ProfileClusterManager({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileClusterManager> createState() =>
      _ProfileClusterManagerState();
}

class _ProfileClusterManagerState extends ConsumerState<ProfileClusterManager>
    with SingleTickerProviderStateMixin {
  TabController? _control;
  List<City> city = [];
  City? selectedCity;
  File? croppedFile;
  PlatformFile? logo;
  String? showSelectedDate;
  String? selectedDate =
      userData!.dob != null ? dateFormat(userData!.dob) : null;
  List<PostOffice> postOffices = [];
  List<States> state = [];
  States? selectedState;
  String? selectedGender =
      userData!.gender != null ? getCapitalizeString(userData!.gender) : null;
  TextEditingController frontResidentalProofController =
      TextEditingController();
  TextEditingController backResidentalProofController = TextEditingController();
  TextEditingController frontPanCardController = TextEditingController();
  TextEditingController backPanCardController = TextEditingController();
  TextEditingController frontAadharCardController = TextEditingController();
  TextEditingController backAadharCardController = TextEditingController();
  File? frontResidentalProof;
  File? backResidentalProof;
  File? backPanCard;
  File? frontPanCard;
  File? backAadharCard;
  File? frontAadharCard;

  @override
  void initState() {
    super.initState();
    _control = TabController(vsync: this, length: 4);
    getResidentDetails();
    getBusinessDetails();
  }

  setLocationOnTheBasisOfPinCode(pincode) async {
    postOffices = await fetchLocationOnBasisOfPinCode(context, pincode);
    if (postOffices.isNotEmpty) {
      PostOffice object = postOffices.first;
      List<States> pinState =
          await fetchStates(context, filterByName: object.state);
      selectedState = pinState.first;
      await fetchCity(selectedState!.id, pinLocation: object.district);
      List<City> pinCity = await fetchCities(context,
          stateId: selectedState!.id, filterByName: object.district);
      selectedCity = pinCity.first;
    }
    setState(() {});
  }

  fetchState() async {
    state = await fetchStates(context);
    if (userData != null) {
      selectedState = userData!.state;
      await fetchCity(userData!.stateId);
    }
    setState(() {});
  }

  fetchCity(id, {pinLocation}) async {
    selectedCity = null;
    city = [];
    setState(() {});
    // return;
    city = await fetchCities(
      context,
      stateId: id.toString(),
    );
    if (userData != null && pinLocation == null) {
      selectedCity = userData!.city;
    }
    setState(() {});
  }

  ManagerPersonalDetails? managerPersonalDetails;
  getResidentDetails() async {
    ApiResponse response = await getMiscellaneousUserPersonalDetails();
    if (response.status == 200 && response.body!.data != null) {
      managerPersonalDetails =
          ManagerPersonalDetails.fromJson(response.body!.data);
      setState(() {});
    }
  }

  ManagerBusinessDetailsModel? managerBusinessDetails;

  getBusinessDetails() async {
    ApiResponse response = await getMiscellaneousUserBussinessDetails();
    if (response.status == 200 && response.body!.data != null) {
      managerBusinessDetails =
          ManagerBusinessDetailsModel.fromJson(response.body!.data);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final styless = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: MyAppColor.backgroundColor,
            body: TabBarSliverAppbar(
              headColumn: SizedBox(),
              toolBarHeight: 0,
              length: 7,
              tabs: _tab(styless),
              tabsWidgets: [
                basicDetails(),
                personalDetails(),
                currentBusinessOccupation(),
                customersDetails(),
              ],
              control: _control!,
            )));
  }

  TabBar _tab(TextTheme styles) {
    return TabBar(
      isScrollable: true,
      indicatorColor: MyAppColor.orangelight,
      indicatorWeight: 1.5,
      controller: _control,
      labelColor: MyAppColor.blacklight,
      unselectedLabelColor: Colors.black,
      tabs: [
        if (!Responsive.isDesktop(context)) tabText('Demographic\nDetails'),
        if (!Responsive.isDesktop(context)) tabText('Residential\nDetails'),
        if (!Responsive.isDesktop(context))
          tabText('Current Business\nAchievement'),
        if (!Responsive.isDesktop(context)) tabText('Customers\nDetails'),
        if (Responsive.isDesktop(context)) tabText('Demographic Details'),
        if (Responsive.isDesktop(context)) tabText('Residential Details'),
        if (Responsive.isDesktop(context))
          tabText('Current Business Achievement'),
        if (Responsive.isDesktop(context)) tabText('Customers Details'),
      ],
    );
  }

  tabText(label) {
    return Text(
      label,
      style: blackDark13,
      textAlign: TextAlign.center,
    );
  }

  basicDetails() {
    return TransparentScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context) ? 265 : 0.0),
        child: ListView(
          children: [
            Column(
              children: [
                TitleEditHead(title: 'PERSONAL DETAILS'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 80),
                    clipBehavior: Clip.hardEdge,
                    height: !Responsive.isDesktop(context)
                        ? Sizeconfig.screenHeight! / 8
                        : Sizeconfig.screenHeight! / 7.5,
                    width: !Responsive.isDesktop(context)
                        ? Sizeconfig.screenWidth! / 4
                        : Sizeconfig.screenWidth! / 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: MyAppColor.greylight),

                    child: croppedFile == null
                        ? currentUrl(userData!.image) != null
                            ? Image(
                                image: NetworkImage(
                                    "${currentUrl(userData!.image)}"),
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.camera_alt_outlined,
                                color: MyAppColor.white,
                                size: 30,
                              )
                        : Image(
                            image: FileImage(croppedFile!),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (!kIsWeb) {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditClusterManager()));
                            getResidentDetails();
                            getBusinessDetails();
                          } else {
                            context.vRouter.to("/BC/edit-profile");
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/edit_small_icon.png'),
                            Text(LabelString.editProfile,
                                style: orangeDarkSemibold12),
                            const SizedBox(
                              width: 15.0,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (kIsWeb) {
                            widgetFullScreenPopDialog(
                                ChangePasswod(
                                  email: userData!.email!,
                                  flag: 'change',
                                ),
                                context,
                                width: Sizeconfig.screenWidth);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePasswod(
                                  email: userData!.email!,
                                  flag: 'change',
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset('assets/edit_small_icon.png'),
                              Text(LabelString.changePassword,
                                  style: orangeDarkSemibold12),
                              const SizedBox(
                                width: 15.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                SizedBox(height: 10),
                Column(
                  children: [
                    NonEditableTextField(
                      label: LabelString.fullName,
                      value: userData!.name ?? '',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                        label: LabelString.email, value: userData!.email ?? ''),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.mobileNumber,
                      value: userData?.mobile ?? '',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.pinCode,
                      value: userData!.pinCode ?? '',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.state,
                      value: checkUserLocationValue(userData!.state),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.city,
                      value: checkUserLocationValue(userData!.city),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.nameOfHouse,
                      value: userData!.addressLine1 != null
                          ? userData!.addressLine1!.split("+/+").first
                          : '',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.numberAndStreet,
                      value: userData!.addressLine1 != null
                          ? userData!.addressLine1!.split("+/+").last
                          : '',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.villageWard,
                      value: userData!.addressLine2 != null
                          ? userData!.addressLine2!.split("+/+").first
                          : '',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.tehseelMunicipality,
                      value: userData!.addressLine2 != null
                          ? userData!.addressLine2!.split("+/+").last
                          : '',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    NonEditableTextField(
                      label: LabelString.gender,
                      value: getCapitalizeString(userData!.gender ?? ''),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    NonEditableTextField(
                      label: LabelString.dob,
                      value: formatDate(userData!.dob),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  personalDetails() {
    return TransparentScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context) ? 265 : 0.0),
        child: ListView(
          children: [
            Column(
              children: [
                TitleEditHead(title: 'RESIDENT DETAILS'),
                managerPersonalDetails == null
                    ? Text("Add Details")
                    : Column(
                        children: [
                          NonEditableTextField(
                              label: LabelString.residentNo,
                              value: managerPersonalDetails!.residenceNo ?? ''),
                          SizedBox(
                            height: 8,
                          ),
                          NonEditableTextField(
                              label: LabelString.officeNo,
                              value: managerPersonalDetails!.officeNo ?? ''),
                          SizedBox(
                            height: 8,
                          ),
                          NonEditableTextField(
                              label: LabelString.whatsappNo,
                              value: managerPersonalDetails!.whatsappNo ?? ''),
                          SizedBox(
                            height: 8,
                          ),
                          NonEditableTextField(
                              label: managerPersonalDetails!.relativeRelation ??
                                  '',
                              value:
                                  managerPersonalDetails!.realtiveName ?? ''),
                          SizedBox(
                            height: 8,
                          ),
                          NonEditableTextField(
                              label: DropdownString.selectQualification,
                              value: managerPersonalDetails!
                                      .educationQualification ??
                                  ''),
                          SizedBox(
                            height: 8,
                          ),
                          // NonEditableTextField(
                          //     label: "Select Education File Name",
                          //     value: managerPersonalDetails!.educationFile ?? ''),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          containerImage(
                              label: "Education File Images",
                              image: managerPersonalDetails!.educationFile),
                          NonEditableTextField(
                              label: LabelString.panNo,
                              value: managerPersonalDetails!.panNo ?? ''),
                          SizedBox(
                            height: 8,
                          ),
                          // NonEditableTextField(
                          //     label: "Front Image of Pan Card",
                          //     value: managerPersonalDetails!.panImgFront ?? ''),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // NonEditableTextField(
                          //     label: "Back Image of Pan Card",
                          //     value: managerPersonalDetails!.panImgBack ?? ''),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          containerImage(
                              label: "Pan Card Images",
                              image: managerPersonalDetails!.panImgFront,
                              image2: managerPersonalDetails!.panImgBack),
                          SizedBox(
                            height: 8,
                          ),
                          NonEditableTextField(
                              label: LabelString.aadharNo,
                              value: managerPersonalDetails!.adharNo ?? ''),
                          SizedBox(
                            height: 8,
                          ),
                          // NonEditableTextField(
                          //     label: "Front Image of Aadhar Card",
                          //     value: managerPersonalDetails!.adharImgFront ?? ''),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // NonEditableTextField(
                          //     label: "Back Image of Aadhar Card",
                          //     value: managerPersonalDetails!.adharImgBack ?? ''),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          containerImage(
                              label: "Aadhar Card Images",
                              image: managerPersonalDetails!.adharImgFront,
                              image2: managerPersonalDetails!.adharImgBack),
                          SizedBox(
                            height: 8,
                          ),
                          NonEditableTextField(
                              label: DropdownString.residentalProof,
                              value: managerPersonalDetails!
                                      .residentialProofName ??
                                  ''),
                          containerImage(
                            label: "${DropdownString.residentalProof} Images",
                            image: managerPersonalDetails!.residentialProof,
                          ),
                        ],
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  currentBusinessOccupation() {
    return TransparentScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context) ? 265 : 0.0),
        child: ListView(
          children: [
            TitleEditHead(title: 'RESIDENT DETAILS'),
            managerPersonalDetails == null
                ? Text("Add Details")
                : Column(
                    children: [
                      TitleEditHead(title: 'CURRENT BUSINESS OCCUPATION'),
                      Column(
                        children: [
                          NonEditableTextField(
                              label: LabelString.businessName,
                              value:
                                  managerBusinessDetails?.bussinessName ?? ''),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: DropdownString.businessOccupation,
                              value: managerBusinessDetails?.currentBussiness ??
                                  ''),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: DropdownString.typeOfBusiness,
                              value:
                                  managerBusinessDetails?.bussinessType ?? ''),
                          SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 15),
                            child: Text(
                              "Business Address",
                              style: blackDark13,
                            ),
                          ),
                          NonEditableTextField(
                              label: LabelString.pinCode,
                              value: (managerBusinessDetails?.pincode ?? '')
                                  .toString()),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.state,
                              value: checkUserLocationValue(
                                  managerBusinessDetails?.state)),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.city,
                              value: checkUserLocationValue(
                                  managerBusinessDetails?.city)),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.nameOfHouse,
                              value: managerBusinessDetails?.houseName ?? ''),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.numberAndStreet,
                              value:
                                  managerBusinessDetails?.streetNoName ?? ''),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.villageWard,
                              value: managerBusinessDetails?.ward ?? ''),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.tehseelMunicipality,
                              value:
                                  managerBusinessDetails?.municipality ?? ''),
                          SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 15),
                            child: Text(
                              "Business Details",
                              style: blackDark13,
                            ),
                          ),
                          NonEditableTextField(
                              label: LabelString.dimensions,
                              value: managerBusinessDetails?.dimensions ?? ''),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.yearsOfBusiness,
                              value:
                                  (managerBusinessDetails?.bussinessYears ?? '')
                                      .toString()),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.infrastructureAvailable,
                              value: managerBusinessDetails
                                      ?.infrastructureAvailable ??
                                  ''),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.businessIncomePerAnnum,
                              value: (managerBusinessDetails?.currentIncomePa ??
                                      '')
                                  .toString()),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString
                                  .approxNumberOfCustomerServedEveryMonth,
                              value: (managerBusinessDetails?.customersServed ??
                                      '')
                                  .toString()),
                          SizedBox(height: 8),
                        ],
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  customersDetails() {
    return TransparentScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context) ? 265 : 0.0),
        child: ListView(
          children: [
            Column(
              children: [
                TitleEditHead(title: 'CUSTOMERS DETAILS'),
                managerBusinessDetails == null
                    ? Text("Add Details")
                    : Column(
                        children: [
                          NonEditableTextField(
                              label: LabelString.noOfTownsFromCustomersCame,
                              value: (managerBusinessDetails!.noTowns ?? '')
                                  .toString()),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.nameOfTownsFromCustomersCame,
                              value: (managerBusinessDetails!.nameTowns ?? '')
                                  .toString()),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.achievementOne,
                              value:
                                  (managerBusinessDetails!.achievement1 ?? '')
                                      .toString()),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.achievementTwo,
                              value:
                                  (managerBusinessDetails!.achievement2 ?? '')
                                      .toString()),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.achievementThree,
                              value:
                                  (managerBusinessDetails!.achievement3 ?? '')
                                      .toString()),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: DropdownString.businessPopularOne,
                              value: (managerBusinessDetails!.popular == 'Y'
                                  ? 'Yes'
                                  : 'No')),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: DropdownString.estimateServedBCAActivity,
                              value: (managerBusinessDetails!.customersServed ??
                                      '')
                                  .toString()),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 15),
                            child: Text(
                              "Reference Details",
                              style: blackDark13,
                            ),
                          ),
                          NonEditableTextField(
                              label: LabelString.referenceOneName,
                              value: (managerBusinessDetails!.ref1Name ?? '')),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.referenceOneAddress,
                              value:
                                  (managerBusinessDetails!.ref1Address ?? '')),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.referenceOneMobile,
                              value:
                                  (managerBusinessDetails!.ref1Mobile ?? '')),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.referenceOneOccupation,
                              value: (managerBusinessDetails!.ref1Occupation ??
                                  '')),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.referenceTwoName,
                              value: (managerBusinessDetails!.ref2Name ?? '')),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.referenceTwoAddress,
                              value:
                                  (managerBusinessDetails!.ref2Address ?? '')),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.referenceTwoMobile,
                              value:
                                  (managerBusinessDetails!.ref2Mobile ?? '')),
                          SizedBox(height: 8),
                          NonEditableTextField(
                              label: LabelString.referenceTwoOccupation,
                              value: (managerBusinessDetails!.ref2Occupation ??
                                  '')),
                          SizedBox(height: 8),
                        ],
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget gender(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: !Responsive.isDesktop(context) ? 46 : 45,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            focusColor: MyAppColor.white,
            child: DropdownButton<String>(
              value: selectedGender ?? DropdownString.gender,
              icon: IconFile.arrow,
              iconSize: 25,
              elevation: 16,
              style: blackDarkOpacityM12(),
              underline: Container(
                height: 3,
                width: MediaQuery.of(context).size.width,
                color: MyAppColor.white,
              ),
              onChanged: (String? newValue) {
                if (newValue == DropdownString.gender) return;
                setState(() {
                  selectedGender = newValue!;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: DropdownString.gender,
                  child: Text(
                    DropdownString.gender,
                    style: blackDarkO40M14,
                  ),
                ),
                ...ListDropdown.genders
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: blackDarkM12(),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  containerImage({label, image, image2, size}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 10),
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width - 730
          : MediaQuery.of(context).size.width - 20,
      color: MyAppColor.greynormal,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: appleColorM12,
            ),
            SizedBox(
              height: 5,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (image != null)
                SizedBox(
                  height: 210,
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        "Front",
                        style: appleColorM12,
                      ),
                      Image.network(
                        currentUrl(image),
                        height: 180,
                      ),
                    ],
                  ),
                ),
              SizedBox(width: 10),
              if (image2 != null)
                SizedBox(
                  height: 210,
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        "Back",
                        style: appleColorM12,
                      ),
                      Image.network(
                        currentUrl(image2),
                        height: 180,
                      ),
                    ],
                  ),
                )
            ])
          ],
        ),
      ),
    );
  }
}
