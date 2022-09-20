// ignore_for_file: void_checks, prefer_const_constructors, avoid_unnecessary_containers, must_be_immutable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/custom_job_alert_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/custom_job_alert_list_page.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';

import '../../header/back_text_widget.dart';

class CustomJobAlerts extends ConsumerStatefulWidget {
  CustomAlert? customJobAlertData;
  bool isFromConnectedRoutes;
  CustomJobAlerts(
      {Key? key, this.customJobAlertData, required this.isFromConnectedRoutes})
      : super(key: key);

  static const String route = '/custom-job-alert';

  @override
  ConsumerState<CustomJobAlerts> createState() => _CustonJobalertsState();
}

class _CustonJobalertsState extends ConsumerState<CustomJobAlerts> {
  Industry? selectedJobRoleType;
  Industry? selectedIndustry;
  Sector? selectedSector;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  States? selectedState;
  City? selectedCity;
  UserData? selectedCompany;
  String? selectedCompanyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listData).checkData();
    });
    setData();
  }

  setData() async {
    if (widget.customJobAlertData != null && ref.read(listData).isData) {
      selectedIndustry = widget.customJobAlertData!.industry;
      await ref.read(listData).fetchSectors(context, selectedIndustry!.id);
      selectedSector = widget.customJobAlertData!.sector;
      selectedState = widget.customJobAlertData!.state;
      await ref.read(listData).fetchCity(context, id: selectedState!.id);
      selectedCity = widget.customJobAlertData!.city;
      selectedCompany = widget.customJobAlertData!.user;
      pinCodeController.text =
          (widget.customJobAlertData!.pincode ?? '').toString();
      selectedJobRoleType = widget.customJobAlertData!.jobRoleType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        key: _drawerKey,
        drawer: const Drawer(
          child: DrawerJobSeeker(),
        ),
        appBar: widget.isFromConnectedRoutes
            ? PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: BackWithText(text: 'Home/Custom Job Alerts'))
            : CustomAppBar(
                context: context,
                drawerKey: _drawerKey,
                back: 'Home/Custom Job Alerts',
              ),
        body: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(
                children: [
                  Container(
                    //color: MyAppColor.greynormal,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        !Responsive.isDesktop(context)
                            ? text()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25.0),
                                child: SizedBox(
                                  width: Sizeconfig.screenWidth! / 2,
                                  child: text(),
                                ),
                              ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: Responsive.isDesktop(context)
                              ? Sizeconfig.screenWidth! / 3.5
                              : Sizeconfig.screenWidth!,
                          child: _body(styles, context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  if (Responsive.isDesktop(context)) Footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget text() {
    return Text(
      "What if company itself reaches out to you?  \nCustomize your job alerts to get placements of your choice.",
      textAlign: TextAlign.center,
    );
  }

  bool checkNullValue(label, value) {
    if (value == null) {
      showSnack(context: context, msg: "Please $label", type: 'error');
      return true;
    }
    return false;
  }

  clearData() {
    selectedIndustry = null;
    selectedCity = null;
    selectedSector = null;
    selectedState = null;
    selectedCompany = null;
    selectedJobRoleType = null;
    setState(() {});
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
      setState(() {});
    }
  }

  createCustomJobAlert(
      {selectedIndustry,
      selectedJobRoleType,
      selectedSector,
      selectedState,
      pincode,
      selectedCity,
      selectedCompany}) async {
    if (selectedJobRoleType == null) {
      return showSnack(
          context: context, msg: "Please select job role", type: 'error');
    } else if (selectedSector == null) {
      return showSnack(
          context: context, msg: "Please select sector", type: 'error');
    } else if (selectedCity == null) {
      return showSnack(
          context: context, msg: "Please select city", type: 'error');
    } else if (selectedCompany == null) {
      return showSnack(
          context: context, msg: "Please select company", type: 'error');
    }
    var createJobAlertData = {
      "industry_id": selectedIndustry.id,
      "sector_id": selectedSector.id,
      "job_role_type_id": selectedJobRoleType.id,
      "state_id": selectedState.id,
      "city_id": selectedCity.id,
      "company_id": selectedCompany,
      "pin_code": pincode
    };
    ApiResponse response;
    String msg;
    if (widget.customJobAlertData != null) {
      createJobAlertData['id'] = widget.customJobAlertData!.id;
      msg = "Updated";
      response = await editUserCustomAlert(createJobAlertData);
    } else {
      msg = "Created";
      response = await addCustomAlert(createJobAlertData);
    }
    if (response.status == 200) {
      await showSnack(
          context: context, msg: "Custom Job Alert $msg Successfully");
      await clearData();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CustomJobAlertList()));
    } else {
      return showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  Widget _body(TextStyle styles, BuildContext context) {
    return Container(
      color: MyAppColor.greynormal,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: !Responsive.isDesktop(context)
                      ? EdgeInsets.all(20)
                      : EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  alignment: Alignment.center,
                  color: MyAppColor.greylight,
                  // height: Sizeconfig.screenHeight! / 10,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Free ',
                        textAlign: TextAlign.center,
                        style: whiteSb12(),
                      ),
                      Text(
                        'Custom Job Alert ',
                        style: whiteSb12(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/contact-image.png', height: 18),
                      Image.asset(
                        'assets/contact-image-down.png',
                        height: 18,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 00,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/contact-page-downs.png', height: 18),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 00,
                  right: 00,
                  child:
                      Image.asset('assets/contact-image-left.png', height: 18),
                ),
              ],
            ),
            Consumer(builder: (context, ref, child) {
              List<Industry> industry = ref.watch(listData).industry;
              List<Sector> sector = ref.watch(listData).sector;
              List<States> states = ref.watch(listData).state;
              List<City> city = ref.watch(listData).city;
              List<Industry> jobRoleTypes = ref.watch(listData).jobRoleTypes;
              List<UserData> companyList = ref.watch(listData).companyList;
              return Padding(
                padding: !Responsive.isDesktop(context)
                    ? EdgeInsets.symmetric()
                    : EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                child: Column(
                  children: [
                    dynamicDropDownListOfFields(
                      label: DropdownString.jobRoleType,
                      dropDownList: jobRoleTypes,
                      selectingValue: selectedJobRoleType,
                      setValue: (value) async {
                        if (DropdownString.jobRoleType == value!) {
                          return;
                        }
                        selectedJobRoleType = jobRoleTypes.firstWhere(
                            (element) => element.name.toString() != value);
                      },
                    ),
                    dynamicDropDownListOfFields(
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
                            .watch(listData)
                            .fetchSectors(context, selectedIndustry!.id);
                      },
                    ),
                    dynamicDropDownListOfFields(
                        label: DropdownString.selectSector,
                        dropDownList: sector,
                        selectingValue: selectedSector,
                        setValue: (value) {
                          if (DropdownString.selectSector == value!) {
                            return;
                          }
                          selectedSector = sector
                              .firstWhere((element) => element.name == value);
                        },
                        isValidDrop: selectedIndustry != null,
                        alertMsg: AlertString.selectIndustry),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 15),
                      child: NumberTextFormFieldWidget(
                        text: LabelString.pinCode,
                        control: pinCodeController,
                        type: TextInputType.number,
                        maxLength: 6,
                        onChanged: (value) async {
                          if (value.length == 6) {
                            await setLocationOnTheBasisOfPinCode(value);
                          }
                        },
                        isRequired: false,
                      ),
                    ),
                    dynamicDropDownListOfFields(
                      label: DropdownString.selectState,
                      dropDownList: states,
                      selectingValue: selectedState,
                      setValue: (value) async {
                        if (DropdownString.selectState == value!) {
                          return;
                        }
                        selectedCity = null;
                        selectedState = states.firstWhere(
                            (element) => element.name.toString() == value);
                        await ref
                            .watch(listData)
                            .fetchCity(context, id: selectedState!.id);
                      },
                    ),
                    dynamicDropDownListOfFields(
                        label: DropdownString.selectCity,
                        dropDownList: city,
                        selectingValue: selectedCity,
                        setValue: (value) {
                          if (DropdownString.selectCity == value!) {
                            return;
                          }
                          setState(() {
                            selectedCity = city
                                .firstWhere((element) => element.name == value);
                          });
                        },
                        isValidDrop: selectedState != null,
                        alertMsg: AlertString.selectState),
                    dynamicSelectDropDownListOfFields(
                      label: DropdownString.company,
                      dropDownList: companyList,
                      selectingValue: selectedCompany,
                      setValue: (value) {
                        if (DropdownString.company == value!) {
                          return;
                        }
                        selectedCompany = companyList
                            .where((element) => element.id.toString() == value)
                            .first;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.customJobAlertData == null)
                            ElevatedButton(
                              child: Text(
                                'Created Alert',
                                style: blackDarkR14(),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomJobAlertList()));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        MyAppColor.grayplane),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            child: Padding(
                              padding: !Responsive.isDesktop(context)
                                  ? EdgeInsets.all(0.0)
                                  : EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                '${widget.customJobAlertData != null ? 'UPDATE' : 'GET'} JOB ALERTS',
                                style: whiteR12(),
                              ),
                            ),
                            onPressed: () {
                              if (checkNullValue(DropdownString.selectIndustry,
                                      selectedIndustry) ||
                                  checkNullValue(DropdownString.selectSector,
                                      selectedSector) ||
                                  checkNullValue(DropdownString.selectState,
                                      selectedState) ||
                                  checkNullValue(DropdownString.selectCity,
                                      selectedCity)) {
                                return;
                              }
                              if (selectedCompany == null) {
                                return showSnack(
                                    context: context,
                                    msg: "Select company",
                                    type: 'error');
                              }
                              createCustomJobAlert(
                                  selectedIndustry: selectedIndustry,
                                  selectedSector: selectedSector,
                                  selectedState: selectedState,
                                  selectedCity: selectedCity,
                                  pincode: pinCodeController.text.trim(),
                                  selectedJobRoleType: selectedJobRoleType,
                                  selectedCompany: selectedCompany!.id);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyAppColor.orangelight),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  _back() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: 30,
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
            Text("HOME(JOB-SEEKER) / CUSTOM JOB ALERT",
                style: GoogleFonts.darkerGrotesque(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  dynamicDropDownListOfFields(
      {String? label,
      List? dropDownList,
      selectingValue,
      Function? setValue,
      bool isValidDrop = true,
      String? alertMsg}) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
                if (!isValidDrop) {
                  showSnack(context: context, msg: "$alertMsg", type: 'error');
                }
              },
              value: selectingValue != null ? selectingValue.name : label,
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
                      value: value.name.toString(),
                      child: Text(
                        getCapitalizeString(value.name),
                        style: blackDarkM14(),
                      ),
                    );
                  },
                )
              ]),
        ),
      ),
    );
  }

  dynamicSelectDropDownListOfFields(
      {String? label,
      List? dropDownList,
      selectingValue,
      Function? setValue,
      bool isValidDrop = true,
      String? alertMsg}) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
                if (!isValidDrop) {
                  showSnack(context: context, msg: "$alertMsg", type: 'error');
                }
              },
              value:
                  selectingValue != null ? selectingValue.id.toString() : label,
              // value: selectingValue != null && dropDownList!.isNotEmpty
              //     ? selectingValue.id.toString()
              //     : label,
              icon: IconFile.arrow,
              iconSize: 25,
              elevation: 16,
              style: TextStyle(color: MyAppColor.blackdark),
              onChanged: (String? newValue) => setValue!(newValue),
              items: [
                DropdownMenuItem<String>(
                  value: label.toString(),
                  child: Text(
                    "${label}",
                    style: blackDarkO40M14,
                  ),
                ),
                ...dropDownList!.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value.id.toString(),
                      child: Text(
                        value.name.toString(),
                        style: blackDarkM14(),
                      ),
                    );
                  },
                )
              ]),
        ),
      ),
    );
  }

  // void contactid() async {
  //   var contactId = contactApi();
  //   var contactList = await contactId;
  //   var error = await contactId;
  //   if (contactList.meta!.code == 200) {
  //     var snackBar = SnackBar(
  //       content: Text(contactList.meta!.message),
  //       backgroundColor: Colors.green,
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else if (contactList.meta!.code == 400) {
  //     var snackBar = SnackBar(
  //       content: Text(contactList.meta!.message),
  //       backgroundColor: Colors.red,
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else {
  //     var snackBar = SnackBar(
  //       content: Text(contactList.meta!.message),
  //       backgroundColor: Colors.red,
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

}
