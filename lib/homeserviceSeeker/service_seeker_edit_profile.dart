// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/body/transaparent_body.dart';
import 'package:hindustan_job/widget/buttons/submit_elevated_button.dart';
import 'package:hindustan_job/widget/drop_down_widget/custom_dropdown.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:hindustan_job/widget/text/date_picker.dart';
import 'package:hindustan_job/widget/text/non_editable_text.dart';
import 'package:hindustan_job/widget/text/text_editable.dart';
import 'package:hindustan_job/widget/text/title_edit_head.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../candidate/header/back_text_widget.dart';
import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../candidate/pages/landing_page/home_page.dart';
import '../widget/common_app_bar_widget.dart';
import '../widget/drop_down_widget/static_dropdown_widget.dart';

class ServiceSeekerEditProfile extends ConsumerStatefulWidget {
  bool isShowAppBar;
  ServiceSeekerEditProfile({Key? key, this.isShowAppBar = false})
      : super(key: key);

  @override
  ConsumerState<ServiceSeekerEditProfile> createState() =>
      _ServiceSeekerEditProfileState();
}

class _ServiceSeekerEditProfileState
    extends ConsumerState<ServiceSeekerEditProfile> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _groupValue = -1;
  File? croppedFile;
  PlatformFile? logo;
  int _radioSelected = 1;
  File? newprofile;
  String? showSelectedDate;
  String? selectedDate =
      userData!.dob != null ? dateFormat(userData!.dob) : null;
  late String _radioVal;
  TextEditingController fullNameController =
      TextEditingController(text: userData != null ? userData!.name : "");
  TextEditingController phoneNumberController =
      TextEditingController(text: userData != null ? userData!.mobile : "");
  TextEditingController addressController = TextEditingController(
      text: userData != null ? userData!.addressLine1 : "");
  TextEditingController address2Controller = TextEditingController(
      text: userData != null ? userData!.addressLine2 : "");
  TextEditingController pinCodeController =
      TextEditingController(text: userData != null ? userData!.pinCode : "");
  DateTime currentDate = DateTime.now();
  DateTime currentYearDate = DateTime.now();
  String? selectedGender =
      userData!.gender != null ? getCapitalizeString(userData!.gender) : null;
  var _formCurrentJobKey = GlobalKey<FormState>();
  TabController? _control;
  final picker = ImagePicker();
  List<States> state = [];
  States? selectedState;
  List<City> city = [];
  City? selectedCity;
  List<PostOffice> postOffices = [];

  @override
  void initState() {
    super.initState();
    fetchState();
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
    city = await fetchCities(context, stateId: id.toString());
    if (userData != null && pinLocation == null) {
      selectedCity = userData!.city;
    }
    setState(() {});
  }

  saveRegisterEditProfile({
    name,
    mobile,
    stateId,
    cityId,
    gender,
    pinCode,
    address2,
    dob,
    image,
    address,
  }) async {
    if (image == null && userData!.image == null) {
      return showSnack(context: context, msg: "Select image", type: 'error');
    }
    Map<String, dynamic> editData = {
      "name": name,
      "mobile": mobile,
      "state_id": stateId,
      "city_id": cityId,
      "pin_code": pinCode,
      "address_line1": address,
      "address_line2": address2,
      "dob": dob,
      "gender": gender.toString().toLowerCase(),
    };
    if (image != null) {
      editData["image"] = kIsWeb
          ? MultipartFile.fromBytes(image.bytes, filename: image!.name)
          : await MultipartFile.fromFile(image.path,
              filename: image.path.toString().split('/').last);
    }
    ApiResponse response = await editUserProfile(editData);
    if (response.status == 200) {
      ApiResponse profileResponse = await getProfile(userData!.resetToken);
      UserData user = UserData.fromJson(profileResponse.body!.data);
      await setUserData(user);
      ref.read(userDataProvider).updateUserData(user);
      showSnack(context: context, msg: response.body!.message);
      Navigator.pop(context);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: !kIsWeb && !widget.isShowAppBar
          ? PreferredSize(
              child: BackWithText(text: "HOME /EDIT PROFILE"),
              preferredSize: Size.fromHeight(50))
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(Responsive.isDesktop(context) ? 150 : 150),
              child: CommomAppBar(
                drawerKey: _drawerKey,
                back: "HOME /EDIT PROFILE",
              ),
            ),
      body: ListView(
        children: [
          basicDetails(),
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

  basicDetails() {
    bool isCompany =
        userData!.userRoleType == RoleTypeConstant.company ? true : false;
    return Column(
      children: [
        TitleEditHead(title: 'PERSONAL DETAILS'),
        !Responsive.isDesktop(context)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  onTap: () async {
                    await _showChoiceDialog(context);
                  },
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

                    child: newprofile == null
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
                            image: FileImage(newprofile!),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: InkWell(
                  onTap: () {
                    webGallery(context);
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
                      child: logo == null
                          ? currentUrl(userData!.image) != null
                              ? Image.network(
                                  "${currentUrl(userData!.image)}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/profileIcon.png',
                                      height: 36,
                                      width: 36,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.camera_alt_outlined,
                                  color: MyAppColor.white,
                                  size: 30,
                                )
                          : Image.memory(
                              logo!.bytes!,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
        !Responsive.isDesktop(context)
            ? Column(
                children: [
                  NonEditableTextField(
                      label: isCompany
                          ? LabelString.companyName
                          : LabelString.fullName,
                      value: fullNameController.text),
                  SizedBox(
                    height: 20,
                  ),
                  NonEditableTextField(
                      label: isCompany
                          ? LabelString.companyMobileNumber
                          : LabelString.mobileNumber,
                      value: phoneNumberController.text),
                  SizedBox(
                    height: 20,
                  ),
                  NonEditableTextField(
                      label: isCompany
                          ? LabelString.companyEmail
                          : LabelString.email,
                      value: userData!.email!),
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
                  SizedBox(
                    height: 20,
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
                      await fetchCity(selectedState!.id,
                          pinLocation: 'fetchLocation');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: DynamicDropDownListOfFields(
                      label: DropdownString.selectCity,
                      dropDownList: city,
                      selectingValue: selectedCity,
                      setValue: (value) async {
                        if (DropdownString.selectCity == value!) {
                          return;
                        }
                        setState(() {
                          selectedCity = city
                              .firstWhere((element) => element.name == value);
                        });
                      },
                    ),
                  ),
                  Column(children: [
                    TextEditable(
                        label: LabelString.address,
                        controller: addressController),
                    TextEditable(
                        label: LabelString.flatNoBuild,
                        controller: address2Controller),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  SubmitElevatedButton(
                    label: "Save",
                    onSubmit: () async {
                      FocusScope.of(context).unfocus();

                      await saveRegisterEditProfile(
                        name: fullNameController.text,
                        mobile: phoneNumberController.text,
                        dob: showSelectedDate != null
                            ? selectedDate
                            : dateServerFormat(userData!.dob),
                        gender: selectedGender,
                        stateId: selectedState!.id,
                        cityId: selectedCity!.id,
                        pinCode: pinCodeController.text,
                        image: croppedFile,
                        address: addressController.text,
                        address2: address2Controller.text,
                      );
                    },
                  )
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 1.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: NonEditableTextField(
                                label: LabelString.fullName,
                                value: fullNameController.text),
                          )),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: NonEditableTextField(
                                label: LabelString.mobileNumber,
                                value: phoneNumberController.text),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 1.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 00.0),
                            child: StaticDropDownWidget(
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
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12),
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 1.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: TextEditable(
                                label: LabelString.pinCode,
                                controller: pinCodeController),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, bottom: 15),
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 1.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (city.isNotEmpty)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: CustomDropdown(
                                  label: DropdownString.selectCity,
                                  dropDownList: city,
                                  selectingValue: selectedCity,
                                  setValue: (value) async {
                                    if (DropdownString.selectCity == value!) {
                                      return;
                                    }
                                    setState(() {
                                      selectedCity = city.firstWhere(
                                          (element) => element.name == value);
                                    });
                                  },
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 1.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextEditable(
                                label: LabelString.address,
                                controller: addressController),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: TextEditable(
                                label: LabelString.flatNoBuild,
                                controller: address2Controller),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: SubmitElevatedButton(
                        label: "Save",
                        onSubmit: () async {
                          FocusScope.of(context).unfocus();
                          await saveRegisterEditProfile(
                            name: fullNameController.text,
                            mobile: phoneNumberController.text,
                            dob: showSelectedDate != null
                                ? selectedDate
                                : dateServerFormat(userData!.dob),
                            gender: selectedGender,
                            stateId: selectedState!.id,
                            cityId: selectedCity!.id,
                            pinCode: pinCodeController.text,
                            image: logo,
                            address: addressController.text,
                            address2: address2Controller.text,
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
      ],
    );
  }

  Widget cityL(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
              value: DropdownString.city,
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
                setState(() {
                  DropdownString.city = newValue!;
                });
              },
              items: ListDropdown.cities
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: blackDarkOpacityM12(),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget stateL(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 00),
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
              value: DropdownString.state,
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
                setState(() {
                  DropdownString.state = newValue!;
                });
              },
              items: ListDropdown.states
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: blackDarkOpacityM12(),
                  ),
                );
              }).toList(),
            ),
          ),
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
          title: Text(
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
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      newprofile = croppedFile;
    });
  }

  Future _openGallery(context) async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        cropImage(context, pickedFile.path);
        Navigator.pop(context);
      } else {}
    });
  }

  Future webGallery(context) async {
    var result = await FilePicker.platform.pickFiles();
    setState(() {
      if (result != null) {
        logo = result.files.single;
        // bytesFromPicker = result.files.single as Uint8List?;
      } else {}
    });
  }

  Future _openCamera(context) async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        cropImage(context, pickedFile.path);
        Navigator.pop(context);
      } else {}
    });
  }
}
