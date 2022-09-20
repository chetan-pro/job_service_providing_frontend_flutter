// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/tag_chip_widget.dart';
import 'package:hindustan_job/candidate/header/back_text_widget.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:hindustan_job/widget/text/date_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../candidate/dropdown/dropdown_list.dart';
import '../candidate/dropdown/dropdown_string.dart';
import '../candidate/header/app_bar.dart';
import '../candidate/model/city_model.dart';
import '../candidate/model/education_model.dart';
import '../candidate/model/location_pincode_model.dart';
import '../candidate/model/manager_business_details_model.dart';
import '../candidate/model/manager_personal_details_model.dart';
import '../candidate/model/state_model.dart';
import '../candidate/model/user_model.dart';
import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../candidate/pages/landing_page/home_page.dart';
import '../candidate/pages/resume_builder_form.dart';
import '../candidate/theme_modeule/new_text_style.dart';
import '../candidate/theme_modeule/text_style.dart';
import '../config/size_config.dart';
import '../constants/colors.dart';
import '../constants/label_string.dart';
import '../services/api_services/panel_services.dart';
import '../services/auth/auth.dart';
import '../services/auth/auth_services.dart';
import '../services/services_constant/response_model.dart';
import '../utility/function_utility.dart';
import '../widget/body/transaparent_body.dart';
import '../widget/buttons/radio_button_widget.dart';
import '../widget/buttons/submit_elevated_button.dart';
import '../widget/drop_down_widget/custom_dropdown.dart';
import '../widget/drop_down_widget/drop_down_dynamic_widget.dart';
import '../widget/drop_down_widget/pop_picker.dart';
import '../widget/drop_down_widget/static_dropdown_widget.dart';
import '../widget/number_input_text_form_field_widget.dart';
import '../widget/select_file.dart';
import '../widget/space_widget.dart';
import '../widget/text/non_editable_text.dart';
import '../widget/text/text_editable.dart';
import '../widget/text/title_edit_head.dart';
import '../widget/text_form_field_widget.dart';

class EditClusterManager extends ConsumerStatefulWidget {
  const EditClusterManager({Key? key}) : super(key: key);

  @override
  ConsumerState<EditClusterManager> createState() => _EditClusterManagerState();
}

class _EditClusterManagerState extends ConsumerState<EditClusterManager>
    with SingleTickerProviderStateMixin {
  String? showSelectedDate;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

//basic details
  var main_image;
  TextEditingController nameController =
      TextEditingController(text: userData!.name ?? '');
  TextEditingController emailController =
      TextEditingController(text: userData!.email ?? '');
  TextEditingController mobileController =
      TextEditingController(text: userData!.mobile ?? '');
  String? selectedGender =
      userData!.gender != null ? getCapitalizeString(userData!.gender) : null;
  String? selectedDate =
      userData!.dob != null ? dateFormat(userData!.dob) : null;
  TextEditingController pincodeController =
      TextEditingController(text: userData!.pinCode ?? '');
  States? selectedState;
  City? selectedCity;
  TextEditingController nameOfHouseController = TextEditingController();
  TextEditingController numberStreetController = TextEditingController();
  TextEditingController villageWardController = TextEditingController();
  TextEditingController tehseelMunicipalityController = TextEditingController();

  // personal details
  TextEditingController residentNoController = TextEditingController();
  TextEditingController officeNoController = TextEditingController();
  TextEditingController whatsappNoController = TextEditingController();
  TextEditingController fatherHusbandController = TextEditingController();
  Education? selectedEducation;
  String? selectedEducationName;
  var selectedEducationFile;
  var selectedEducationFileUrl;
  TextEditingController selectedEducationFileController =
      TextEditingController();
  var backPanCard;
  var frontPanCard;
  var backAadharCard;
  var frontAadharCard;
  String? backPanCardUrl;
  String? frontPanCardUrl;
  String? backAadharCardUrl;
  String? frontAadharCardUrl;
  TextEditingController panCardController = TextEditingController();
  TextEditingController frontPanCardController = TextEditingController();
  TextEditingController backPanCardController = TextEditingController();
  TextEditingController aadharCardController = TextEditingController();
  TextEditingController frontAadharCardController = TextEditingController();
  TextEditingController backAadharCardController = TextEditingController();
  String? selectedResidentalProof;
  var selectedResidentalProofFile;
  String? selectedResidentalProofUrl;
  TextEditingController residentalProofController = TextEditingController();
  String? selectedCurrentStatus;

// current business occupation
  TextEditingController businessNameController = TextEditingController();
  String? selectedBusinessOccupation;
  String? selectedTypeOfBusiness;
  TextEditingController pincodeBusinessController = TextEditingController();
  States? selectedBusinessState;
  City? selectedBusinessCity;
  TextEditingController nameOfHouseBusinessController = TextEditingController();
  TextEditingController numberStreetBusinessController =
      TextEditingController();
  TextEditingController villageWardBusinessController = TextEditingController();
  TextEditingController tehseelMunicipalityBusinessController =
      TextEditingController();
  TextEditingController businessDimensionsController = TextEditingController();
  TextEditingController yearOfExperienceController = TextEditingController();
  TextEditingController businessIncomePerAnnumController =
      TextEditingController();
  TextEditingController approxNumberOfCustomerServedEveryMonthController =
      TextEditingController();

  // customer details
  String? selectBusinessLocationPopular;
  TextEditingController estimateServedBCAActivityController =
      TextEditingController();
  TextEditingController noOfTownsFromCustomersCameController =
      TextEditingController();
  TextEditingController nameOfTownsFromCustomersCameController =
      TextEditingController();
  TextEditingController achievementOneController = TextEditingController();
  TextEditingController achievementTwoController = TextEditingController();
  TextEditingController achievementThreeController = TextEditingController();
  TextEditingController referenceOneNameController = TextEditingController();
  TextEditingController referenceOneMobileController = TextEditingController();
  TextEditingController referenceOneAddressController = TextEditingController();
  TextEditingController referenceOneOccupationController =
      TextEditingController();
  TextEditingController referenceTwoNameController = TextEditingController();
  TextEditingController referenceTwoMobileController = TextEditingController();
  TextEditingController referenceTwoAddressController = TextEditingController();
  TextEditingController referenceTwoOccupationController =
      TextEditingController();

  TabController? _control;
  List<City> city = [];
  List<City> businessCity = [];
  var croppedFile;
  PlatformFile? logo;

  List<PostOffice> postOffices = [];
  List<States> state = [];
  List<Education> educations = [];

  TextEditingController frontResidentalProofController =
      TextEditingController();
  TextEditingController backResidentalProofController = TextEditingController();

  var frontResidentalProof;
  var backResidentalProof;

  int group = 1;

  List<Hobbies> businessInfrastructureList = [];
  List<Hobbies> selectedBusinessInfrastructureList = [];

  @override
  void initState() {
    super.initState();
    fetchEducation();
    fetchState();
    for (var element in ListDropdown.infrastructure) {
      businessInfrastructureList.add(Hobbies.fromJson(element));
    }
    setBasicDetailsData();
    getManagerPersonalDetails();
    getManagerBusinessDetails();
    _control = TabController(vsync: this, length: 4);
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

  setBasicDetailsData() {
    if (userData!.addressLine1 != null) {
      nameOfHouseController.text = userData!.addressLine1!.split('+/+').first;
      numberStreetController.text = userData!.addressLine1!.split('+/+').last;
    }
    if (userData!.addressLine2 != null) {
      villageWardController.text = userData!.addressLine2!.split('+/+').first;
      tehseelMunicipalityController.text =
          userData!.addressLine2!.split('+/+').last;
    }
  }

  setBusinessLocationOnTheBasisOfPinCode(pincode) async {
    postOffices = await fetchLocationOnBasisOfPinCode(context, pincode);
    if (postOffices.isNotEmpty) {
      PostOffice object = postOffices.first;
      List<States> pinState =
          await fetchStates(context, filterByName: object.state);
      selectedBusinessState = pinState.first;
      await fetchBusinessCity(selectedBusinessState!.id,
          pinLocation: object.district);
      List<City> pinCity = await fetchCities(context,
          stateId: selectedBusinessState!.id, filterByName: object.district);
      selectedBusinessCity = pinCity.first;
    }
    setState(() {});
  }

  fetchEducation() async {
    educations = await fetchEducations(context);
    print("educations");
    print(educations);
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
    city = await fetchCities(
      context,
      stateId: id.toString(),
    );
    if (userData != null && pinLocation == null) {
      selectedCity = userData!.city;
    }
    setState(() {});
  }

  ManagerBusinessDetailsModel? managerBusinessDetails;
  ManagerPersonalDetails? managerPersonalDetails;

  getManagerBusinessDetails() async {
    ApiResponse response = await getMiscellaneousUserBussinessDetails();
    if (response.status == 200 && response.body!.data != null) {
      managerBusinessDetails =
          ManagerBusinessDetailsModel.fromJson(response.body!.data);
      businessNameController.text = managerBusinessDetails!.bussinessName ?? '';
      selectedBusinessOccupation = managerBusinessDetails!.currentBussiness;
      selectedTypeOfBusiness = managerBusinessDetails!.bussinessType;
      pincodeBusinessController.text =
          (managerBusinessDetails!.pincode ?? '').toString();
      selectedBusinessState = managerBusinessDetails!.state;
      await fetchBusinessCity(selectedBusinessState!.id);
      selectedBusinessCity = managerBusinessDetails!.city;
      nameOfHouseBusinessController.text =
          managerBusinessDetails!.houseName ?? '';
      numberStreetBusinessController.text =
          managerBusinessDetails!.streetNoName ?? '';
      villageWardBusinessController.text = managerBusinessDetails!.ward ?? '';
      tehseelMunicipalityBusinessController.text =
          managerBusinessDetails!.municipality ?? '';
      businessDimensionsController.text =
          managerBusinessDetails!.dimensions ?? '';
      yearOfExperienceController.text =
          (managerBusinessDetails!.bussinessYears ?? '').toString();
      List infrastructureList =
          managerBusinessDetails!.infrastructureAvailable != null
              ? managerBusinessDetails!.infrastructureAvailable!.split(',')
              : [];
      for (var element in infrastructureList) {
        selectedBusinessInfrastructureList
            .add(Hobbies.fromJson({"name": element.trim()}));
      }
      businessIncomePerAnnumController.text =
          (managerBusinessDetails!.currentIncomePa ?? '').toString();
      approxNumberOfCustomerServedEveryMonthController.text =
          (managerBusinessDetails!.noCustomers ?? '').toString();
      selectBusinessLocationPopular =
          managerBusinessDetails!.popular == 'Y' ? 'Yes' : 'No';
      estimateServedBCAActivityController.text =
          (managerBusinessDetails!.customersServed ?? '').toString();
      noOfTownsFromCustomersCameController.text =
          (managerBusinessDetails!.noTowns ?? '').toString();
      nameOfTownsFromCustomersCameController.text =
          managerBusinessDetails!.nameTowns ?? '';
      achievementOneController.text =
          managerBusinessDetails!.achievement1 ?? '';
      achievementTwoController.text =
          managerBusinessDetails!.achievement2 ?? '';
      achievementThreeController.text =
          managerBusinessDetails!.achievement3 ?? '';
      referenceOneNameController.text = managerBusinessDetails!.ref1Name ?? '';
      referenceOneMobileController.text =
          managerBusinessDetails!.ref1Mobile ?? '';
      referenceOneAddressController.text =
          managerBusinessDetails!.ref1Address ?? '';
      referenceOneOccupationController.text =
          managerBusinessDetails!.ref1Occupation ?? '';
      referenceTwoNameController.text = managerBusinessDetails!.ref2Name ?? '';
      referenceTwoMobileController.text =
          managerBusinessDetails!.ref2Address ?? '';
      referenceTwoAddressController.text =
          managerBusinessDetails!.ref2Address ?? '';
      referenceTwoOccupationController.text =
          managerBusinessDetails!.ref1Occupation ?? '';
    }
    setState(() {});
  }

  getManagerPersonalDetails() async {
    ApiResponse response = await getMiscellaneousUserPersonalDetails();
    if (response.status == 200 && response.body!.data != null) {
      managerPersonalDetails =
          ManagerPersonalDetails.fromJson(response.body!.data);
      residentNoController.text =
          managerPersonalDetails!.residenceNo.toString();
      officeNoController.text = managerPersonalDetails!.officeNo.toString();
      whatsappNoController.text = managerPersonalDetails!.whatsappNo.toString();
      group = managerPersonalDetails!.relativeRelation == 'Father' ? 1 : 2;
      fatherHusbandController.text =
          managerPersonalDetails!.realtiveName.toString();
      panCardController.text = managerPersonalDetails!.panNo.toString();
      backPanCardUrl = managerPersonalDetails!.panImgBack;
      backPanCardController.text = backPanCardUrl!.split('/').last;
      frontPanCardUrl = managerPersonalDetails!.panImgFront;
      frontPanCardController.text = frontPanCardUrl!.split('/').last;
      aadharCardController.text = managerPersonalDetails!.adharNo.toString();
      backAadharCardUrl = managerPersonalDetails!.adharImgBack;
      backAadharCardController.text = backAadharCardUrl!.split('/').last;
      frontAadharCardUrl = managerPersonalDetails!.adharImgFront;
      frontAadharCardController.text = frontAadharCardUrl!.split('/').last;
      selectedResidentalProof = managerPersonalDetails!.residentialProofName;
      residentalProofController.text =
          managerPersonalDetails!.residentialProof!;
      selectedResidentalProofUrl = managerPersonalDetails!.residentialProof!;
      selectedCurrentStatus = managerPersonalDetails!.currentStatus;
      selectedEducationName = managerPersonalDetails!.educationQualification;
      if (educations.isNotEmpty && selectedEducationName != null) {
        selectedEducation = educations
            .where((element) => element.name == selectedEducationName)
            .first;
      }
      selectedEducationFileController.text =
          managerPersonalDetails?.educationFile ?? '';
      selectedEducationFileUrl = managerPersonalDetails?.educationFile;
      setState(() {});
    }
  }

  fetchBusinessCity(id, {pinLocation}) async {
    selectedBusinessCity = null;
    businessCity = [];
    setState(() {});
    // return;
    businessCity = await fetchCities(
      context,
      stateId: id.toString(),
    );
    setState(() {});
  }

  saveBasicDetails() async {
    Map<String, dynamic> editData = {
      "name": nameController.text,
      "mobile": mobileController.text,
      "state_id": selectedState!.id,
      "city_id": selectedCity!.id,
      "pin_code": pincodeController.text,
      "gender": selectedGender.toString().toLowerCase(),
      "dob": selectedDate,
      "address_line1":
          nameOfHouseController.text + '+/+' + numberStreetController.text,
      "address_line2": villageWardController.text +
          '+/+' +
          tehseelMunicipalityController.text,
    };

    if (main_image != null) {
      editData["image"] = kIsWeb
          ? MultipartFile.fromBytes(main_image.bytes, filename: main_image.name)
          : await MultipartFile.fromFile(main_image.path,
              filename: main_image.path.toString().split('/').last);
    }

    ApiResponse response = await editUserProfile(editData);
    if (response.status == 200) {
      UserData userData = UserData.fromJson(response.body!.data);
      ApiResponse profileResponse = await getProfile(userData.resetToken);
      UserData user = UserData.fromJson(profileResponse.body!.data);
      await setUserData(user);
      ref.read(userDataProvider).updateUserData(user);
      setState(() {});
      showSnack(context: context, msg: response.body!.message);
      _control!.animateTo(1);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  personalDetail() async {
    Map<String, dynamic> carryData = {
      "residence_no": residentNoController.text,
      "office_no": officeNoController.text,
      "whatsapp_no": whatsappNoController.text,
      "relative_relation": group == 1 ? 'Father' : 'Husband',
      "realtive_name": fatherHusbandController.text,
      "pan_no": panCardController.text,
      "adhar_no": panCardController.text,
      'residential_proof_name': selectedResidentalProof,
      'current_status': selectedCurrentStatus,
      "education_qualification": selectedEducationName ?? '',
    };
    if (frontResidentalProof != null) {
      carryData["residential_proof"] = kIsWeb
          ? MultipartFile.fromBytes(frontResidentalProof.bytes,
              filename: frontResidentalProof.name)
          : await MultipartFile.fromFile(frontResidentalProof!.path,
              filename: frontResidentalProof!.path.toString().split('/').last);
    }
    if (selectedEducationFile != null) {
      carryData["education_file"] = kIsWeb
          ? MultipartFile.fromBytes(selectedEducationFile.bytes,
              filename: selectedEducationFile.name)
          : await MultipartFile.fromFile(selectedEducationFile.path,
              filename: selectedEducationFile.path.toString().split('/').last);
    }
    if (frontPanCard != null) {
      carryData["pan_img_front"] = kIsWeb
          ? MultipartFile.fromBytes(frontPanCard.bytes,
              filename: frontPanCard.name)
          : await MultipartFile.fromFile(frontPanCard!.path,
              filename: frontPanCard!.path.toString().split('/').last);
    }
    if (backPanCard != null) {
      carryData["pan_img_back"] = kIsWeb
          ? MultipartFile.fromBytes(backPanCard.bytes,
              filename: backPanCard.name)
          : await MultipartFile.fromFile(backPanCard!.path,
              filename: backPanCard!.path.toString().split('/').last);
    }
    if (frontAadharCard != null) {
      carryData["adhar_img_front"] = kIsWeb
          ? MultipartFile.fromBytes(frontAadharCard.bytes,
              filename: frontAadharCard.name)
          : await MultipartFile.fromFile(frontAadharCard!.path,
              filename: frontAadharCard!.path.toString().split('/').last);
    }
    if (backAadharCard != null) {
      carryData["adhar_img_back"] = kIsWeb
          ? MultipartFile.fromBytes(backAadharCard.bytes,
              filename: backAadharCard.name)
          : await MultipartFile.fromFile(backAadharCard!.path,
              filename: backAadharCard!.path.toString().split('/').last);
    }

    ApiResponse response = managerPersonalDetails != null
        ? await editMiscellaneousUserPersonalDetails(carryData)
        : await addMiscellaneousUserPersonalDetails(carryData);
    if (response.status == 200) {
      setState(() {});

      showSnack(context: context, msg: response.body!.message);
      _control!.animateTo(2);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  currentBusinessOccupation() async {
    var carryData = {
      "current_bussiness": selectedBusinessOccupation,
      "bussiness_type": selectedTypeOfBusiness,
      "bussiness_name": businessNameController.text,
      "state_id": selectedBusinessState!.id,
      "city_id": selectedBusinessCity!.id,
      "bussiness_years": yearOfExperienceController.text,
      "dimensions": businessDimensionsController.text,
      "infrastructure_available":
          selectedBusinessInfrastructureList.map((e) => e.name).join(','),
      "current_income_pa": businessIncomePerAnnumController.text,
      "no_customers": approxNumberOfCustomerServedEveryMonthController.text,
      "pincode": pincodeBusinessController.text,
      "house_name": nameOfHouseBusinessController.text,
      "street_no_name": numberStreetBusinessController.text,
      "ward": villageWardBusinessController.text,
      "municipality": tehseelMunicipalityBusinessController.text,
    };
    ApiResponse response =
        await addMiscellaneousUserCurrentBussinessDetails(carryData);
    if (response.status == 200) {
      setState(() {});
      showSnack(
          context: context, msg: "Business Details added successfully...");
      _control!.animateTo(3);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  custormersDetails() async {
    var carryData = {
      "achievement1": achievementOneController.text,
      "achievement2": achievementTwoController.text,
      "achievement3": achievementThreeController.text,
      "ref1_name": referenceOneNameController.text,
      "ref1_occupation": referenceOneOccupationController.text,
      "ref1_address": referenceOneAddressController.text,
      "ref1_mobile": referenceOneMobileController.text,
      "ref2_name": referenceTwoNameController.text,
      "ref2_occupation": referenceTwoOccupationController.text,
      "ref2_address": referenceTwoAddressController.text,
      "ref2_mobile": referenceTwoMobileController.text,
      "no_towns": noOfTownsFromCustomersCameController.text,
      "name_towns": nameOfTownsFromCustomersCameController.text,
      "popular": selectBusinessLocationPopular == 'Yes' ? 'Y' : 'N',
      "customers_served": estimateServedBCAActivityController.text
    };
    ApiResponse response = await addMiscellaneousUserCustomerDetails(carryData);
    if (response.status == 200) {
      setState(() {});
      showSnack(
          context: context, msg: "Customer Details added successfully...");
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
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
            key: _drawerKey,
            drawer: const Drawer(
              child: const DrawerJobSeeker(),
            ),
            // backgroundColor: MyAppColor.backgroundColor,
            appBar: CustomAppBar(
              drawerKey: _drawerKey,
              context: context,
              back: "edit-cluster-manager",
            ),
            body: TabBarSliverAppbar(
              headColumn: BackWithText(text: "edit-cluster-manager"),
              toolBarHeight: 0,
              length: 7,
              tabs: _tab(styless),
              tabsWidgets: [
                basicDetails(),
                personalDetails(),
                currentBusinesOccupation(),
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
          tabText('Current Business\nOccupation'),
        if (!Responsive.isDesktop(context)) tabText('Customers\nDetails'),
        if (Responsive.isDesktop(context)) tabText('Demographic Details'),
        if (Responsive.isDesktop(context)) tabText('Residential Details'),
        if (Responsive.isDesktop(context))
          tabText('Current Business Occupation'),
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
                  child: InkWell(
                    onTap: () async {
                      if (kIsWeb) {
                        _openGallery(context);
                      } else {
                        await _showChoiceDialog(context);
                      }
                      setState(() {});
                    },
                    child: Container(
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
                          : kIsWeb
                              ? Image(
                                  image: MemoryImage(croppedFile!.bytes),
                                  fit: BoxFit.cover,
                                )
                              : Image(
                                  image: FileImage(croppedFile!),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    NonEditableTextField(
                        label: LabelString.fullName,
                        value: nameController.text),
                    space20(),
                    NonEditableTextField(
                        label: LabelString.email, value: emailController.text),
                    space20(),
                    NonEditableTextField(
                      label: LabelString.mobileNumber,
                      value: mobileController.text,
                    ),
                    if (Responsive.isDesktop(context))
                      Column(
                        children: [
                          space20(),
                          Row(
                            children: [
                              StaticDropDownWidget(
                                dropDownList: ListDropdown.genders,
                                label: DropdownString.gender,
                                selectingValue: selectedGender,
                                setValue: (newValue) {
                                  if (newValue == DropdownString.gender) return;
                                  setState(() {
                                    selectedGender = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: DatePicker(
                                    text: 'Date of birth',
                                    value: showSelectedDate ?? selectedDate,
                                    onSelect: (date, showDate) {
                                      setState(() {
                                        showSelectedDate = showDate;
                                        selectedDate = date;
                                      });
                                    },
                                    padding: 15.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        StaticDropDownWidget(
                          dropDownList: ListDropdown.genders,
                          label: DropdownString.gender,
                          selectingValue: selectedGender,
                          setValue: (newValue) {
                            if (newValue == DropdownString.gender) return;
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                        ),
                      ]),
                    if (!Responsive.isDesktop(context))
                      DatePicker(
                          text: 'Date of birth',
                          value: showSelectedDate ?? selectedDate,
                          onSelect: (date, showDate) {
                            setState(() {
                              showSelectedDate = showDate;
                              selectedDate = date;
                            });
                          },
                          padding: 20.0),
                    NumberTextFormFieldWidget(
                      text: LabelString.pinCode,
                      control: pincodeController,
                      type: TextInputType.number,
                      maxLength: 6,
                      onChanged: (value) async {
                        if (value.length == 6) {
                          await setLocationOnTheBasisOfPinCode(value);
                        }
                      },
                      isRequired: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: DynamicDropDownListOfFields(
                              label: DropdownString.selectState,
                              dropDownList: state,
                              selectingValue: selectedState,
                              setValue: (value) async {
                                if (DropdownString.selectState == value!) {
                                  return;
                                }
                                selectedState = state.firstWhere((element) =>
                                    element.name.toString() == value);
                                await fetchCity(selectedState!.id,
                                    pinLocation: 'fetchLocation');
                              },
                            ),
                          ),
                          if (city.isNotEmpty)
                            const SizedBox(
                              width: 20,
                            ),
                          if (city.isNotEmpty)
                            Expanded(
                              child: DynamicDropDownListOfFields(
                                label: DropdownString.selectCity,
                                dropDownList: city,
                                selectingValue: selectedCity,
                                setValue: (value) async {
                                  if (DropdownString.selectCity == value!) {
                                    return;
                                  }
                                  setState(
                                    () {
                                      selectedCity = city.firstWhere(
                                          (element) => element.name == value);
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      DynamicDropDownListOfFields(
                        label: DropdownString.selectState,
                        dropDownList: state,
                        selectingValue: selectedState,
                        setValue: (value) async {
                          if (DropdownString.selectState == value!) {
                            return;
                          }
                          selectedState = state.firstWhere(
                              (element) => element.name.toString() == value);
                          await fetchCity(selectedState!.id,
                              pinLocation: 'fetchLocation');
                        },
                      ),
                    if (city.isNotEmpty && !Responsive.isDesktop(context))
                      const SizedBox(
                        height: 15,
                      ),
                    if (city.isNotEmpty && !Responsive.isDesktop(context))
                      DynamicDropDownListOfFields(
                        label: DropdownString.selectCity,
                        dropDownList: city,
                        selectingValue: selectedCity,
                        setValue: (value) async {
                          if (DropdownString.selectCity == value!) {
                            return;
                          }
                          setState(
                            () {
                              selectedCity = city.firstWhere(
                                  (element) => element.name == value);
                            },
                          );
                        },
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: TextEditable(
                                label: LabelString.nameOfHouse,
                                controller: nameOfHouseController),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextEditable(
                                label: LabelString.numberAndStreet,
                                controller: numberStreetController),
                          ),
                        ],
                      ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: TextEditable(
                                label: LabelString.villageWard,
                                controller: villageWardController),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextEditable(
                                label: LabelString.tehseelMunicipality,
                                controller: tehseelMunicipalityController),
                          ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      Column(children: [
                        TextEditable(
                            label: LabelString.nameOfHouse,
                            controller: nameOfHouseController),
                        TextEditable(
                            label: LabelString.numberAndStreet,
                            controller: numberStreetController),
                        TextEditable(
                            label: LabelString.villageWard,
                            controller: villageWardController),
                        TextEditable(
                            label: LabelString.tehseelMunicipality,
                            controller: tehseelMunicipalityController),
                      ]),
                    SubmitElevatedButton(
                      label: "Save",
                      onSubmit: () async {
                        saveBasicDetails();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    space20(),
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
                Column(
                  children: [
                    if (Responsive.isDesktop(context))
                      Row(children: [
                        Expanded(
                          child: NumberTextFormFieldWidget(
                            text: LabelString.residentNo,
                            control: residentNoController,
                            type: TextInputType.number,
                            maxLength: 10,
                            isRequired: false,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: NumberTextFormFieldWidget(
                            text: LabelString.officeNo,
                            control: officeNoController,
                            type: TextInputType.number,
                            maxLength: 10,
                            isRequired: false,
                          ),
                        ),
                      ]),
                    SizedBox(height: 10),
                    if (Responsive.isDesktop(context))
                      Row(children: [
                        Expanded(
                          child: NumberTextFormFieldWidget(
                            text: LabelString.whatsappNo,
                            control: whatsappNoController,
                            type: TextInputType.number,
                            maxLength: 10,
                            isRequired: false,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        if (educations.isNotEmpty)
                          DynamicDropDownListOfFields(
                            widthRatio: 4,
                            label: DropdownString.selectQualification,
                            dropDownList: educations,
                            selectingValue: selectedEducation,
                            setValue: (value) async {
                              if (DropdownString.selectQualification ==
                                  value!) {
                                return;
                              }
                              selectedEducation = educations.firstWhere(
                                  (element) =>
                                      element.name.toString() == value);
                              selectedEducationName = selectedEducation!.name;

                              setState(() {});
                            },
                          ),
                      ]),
                    if (!Responsive.isDesktop(context))
                      Column(children: [
                        NumberTextFormFieldWidget(
                          text: LabelString.residentNo,
                          control: residentNoController,
                          type: TextInputType.number,
                          maxLength: 10,
                          isRequired: false,
                        ),
                        space20(),
                        NumberTextFormFieldWidget(
                          text: LabelString.officeNo,
                          control: officeNoController,
                          type: TextInputType.number,
                          maxLength: 10,
                          isRequired: false,
                        ),
                        space20(),
                        NumberTextFormFieldWidget(
                          text: LabelString.whatsappNo,
                          control: whatsappNoController,
                          type: TextInputType.number,
                          maxLength: 10,
                          isRequired: false,
                        ),
                        space20(),
                        CustomDropdown(
                          label: DropdownString.selectQualification,
                          dropDownList: educations,
                          selectingValue: selectedEducation,
                          setValue: (value) async {
                            if (DropdownString.selectQualification == value!) {
                              return;
                            }
                            selectedEducation = educations
                                .firstWhere((element) => element.name == value);
                            selectedEducationName = selectedEducation!.name;
                            setState(() {});
                          },
                        ),
                      ]),
                    space20(),
                    if (selectedEducation != null)
                      TextFormFieldWidget(
                        text: 'Select Education File',
                        control: selectedEducationFileController,
                        isRequired: false,
                        type: TextInputType.none,
                        onTap: () async {
                          FilePickerResult? file = await selectFile();
                          if (file == null) return;
                          selectedEducationFile = kIsWeb
                              ? file.files.first
                              : File(file.paths.first!);
                          selectedEducationFileController.text = kIsWeb
                              ? file.files.first.name
                              : file.names.first!;
                          FocusScope.of(context).unfocus();
                          setState(() {});
                        },
                      ),
                    if (selectedEducationFile != null ||
                        selectedEducationFileUrl != null)
                      containerImage(
                          label: "Selected Education File Images",
                          image: selectedEducationFile,
                          imageUrl: selectedEducationFileUrl),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Select Relationship",
                              style: blackDark13,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                RadioButton(
                                  text: "Father",
                                  groupValue: group,
                                  onChanged: (value) => setState(() {
                                    group = value;
                                  }),
                                  value: 1,
                                ),
                                RadioButton(
                                  text: "Husband",
                                  groupValue: group,
                                  onChanged: (value) => setState(() {
                                    group = value;
                                  }),
                                  value: 2,
                                ),
                              ],
                            ),
                          ),
                          TextFormFieldWidget(
                            control: fatherHusbandController,
                            text:
                                "Name of ${group == 1 ? 'Father' : 'Husband'}",
                            type: TextInputType.multiline,
                          ),
                        ],
                      ),
                    ),
                    NumberTextFormFieldWidget(
                      text: "Your ${LabelString.panNo}",
                      control: panCardController,
                      type: TextInputType.multiline,
                      stringAllow: 'true',
                      maxLength: 10,
                      isRequired: true,
                    ),
                    space20(),
                    if (Responsive.isDesktop(context))
                      Row(children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            control: frontPanCardController,
                            text: "Front Image of Pan Card",
                            onTap: () async {
                              FilePickerResult? file = await selectFile();
                              if (file == null) return;
                              setState(() {
                                frontPanCard = kIsWeb
                                    ? file.files.first
                                    : File(file.paths.first!);
                                frontPanCardController.text = kIsWeb
                                    ? file.files.first.name
                                    : file.names.first!;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            type: TextInputType.none,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                            control: backPanCardController,
                            text: "Back Image of Pan Card",
                            onTap: () async {
                              FilePickerResult? file = await selectFile();
                              if (file == null) return;
                              setState(() {
                                backPanCard = kIsWeb
                                    ? file.files.first
                                    : File(file.paths.first!);
                                backPanCardController.text = kIsWeb
                                    ? file.files.first.name
                                    : file.names.first!;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            type: TextInputType.none,
                          ),
                        ),
                      ]),
                    if (!Responsive.isDesktop(context))
                      Column(children: [
                        TextFormFieldWidget(
                          control: frontPanCardController,
                          text: "Front Image of Pan Card",
                          onTap: () async {
                            FilePickerResult? file = await selectFile();
                            if (file == null) return;
                            setState(() {
                              frontPanCard = File(file.paths.first!);
                              frontPanCardController.text = file.names.first!;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          type: TextInputType.none,
                        ),
                        space20(),
                        TextFormFieldWidget(
                          control: backPanCardController,
                          text: "Back Image of Pan Card",
                          onTap: () async {
                            FilePickerResult? file = await selectFile();
                            if (file == null) return;
                            setState(() {
                              backPanCard = File(file.paths.first!);
                              backPanCardController.text = file.names.first!;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          type: TextInputType.none,
                        ),
                      ]),
                    space20(),
                    containerImage(
                        label: "Pan Card Images",
                        image: frontPanCard,
                        image2: backPanCard,
                        image2Url: backPanCardUrl,
                        imageUrl: frontPanCardUrl),
                    NumberTextFormFieldWidget(
                      text: LabelString.aadharNo,
                      control: aadharCardController,
                      type: TextInputType.number,
                      maxLength: 12,
                      isRequired: true,
                    ),
                    space20(),
                    if (Responsive.isDesktop(context))
                      Row(children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            control: frontAadharCardController,
                            text: "Front Image of Aadhar Card",
                            onTap: () async {
                              FilePickerResult? file = await selectFile();
                              if (file == null) return;
                              setState(() {
                                frontAadharCard = kIsWeb
                                    ? file.files.first
                                    : File(file.paths.first!);
                                frontAadharCardController.text = kIsWeb
                                    ? file.files.first.name
                                    : file.names.first!;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            type: TextInputType.none,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                            control: backAadharCardController,
                            text: "Back Image of Aadhar Card",
                            onTap: () async {
                              FilePickerResult? file = await selectFile();
                              if (file == null) return;
                              setState(() {
                                backAadharCard = kIsWeb
                                    ? file.files.first
                                    : File(file.paths.first!);
                                backAadharCardController.text = kIsWeb
                                    ? file.files.first.name
                                    : file.names.first!;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            type: TextInputType.none,
                          ),
                        ),
                      ]),
                    if (!Responsive.isDesktop(context))
                      Column(children: [
                        TextFormFieldWidget(
                          control: frontAadharCardController,
                          text: "Front Image of Aadhar Card",
                          onTap: () async {
                            FilePickerResult? file = await selectFile();
                            if (file == null) return;
                            setState(() {
                              frontAadharCard = File(file.paths.first!);
                              frontAadharCardController.text =
                                  file.names.first!;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          type: TextInputType.none,
                        ),
                        space20(),
                        TextFormFieldWidget(
                          control: backAadharCardController,
                          text: "Back Image of Aadhar Card",
                          onTap: () async {
                            FilePickerResult? file = await selectFile();
                            if (file == null) return;
                            setState(() {
                              backAadharCard = File(file.paths.first!);
                              backAadharCardController.text = file.names.first!;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          type: TextInputType.none,
                        ),
                      ]),
                    containerImage(
                        label: "Aadhar Card Images",
                        image: frontAadharCard,
                        image2: backAadharCard,
                        imageUrl: frontAadharCardUrl,
                        image2Url: backAadharCardUrl),
                    if (Responsive.isDesktop(context))
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StaticDropDownWidget(
                            dropDownList: ListDropdown.residentalProof,
                            label: DropdownString.residentalProof,
                            selectingValue: selectedResidentalProof,
                            setValue: (newValue) {
                              if (newValue == DropdownString.residentalProof)
                                return;
                              setState(() {
                                selectedResidentalProof = newValue!;
                              });
                            },
                          ),
                          SizedBox(width: 20),
                          if (selectedResidentalProof != null)
                            Expanded(
                              child: TextFormFieldWidget(
                                control: residentalProofController,
                                text: "Residental Proof Front Image",
                                onTap: () async {
                                  FilePickerResult? file = await selectFile();
                                  if (file == null) return;
                                  setState(() {
                                    frontResidentalProof = kIsWeb
                                        ? file.files.first
                                        : File(file.paths.first!);
                                    residentalProofController.text = kIsWeb
                                        ? file.files.first.name
                                        : file.names.first!;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                type: TextInputType.none,
                              ),
                            ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      Column(
                        children: [
                          StaticDropDownWidget(
                            dropDownList: ListDropdown.residentalProof,
                            label: DropdownString.residentalProof,
                            selectingValue: selectedResidentalProof ??
                                DropdownString.residentalProof,
                            setValue: (newValue) {
                              if (newValue == DropdownString.residentalProof)
                                return;
                              setState(() {
                                selectedResidentalProof = newValue!;
                              });
                            },
                          ),
                          if (selectedResidentalProof != null)
                            TextFormFieldWidget(
                              control: residentalProofController,
                              text: "Residental Proof Front Image",
                              onTap: () async {
                                FilePickerResult? file = await selectFile();
                                if (file == null) return;
                                setState(() {
                                  frontResidentalProof =
                                      File(file.paths.first!);
                                  residentalProofController.text =
                                      file.names.first!;
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              type: TextInputType.none,
                            ),
                        ],
                      ),
                    containerImage(
                        label: "Residental Proof",
                        image: frontResidentalProof,
                        image2: backResidentalProof,
                        imageUrl: selectedResidentalProofUrl),
                    StaticDropDownWidget(
                      dropDownList: ListDropdown.currentStatus,
                      label: DropdownString.yourCurrentStatus,
                      selectingValue: selectedCurrentStatus,
                      setValue: (newValue) {
                        if (newValue == DropdownString.yourCurrentStatus)
                          return;
                        setState(() {
                          selectedCurrentStatus = newValue!;
                        });
                      },
                    ),
                    SubmitElevatedButton(
                      label: "Save",
                      onSubmit: () async {
                        personalDetail();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    space20(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  currentBusinesOccupation() {
    return TransparentScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context) ? 265 : 0.0),
        child: ListView(
          children: [
            Column(
              children: [
                TitleEditHead(title: 'CURRENT BUSINESS OCCUPATION'),
                Column(
                  children: [
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: TextEditable(
                                label: LabelString.businessName,
                                controller: businessNameController),
                          ),
                          SizedBox(width: 20),
                          StaticDropDownWidget(
                            dropDownList:
                                ListDropdown.currentBusinessOccupation,
                            label: DropdownString.businessOccupation,
                            selectingValue: selectedBusinessOccupation,
                            setValue: (newValue) {
                              if (newValue == DropdownString.businessOccupation)
                                return;
                              setState(() {
                                selectedBusinessOccupation = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      Column(
                        children: [
                          TextEditable(
                              label: LabelString.businessName,
                              controller: businessNameController),
                          StaticDropDownWidget(
                            dropDownList:
                                ListDropdown.currentBusinessOccupation,
                            label: DropdownString.businessOccupation,
                            selectingValue: selectedBusinessOccupation,
                            setValue: (newValue) {
                              if (newValue == DropdownString.businessOccupation)
                                return;
                              setState(() {
                                selectedBusinessOccupation = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    StaticDropDownWidget(
                      dropDownList: ListDropdown.typeOfBusiness,
                      label: DropdownString.typeOfBusiness,
                      selectingValue: selectedTypeOfBusiness,
                      setValue: (newValue) {
                        if (newValue == DropdownString.typeOfBusiness) return;
                        setState(() {
                          selectedTypeOfBusiness = newValue!;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 15),
                      child: Text(
                        "Business Address",
                        style: blackDark13,
                      ),
                    ),
                    if (Responsive.isDesktop(context))
                      Row(children: [
                        Expanded(
                          child: NumberTextFormFieldWidget(
                            text: LabelString.pinCode,
                            control: pincodeBusinessController,
                            type: TextInputType.number,
                            maxLength: 6,
                            onChanged: (value) async {
                              if (value.length == 6) {
                                await setBusinessLocationOnTheBasisOfPinCode(
                                    value);
                              }
                            },
                            isRequired: false,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DynamicDropDownListOfFields(
                          widthRatio: 4,
                          label: DropdownString.selectState,
                          dropDownList: state,
                          selectingValue: selectedBusinessState,
                          setValue: (value) async {
                            if (DropdownString.selectState == value!) {
                              return;
                            }
                            selectedBusinessState = state.firstWhere(
                                (element) => element.name.toString() == value);
                            await fetchCity(selectedBusinessState!.id,
                                pinLocation: 'fetchLocation');
                          },
                        ),
                      ]),
                    if (!Responsive.isDesktop(context))
                      Column(children: [
                        NumberTextFormFieldWidget(
                          text: LabelString.pinCode,
                          control: pincodeBusinessController,
                          type: TextInputType.number,
                          maxLength: 6,
                          onChanged: (value) async {
                            if (value.length == 6) {
                              await setBusinessLocationOnTheBasisOfPinCode(
                                  value);
                            }
                          },
                          isRequired: false,
                        ),
                        space20(),
                        DynamicDropDownListOfFields(
                          label: DropdownString.selectState,
                          dropDownList: state,
                          selectingValue: selectedBusinessState,
                          setValue: (value) async {
                            if (DropdownString.selectState == value!) {
                              return;
                            }
                            selectedBusinessState = state.firstWhere(
                                (element) => element.name.toString() == value);
                            await fetchCity(selectedBusinessState!.id,
                                pinLocation: 'fetchLocation');
                          },
                        ),
                      ]),
                    if (city.isNotEmpty)
                      const SizedBox(
                        height: 15,
                      ),
                    if (city.isNotEmpty)
                      DynamicDropDownListOfFields(
                        widthRatio: 4,
                        label: DropdownString.selectCity,
                        dropDownList: businessCity,
                        selectingValue: selectedBusinessCity,
                        setValue: (value) async {
                          if (DropdownString.selectCity == value!) {
                            return;
                          }
                          setState(
                            () {
                              selectedBusinessCity = businessCity.firstWhere(
                                  (element) => element.name == value);
                            },
                          );
                        },
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: TextEditable(
                                label: "Shop name , Appartment, Building etc",
                                controller: nameOfHouseBusinessController),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextEditable(
                                label: LabelString.numberAndStreet,
                                controller: numberStreetBusinessController),
                          ),
                        ],
                      ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: TextEditable(
                                label: LabelString.villageWard,
                                controller: villageWardBusinessController),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextEditable(
                                label: LabelString.tehseelMunicipality,
                                controller:
                                    tehseelMunicipalityBusinessController),
                          ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      Column(children: [
                        TextEditable(
                            label: "Shop name , Appartment, Building etc",
                            controller: nameOfHouseBusinessController),
                        TextEditable(
                            label: LabelString.numberAndStreet,
                            controller: numberStreetBusinessController),
                        TextEditable(
                            label: LabelString.villageWard,
                            controller: villageWardBusinessController),
                        TextEditable(
                            label: LabelString.tehseelMunicipality,
                            controller: tehseelMunicipalityBusinessController),
                      ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 15),
                      child: Text(
                        "Business Details",
                        style: blackDark13,
                      ),
                    ),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: TextEditable(
                                hintText: 'as in sqft.',
                                type: TextInputType.number,
                                label: LabelString.dimensions,
                                controller: businessDimensionsController),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: NumberTextFormFieldWidget(
                              text: LabelString.yearsOfBusiness,
                              control: yearOfExperienceController,
                              isRequired: true,
                              maxLength: 3,
                              type: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      Column(
                        children: [
                          TextEditable(
                              hintText: 'as in sqft.',
                              type: TextInputType.number,
                              label: LabelString.dimensions,
                              controller: businessDimensionsController),
                          NumberTextFormFieldWidget(
                            text: LabelString.yearsOfBusiness,
                            control: yearOfExperienceController,
                            isRequired: true,
                            maxLength: 3,
                            type: TextInputType.number,
                          ),
                        ],
                      ),
                    space20(),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                          selectedBusinessInfrastructureList.length,
                          (index) => TagChip(
                                text: selectedBusinessInfrastructureList[index]
                                    .name!,
                                onTap: () {
                                  selectedBusinessInfrastructureList
                                      .removeWhere((element) =>
                                          element.name ==
                                          selectedBusinessInfrastructureList[
                                                  index]
                                              .name);
                                  setState(() {});
                                },
                              )),
                    ),
                    InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => PopPicker(
                                  title:
                                      '${DropdownString.infrastructureBusiness}',
                                  list: businessInfrastructureList,
                                  flag: 'hobby',
                                  allReadySelected:
                                      selectedBusinessInfrastructureList,
                                ));
                        setState(() {});
                      },
                      child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            DropdownString.infrastructureBusiness,
                            style: blackDarkM16(),
                          )),
                    ),
                    space20(),
                    if (Responsive.isDesktop(context))
                      Row(children: [
                        Expanded(
                          child: NumberTextFormFieldWidget(
                            text: LabelString.businessIncomePerAnnum,
                            control: businessIncomePerAnnumController,
                            isRequired: true,
                            type: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: NumberTextFormFieldWidget(
                          text: LabelString
                              .approxNumberOfCustomerServedEveryMonth,
                          control:
                              approxNumberOfCustomerServedEveryMonthController,
                          isRequired: true,
                          type: TextInputType.number,
                        )),
                      ]),
                    if (!Responsive.isDesktop(context))
                      Column(children: [
                        NumberTextFormFieldWidget(
                          text: LabelString.businessIncomePerAnnum,
                          control: businessIncomePerAnnumController,
                          isRequired: true,
                          type: TextInputType.number,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        NumberTextFormFieldWidget(
                          text: LabelString
                              .approxNumberOfCustomerServedEveryMonth,
                          control:
                              approxNumberOfCustomerServedEveryMonthController,
                          isRequired: true,
                          type: TextInputType.number,
                        ),
                      ]),
                    SizedBox(
                      height: 20,
                    ),
                    SubmitElevatedButton(
                      label: "Save",
                      onSubmit: () async {
                        FocusScope.of(context).unfocus();
                        currentBusinessOccupation();
                      },
                    ),
                    space20(),
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
                Column(
                  children: [
                    Responsive.isDesktop(context)
                        ? Row(children: [
                            Expanded(
                              child: TextFormFieldWidget(
                                text: LabelString.noOfTownsFromCustomersCame,
                                control: noOfTownsFromCustomersCameController,
                                type: TextInputType.number,
                                isRequired: false,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormFieldWidget(
                                text: LabelString.nameOfTownsFromCustomersCame,
                                control: nameOfTownsFromCustomersCameController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                            )
                          ])
                        : Column(children: [
                            TextFormFieldWidget(
                              text: LabelString.noOfTownsFromCustomersCame,
                              control: noOfTownsFromCustomersCameController,
                              type: TextInputType.number,
                              isRequired: false,
                            ),
                            space20(),
                            TextFormFieldWidget(
                              text: LabelString.nameOfTownsFromCustomersCame,
                              control: nameOfTownsFromCustomersCameController,
                              type: TextInputType.multiline,
                              isRequired: false,
                            ),
                          ]),
                    space20(),
                    Responsive.isDesktop(context)
                        ? Row(children: [
                            Expanded(
                              child: TextFormFieldWidget(
                                text: LabelString.achievementOne,
                                control: achievementOneController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormFieldWidget(
                                text: LabelString.achievementTwo,
                                control: achievementTwoController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                            )
                          ])
                        : Column(children: [
                            TextFormFieldWidget(
                              text: LabelString.achievementOne,
                              control: achievementOneController,
                              type: TextInputType.multiline,
                              isRequired: false,
                            ),
                            space20(),
                            TextFormFieldWidget(
                              text: LabelString.achievementTwo,
                              control: achievementTwoController,
                              type: TextInputType.multiline,
                              isRequired: false,
                            )
                          ]),
                    space20(),
                    Responsive.isDesktop(context)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Expanded(
                                  child: TextFormFieldWidget(
                                    text: LabelString.achievementThree,
                                    control: achievementThreeController,
                                    type: TextInputType.multiline,
                                    isRequired: false,
                                  ),
                                ),
                                SizedBox(width: 20),
                                StaticDropDownWidget(
                                  dropDownList: ListDropdown.selectYesNo,
                                  label: DropdownString.businessPopularOne,
                                  selectingValue: selectBusinessLocationPopular,
                                  setValue: (newValue) {
                                    if (newValue ==
                                        DropdownString.yourCurrentStatus)
                                      return;
                                    setState(() {
                                      selectBusinessLocationPopular = newValue!;
                                    });
                                  },
                                ),
                              ])
                        : Column(children: [
                            TextFormFieldWidget(
                              text: LabelString.achievementThree,
                              control: achievementThreeController,
                              type: TextInputType.multiline,
                              isRequired: false,
                            ),
                            space20(),
                            StaticDropDownWidget(
                              dropDownList: ListDropdown.selectYesNo,
                              label: DropdownString.businessPopularOne,
                              selectingValue: selectBusinessLocationPopular,
                              setValue: (newValue) {
                                if (newValue ==
                                    DropdownString.yourCurrentStatus) return;
                                setState(() {
                                  selectBusinessLocationPopular = newValue!;
                                });
                              },
                            ),
                          ]),
                    NumberTextFormFieldWidget(
                      text: DropdownString.estimateServedBCAActivity,
                      control: estimateServedBCAActivityController,
                      type: TextInputType.number,
                      maxLength: 6,
                      isRequired: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10.0, bottom: 15),
                      child: Text(
                        "Reference Details",
                        style: blackDark13,
                      ),
                    ),
                    Responsive.isDesktop(context)
                        ? Row(children: [
                            Expanded(
                              child: TextFormFieldWidget(
                                text: LabelString.referenceOneName,
                                control: referenceOneNameController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: NumberTextFormFieldWidget(
                                text: LabelString.referenceOneMobile,
                                control: referenceOneMobileController,
                                type: TextInputType.number,
                                maxLength: 10,
                                isRequired: false,
                              ),
                            ),
                          ])
                        : Column(children: [
                            TextFormFieldWidget(
                              text: LabelString.referenceOneName,
                              control: referenceOneNameController,
                              type: TextInputType.multiline,
                              isRequired: false,
                            ),
                            space20(),
                            NumberTextFormFieldWidget(
                              text: LabelString.referenceOneMobile,
                              control: referenceOneMobileController,
                              type: TextInputType.number,
                              maxLength: 10,
                              isRequired: false,
                            ),
                          ]),
                    space20(),
                    Responsive.isDesktop(context)
                        ? Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  text: LabelString.referenceOneAddress,
                                  control: referenceOneAddressController,
                                  type: TextInputType.multiline,
                                  isRequired: false,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormFieldWidget(
                                  text: LabelString.referenceOneOccupation,
                                  control: referenceOneOccupationController,
                                  type: TextInputType.multiline,
                                  isRequired: false,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              TextFormFieldWidget(
                                text: LabelString.referenceOneAddress,
                                control: referenceOneAddressController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                              space20(),
                              TextFormFieldWidget(
                                text: LabelString.referenceOneOccupation,
                                control: referenceOneOccupationController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                            ],
                          ),
                    space20(),
                    Responsive.isDesktop(context)
                        ? Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  text: LabelString.referenceTwoName,
                                  control: referenceTwoNameController,
                                  type: TextInputType.multiline,
                                  isRequired: false,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: NumberTextFormFieldWidget(
                                  text: LabelString.referenceTwoMobile,
                                  control: referenceTwoMobileController,
                                  type: TextInputType.number,
                                  maxLength: 10,
                                  isRequired: false,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              TextFormFieldWidget(
                                text: LabelString.referenceTwoName,
                                control: referenceTwoNameController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                              space20(),
                              NumberTextFormFieldWidget(
                                text: LabelString.referenceTwoMobile,
                                control: referenceTwoMobileController,
                                type: TextInputType.number,
                                maxLength: 10,
                                isRequired: false,
                              ),
                            ],
                          ),
                    space20(),
                    Responsive.isDesktop(context)
                        ? Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  text: LabelString.referenceTwoAddress,
                                  control: referenceTwoAddressController,
                                  type: TextInputType.multiline,
                                  isRequired: false,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: TextFormFieldWidget(
                                  text: LabelString.referenceTwoOccupation,
                                  control: referenceTwoOccupationController,
                                  type: TextInputType.multiline,
                                  isRequired: false,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              TextFormFieldWidget(
                                text: LabelString.referenceTwoAddress,
                                control: referenceTwoAddressController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                              space20(),
                              TextFormFieldWidget(
                                text: LabelString.referenceTwoOccupation,
                                control: referenceTwoOccupationController,
                                type: TextInputType.multiline,
                                isRequired: false,
                              ),
                            ],
                          ),
                    SubmitElevatedButton(
                      label: "Save",
                      onSubmit: () async {
                        FocusScope.of(context).unfocus();
                        custormersDetails();
                      },
                    ),
                    space20(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  containerImage({label, image, image2, size, imageUrl, image2Url}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 10),
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
            const SizedBox(
              height: 5,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              image != null
                  ? Container(
                      height: 210,
                      width: 150,
                      child: Column(
                        children: [
                          Text(
                            "Front",
                            style: appleColorM12,
                          ),
                          kIsWeb
                              ? Image.memory(
                                  image.bytes,
                                  height: 180,
                                )
                              : Image.file(
                                  image,
                                  height: 180,
                                ),
                        ],
                      ),
                    )
                  : imageUrl != null
                      ? Container(
                          height: 210,
                          width: 150,
                          child: Column(
                            children: [
                              Text(
                                "Front",
                                style: appleColorM12,
                              ),
                              Image.network(
                                currentUrl(imageUrl),
                                height: 180,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
              const SizedBox(width: 10),
              image2 != null
                  ? Container(
                      height: 210,
                      width: 150,
                      child: Column(
                        children: [
                          Text(
                            "Back",
                            style: appleColorM12,
                          ),
                          kIsWeb
                              ? Image.memory(
                                  image2.bytes,
                                  height: 180,
                                )
                              : Image.file(
                                  image2,
                                  height: 180,
                                ),
                        ],
                      ),
                    )
                  : image2Url != null
                      ? Container(
                          height: 210,
                          width: 150,
                          child: Column(
                            children: [
                              Text(
                                "Back",
                                style: appleColorM12,
                              ),
                              Image.network(
                                currentUrl(image2Url),
                                height: 180,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox()
            ])
          ],
        ),
      ),
    );
  }

  Future _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyAppColor.backgroundColor,
          title: const Text(
            "Choose option",
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: 1,
                  color: MyAppColor.blackdark,
                ),
                ListTile(
                  onTap: () {
                    _openGallery(context);
                  },
                  title: Text("Gallery",
                      style: TextStyle(color: MyAppColor.blackdark)),
                  leading: Icon(
                    Icons.account_box,
                    color: MyAppColor.blackdark,
                  ),
                ),
                Divider(
                  height: 1,
                  color: MyAppColor.blackdark,
                ),
                ListTile(
                  onTap: () {
                    _openCamera(context);
                  },
                  title: Text("Camera",
                      style: TextStyle(color: MyAppColor.blackdark)),
                  leading: Icon(
                    Icons.camera,
                    color: MyAppColor.blackdark,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future cropImage(context, imageFile) async {
    croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: MyAppColor.backgroundColor,
            toolbarWidgetColor: MyAppColor.blackdark,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {});
    return croppedFile;
  }

  Future _openGallery(context) async {
    if (kIsWeb) {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
      setState(() {
        if (pickedFile != null) {
          croppedFile = pickedFile.files.first;
          Navigator.pop(context);
        }
      });
    } else {
      var pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          croppedFile = pickedFile;
        } else {
          main_image = await cropImage(context, pickedFile.path);
        }
        Navigator.pop(context);
      }
    }
    setState(() {});
  }

  Future _openCamera(context) async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      main_image = await cropImage(context, pickedFile.path);
      Navigator.pop(context);
    } else {}
    setState(() {});
  }
}
