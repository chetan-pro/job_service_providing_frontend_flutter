// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/salary_type_model.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/edit_profile.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/filter_job_page.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/search_job_page.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/elevated_button.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:vrouter/vrouter.dart';

import '../../../services/services_constant/api_string_constant.dart';

class SerchJobHere extends ConsumerStatefulWidget {
  const SerchJobHere({Key? key}) : super(key: key);

  @override
  ConsumerState<SerchJobHere> createState() => _SerchJobHereState();
}

class _SerchJobHereState extends ConsumerState<SerchJobHere> {
  TextEditingController jobTitle = TextEditingController();
  Industry? selectedIndustry;
  Sector? selectedSector;
  States? selectedState;
  City? selectedCity;
  TextEditingController experienceInFromController = TextEditingController();
  TextEditingController experienceInToController = TextEditingController();
  List<SalaryType>? salaryType =
      SalaryTypeModel.fromJson(ListDropdown.salaryType).salaryType;
  SalaryType? selectedSalaryType;
  String? selectedNoOfFromMonths;
  String? selectedNoOfTOMonths;
  List<SalaryType>? experiencePeriodType =
      SalaryTypeModel.fromJson(ListDropdown.experienceType).salaryType;
  SalaryType? selectedExperienceFromType;
  SalaryType? selectedExperienceToType;

  @override
  void initState() {
    super.initState();
    if (isUserData()) {
      ref.read(listData).fetchData(context);
    }
  }

  checkReturnId(obj) {
    return obj?.id.toString();
  }

  TextEditingController pinCodeController = TextEditingController();
  List<PostOffice> postOffices = [];

  setLocationOnTheBasisOfPinCode(pincode) async {
    postOffices = await fetchLocationOnBasisOfPinCode(context, pincode);
    if (postOffices.isNotEmpty) {
      PostOffice object = postOffices.first;
      List<States> pinState =
          await fetchStates(context, filterByName: object.state);
      selectedState = pinState.first;
      selectedCity = null;
      await ref.watch(listData).fetchCity(context, id: selectedState!.id);
      List<City> pinCity = await fetchCities(context,
          stateId: selectedState!.id, filterByName: object.district);
      selectedCity = pinCity.first;
    }
    setState(() {});
  }

  filterJobPageWithData(
      {jobTitle,
      industryId,
      sectorId,
      stateId,
      cityId,
      expFrom,
      expTo,
      salaryType}) async {
    Map<String, dynamic> filterJobData = {
      // "search": jobTitle,
      "filter_by_job_title": jobTitle,
      "filter_by_industry": industryId,
      "filter_by_sector": sectorId,
      "filter_by_city": cityId,
      "filter_by_state": stateId,
      "filter_by_exp_from": expFrom,
      "filter_by_exp_to": expTo,
      "filter_by_paid_type": salaryType
    };
    filterJobData.removeWhere((key, value) =>
        value == null || value == '' || value == 0 || value == 'null');
    if (filterJobData.isEmpty) {
      showSnack(
          context: context, msg: "Please select any one field", type: 'error');
      return;
    }
    await ref.read(jobData).fetchFilterJobs(context, filterJobData, page: 1);
    if (kIsWeb) {
      context.vRouter.to("/hindustaan-jobs/filter-job-search",
          queryParameters: {...filterJobData});
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => FilterJobPage(
                  data: filterJobData,
                  isFromConnectedRoutes: false,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      List<Industry> industry = ref.watch(listData).industry;
      List<States> state = ref.watch(listData).state;
      return Center(
        child: SafeArea(
          child: Responsive.isMobile(context)
              ? Scaffold(
                  backgroundColor: MyAppColor.backgroundColor,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Search Jobs',
                                    style: Mytheme.lightTheme(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Column(
                                children: [
                                  jobtitleResponse(context),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  DynamicDropDownListOfFields(
                                    label: DropdownString.selectIndustry,
                                    dropDownList: industry,
                                    selectingValue: selectedIndustry,
                                    setValue: (value) async {
                                      if (DropdownString.selectIndustry ==
                                          value!) {
                                        return;
                                      }
                                      selectedSector = null;
                                      selectedIndustry = industry.firstWhere(
                                          (element) => element.name == value);
                                      await ref.read(listData).fetchSectors(
                                          context, selectedIndustry!.id);
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Consumer(builder: (context, watch, child) {
                                    List<Sector> sector =
                                        ref.watch(listData).sector;

                                    return DynamicDropDownListOfFields(
                                        label: DropdownString.selectSector,
                                        dropDownList: sector,
                                        selectingValue: selectedSector,
                                        setValue: (value) {
                                          if (DropdownString.selectSector ==
                                              value!) {
                                            return;
                                          }
                                          selectedSector = sector.firstWhere(
                                              (element) =>
                                                  element.name == value);
                                        },
                                        isValidDrop: selectedIndustry != null,
                                        alertMsg: AlertString.selectIndustry);
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: NumberTextFormFieldWidget(
                                      text: LabelString.pinCode,
                                      control: pinCodeController,
                                      type: TextInputType.number,
                                      maxLength: 6,
                                      onChanged: (value) async {
                                        if (value.length == 6) {
                                          await setLocationOnTheBasisOfPinCode(
                                              value);
                                        }
                                      },
                                      isRequired: false,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  DynamicDropDownListOfFields(
                                    label: DropdownString.selectState,
                                    dropDownList: state,
                                    selectingValue: selectedState,
                                    setValue: (value) async {
                                      if (DropdownString.selectState ==
                                          value!) {
                                        return;
                                      }
                                      selectedState = state.firstWhere(
                                          (element) =>
                                              element.name.toString() == value);
                                      selectedCity = null;

                                      await ref.read(listData).fetchCity(
                                          context,
                                          id: selectedState!.id);
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Consumer(builder: (context, watch, child) {
                                    List<City> city = ref.watch(listData).city;
                                    return DynamicDropDownListOfFields(
                                        label: DropdownString.selectCity,
                                        dropDownList: city,
                                        selectingValue: selectedCity,
                                        setValue: (value) {
                                          if (DropdownString.selectCity ==
                                              value!) {
                                            return;
                                          }
                                          setState(() {
                                            selectedCity = city.firstWhere(
                                                (element) =>
                                                    element.name == value);
                                          });
                                        },
                                        isValidDrop: selectedState != null,
                                        alertMsg: AlertString.selectState);
                                  }),
                                  Text(
                                    'Experience',
                                    style: blackDarkO40M14,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Container(
                                                width:
                                                    Sizeconfig.screenWidth! / 2,
                                                child:
                                                    NumberTextFormFieldWidget(
                                                        text: "Experience From",
                                                        control:
                                                            experienceInFromController,
                                                        isRequired: true,
                                                        onTap: () {
                                                          if (selectedExperienceFromType ==
                                                              null) {
                                                            return showSnack(
                                                                context:
                                                                    context,
                                                                msg:
                                                                    "Please select experience  type first",
                                                                type: 'error');
                                                          }
                                                        },
                                                        enableInterative: false,
                                                        type:
                                                            selectedExperienceFromType !=
                                                                    null
                                                                ? TextInputType
                                                                    .number
                                                                : TextInputType
                                                                    .none),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: SizedBox(
                                                width: Sizeconfig.screenWidth! /
                                                    2.3,
                                                child: dynamicDropDown(
                                                  context,
                                                  label: DropdownString
                                                      .selectExperienceType,
                                                  dropDownList:
                                                      experiencePeriodType,
                                                  selectingValue:
                                                      selectedExperienceFromType,
                                                  setValue: (value) {
                                                    if (DropdownString
                                                            .selectExperienceType ==
                                                        value!) {
                                                      selectedExperienceFromType =
                                                          null;
                                                      setState(() {});
                                                      return;
                                                    }
                                                    selectedExperienceFromType =
                                                        experiencePeriodType!
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .name ==
                                                                    value);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("To"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Container(
                                                width:
                                                    Sizeconfig.screenWidth! / 2,
                                                child:
                                                    NumberTextFormFieldWidget(
                                                        text: "Experience To",
                                                        control:
                                                            experienceInToController,
                                                        enableInterative: false,
                                                        onTap: () {
                                                          if (selectedExperienceToType ==
                                                              null) {
                                                            return showSnack(
                                                                context:
                                                                    context,
                                                                msg:
                                                                    "Please select experience type first",
                                                                type: 'error');
                                                          }
                                                        },
                                                        type:
                                                            selectedExperienceToType !=
                                                                    null
                                                                ? TextInputType
                                                                    .number
                                                                : TextInputType
                                                                    .none,
                                                        isRequired: true),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: SizedBox(
                                                width: Sizeconfig.screenWidth! /
                                                    2.3,
                                                child: dynamicDropDown(
                                                  context,
                                                  label: DropdownString
                                                      .selectExperienceType,
                                                  dropDownList:
                                                      experiencePeriodType,
                                                  selectingValue:
                                                      selectedExperienceToType,
                                                  setValue: (value) {
                                                    if (DropdownString
                                                            .selectExperienceType ==
                                                        value!) {
                                                      selectedExperienceToType =
                                                          null;
                                                      setState(() {});
                                                      return;
                                                    }
                                                    selectedExperienceToType =
                                                        experiencePeriodType!
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .name ==
                                                                    value);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  dynamicDropDown(context,
                                      label: DropdownString.selectSalary,
                                      dropDownList: salaryType,
                                      selectingValue: selectedSalaryType,
                                      setValue: (value) {
                                    if (DropdownString.selectSalary == value!) {
                                      selectedSalaryType = null;
                                      return;
                                    }
                                    selectedSalaryType = salaryType!.firstWhere(
                                        (element) => element.name == value);
                                  })
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Sizeconfig.screenHeight! / 6,
                        ),
                        SizedBox(
                          height: 40,
                          width: Sizeconfig.screenHeight! / 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: MyAppColor.orangedark,
                            ),
                            child: ElavatedButtons(
                              func: () async {
                                await filterJobPageWithData(
                                    jobTitle: jobTitle.text,
                                    cityId: checkReturnId(selectedCity),
                                    expFrom: calculateExperience(
                                        experienceInFromController,
                                        selectedExperienceFromType),
                                    expTo: calculateExperience(
                                        experienceInToController,
                                        selectedExperienceToType),
                                    industryId: checkReturnId(selectedIndustry),
                                    salaryType: selectedSalaryType != null
                                        ? selectedSalaryType!.key
                                        : null,
                                    sectorId: checkReturnId(selectedSector),
                                    stateId: checkReturnId(selectedState));
                              },
                              myHexColor: MyAppColor.orangedark,
                              text: 'SEARCH JOBS',
                              // myHexColor: MyAppColor.orangelight,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(child: jobtitleResponse(context)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      DynamicDropDownListOfFields(
                        label: DropdownString.selectIndustry,
                        dropDownList: industry,
                        selectingValue: selectedIndustry,
                        setValue: (value) async {
                          if (DropdownString.selectIndustry == value!) {
                            return;
                          }
                          selectedSector = null;
                          selectedIndustry = industry
                              .firstWhere((element) => element.name == value);
                          await ref
                              .read(listData)
                              .fetchSectors(context, selectedIndustry!.id);
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      sectorREsponsive(),
                      SizedBox(
                        width: 8,
                      ),
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
                          selectedCity = null;
                          await ref
                              .read(listData)
                              .fetchCity(context, id: selectedState!.id);
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      cityResponisve(),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          if (userData != null) {
                            await filterJobPageWithData(
                                jobTitle: jobTitle.text,
                                cityId: checkReturnId(selectedCity),
                                industryId: checkReturnId(selectedIndustry),
                                sectorId: checkReturnId(selectedSector),
                                stateId: checkReturnId(selectedState));
                          } else {
                            if (!Responsive.isDesktop(context)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            } else {
                              showDialog(
                                context: context,
                                routeSettings:
                                    const RouteSettings(name: Login.route),
                                builder: (_) => Container(
                                  constraints: BoxConstraints(
                                      maxWidth: Sizeconfig.screenWidth! / 2.9),
                                  child: Dialog(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            Sizeconfig.screenWidth! / 2.9,
                                        vertical: 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(00),
                                    ),
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          Container(
                                            color: Colors.transparent,
                                            margin: EdgeInsets.only(
                                              right: 25,
                                            ),
                                            child: Login(),
                                          ),
                                          Positioned(
                                            right: 0.0,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                padding: EdgeInsets.all(5),
                                                color:
                                                    MyAppColor.backgroundColor,
                                                alignment: Alignment.topRight,
                                                child: Image.asset(
                                                    'assets/back_buttons.png'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Container(
                            padding: EdgeInsets.all(6),
                            height: 40,
                            width: 33,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: MyAppColor.orangelight,
                            ),
                            child: Image.asset(
                              'assets/search_image.png',
                              height: 6,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      );
    });
  }

  Consumer cityResponisve() {
    return Consumer(builder: (context, watch, child) {
      List<City> city = ref.watch(listData).city;
      return DynamicDropDownListOfFields(
          label: DropdownString.selectCity,
          dropDownList: city,
          selectingValue: selectedCity,
          setValue: (value) {
            if (DropdownString.selectCity == value!) {
              return;
            }
            setState(() {
              selectedCity =
                  city.firstWhere((element) => element.name == value);
            });
          },
          isValidDrop: selectedState != null,
          alertMsg: AlertString.selectState);
    });
  }

  Widget sectorREsponsive() {
    return Consumer(builder: (context, watch, child) {
      List<Sector> sector = ref.watch(listData).sector;

      return DynamicDropDownListOfFields(
          label: DropdownString.selectSector,
          dropDownList: sector,
          selectingValue: selectedSector,
          setValue: (value) {
            if (DropdownString.selectSector == value!) {
              return;
            }
            selectedSector =
                sector.firstWhere((element) => element.name == value);
          },
          isValidDrop: selectedIndustry != null,
          alertMsg: AlertString.selectIndustry);
    });
  }

  Widget jobtitleResponse(BuildContext context) {
    return SizedBox(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 6,
      child: TextFormFieldWidget(
        text: 'Search by job title..',
        type: TextInputType.multiline,
        control: jobTitle,
        isRequired: false,
        textStyle:
            !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M10,
      ),
    );
  }

  dropDownListOfFields(
      {String? label, List? dropDownList, selectingValue, Function? setValue}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // height: Responsive.isMobile(context) ? 46 : 35,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MyAppColor.white),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              )),
              validator: (value) {
                if (selectingValue == null) return "Select ${label}";
                return null;
              },
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              value: selectingValue != null ? selectingValue : label,
              icon: IconFile.arrow,
              iconSize: 25,
              elevation: 16,
              style: TextStyle(color: MyAppColor.blackdark),
              onChanged: (String? newValue) => setValue!(newValue),
              items: [
                DropdownMenuItem<String>(
                  value: label,
                  child: Text(
                    "${label}",
                    style: blackDarkO40M14,
                  ),
                ),
                ...dropDownList!.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text("$value", style: blackDarkM14()),
                    );
                  },
                )
              ]),
        ),
      ),
    );
  }

  Padding dynamicDropDown(BuildContext context,
      {label, dropDownList, selectingValue, setValue, isValidDrop, alertMsg}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 0 : 4, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 9),
        height:
            Responsive.isMobile(context) ? 46 : Sizeconfig.screenHeight! / 22,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  )),
                  value: selectingValue != null ? selectingValue.name : label,
                  icon: IconFile.arrow,
                  iconSize: Responsive.isMobile(context) ? 25 : 17,
                  elevation: 16,
                  style: TextStyle(color: MyAppColor.blackdark),
                  // underline: Container(
                  //   height: 3,
                  //   width: MediaQuery.of(context).size.width,
                  //   color: MyAppColor.blackdark,
                  // ),
                  validator: (value) {
                    if (selectingValue == null) return "Select ${label}";
                    return null;
                  },
                  onChanged: (String? newValue) => setValue!(newValue),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!isValidDrop) {
                      showSnack(
                          context: context, msg: "$alertMsg", type: 'error');
                    }
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: label,
                      child: Text(
                        "${label}",
                        style: TextStyle(
                            fontSize: Responsive.isMobile(context) ? null : 11,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...dropDownList!.map(
                      (value) {
                        return DropdownMenuItem(
                          value: value.name.toString(),
                          child: Text(
                            getCapitalizeString(value.name),
                            style: TextStyle(
                                fontSize:
                                    Responsive.isMobile(context) ? null : 11,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Padding _industry(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 8 : 4, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 9),
        height:
            Responsive.isMobile(context) ? 46 : Sizeconfig.screenHeight! / 22,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton<String>(
                value: DropdownString.selectIndustry,
                icon: IconFile.arrow,
                iconSize: Responsive.isMobile(context) ? 25 : 17,
                elevation: 16,
                style: TextStyle(color: MyAppColor.blackdark),
                underline: Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  color: MyAppColor.blackdark,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    DropdownString.selectIndustry = newValue!;
                  });
                },
                items: ListDropdown.selectIndustries
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: Responsive.isMobile(context) ? null : 11,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _salery(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 8 : 4, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 9),
        height:
            Responsive.isMobile(context) ? 46 : Sizeconfig.screenHeight! / 22,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton<String>(
                value: DropdownString.salery,
                icon: IconFile.arrow,
                iconSize: Responsive.isMobile(context) ? 25 : 17,
                elevation: 16,
                style: TextStyle(color: MyAppColor.blackdark),
                underline: Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  color: MyAppColor.blackdark,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    DropdownString.salery = newValue!;
                  });
                },
                items: ListDropdown.saleries
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: Responsive.isMobile(context) ? null : 11,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _jobsTitleHere() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 8 : 4,
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 30),
        width: Sizeconfig.screenWidth! / 8,
        child: TextfieldWidget(
          text: 'Jobs Title here',
        ),
      ),
    );
  }
}
