// ignore_for_file: await_only_futures, unused_field, prefer_final_fields, non_constant_identifier_names, prefer_const_constructors, list_remove_unrelated_type

import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as i;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/certificate_experience_model.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/course_model.dart';
import 'package:hindustan_job/candidate/model/current_job_model.dart';
import 'package:hindustan_job/candidate/model/education_experience_model.dart';
import 'package:hindustan_job/candidate/model/education_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/language_model.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/salary_type_model.dart';
import 'package:hindustan_job/candidate/model/skill_category.dart';
import 'package:hindustan_job/candidate/model/skill_sub_category_model.dart';
import 'package:hindustan_job/candidate/model/specialization_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/user_language_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/model/work_experience_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/enum_contants.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:hindustan_job/widget/body/transaparent_body.dart';
import 'package:hindustan_job/widget/buttons/list_tile_radio_button_widget.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/buttons/submit_elevated_button.dart';
import 'package:hindustan_job/widget/drop_down_widget/custom_dropdown.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/filter_section/check_box_with_label_widget.dart';
import 'package:hindustan_job/widget/filter_section/filter_section_one_widget.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/select_file.dart';
import 'package:hindustan_job/widget/text/date_picker.dart';
import 'package:hindustan_job/widget/text/non_editable_text.dart';
import 'package:hindustan_job/widget/text/text_editable.dart';
import 'package:hindustan_job/widget/text/title_edit_head.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../widget/drop_down_widget/static_dropdown_widget.dart';
import '../../../header/back_text_widget.dart';

class EditProfile extends ConsumerStatefulWidget {
  bool isAppBarShow;
  EditProfile({Key? key, this.isAppBarShow = false}) : super(key: key);
  static const String route = '/edit-profile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile>
    with SingleTickerProviderStateMixin {
  DateTime currentDate = DateTime.now();
  DateTime currentYearDate = DateTime.now();
  String? selectedGender =
      userData!.gender != null ? getCapitalizeString(userData!.gender) : null;
  String? showSelectedDate;
  String? selectedDate =
      userData!.dob != null ? dateFormat(userData!.dob) : null;
  var _formCurrentJobKey = GlobalKey<FormState>();
  TabController? _control;

  String? selectedDateOfCurrentJob;
  int _groupValue = -1;
  int _radioSelected = 1;
  late String _radioVal;
  File? newprofile;
  File? main_image;
  PlatformFile? logo;
  File? croppedFile;
  final picker = ImagePicker();
  List<States> state = [];
  States? selectedState;
  List<City> city = [];
  City? selectedCity;
  List<Industry> industry = [];
  Industry? selectedIndustry;
  List<Course> courses = [];
  List<Education> educations = [];
  List<Language> selectedLanguages = [];

  TextEditingController resume = TextEditingController(
      text: userData!.resume != null
          ? userData!.resume.toString().split('/').last
          : '');
  var resumeFile;
  Uint8List? bytesFromPicker;
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
  TextEditingController currentJobTitleController = TextEditingController();
  TextEditingController currentCompanyNameController = TextEditingController();
  TextEditingController currentJobDescriptionController =
      TextEditingController();
  TextEditingController currentSalaryController = TextEditingController();
  TextEditingController currentNoticePeriodController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  List<SubSkill> selectedSkills = [];
  List<Skill> skillCategory = [];
  Skill? selectedSkillCategory;
  List<SubSkill> subSkills = [];
  List<Specialization> specialization = [];
  List<WorkExperience> workExperiences = [];
  List<EducationExperience> educationExperiences = [];
  List<CertificateExperience> certificateExperiences = [];
  List<Language> languages = [];
  List<SalaryType>? salaryType =
      SalaryTypeModel.fromJson(ListDropdown.currentSalaryType).salaryType;
  List<SalaryType>? noticePeriodType =
      SalaryTypeModel.fromJson(ListDropdown.noticePeriodType).salaryType;

  SalaryType? selectedSalaryType;
  SalaryType? selectedNoticePeriodType;
  @override
  void initState() {
    super.initState();
    getLanguages();
    _control = TabController(vsync: this, length: 5);
    ref.read(listData).getLanguages(context);
    fetchIndustries();
    fetchEducation();
    fetchState();
    fetchSkills();
    fetchCurrentJobDetail();
    if (userData != null) {
      addSkills();
    }
    selectedSalaryType = salaryType!.first;
    selectedNoticePeriodType = noticePeriodType!.first;
  }

  userLanguages() async {
    selectedLanguages = await fetchUserLanguage(context);
    languages = languages.map((element) {
      if (selectedLanguages.any((item) => item.id == element.id)) {
        element.isSelected = true;
      }
      return element;
    }).toList();
    setState(() {});
  }

  addSkills() {
    if (userData!.userSkills != null && userData!.userSkills!.isNotEmpty) {
      selectedSkills = userData!.userSkills!
          .map(
            (e) => SubSkill.fromJson(
              {
                'id': e.skillSubCategory!.id,
                'name': e.skillSubCategory!.name,
                'skill_category_id': e.skillSubCategory!.skillCategoryId
              },
            ),
          )
          .toList();
    }
    setState(() {});
  }

  fetchSkills() async {
    skillCategory = await fetchSkillCategory(context);
    if (skillCategory.isNotEmpty) {
      selectedSkillCategory = skillCategory.first;
      fetchSubSkills(selectedSkillCategory!.id);
    }
  }

  fetchSubSkills(id) async {
    subSkills = await fetchSubSkillsCategory(context, categoryId: id);
    setState(() {});
  }

  bool isSelectedSkillCheck(id) {
    if (selectedSkillCategory == null) {
      return true;
    }
    return selectedSkillCategory!.id == id;
  }

  fetchIndustries() async {
    industry = await fetchIndustry(context);
  }

  fetchCourses() async {
    courses = await fetchCourse(context);
  }

  fetchEducation() async {
    educations = await fetchEducations(context);
  }

  fetchSpecializations(id) async {
    specialization = await fetchCourseSpecialization(context, courseId: id);
    setState(() {});
  }

  fetchState() async {
    state = ref.read(listData).state;
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

  getLanguages() async {
    languages = await fetchLanguages(context);
    if (languages.isNotEmpty) {
      userLanguages();
    }
  }

  saveRegisterEditProfile(
      {name,
      mobile,
      stateId,
      cityId,
      gender,
      pinCode,
      address2,
      dob,
      subSkills,
      image,
      resume,
      address}) async {
    if (subSkills.isEmpty) {
      return showSnack(context: context, msg: "Select skills", type: 'error');
    } else if (image == null && currentUrl(userData!.image) == null) {
      return showSnack(context: context, msg: "Select image", type: 'error');
    }
    String subSkill = subSkills.map((e) => e.id).toList().join(",");
    Map<String, dynamic> editData = {
      "name": name,
      "mobile": mobile,
      "state_id": stateId,
      "city_id": cityId,
      "pin_code": pinCode,
      "gender": gender.toString().toLowerCase(),
      "dob": dob,
      "skill_sub_category_id": subSkill,
      "address_line1": address,
      "address_line2": address2,
    };

    if (image != null) {
      editData["image"] = kIsWeb
          ? MultipartFile.fromBytes(image.bytes, filename: image!.name)
          : await MultipartFile.fromFile(image.path,
              filename: image.path.toString().split('/').last);
    }

    if (resume != null) {
      editData["resume"] = kIsWeb
          ? MultipartFile.fromBytes(resume.bytes, filename: resume.name)
          : await MultipartFile.fromFile(resume.path,
              filename: resume.path.toString().split('/').last);
    }
    ApiResponse response = await editUserProfile(editData);
    if (response.status == 200) {
      UserData userData = UserData.fromJson(response.body!.data);
      ApiResponse profileResponse = await getProfile(userData.resetToken);
      UserData user = UserData.fromJson(profileResponse.body!.data);
      await setUserData(user);

      setState(() {});
      showSnack(context: context, msg: response.body!.message);
      _control!.animateTo(1);
      ref.read(editProfileData).calculateProfilePercent();
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  fetchCurrentJobDetail() async {
    CurrentJobModel data = await fetchCurrentJobDetails(context);
    updateCurrentJobDetails(data);
  }

  updateCurrentJobDetails(CurrentJobModel? data) {
    if (data != null) {
      currentJobTitleController.text = data.jobTitle!;
      currentCompanyNameController.text = data.companyName!;
      currentJobDescriptionController.text = data.jobDescription!;
      currentSalaryController.text = data.currentSalary!.toString();
      currentSalaryController.text = data.currentSalary!.toString();
      selectedDateOfCurrentJob = dateFormat(
        data.dateOfJoining,
      );
      if (industry.isNotEmpty) {
        selectedIndustry =
            industry.where((element) => element.id == data.industryId).first;
      }
      ref.read(editProfileData).currentEmployed = data.currentlyEmployed == 'Y'
          ? CurrentEmployed.employed
          : CurrentEmployed.notEmployed;
      ref.read(editProfileData).noticePeriod = data.noticePeriod == 'Y'
          ? NoticePeriod.noticePeriod
          : NoticePeriod.notNoticePeriod;
      if (data.noticePeriodDays != null) {
        currentNoticePeriodController.text =
            data.noticePeriodDays != null && data.noticePeriodDays != 'null'
                ? data.noticePeriodDays!
                : '';
      }
    }
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final styless = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            backgroundColor: MyAppColor.backgroundColor,
            key: _drawerKey,
            appBar: !kIsWeb && !widget.isAppBarShow
                ? PreferredSize(
                    child:
                        BackWithText(text: "HOME (JOB-SEEKER) /EDIT PROFILE"),
                    preferredSize: Size.fromHeight(50))
                : CustomAppBar(
                    context: context,
                    drawerKey: _drawerKey,
                    back: "HOME (JOB-SEEKER) /EDIT PROFILE",
                  ),
            drawer: Drawer(
              child: DrawerJobSeeker(),
            ),
            body: TabBarSliverAppbar(
              headColumn: SizedBox(),
              toolBarHeight: 0,
              length: 7,
              tabs: _tab(styless),
              tabsWidgets: [
                basicDetails(),
                workExperience(),
                educationQualification(),
                certificates(),
                languagesTab(),
              ],
              control: _control!,
            )));
  }

  basicDetails() {
    return TransparentScaffold(
      body: ListView(
        children: [
          Column(
            children: [
              TitleEditHead(title: 'PERSONAL DETAILS'),
              !Responsive.isDesktop(context)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: InkWell(
                        onTap: () async {
                          await _showChoiceDialog(context);

                          setState(() {});
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
                              shape: BoxShape.circle,
                              color: MyAppColor.greylight),

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
                    )
                  : Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
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
                              shape: BoxShape.circle,
                              color: MyAppColor.greylight,
                            ),
                            child: logo == null
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
                            label: LabelString.fullName,
                            value: fullNameController.text),
                        SizedBox(
                          height: 8,
                        ),
                        NonEditableTextField(
                            label: LabelString.mobileNumber,
                            value: phoneNumberController.text),

                        SizedBox(
                          height: 8,
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
                            padding: 15.0),
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
                        SizedBox(height: 20),
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
                        if (city.isNotEmpty)
                          SizedBox(
                            height: 20,
                          ),
                        if (city.isNotEmpty)
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
                        SizedBox(
                          height: 20,
                        ),
                        TextEditable(
                            label: LabelString.address,
                            controller: addressController),
                        TextEditable(
                            label: LabelString.flatNoBuild,
                            controller: address2Controller),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        TextFormFieldWidget(
                            text: 'Upload Resume',
                            control: resume,
                            isRequired: false,
                            type: TextInputType.none,
                            onTap: kIsWeb
                                ? () async {
                                    var result = await selectFileweb();
                                    setState(
                                      () {
                                        if (result != null) {
                                          resumeFile = result.files.single;
                                          resume.text = result.names.toString();
                                          // bytesFromPicker = result.files.single as Uint8List?;
                                        } else {}
                                      },
                                    );
                                  }
                                : () async {
                                    FilePickerResult? file = await selectFile();
                                    if (file == null) return;
                                    setState(() {
                                      resumeFile = File(file.paths.first!);
                                      resume.text = file.names.first!;
                                      FocusScope.of(context).unfocus();
                                    });
                                  }),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: Sizeconfig.screenWidth,
                          height: 40,
                          color: MyAppColor.greynormal,
                          child: Center(
                            child: Text("YOUR SKILLS"),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        yourSkill(),
                        SizedBox(
                          height: 10,
                        ),
                        categorySkill(),
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
                                subSkills: selectedSkills,
                                image: croppedFile,
                                address: addressController.text,
                                address2: address2Controller.text,
                                resume: resumeFile);
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
                                      if (newValue == DropdownString.gender)
                                        return;
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
                                    padding: const EdgeInsets.only(
                                        left: 12.0, bottom: 15),
                                    child: DynamicDropDownListOfFields(
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
                                                element.name.toString() ==
                                                value);
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
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: CustomDropdown(
                                        label: DropdownString.selectCity,
                                        dropDownList: city,
                                        selectingValue: selectedCity,
                                        setValue: (value) async {
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
                            height: 22,
                          ),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 1.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: TextEditable(
                                        label: LabelString.address,
                                        controller: addressController),
                                  ),
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
                          SizedBox(
                            height: 9,
                          ),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 1.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: TextFormFieldWidget(
                                      text: 'Upload Resume',
                                      control: resume,
                                      isRequired: false,
                                      type: TextInputType.none,
                                      onTap: () async {
                                        FilePickerResult? file =
                                            await selectFile();
                                        if (file == null) return;
                                        setState(() {
                                          resumeFile = kIsWeb
                                              ? file.files.first
                                              : File(file.paths.first!);
                                          resume.text = kIsWeb
                                              ? resumeFile.name.toString()
                                              : file.names.first!;
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(child: Container())
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Container(
                              width: Sizeconfig.screenWidth! / 1.9,
                              height: 40,
                              color: MyAppColor.greynormal,
                              child: Center(child: Text("YOUR SKILLS")),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: SizedBox(
                                width: Sizeconfig.screenWidth! / 1.9,
                                child: yourSkill()),
                          ),
                          categorySkill(),
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
                                    subSkills: selectedSkills,
                                    image: logo,
                                    address: addressController.text,
                                    address2: address2Controller.text,
                                    resume: resumeFile);
                              },
                            ),
                          )
                        ],
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }

  Column yourSkill() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(
        runSpacing: 10.0,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: List.generate(
            selectedSkills.length,
            (index) => tagChip(
                  text: selectedSkills[index].name,
                  onTap: (name) {
                    FocusScope.of(context).unfocus();
                    selectedSkills.remove(selectedSkills[index]);
                    setState(() {});
                  },
                  action: 'Add',
                )).toList(),
      ),
    ]);
  }

  Widget categorySkill() {
    return Container(
      color: MyAppColor.greynormal,
      child: !Responsive.isDesktop(context)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                  child: textSkillCategory(),
                ),
                skillCategoryResponsive(),
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
                  child: Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                ),
                subCatogaryResponse(),
              ],
            )
          : SizedBox(
              width: Sizeconfig.screenWidth! / 1.9,
              child: Row(children: [
                Expanded(
                  child: Column(
                    children: [
                      textSkillCategory(),
                      skillCategoryResponsive(),
                    ],
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: subCatogaryResponse(),
                ),
              ]),
            ),
    );
  }

  Text textSkillCategory() {
    return Text(
      "SELECT A SKILLS CATEGORY",
      style: TextStyle(fontSize: 10, color: Colors.grey),
    );
  }

  Widget subCatogaryResponse() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 20),
      child: Container(
        width: Sizeconfig.screenWidth,
        color: MyAppColor.greynormal,
        child: SizedBox(
          height: 300,
          child: ListView(
              children: List.generate(
                  subSkills.length,
                  (index) => tagListElement(
                      index: index,
                      text: subSkills[index].name,
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        if (selectedSkills.contains(subSkills[index])) {
                          selectedSkills.remove(subSkills[index]);
                        } else {
                          selectedSkills.add(subSkills[index]);
                        }
                        setState(() {});
                      }))),
        ),
      ),
    );
  }

  Widget skillCategoryResponsive() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: 300,
        padding: EdgeInsets.all(10),
        // color: MyAppColor.greynormal,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  skillCategory.length,
                  (index) => courseListElement(skillCategory[index].name, index,
                      isSelectedSkillCheck(skillCategory[index].id)))),
        ),
      ),
    );
  }

  removeText() {
    currentJobTitleController.clear();
    currentCompanyNameController.clear();
    currentJobDescriptionController.clear();
    currentSalaryController.clear();
    currentSalaryController.clear();
    currentNoticePeriodController.clear();
    selectedDateOfCurrentJob = null;
    selectedIndustry = null;
    setState(() {});
  }

  workExperience() {
    return TransparentScaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxWidth: 700,
          ),
          child: ListView(
            children: [
              TitleEditHead(title: 'WORK EXPERIENCE'),
              Form(
                  key: _formCurrentJobKey,
                  child: Consumer(builder: (context, ref, child) {
                    CurrentEmployed currentEmployed =
                        ref.watch(editProfileData).currentEmployed;
                    NoticePeriod noticePeriod =
                        ref.watch(editProfileData).noticePeriod;
                    CurrentJobModel? currentJobModel =
                        ref.watch(editProfileData).currentJobModel;
                    return Column(
                      children: [
                        !Responsive.isDesktop(context)
                            ? Column(
                                children: [
                                  ListTileRadioButton(
                                    value: CurrentEmployed.employed,
                                    groupValue: currentEmployed,
                                    text: LabelString.currentlyEmployed,
                                    onChanged: (value) => ref
                                        .read(editProfileData)
                                        .employedValueChange(value),
                                  ),
                                  ListTileRadioButton(
                                    value: CurrentEmployed.notEmployed,
                                    groupValue: currentEmployed,
                                    text: LabelString.currentlyNotEmployed,
                                    onChanged: (value) {
                                      ref
                                          .read(editProfileData)
                                          .employedValueChange(value,
                                              context: context,
                                              id: currentJobModel?.id);
                                      removeText();
                                    },
                                  ),
                                ],
                              )
                            : Row(children: [
                                Expanded(
                                  child: ListTileRadioButton(
                                    value: CurrentEmployed.employed,
                                    groupValue: currentEmployed,
                                    text: LabelString.currentlyEmployed,
                                    onChanged: (value) => ref
                                        .read(editProfileData)
                                        .employedValueChange(value),
                                  ),
                                ),
                                Expanded(
                                  child: ListTileRadioButton(
                                      value: CurrentEmployed.notEmployed,
                                      groupValue: currentEmployed,
                                      text: LabelString.currentlyNotEmployed,
                                      onChanged: (value) {
                                        ref
                                            .read(editProfileData)
                                            .employedValueChange(value,
                                                context: context,
                                                id: currentJobModel?.id);
                                        removeText();
                                      }),
                                ),
                              ]),
                        if (currentEmployed == CurrentEmployed.employed)
                          Column(
                            children: [
                              !Responsive.isDesktop(context)
                                  ? Column(
                                      children: [
                                        jobtitleRes(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        companyNameRes(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        selectIndustryRes(context),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        jobDescriptionRes(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        datepickerRes(context),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: jobtitleRes()),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: companyNameRes(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: selectIndustryRes(context),
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: jobDescriptionRes(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: datepickerRes(context),
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: SizedBox(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: SizedBox(
                                        width: Sizeconfig.screenWidth! / 2,
                                        child: NumberTextFormFieldWidget(
                                            text: "Current Salary",
                                            control: currentSalaryController,
                                            onTap: () {
                                              if (selectedSalaryType == null) {
                                                return showSnack(
                                                    context: context,
                                                    msg:
                                                        "Please select salary type first",
                                                    type: 'error');
                                              }
                                            },
                                            enableInterative: false,
                                            type: selectedSalaryType != null
                                                ? TextInputType.number
                                                : TextInputType.none,
                                            isRequired: true),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: SizedBox(
                                        width: Sizeconfig.screenWidth! / 2.3,
                                        child: CustomDropdown(
                                          label:
                                              DropdownString.selectSalaryType,
                                          dropDownList: salaryType,
                                          selectingValue: selectedSalaryType,
                                          setValue: (value) {
                                            if (DropdownString
                                                    .selectSalaryType ==
                                                value!) {
                                              selectedSalaryType = null;
                                              setState(() {});
                                              return;
                                            }
                                            selectedSalaryType = salaryType!
                                                .firstWhere((element) =>
                                                    element.name == value);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              !Responsive.isDesktop(context)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Column(
                                        children: [
                                          noticeperiodRes(noticePeriod, ref),
                                          notNoticePeriodRes(noticePeriod, ref),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: noticeperiodRes(
                                                noticePeriod, ref),
                                          ),
                                          Expanded(
                                            child: notNoticePeriodRes(
                                                noticePeriod, ref),
                                          ),
                                        ],
                                      ),
                                    ),
                              if (noticePeriod != NoticePeriod.notNoticePeriod)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: SizedBox(
                                          width: Sizeconfig.screenWidth! / 2,
                                          child: NumberTextFormFieldWidget(
                                            text:
                                                'Notice Period (In no. of days)',
                                            isRequired: true,
                                            maxLength: 2,
                                            control:
                                                currentNoticePeriodController,
                                            type: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: SizedBox(
                                          width: Sizeconfig.screenWidth! / 2.3,
                                          child: CustomDropdown(
                                            label: DropdownString
                                                .selectNoticePeriodType,
                                            dropDownList: noticePeriodType,
                                            selectingValue:
                                                selectedNoticePeriodType,
                                            setValue: (value) {
                                              if (DropdownString
                                                      .selectNoticePeriodType ==
                                                  value!) {
                                                selectedNoticePeriodType = null;
                                                setState(() {});
                                                return;
                                              }
                                              selectedNoticePeriodType =
                                                  noticePeriodType!.firstWhere(
                                                      (element) =>
                                                          element.name ==
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
                                height: 15,
                              ),
                              SubmitElevatedButton(
                                  label: currentJobModel != null
                                      ? "Update"
                                      : "Submit",
                                  onSubmit: () async {
                                    FocusScope.of(context).unfocus();

                                    if (!isFormValid(_formCurrentJobKey)) {
                                      return;
                                    }

                                    ref.read(editProfileData).addCurrentJobData(
                                        context,
                                        currentJobId: currentJobModel?.id,
                                        currentlyEmployed: currentEmployed ==
                                                CurrentEmployed.employed
                                            ? 'Y'
                                            : 'N',
                                        companyName:
                                            currentCompanyNameController.text
                                                .toString(),
                                        salaryType: selectedSalaryType!.key,
                                        noticePeriodType:
                                            selectedNoticePeriodType!.key,
                                        jobTitle: currentJobTitleController.text
                                            .toString(),
                                        currentSalary: currentSalaryController
                                            .text
                                            .toString(),
                                        dateOfJoining:
                                            selectedDateOfCurrentJob.toString(),
                                        industryId:
                                            selectedIndustry!.id.toString(),
                                        jobDescription:
                                            currentJobDescriptionController.text
                                                .toString(),
                                        noticePeriod: noticePeriod ==
                                                NoticePeriod.noticePeriod
                                            ? 'Y'
                                            : 'N',
                                        noticePeriodDays:
                                            currentNoticePeriodController.text
                                                .toString());
                                  })
                            ],
                          ),
                      ],
                    );
                  })),
              SizedBox(height: 20),
              TitleEditHead(title: 'PAST WORK EXPERIENCE'),
              Consumer(builder: (context, watch, child) {
                List<WorkExperience> workExperiences =
                    ref.watch(editProfileData).workExperiences;
                return Column(
                    children: List.generate(
                        workExperiences.length,
                        (index) => workExperienceContainer(
                            object: workExperiences[index])));
              }),
              _addbuttons(onTap: () async {
                await showJobExperienceWidgetDialog(context);
              }, onNext: () async {
                _control!.animateTo(2);
              }),
            ],
          ),
        ),
      ),
    );
  }

  ListTileRadioButton notNoticePeriodRes(
      NoticePeriod noticePeriod, riverpod.WidgetRef ref) {
    return ListTileRadioButton(
      value: NoticePeriod.notNoticePeriod,
      groupValue: noticePeriod,
      text: LabelString.noticeNoPeriod,
      onChanged: (value) {
        currentNoticePeriodController.text = '';
        ref.read(editProfileData).noticePeriodValueChange(value);
      },
    );
  }

  ListTileRadioButton noticeperiodRes(
      NoticePeriod noticePeriod, riverpod.WidgetRef ref) {
    return ListTileRadioButton(
      value: NoticePeriod.noticePeriod,
      groupValue: noticePeriod,
      text: LabelString.noticePeriod,
      onChanged: (value) =>
          ref.read(editProfileData).noticePeriodValueChange(value),
    );
  }

  datepickerRes(BuildContext context) {
    return DatePicker(
        text: 'Duration From',
        value: selectedDateOfCurrentJob,
        onSelect: (value, showDate) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            selectedDateOfCurrentJob = value;
          });
        });
  }

  TextFormFieldWidget jobDescriptionRes() {
    return TextFormFieldWidget(
      text: 'Job Description',
      isRequired: true,
      control: currentJobDescriptionController,
      type: TextInputType.multiline,
    );
  }

  Widget selectIndustryRes(BuildContext context) {
    return CustomDropdown(
      label: DropdownString.selectIndustry,
      dropDownList: industry,
      selectingValue: selectedIndustry,
      setValue: (value) {
        FocusScope.of(context).requestFocus(new FocusNode());

        if (DropdownString.selectIndustry == value!) {
          return;
        }
        selectedIndustry =
            industry.firstWhere((element) => element.name == value);
      },
    );
  }

  TextFormFieldWidget companyNameRes() {
    return TextFormFieldWidget(
      text: 'Company Name',
      isRequired: true,
      control: currentCompanyNameController,
      type: TextInputType.multiline,
    );
  }

  TextFormFieldWidget jobtitleRes() {
    return TextFormFieldWidget(
      text: 'Job Title',
      isRequired: true,
      control: currentJobTitleController,
      type: TextInputType.multiline,
    );
  }

  languagesTab() {
    return TransparentScaffold(
        body: Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 700),
        child: ListView(
          children: [
            TitleEditHead(title: 'LANGUAGE'),
            Column(
              children: List.generate(
                  selectedLanguages.length,
                  (index) => Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await ref.read(editProfileData).delLanguage(
                                      context,
                                      id: selectedLanguages[index].userLangId,
                                      object: selectedLanguages[index]);
                                  Language lang = languages.firstWhere(
                                      (element) =>
                                          element.id ==
                                          selectedLanguages[index].id);
                                  lang.isSelected = false;
                                  selectedLanguages.removeWhere((element) =>
                                      element.id ==
                                      selectedLanguages[index].id);
                                  setState(() {});
                                },
                                icon: Icon(Icons.close))
                          ],
                        ),
                        NonEditableTextField(
                            label: "Language",
                            value: selectedLanguages[index].name.toString())
                      ])),
            ),
            _addbuttons(
                onTap: () async {
                  await showWidgetDialog(context);
                },
                onNext: () {
                  ref.read(editProfileData).calculateProfilePercent();
                  if (kIsWeb) {
                    ConnectedRoutes.toJobSeeker(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
                text: 'Add Language',
                nextText: "Complete Profile"),
          ],
        ),
      ),
    ));
  }

  educationQualification() {
    return TransparentScaffold(
        body: Center(
      child: SizedBox(
        width: !Responsive.isDesktop(context)
            ? Sizeconfig.screenWidth!
            : Sizeconfig.screenWidth! / 2,
        child: ListView(
          children: [
            TitleEditHead(title: 'EDUCATION QUALIFICATION'),
            Consumer(builder: (context, watch, child) {
              List<EducationExperience> educationExperiences =
                  ref.watch(editProfileData).educationExperiences;
              return Column(
                  children: List.generate(
                      educationExperiences.length,
                      (index) => educationExperienceContainer(
                          object: educationExperiences[index])));
            }),
            _addbuttons(
                onTap: () async {
                  await showEducationExperienceWidgetDialog(context);
                },
                onNext: () async {
                  _control!.animateTo(3);
                },
                text: 'Add Qualifications'),
          ],
        ),
      ),
    ));
  }

  certificates() {
    return TransparentScaffold(
        body: Center(
      child: SizedBox(
        width: !Responsive.isDesktop(context)
            ? Sizeconfig.screenWidth!
            : Sizeconfig.screenWidth! / 2,
        child: ListView(children: [
          TitleEditHead(title: 'CERTIFICATION'),
          Consumer(builder: (context, watch, child) {
            List<CertificateExperience> certificateExperiences =
                ref.watch(editProfileData).certificateExperiences;
            return Column(
                children: List.generate(
                    certificateExperiences.length,
                    (index) => certificateExperienceContainer(
                        object: certificateExperiences[index])));
          }),
          _addbuttons(
              onTap: () async {
                await showCertificationWidgetDialog(context);
              },
              onNext: () async {
                _control!.animateTo(4);
              },
              text: 'Add Certificate')
        ]),
      ),
    ));
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
        if (!Responsive.isDesktop(context)) tabText('Basic\nDetails'),
        if (Responsive.isDesktop(context))
          Text('Basic Details', style: blackdarkM10),
        if (!Responsive.isDesktop(context)) tabText('Work\nExperience'),
        if (Responsive.isDesktop(context))
          Text('Work Experience', style: blackdarkM10),
        if (!Responsive.isDesktop(context))
          tabText('Education\nQualifications'),
        if (Responsive.isDesktop(context))
          Text(
            'Education Qualifications',
            style: blackdarkM10,
          ),
        if (!Responsive.isDesktop(context)) tabText('Certificates'),
        if (Responsive.isDesktop(context))
          Text(
            'Certificates',
            style: blackdarkM10,
          ),
        if (!Responsive.isDesktop(context)) tabText('Languages'),
        if (Responsive.isDesktop(context))
          Text(
            'Languages',
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

  Padding _addbuttons({onTap, onNext, text, nextText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: !Responsive.isDesktop(context)
                ? Sizeconfig.screenWidth! / 2.2
                : Sizeconfig.screenWidth! / 7,
            child: OutlinedButton(
              onPressed: () => onTap(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: MyAppColor.blackdark,
                    size: 15,
                  ),
                  Text(
                    text ?? 'ADD MORE',
                    style: blackDarkSb12(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30),
            // width: !Responsive.isDesktop(context)
            //     ? Sizeconfig.screenWidth! / 2.2
            //     : Sizeconfig.screenWidth! / 7,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(MyAppColor.orangedark),
              ),
              onPressed: () => onNext(),
              child: Text(
                nextText ?? 'Next',
                style: whiteSb12(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yearPicker(BuildContext context, String text,
      {value, required Function onSelect, padding}) {
    return Padding(
        padding: EdgeInsets.only(bottom: padding != null ? padding : 25),
        child: GestureDetector(
          onTap: () async {
            var data = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Select Year"),
                      content: SizedBox(
                        // Need to use container to add size constraint.
                        width: 300,
                        height: 300,
                        child: YearPicker(
                          firstDate: DateTime(DateTime.now().year - 72, 1),
                          lastDate: DateTime(DateTime.now().year, 1),
                          initialDate: DateTime.now(),

                          // save the selected date to _selectedDate DateTime variable.
                          // It's used to set the previous selected date when
                          // re-showing the dialog.
                          selectedDate: currentDate,
                          onChanged: (DateTime dateTime) {
                            var year = DateFormat('yyyy').format(dateTime);
                            // close the dialog when year is selected.
                            Navigator.pop(context, year);

                            // Do something with the dateTime selected.
                            // Remember that you need to use dateTime.year to get the year
                          },
                        ),
                      ),
                    ));
            value = data;
            onSelect(value);
          },
          child: Container(
            height: !Responsive.isDesktop(context) ? 50 : 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: MyAppColor.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    value != '' && value != null ? value : text,
                    style: value != '' && value != null
                        ? blackDarkM14()
                        : blackDarkO40M14,
                  ),
                ),
                const Icon(
                  Icons.date_range_outlined,
                  size: 15,
                ),
              ],
            ),
          ),
        ));
  }

  courseListElement(text, index, isSelected) {
    Color color = isSelected ? Colors.white : Colors.transparent;
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();

        selectedSkillCategory = skillCategory[index];
        await fetchSubSkills(selectedSkillCategory!.id);
      },
      child: Container(
        color: color,
        margin: EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 18,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  tagListElement({text, onTap, index}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
            ),
          ),
          InkWell(
            onTap: () => onTap(),
            child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      selectedSkills.contains(subSkills[index])
                          ? Icons.close
                          : Icons.add,
                      size: 14,
                    ))),
          )
        ],
      ),
    );
  }

  Widget tagChip({
    text,
    onTap,
    action,
  }) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff755F55),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 14,
            child: Icon(
              Icons.edit,
              size: 18.0,
              color: Color(0xff755F55),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              '$text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
          InkWell(
            onTap: () => onTap(text),
            child: Icon(
              Icons.clear,
              size: 18.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget locations(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: !Responsive.isDesktop(context) ? 46 : 30,
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
              value: DropdownString.selectIndustry,
              icon: IconFile.arrow,
              iconSize: 25,
              elevation: 16,
              style: TextStyle(color: MyAppColor.blackdark),
              underline: Container(
                height: 3,
                width: MediaQuery.of(context).size.width,
                color: MyAppColor.white,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  DropdownString.selectIndustry = newValue!;
                });
              },
              items:
                  ListDropdown.selectIndustries.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Colors.grey[400], fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget language(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: !Responsive.isDesktop(context) ? 46 : 35,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            focusColor: MyAppColor.white,
            child: DropdownButton<String>(
              value: DropdownString.language,
              icon: IconFile.arrow,
              iconSize: 25,
              elevation: 16,
              style: TextStyle(color: MyAppColor.blackdark),
              underline: Container(
                height: 3,
                width: MediaQuery.of(context).size.width,
                color: MyAppColor.white,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  DropdownString.language = newValue!;
                });
              },
              items: ListDropdown.languages
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.grey[400], fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
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

  radioButtonWithText({groupValue, value, text, onChanged}) {
    return SizedBox(
      height: 25,
      child: Row(
        children: [
          Radio<dynamic>(
              activeColor: Color(0xffEB8258),
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v)),
          Text("$text")
        ],
      ),
    );
  }

  radioButtonTile({groupValue, value, text}) {
    return ListTile(
      title: Text(text),
      leading: RadioButton(
        value: value,
        groupValue: groupValue,
        onChanged: (value) {},
        text: text,
      ),
    );
  }

  Future showWidgetDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) =>
            StatefulBuilder(builder: (context, StateSetter innerState) {
              return AlertDialog(
                title: Text(DropdownString.selectLanguage),
                content: Container(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                        children: List.generate(languages.length, (index) {
                      return CheckBoxWithLabel(
                          label: "${languages[index].name}",
                          value: languages[index].isSelected,
                          onSelect: (value) {
                            if (value && selectedLanguages.length > 2) {
                              return toast("You can select only 3 languages");
                            }
                            languages[index].isSelected = value;
                            List<Language> lang = selectedLanguages
                                .where((element) =>
                                    element.id == languages[index].id)
                                .toList();
                            if (lang.isNotEmpty) {
                              selectedLanguages.removeWhere(
                                  (e) => e.id == languages[index].id);
                            } else {
                              selectedLanguages.add(languages[index]);
                            }
                            innerState(() {});
                          });
                    })),
                  ),
                ),
                actions: [
                  SubmitElevatedButton(
                    label: "Save",
                    onSubmit: () async {
                      String ids =
                          selectedLanguages.map((e) => e.id).toList().join(",");
                      ApiResponse response = await ref
                          .read(editProfileData)
                          .addLanguage(context, languageIds: ids);
                      if (response.status == 200) {
                        List<Language> addedLanguages =
                            UserLanguageModel.fromJson(
                                {"rows": response.body!.data}).userLanguage!;
                        if (addedLanguages.isNotEmpty) {
                          for (Language lan in addedLanguages) {
                            for (Language selectLang in selectedLanguages) {
                              if (selectLang.id == int.parse(lan.languageId!)) {
                                selectLang.userLangId = lan.id;
                              }
                            }
                          }
                        }
                      }
                      setState(() {});
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }));
  }

  Future showJobExperienceWidgetDialog(BuildContext context,
      {WorkExperience? data}) {
    EasyLoading.show();
    var _formKey = GlobalKey<FormState>();

    TextEditingController jobTitle =
        TextEditingController(text: data != null ? data.jobTitle : '');
    TextEditingController companyName =
        TextEditingController(text: data != null ? data.companyName : '');
    TextEditingController companyDescription =
        TextEditingController(text: data != null ? data.jobDescription : '');
    String? selectedDateOfJoining;
    String? showDateOfJoining;
    String? selectedDateOfResigning;
    String? showDateOfResigning;
    Industry? selectedIndustry;
    if (data != null) {
      selectedDateOfJoining = dateFormat(data.dateOfJoining);
      selectedDateOfResigning = dateFormat(data.dateOfResigning);
      selectedIndustry = data.industry;
    }
    EasyLoading.dismiss();
    return showDialog(
        context: context,
        builder: (_) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: MyAppColor.backgroundColor,
                title: Text(
                  "Add Work Experience",
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
                        TextFormFieldWidget(
                            text: 'Job Title',
                            isRequired: true,
                            control: jobTitle,
                            type: TextInputType.multiline),
                        SizedBox(height: 20),
                        TextFormFieldWidget(
                            text: 'Company Name',
                            isRequired: true,
                            control: companyName,
                            type: TextInputType.multiline),
                        SizedBox(height: 20),
                        CustomDropdown(
                          label: DropdownString.selectIndustry,
                          dropDownList: industry,
                          selectingValue: selectedIndustry,
                          setValue: (value) async {
                            if (DropdownString.selectIndustry == value!) {
                              return;
                            }
                            selectedIndustry = industry
                                .firstWhere((element) => element.name == value);
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormFieldWidget(
                            text: 'Job Description',
                            isRequired: true,
                            control: companyDescription,
                            type: TextInputType.multiline),
                        SizedBox(height: 20),
                        DatePicker(
                          text: 'Duration From',
                          value: showDateOfJoining ?? selectedDateOfJoining,
                          onSelect: (date, showDate) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              showDateOfJoining = showDate;
                              selectedDateOfJoining = date;
                            });
                          },
                          padding: 0.0,
                        ),
                        SizedBox(height: 20),
                        DatePicker(
                          text: 'Duration To',
                          value: showDateOfResigning ?? selectedDateOfResigning,
                          onSelect: (date, showDate) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              showDateOfResigning = showDate;
                              selectedDateOfResigning = date;
                            });
                          },
                          padding: 0.0,
                        ),
                      ],
                    ),
                  )),
                ),
                actions: <Widget>[
                  SubmitElevatedButton(
                    label: "Save",
                    onSubmit: () async {
                      if (!isFormValid(_formKey)) {
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      if (selectedDateOfJoining == null) {
                        return toast("Select date of joining");
                      } else if (selectedDateOfResigning == null) {
                        return toast("Select date of resigning");
                      }

                      if (data != null) {
                        await ref.read(editProfileData).updateWorkExp(context,
                            workExpId: data.id,
                            jobTitle: jobTitle.text.toString(),
                            companyName: companyName.text.toString(),
                            jobDescripton: companyDescription.text.toString(),
                            industryId: selectedIndustry!.id.toString(),
                            dateOfJoin: selectedDateOfJoining ==
                                    dateFormat(data.dateOfJoining)
                                ? dateReverseFormat(data.dateOfJoining)
                                : selectedDateOfJoining,
                            dateOfResgin: selectedDateOfResigning ==
                                    dateFormat(data.dateOfResigning)
                                ? dateReverseFormat(data.dateOfResigning)
                                : selectedDateOfResigning);
                      } else {
                        await ref.read(editProfileData).addWorkExp(context,
                            jobTitle: jobTitle.text.toString(),
                            companyName: companyName.text.toString(),
                            jobDescripton: companyDescription.text.toString(),
                            industryId: selectedIndustry!.id.toString(),
                            dateOfJoin: selectedDateOfJoining,
                            dateOfResgin: selectedDateOfResigning);
                      }
                    },
                  )
                ],
              );
            }));
  }

  workExperienceContainer({WorkExperience? object}) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () async {
                await showJobExperienceWidgetDialog(context, data: object);
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                await ref
                    .read(editProfileData)
                    .delWorkExp(context, id: object!.id, object: object);
              },
              icon: Icon(Icons.close))
        ],
      ),
      NonEditableTextField(
        label: 'Job Title',
        value: object!.jobTitle.toString(),
      ),
      NonEditableTextField(
        label: 'Company Name',
        value: object.companyName.toString(),
      ),
      NonEditableTextField(
        label: 'Industry',
        value: object.industry!.name.toString(),
      ),
      NonEditableTextField(
        label: 'Job Description',
        value: object.jobDescription.toString(),
      ),
      NonEditableTextField(
        label: 'Date of Join',
        value: dateFormat(object.dateOfJoining),
      ),
      NonEditableTextField(
        label: 'Date of Resign',
        value: dateFormat(object.dateOfResigning),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Divider(
          thickness: 2,
        ),
      ),
    ]);
  }

  Future showEducationExperienceWidgetDialog(BuildContext context,
      {EducationExperience? data}) async {
    EasyLoading.show();
    courses = [];
    specialization = [];
    Course? selectedCourse;
    Specialization? selectedSpecialization;
    TextEditingController instituteName = TextEditingController();
    TextEditingController yearOfPassing = TextEditingController();
    Education? selectedEducation;

    if (data != null) {
      selectedEducation = data.educationDatum;
      if (selectedEducation != null) {
        courses = await fetchCourse(context,
            educationId: selectedEducation.id.toString());
      }
      selectedCourse = data.courses;
      if (selectedCourse != null) {
        specialization = await fetchCourseSpecialization(context,
            courseId: selectedCourse.id.toString());
        if (specialization.isNotEmpty) {
          selectedSpecialization = specialization
              .firstWhere((element) => element.id == data.specializationId);
        }
      }

      instituteName.text = data.instituteName.toString();
      yearOfPassing.text = data.yearOfPassing.toString();
    }

    var _formKey = GlobalKey<FormState>();
    EasyLoading.dismiss();
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
              builder: (context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: MyAppColor.backgroundColor,
                  title: Text(
                    "Add Education",
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
                            label: DropdownString.selectQualification,
                            dropDownList: educations,
                            selectingValue: selectedEducation,
                            setValue: (value) async {
                              if (DropdownString.selectQualification ==
                                  value!) {
                                return;
                              }
                              selectedEducation = educations.firstWhere(
                                  (element) => element.name == value);
                              selectedCourse = null;
                              courses = await fetchCourse(context,
                                  educationId:
                                      selectedEducation!.id.toString());
                              setState(() {});
                            },
                          ),
                          if (courses.isNotEmpty)
                            SizedBox(
                              height: 10,
                            ),
                          if (courses.isNotEmpty)
                            CustomDropdown(
                              label: DropdownString.selectCourse,
                              dropDownList: courses,
                              selectingValue: selectedCourse,
                              setValue: (value) async {
                                if (DropdownString.selectCourse == value!) {
                                  return;
                                }
                                selectedCourse = courses.firstWhere(
                                    (element) => element.name == value);
                                selectedSpecialization = null;
                                setState(() {});

                                specialization =
                                    await fetchCourseSpecialization(
                                        context,
                                        courseId:
                                            selectedCourse!.id.toString());
                                setState(() {});
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (specialization.isNotEmpty)
                            CustomDropdown(
                              label: DropdownString.selectSpecialization,
                              dropDownList: specialization,
                              selectingValue: selectedSpecialization,
                              setValue: (value) async {
                                if (DropdownString.selectSpecialization ==
                                    value!) {
                                  return;
                                }
                                selectedSpecialization =
                                    specialization.firstWhere(
                                        (element) => element.name == value);
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormFieldWidget(
                            textStyle: blackDarkO40M14,
                            text: 'School/College/University Name',
                            control: instituteName,
                            isRequired: true,
                            type: TextInputType.multiline,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _yearPicker(context, 'Specify Year of Passing',
                              value: yearOfPassing.text, onSelect: (date) {
                            setState(() {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              yearOfPassing.text = date;
                            });
                          }),
                        ],
                      ),
                    )),
                  ),
                  actions: <Widget>[
                    SubmitElevatedButton(
                      label: "Save",
                      onSubmit: () async {
                        if (!isFormValid(_formKey)) {
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        if (data != null) {
                          await ref.read(editProfileData).updateEducationExp(
                              context,
                              educationExpId: data.id,
                              courseId: selectedCourse == null
                                  ? null
                                  : selectedCourse!.id.toString(),
                              instituteName: instituteName.text,
                              specializationId: selectedSpecialization == null
                                  ? null
                                  : selectedSpecialization!.id.toString(),
                              educationId: selectedEducation!.id.toString(),
                              yearOfPassing: yearOfPassing.text.toString());
                        } else {
                          await ref.read(editProfileData).addEducationExp(
                              context,
                              courseId: selectedCourse == null
                                  ? null
                                  : selectedCourse!.id.toString(),
                              instituteName: instituteName.text,
                              specializationId: selectedSpecialization == null
                                  ? null
                                  : selectedSpecialization!.id.toString(),
                              educationId: selectedEducation!.id.toString(),
                              yearOfPassing: yearOfPassing.text.toString());
                        }
                      },
                    )
                  ],
                );
              },
            ));
  }

  educationExperienceContainer({EducationExperience? object}) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              await showEducationExperienceWidgetDialog(context, data: object);
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
              onPressed: () async {
                await ref
                    .read(editProfileData)
                    .delEducationExp(context, id: object!.id, object: object);
              },
              icon: Icon(Icons.close))
        ],
      ),
      if (object!.educationDatum != null)
        NonEditableTextField(
          label: 'Qualification',
          value: object.educationDatum!.name.toString(),
        ),
      if (object.educationDatum != null)
        SizedBox(
          height: 20,
        ),
      if (object.courses != null)
        NonEditableTextField(
          label: 'Course Name',
          value: object.courses!.name.toString(),
        ),
      if (object.courses != null)
        SizedBox(
          height: 20,
        ),
      if (object.specializations != null)
        NonEditableTextField(
          label: 'Specialization',
          value: object.specializations!.name.toString(),
        ),
      if (object.specializations != null)
        SizedBox(
          height: 20,
        ),
      NonEditableTextField(
        label: 'School/College/University Name',
        value: object.instituteName.toString(),
      ),
      SizedBox(
        height: 20,
      ),
      NonEditableTextField(
        label: 'Year of passing',
        value: object.yearOfPassing.toString(),
      ),
    ]);
  }

  Future showCertificationWidgetDialog(BuildContext context,
      {CertificateExperience? data}) {
    EasyLoading.show();
    TextEditingController certificateTitle = TextEditingController();
    TextEditingController nameOfInstitute = TextEditingController();
    TextEditingController yearOfAchieving = TextEditingController();
    var _formKey = GlobalKey<FormState>();
    TextEditingController certificate = TextEditingController();
    var certificateFile;
    if (data != null) {
      certificateTitle.text = data.title.toString();
      nameOfInstitute.text = data.instituteName.toString();
      yearOfAchieving.text = data.yearOfAchievingCertificate.toString();
      certificate.text = data.fileName.toString();
    }
    EasyLoading.dismiss();
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
              builder: (context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: MyAppColor.backgroundColor,
                  title: Text(
                    "Add Certification",
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
                          TextFormFieldWidget(
                            text: 'Certificate Title',
                            control: certificateTitle,
                            isRequired: true,
                            type: TextInputType.multiline,
                          ),
                          SizedBox(height:20),
                          TextFormFieldWidget(
                            text: 'Select Certificate',
                            control: certificate,
                            isRequired: false,
                            type: TextInputType.none,
                            onTap: () async {
                              FilePickerResult? file = await selectFile();
                              if (file == null) return;
                              setState(() {
                                certificateFile = kIsWeb
                                    ? file.files.first
                                    : File(file.paths.first!);
                                certificate.text = file.names.first!;
                                FocusScope.of(context).unfocus();
                              });
                            },
                          ),
                          SizedBox(height:20),
                          TextFormFieldWidget(
                            text: 'Name of Certificate issuing Institute',
                            control: nameOfInstitute,
                            isRequired: true,
                            type: TextInputType.multiline,
                          ),
                          SizedBox(height:20),
                          _yearPicker(context,
                              'Specify Year of Achieving the Certificate',
                              value: yearOfAchieving.text, onSelect: (date) {
                            setState(() {
                              yearOfAchieving.text = date;
                            });
                          }),
                        ],
                      ),
                    )),
                  ),
                  actions: <Widget>[
                    SubmitElevatedButton(
                      label: "Save",
                      onSubmit: () async {
                        if (!isFormValid(_formKey)) {
                          return;
                        }
                        if (yearOfAchieving.text == '') {
                          return toast("Select year of certificate achieving");
                        }
                        FocusScope.of(context).unfocus();
                        if (data != null) {
                          await ref.read(editProfileData).updateCertificate(
                                context,
                                certificateId: data.id,
                                certificateTitle:
                                    certificateTitle.text.toString(),
                                nameOfInstitute:
                                    nameOfInstitute.text.toString(),
                                selectedCerficate: certificateFile,
                                nameOfCertificate: certificate.text,
                                yearOfAchieving:
                                    yearOfAchieving.text.toString(),
                              );
                        } else {
                          await ref.read(editProfileData).addCertificate(
                                context,
                                certificateTitle:
                                    certificateTitle.text.toString(),
                                nameOfInstitute:
                                    nameOfInstitute.text.toString(),
                                selectedCerficate: certificateFile,
                                yearOfAchieving:
                                    yearOfAchieving.text.toString(),
                              );
                        }
                      },
                    )
                  ],
                );
              },
            ));
  }

  certificateExperienceContainer({CertificateExperience? object}) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () async {
                await showCertificationWidgetDialog(context, data: object);
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                await ref
                    .read(editProfileData)
                    .delCertificateExp(context, id: object!.id, object: object);
              },
              icon: Icon(Icons.close))
        ],
      ),
      NonEditableTextField(
        label: 'Certificate title',
        value: object!.title.toString(),
      ),
      SizedBox(height: 20,),

      NonEditableTextField(
        label: 'Name of institute',
        value: object.instituteName.toString(),
      ),
      SizedBox(height: 20,),
      if (object.fileName != null)
        NonEditableTextField(
          label: 'Uploaded of certificate',
          value: object.fileName.toString(),
        ),
      SizedBox(height: 20,),
      NonEditableTextField(
        label: 'Year of achieving',
        value: object.yearOfAchievingCertificate.toString(),
      ),
    ]);
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
        main_image = File(pickedFile.path);
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
        main_image = File(pickedFile.path);
        cropImage(context, pickedFile.path);
        Navigator.pop(context);
      } else {}
    });
  }
}
