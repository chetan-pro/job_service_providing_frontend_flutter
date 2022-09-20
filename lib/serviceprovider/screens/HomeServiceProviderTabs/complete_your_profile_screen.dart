// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, unused_import, prefer_const_literals_to_create_immutables, await_only_futures, avoid_print, unnecessary_null_comparison, duplicate_import, unnecessary_cast

import 'dart:io';
import 'dart:io' as i;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/candidate_data_model.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/document_data.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/register_page/register_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/add_a_service_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_profile.dart';
import 'package:hindustan_job/serviceprovider/screens/edit_branch.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/service_provider.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/submit_elevated_button.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/select_file.dart';
import 'package:hindustan_job/widget/text/non_editable_text.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import '../../../candidate/header/back_text_widget.dart';
import '../../../candidate/pages/landing_page/home_page.dart';
import '../../../candidate/pages/resume_builder_form.dart';
import '../../../widget/common_app_bar_widget.dart';
import '../../../widget/drop_down_widget/custom_dropdown.dart';
import '../../../widget/drop_down_widget/static_dropdown_widget.dart';
import '../../../widget/number_input_text_form_field_widget.dart';
import '../../../widget/text/date_picker.dart';
import '../../../widget/text/text_editable.dart';

Documents? docum;

class CompleteYourProfileScreen extends ConsumerStatefulWidget {
  bool isShowAppBar;
  CompleteYourProfileScreen({Key? key, this.isShowAppBar = false})
      : super(
          key: key,
        );

  @override
  _CompleteYourProfileScreenState createState() =>
      _CompleteYourProfileScreenState();
}

class _CompleteYourProfileScreenState
    extends ConsumerState<CompleteYourProfileScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  DateTime currentDate = DateTime.now();
  DateTime currentYearDate = DateTime.now();
  // File? croppedFile;

  List<States> state = [];
  States? selectedState;
  List<City> city = [];
  City? selectedCity;
  final picker = ImagePicker();

  var croppedFile;
  PlatformFile? logo;
  String? selectedGender =
      userData!.gender != null ? getCapitalizeString(userData!.gender) : null;

  TabController? _control;
  String? showSelectedDate;
  var main_image;
  String? selectedDate =
      userData!.dob != null ? dateFormat(userData!.dob) : null;
  TextEditingController fullNameController =
      TextEditingController(text: userData != null ? userData!.name : "");
  TextEditingController emailController =
      TextEditingController(text: userData != null ? userData!.email : "");
  TextEditingController MobileController =
      TextEditingController(text: userData != null ? userData!.mobile : "");
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  TextEditingController addressLine1Controller = TextEditingController(
      text: userData != null ? userData!.addressLine1 : "");
  TextEditingController addressLine2Controller = TextEditingController(
      text: userData != null ? userData!.addressLine2 : "");
  TextEditingController pincodeController =
      TextEditingController(text: userData != null ? userData!.pinCode : "");
  TextEditingController experienceController = TextEditingController();
  TextEditingController uniqueIdNumberController = TextEditingController();
  List<Hobbies> documentList = [];
  @override
  void initState() {
    super.initState();
    for (var element in ListDropdown.documents) {
      documentList.add(Hobbies.fromJson(element));
    }

    ref.read(serviceProviderData).documetFetchData();
    fetchState();
    fetchDataDoc();
  }

  fetchDataDoc() async {
    docum = await ref.read(serviceProviderData).documetFetchData();
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
      selectedCity = userData!.city as City?;
    }
    setState(() {});
  }

  List<PostOffice> postOffices = [];

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

  saveRegisterEditProfile({
    name,
    mobile,
    stateId,
    cityId,
    gender,
    pinCode,
    address1,
    address2,
    dob,
    image,
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
      "gender": gender.toString().toLowerCase(),
      "dob": dob,
      "address_line1": address1,
      "address_line2": address2,
    };
    if (image != null) {
      editData["image"] = await kIsWeb
          ? MultipartFile.fromBytes(image.bytes, filename: image!.name)
          : await MultipartFile.fromFile(image.path,
              filename: image.path.toString().split('/').last);
    }
    ApiResponse response = await editUserProfile(editData);
    if (response.status == 200) {
      UserData userData = UserData.fromJson(response.body!.data);
      ApiResponse profileResponse = await getProfile(userData.resetToken);
      UserData user = UserData.fromJson(profileResponse.body!.data);
      setUserData(user);
      await setUserData(user);
      ref.read(userDataProvider).updateUserData(user);
      setState(() {});
      showSnack(context: context, msg: response.body!.message);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return DefaultTabController(
      length: 2,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(statusBarColor: MyAppColor.backgroundColor),
        child: SafeArea(
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            backgroundColor: MyAppColor.backgroundColor,
            appBar: !kIsWeb && !widget.isShowAppBar
                ? PreferredSize(
                    child: BackWithText(
                        text: "HOME (HOME-SERVICE-PROIVIDER) /EDIT PROFILE"),
                    preferredSize: Size.fromHeight(50))
                : PreferredSize(
                    preferredSize: Size.fromHeight(
                        Responsive.isDesktop(context) ? 150 : 150),
                    child: CommomAppBar(
                      drawerKey: _drawerKey,
                      back: "HOME (HOME-SERVICE-PROIVIDER) /EDIT PROFILE",
                    ),
                  ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    child: _tab(),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: BouncingScrollPhysics(),
                      controller: _control,
                      children: [
                        Responsive.isDesktop(context)
                            ? personalDesktopDetails()
                            : personalDetails(),
                        document(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  personalDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SizedBox(height: sizeBoxHeight),
            greyHeaderContainer(text: 'PERSONAL DETAILS'),
            SizedBox(height: sizeBoxHeight),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                onTap: () async {
                  await _showChoiceDialog(context);
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
                      : Image(
                          image: FileImage(croppedFile!),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SizedBox(height: sizeBoxHeight),

            NonEditableTextField(
                value: fullNameController.text, label: 'Full name'),
            SizedBox(height: 15),
            NonEditableTextField(
                value: MobileController.text, label: ' Mobile Number'),
            SizedBox(height: 15),
            NonEditableTextField(
              value: emailController.text,
              label: 'Email',
            ),
            SizedBox(height: sizeBoxHeight),
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
            _datePicker(context, 'Date of birth',
                value: showSelectedDate ?? selectedDate,
                onSelect: (date, showDate) {
              setState(() {
                showSelectedDate = showDate;
                selectedDate = date;
              });
            }, padding: 15.0),
            TextEditable(
                label: LabelString.flatNoBuild,
                controller: addressLine2Controller),
            TextEditable(
                label: LabelString.address, controller: addressLine1Controller),
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
            SizedBox(height: 15),
            DynamicDropDownListOfFields(
              label: DropdownString.selectState,
              dropDownList: state,
              selectingValue: selectedState,
              setValue: (value) async {
                if (DropdownString.selectState == value!) {
                  return;
                }
                selectedState = state
                    .firstWhere((element) => element.name.toString() == value);
                await fetchCity(selectedState!.id,
                    pinLocation: 'fetchLocation');
              },
            ),
            SizedBox(
              height: 15,
            ),
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
                    selectedCity =
                        city.firstWhere((element) => element.name == value);
                  },
                );
              },
            ),

            saveprofileDetailsButton(
                function: () async {
                  await saveRegisterEditProfile(
                    name: fullNameController.text,
                    mobile: MobileController.text,
                    stateId: selectedState!.id,
                    cityId: selectedCity!.id,
                    gender: selectedGender,
                    pinCode: pincodeController.text,
                    address1: addressLine1Controller.text,
                    address2: addressLine2Controller.text,
                    dob: showSelectedDate != null
                        ? selectedDate
                        : dateServerFormat(userData!.dob),
                    image: croppedFile,
                  );
                },
                text: 'save'),
            // Footer()
          ],
        ),
      ),
    );
  }

  personalDesktopDetails() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: [
            SizedBox(height: sizeBoxHeight),
            greyHeaderContainer(text: 'PERSONAL DETAILS'),
            SizedBox(height: sizeBoxHeight),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                onTap: () async {
                  await webGallery(context);
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
                      : Image(
                          image: MemoryImage(croppedFile!.bytes),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SizedBox(height: sizeBoxHeight),
            SizedBox(
                width: Sizeconfig.screenWidth! / 1.9,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: NonEditableTextField(
                          value: fullNameController.text, label: 'Full name')),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: NonEditableTextField(
                          value: MobileController.text,
                          label: ' Mobile Number'))
                ])),
            SizedBox(height: 20),
            SizedBox(
                width: Sizeconfig.screenWidth! / 1.9,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: NonEditableTextField(
                        value: emailController.text,
                        label: 'Email',
                      )),
                      SizedBox(width: 20),
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
                    ])),
            SizedBox(height: 20),
            SizedBox(
                width: Sizeconfig.screenWidth! / 1.9,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                    ])),
            SizedBox(height: 20),

            SizedBox(
                width: Sizeconfig.screenWidth! / 1.9,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: editaBleTextField(
                          controller1: addressLine1Controller,
                          label1: 'Address Line 1')),
                  SizedBox(width: 20),
                  Expanded(
                      child: editaBleTextField(
                          controller1: addressLine2Controller,
                          label1: 'Address Line 2')),
                ])),
            SizedBox(height: 20),
            SizedBox(
                width: Sizeconfig.screenWidth! / 1.9,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: NumberTextFormFieldWidget(
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
                  )),
                  SizedBox(width: 20),
                  Expanded(child: SizedBox()),
                ])),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: Sizeconfig.screenWidth! / 1.9,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: DynamicDropDownListOfFields(
                    widthRatio: 2,
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
                  )),
                  SizedBox(width: 20),
                  Expanded(
                    child: DynamicDropDownListOfFields(
                      widthRatio: 2,
                      label: DropdownString.selectCity,
                      dropDownList: city,
                      selectingValue: selectedCity,
                      setValue: (value) async {
                        if (DropdownString.selectCity == value!) {
                          return;
                        }
                        setState(
                          () {
                            selectedCity = city
                                .firstWhere((element) => element.name == value);
                          },
                        );
                      },
                    ),
                  ),
                ])),

            saveprofileDetailsButton(
                function: () async {
                  await saveRegisterEditProfile(
                    name: fullNameController.text,
                    mobile: MobileController.text,
                    stateId: selectedState!.id,
                    cityId: selectedCity!.id,
                    gender: selectedGender,
                    pinCode: pincodeController.text,
                    address1: addressLine1Controller.text,
                    address2: addressLine2Controller.text,
                    dob: showSelectedDate != null
                        ? selectedDate
                        : dateServerFormat(userData!.dob),
                    image: croppedFile,
                  );
                },
                text: 'save'),
            // Footer()
          ],
        ),
      ),
    );
  }

  Padding _datePicker(BuildContext context, String text,
      {value, required Function onSelect, padding}) {
    String showValue = value;
    return Padding(
        padding: EdgeInsets.only(bottom: padding ?? 25),
        child: GestureDetector(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            var data = await showDatePicker(
              context: context,
              initialDate: currentDate,
              firstDate: DateTime(1950), // Required
              lastDate: DateTime(2023),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: MyAppColor.blackdark,
                      onPrimary: MyAppColor.backgroundColor,
                      surface: MyAppColor.backgroundColor,
                      background: MyAppColor.blackdark,
                      onBackground: MyAppColor.backgroundColor,
                      onSurface: MyAppColor.blackdark,
                    ),
                    dialogBackgroundColor: MyAppColor.backgroundColor,
                  ),
                  child: child!,
                );
              },
            );
            value = DateFormat('MM/dd/yyyy').format(data!);
            showValue = DateFormat('dd/MM/yyyy').format(data);
            onSelect(value, showValue);
          },
          child: Container(
            height: !Responsive.isDesktop(context) ? 50 : 45,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: MyAppColor.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value ?? text,
                    style: value != null ? blackDarkM14() : blackDarkO40M14),
                const Icon(
                  Icons.date_range_outlined,
                  size: 15,
                ),
              ],
            ),
          ),
        ));
  }

  Future _showChoiceDialog(BuildContext context) {
    return Responsive.isDesktop(context)
        ? webGallery(context)
        : showDialog(
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

  Future webGallery(context) async {
    var result = await selectFile();
    setState(() {
      if (result != null) {
        croppedFile = result.files.single;
      } else {}
    });
  }

  Future _openGallery(context) async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        main_image = File(pickedFile.path);
        cropImage(context, pickedFile.path);
        Navigator.pop(context);
      } else {}
    });
  }

  Future _openCamera(context) async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        main_image = File(pickedFile.path);
        cropImage(context, pickedFile.path);
        Navigator.pop(context);
      } else {}
    });
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
    setState(() {});
  }

  document() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          greyHeaderContainer(text: LabelString.idProofDocument),
          SizedBox(height: sizeBoxHeight),
          Consumer(builder: (context, ref, child) {
            var docs = ref.watch(serviceProviderData).doc;
            return docs == null
                ? SubmitElevatedButton(
                    onSubmit: () async {
                      await showDocumentWidgetDialog(context, Documents());
                    },
                    label: 'Add Document')
                : SizedBox(
                    width: Responsive.isDesktop(context)
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await ref
                                      .read(serviceProviderData)
                                      .deleteDocumentServiceData(
                                          context, docs.id);
                                },
                                icon: Icon(Icons.close))
                          ],
                        ),
                        NonEditableTextField(
                          label: LabelString.idProofDocument,
                          value: docs.documentName.toString(),
                        ),
                        SizedBox(height: sizeBoxHeight),
                        NonEditableTextField(
                          label: LabelString.idProofUniqueNumber,
                          value: docs.documentNumber.toString(),
                        ),
                        SizedBox(height: sizeBoxHeight),
                        NonEditableTextField(
                          label: LabelString.serviceExperience,
                          value: docs.serviceExperience.toString(),
                        ),
                        SizedBox(height: sizeBoxHeight),
                        containerImage(
                          image: docs.image,
                          image2: docs.imageBack,
                          size: size,
                          label: LabelString.idProofImage,
                        ),
                      ],
                    ),
                  );
          }),
        ],
      ),
    );
  }

  containerImage({label, image, image2, size}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
              Container(
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
              Container(
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

  Widget container({label, text}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width - 1150
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
            Text(
              text,
              style: blackMedium14,
            )
          ],
        ),
      ),
    );
  }

  Future showDocumentWidgetDialog(
    BuildContext context,
    Documents docs,
  ) {
    EasyLoading.show();
    var frontDocumentFile;
    var backDocumentFile;

    TextEditingController uniqueIdNumberController = TextEditingController();
    TextEditingController frontDocument = TextEditingController();
    TextEditingController backDocument = TextEditingController();
    TextEditingController serviceExperience = TextEditingController();
    Hobbies? selectedDocument;
    var _formKey = GlobalKey<FormState>();
    if (docs.id != null) {
      selectedDocument = documentList
          .firstWhere((element) => element.name == docs.documentName);
      backDocument.text = (docs.image ?? '').toString();
      uniqueIdNumberController.text = (docs.documentNumber ?? '').toString();
    }
    EasyLoading.dismiss();
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
              builder: (context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: MyAppColor.backgroundColor,
                  title: Text(
                    "Update Document",
                    style: blackdarkM12,
                  ),
                  insetPadding: EdgeInsets.all(0),
                  content: SizedBox(
                    width: !Responsive.isDesktop(context)
                        ? MediaQuery.of(context).size.width * 0.75
                        : MediaQuery.of(context).size.width / 3.5,
                    child: SingleChildScrollView(
                        child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomDropdown(
                            dropDownList: documentList,
                            label: DropdownString.document,
                            selectingValue: selectedDocument,
                            setValue: (value) {
                              if (DropdownString.document != value) {
                                setState(() {
                                  selectedDocument = documentList.firstWhere(
                                      (element) => element.name == value);
                                  uniqueIdNumberController.clear();
                                });
                              }
                            },
                          ),
                          SizedBox(height: sizeBoxHeight),
                          if (selectedDocument != null)
                            NumberTextFormFieldWidget(
                              stringAllow: selectedDocument!.id == 12
                                  ? null
                                  : selectedDocument!.name,
                              maxLength: selectedDocument!.id!,
                              control: uniqueIdNumberController,
                              text: 'ID NUMBER',
                              type: TextInputType.multiline,
                              isRequired: true,
                            ),
                          SizedBox(height: sizeBoxHeight),
                          TextFormFieldWidget(
                            control: frontDocument,
                            // controller: controller1,
                            text: "Front Image of Document",
                            onTap: () async {
                              FilePickerResult? file = await selectFile();
                              if (file == null) return;
                              setState(() {
                                frontDocumentFile = kIsWeb
                                    ? file.files.first
                                    : File(file.paths.first!);
                                frontDocument.text = kIsWeb
                                    ? file.files.first.name
                                    : file.names.first!;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            type: TextInputType.none,
                          ),
                          SizedBox(height: sizeBoxHeight),
                          TextFormFieldWidget(
                            control: backDocument,
                            // controller: controller1,
                            text: "back Image of Document",
                            onTap: () async {
                              FilePickerResult? file = await selectFile();
                              if (file == null) return;
                              setState(() {
                                backDocumentFile = kIsWeb
                                    ? file.files.first
                                    : File(file.paths.first!);
                                backDocument.text = kIsWeb
                                    ? file.files.first.name
                                    : file.names.first!;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            type: TextInputType.none,
                          ),
                          SizedBox(height: sizeBoxHeight),
                          TextFormFieldWidget(
                            control: serviceExperience,
                            // controller: controller1,
                            text: "Service Experience",

                            type: TextInputType.multiline,
                          ),
                          SizedBox(height: sizeBoxHeight),
                        ],
                      ),
                    )),
                  ),
                  actions: <Widget>[
                    SubmitElevatedButton(
                      label: docs.id != null
                          ? "Update Document"
                          : "Submit Document",
                      onSubmit: () async {
                        if (!isFormValid(_formKey)) {
                          return;
                        }
                        ref.read(serviceProviderData).sendDocument(context,
                            docName: selectedDocument!.name,
                            docNumber: uniqueIdNumberController.text,
                            frontDoc: frontDocumentFile,
                            backDoc: backDocumentFile,
                            serviceExperience: serviceExperience.text);
                        FocusScope.of(context).unfocus();
                      },
                    )
                  ],
                );
              },
            ));
  }

  TabBar _tab() {
    return TabBar(
      isScrollable: true,
      indicatorColor: MyAppColor.orangelight,
      indicatorWeight: 1.5,
      controller: _control,
      labelColor: MyAppColor.blacklight,
      unselectedLabelColor: Colors.black,
      tabs: [
        if (!Responsive.isDesktop(context)) tabText('PERSONAL DETAILS'),
        if (Responsive.isDesktop(context))
          Text('PERSONAL DETAILS', style: blackdarkM10),
        if (!Responsive.isDesktop(context))
          tabText(LabelString.idProofDocument),
        if (Responsive.isDesktop(context))
          Text(
            LabelString.idProofDocument,
            style: blackdarkM10,
          ),
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

  backButtonContainer() {
    return Column(
      children: [
        Container(
          color: MyAppColor.greynormal,
          height: Responsive.isDesktop(context) ? 50 : 40,
          child: Row(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: Responsive.isDesktop(context) ? 40 : 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: Responsive.isMobile(context) ? 25 : 20,
                      child: CircleAvatar(
                        radius: Responsive.isDesktop(context) ? 20.0 : 15,
                        backgroundColor: MyAppColor.backgray,
                        child: Icon(
                          Icons.arrow_back,
                          color: MyAppColor.greylight,
                          size: Responsive.isDesktop(context) ? 20 : 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Responsive.isDesktop(context) ? 20 : 10,
                  ),
                  Text(
                    LabelString.back,
                    style: grey14,
                  ),
                  SizedBox(
                    width: Responsive.isDesktop(context) ? 40 : 20,
                  ),
                  Text('HOME (HSP) / COMPLETE PROFILE', style: greyMedium10)
                ],
              )
            ],
          ),
        ),
        mainBody()
      ],
    );
  }

  Widget mainBody() {
    return Container(
      height: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.height - 160
          : MediaQuery.of(context).size.height - 189.3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: sizeBoxHeight),
            SizedBox(height: sizeBoxHeight),
            Text(
              'COMPLETE YOUR PROFILE',
              style: blackDarkR18,
            ),
            SizedBox(height: sizeBoxHeight),
            const Text('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .'),
            Responsive.isDesktop(context)
                ? SizedBox(height: sizeBoxHeight)
                : SizedBox(),
            const Text('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .'),
            const Text('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .'),
            SizedBox(height: sizeBoxHeight),
            greyHeaderContainer(text: LabelString.serviceExperience),
            const Text('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .'),
            SizedBox(height: sizeBoxHeight),
            Responsive.isDesktop(context)
                ? Text(
                    '______________________________________________________________________________________________________________________')
                : Text(
                    '_______________________________________________________'),
            SizedBox(height: sizeBoxHeight),
            // saveprofileDetailsButton(function: onTapSave),
            Footer()
          ],
        ),
      ),
    );
  }

  editaBleTextField(
      {required TextEditingController controller1, required String label1}) {
    return TextFormField(
      controller: controller1,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.only(left: 15, bottom: 5),
          border: InputBorder.none,
          hintText: label1,
          hintStyle: blackMedium14),
    );
  }

  containerWhitetextFiled({label1, label2, controller1, controller2}) {
    return Responsive.isDesktop(context)
        ? Container(
            // width:
            //     Responsive.isDesktop(context) ? 770 : 332,
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            // height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      color: MyAppColor.white,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: controller1,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 5),
                              border: InputBorder.none,
                              hintText: label1,
                              hintStyle: blackMedium14),
                        ),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        color: MyAppColor.white,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(label2 ?? ''),
                        )),
                  ),
                ),
              ],
            ),
          )
        : Container(
            // width:
            //     Responsive.isDesktop(context) ? 770 : 332,
            // height: 40,
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller: controller1,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 0, bottom: 5),
                        border: InputBorder.none,
                        hintText: label1,
                        hintStyle: blackMedium14),
                  ),
                ),
              ],
            ),
          );
  }

  containerWhiteDropDown({label1, label2}) {
    return Responsive.isDesktop(context)
        ? Container(
            // width:
            //     Responsive.isDesktop(context) ? 770 : 332,
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        color: MyAppColor.white,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                'City',
                                style: blackMedium14,
                              ),
                              items: <String>['City', 'B', 'C', 'D']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),
                          ),
                        )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        color: MyAppColor.white,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                'State',
                                style: blackMedium14,
                              ),
                              items: <String>['State', 'B', 'C', 'D']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          )
        : Container(
            // width:
            //     Responsive.isDesktop(context) ? 770 : 332,
            // height: 40,
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 40,
                    width: Responsive.isDesktop(context)
                        ? 370
                        : MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.centerLeft,
                    color: MyAppColor.white,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(
                            'State',
                            style: blackMedium14,
                          ),
                          isExpanded: true,
                          items: <String>['State', 'B', 'C', 'D']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: 40,
                    width: Responsive.isDesktop(context)
                        ? 370
                        : MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.centerLeft,
                    color: MyAppColor.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                'City',
                                style: blackMedium14,
                              ),
                              items: <String>['City', 'B', 'C', 'D']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
  }

  var sizeBoxHeight = 20.0;

  Widget saveprofileDetailsButton(
      {required Function function, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () => function(),
              style: ElevatedButton.styleFrom(
                primary: MyAppColor.orangelight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: whiteRegular14,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  greyHeaderContainer({text}) {
    return Container(
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 20,
      height: 40,
      color: MyAppColor.greynormal,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: black12,
            )
          ]),
    );
  }
}
