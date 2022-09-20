// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, must_be_immutable, prefer_final_fields, prefer_typing_uninitialized_variables, unused_local_variable, unused_element, use_key_in_widget_constructors

import 'dart:io';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/contract_type_model.dart';
import 'package:hindustan_job/candidate/model/education_model.dart';
import 'package:hindustan_job/candidate/model/employment_type_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
// import 'package:hindustan_job/candidate/model/job_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/job_schedule_model.dart';
import 'package:hindustan_job/candidate/model/job_type_model.dart';
import 'package:hindustan_job/candidate/model/key_value_model.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/salary_type_model.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/widget/body/row_widget.dart';
import 'package:vrouter/vrouter.dart';
import 'package:hindustan_job/candidate/model/skill_category.dart';
import 'package:hindustan_job/candidate/model/skill_sub_category_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/work_from_home_model.dart';
import 'package:hindustan_job/candidate/model/yes_no_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/pages/job_preview_page.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/constants/enum_contants.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/api_services/jobs_services.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:hindustan_job/widget/text/non_editable_text.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:dynamic_form/dynamic_form.dart';
import 'package:intl/intl.dart';

class CreateJobPost extends ConsumerStatefulWidget {
  String? jobsEditId;
  CreateJobPost({this.initialCount = 1, this.jobsEditId});

  final int initialCount;

  @override
  ConsumerState<CreateJobPost> createState() => _CreateJobPostState();
}

class _CreateJobPostState extends ConsumerState<CreateJobPost> {
  FormController fcontroller = FormController();
  // HtmlEditorController jobDescriptioncontroller = HtmlEditorController();
  TextEditingController jobDescriptioncontroller = TextEditingController();
  TextEditingController companyController = TextEditingController(
      text: userData != null
          ? userData!.userRoleType != RoleTypeConstant.company
              ? userData!.companyData!.name
              : userData!.name
          : '');
  TextEditingController roleOfHiringController = TextEditingController();
  TextEditingController specifyContractDurationController =
      TextEditingController();
  TextEditingController specifyEmailController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController noOfPositionsController = TextEditingController();
  TextEditingController noOfMonthsController = TextEditingController();
  TextEditingController salaryInFromController = TextEditingController();
  TextEditingController salaryInToController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController experienceInFromController = TextEditingController();
  TextEditingController experienceInToController = TextEditingController();
  TextEditingController resumeController = TextEditingController();
  List<SalaryType>? experiencePeriodType =
      SalaryTypeModel.fromJson(ListDropdown.experienceType).salaryType;
  File? resumeFile;
  var _formJobKey = GlobalKey<FormState>();
  int fieldCount = 0;
  int nextIndex = 0;
  List<States> state = [];
  States? selectedState;
  States? selectedBrandPostState;
  City? selectedCity;
  List<City> city = [];
  List<Industry> industry = [];
  List<Industry> jobRoleType = [];
  Industry? selectedIndustry;
  List<EmploymentType>? employmentType =
      EmploymentModel.fromJson(ListDropdown.employmentType).employmentType;
  List<SalaryType>? salaryType =
      SalaryTypeModel.fromJson(ListDropdown.salaryType).salaryType;
  SalaryType? selectedSalaryType;
  EmploymentType? selectedEmploymentType;
  List<ContractType>? contractType =
      ContractTypeModel.fromJson(ListDropdown.contractType).contractType;
  ContractType? selectedContractType;
  List<JobScheduleType>? jobSchedule =
      JobScheduleModel.fromJson(ListDropdown.jobSchedule).jobScheduleType;
  JobScheduleType? selectedJobSchedule;
  List<JobType>? jobTypes = [];
  JobType? selectedJobType;
  List<YesNoType>? yesNo = YesNoModel.fromJson(ListDropdown.yesNo).yesNoType;
  List<WFHType>? wfhList = WFHModel.fromJson(ListDropdown.wfh).wfhType;
  List<KeyValue>? monthsKeyValue =
      KeyValueModel.fromJson(ListDropdown.months).keyValue;
  String? selectedMonth;
  WFHType? isWorkFromHome;
  YesNoType? isEducationRequired;
  YesNoType? isExperienceRequired;
  List<Sector> sector = [];
  Sector? selectedSector;
  Industry? selectedRole;
  String? selectedExperience;
  String? selectedJobTimeTable;
  TextEditingController otherContractType = TextEditingController();
  TextEditingController fromTiming = TextEditingController();
  TextEditingController toTiming = TextEditingController();
  String? selectedLocation;
  String? selectedNoOfPositions;
  String? selectedNoOfMonths;
  List<SubSkill> selectedSkills = [];
  List<Skill> skillCategory = [];
  Skill? selectedSkillCategory;
  List<SubSkill> subSkills = [];
  List<Education> educations = [];
  Education? selectedEducation;
  List<TextEditingController> controllers = <TextEditingController>[];
  SalaryType? selectedExperienceFromType;
  SalaryType? selectedExperienceToType;

  SalaryAmount salaryAmount = SalaryAmount.rangeOfAmounts;
  YesNo yesNoRadio = YesNo.yes;
  JobsTwo? jobDetail;
  @override
  void initState() {
    super.initState();

    fetchSkills();
    fetchJobType();
    fetchJobRoleTypes();
    fetchIndustries();
    fetchEducation();
    fetchState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyProfile).checkSubscription();
    });
    selectedSalaryType = salaryType!.first;
    fieldCount = widget.initialCount;
    if (widget.jobsEditId != null) {
      fetchJobDetails(widget.jobsEditId);
    }
  }

  double? _height;
  double? _width;

  String? _setTime, _setDate;

  String? _hour, _minute, _time;

  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  _selectTime(context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedTime = picked;
      _hour = selectedTime.hour.toString();
      _minute = selectedTime.minute.toString();
      _time = selectedTime.format(context);
      _timeController.text = _time!;
    }
    return _time;
  }

  setLocationOnTheBasisOfPinCode(pincode) async {
    List<PostOffice> postOffices =
        await fetchLocationOnBasisOfPinCode(context, pincode);
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

  fetchJobDetails(id) async {
    jobDetail = await jobDetails(context, jobId: id);
    EasyLoading.show(status: "Loading...");
    selectedRole = jobDetail!.jobRoleType!;
    jobTitleController.text = jobDetail!.jobTitle!;
    pinCodeController.text = jobDetail!.pinCode!;
    selectedState = States.fromJson(
        {'id': jobDetail!.state!.id, 'name': jobDetail!.state!.name});
    if (jobDetail!.boostingJobStateData != null) {
      selectedBrandPostState = States.fromJson({
        'id': jobDetail!.boostingJobStateData!.id,
        'name': jobDetail!.boostingJobStateData!.name
      });
    }
    await fetchCity(selectedState!.id);
    if (city.isNotEmpty) {
      selectedCity = City.fromJson(
          {'id': jobDetail!.city!.id, 'name': jobDetail!.city!.name});
    }
    selectedIndustry = Industry.fromJson(
        {'id': jobDetail!.industry!.id, 'name': jobDetail!.industry!.name});
    await fetchSectors(jobDetail!.industry!.id);
    if (sector.isNotEmpty) {
      selectedSector =
          sector.where((element) => element.id == jobDetail!.sectorId).first;
    }
    selectedJobType = JobType.fromJson(
        {'id': jobDetail!.jobType!.id, 'name': jobDetail!.jobType!.name});

    selectedEmploymentType = EmploymentType.fromJson(findValueConstantObject(
        list: ListDropdown.employmentType,
        keyValue: jobDetail!.employmentType));
    selectedContractType = ContractType.fromJson(findValueConstantObject(
        list: ListDropdown.contractType, keyValue: jobDetail!.contractType));
    if (selectedContractType!.key == 'other') {
      otherContractType.text = jobDetail!.otherContractType ?? '';
    }
    selectedJobSchedule = JobScheduleType.fromJson(findValueConstantObject(
        list: ListDropdown.jobSchedule, keyValue: jobDetail!.jobSchedule));
    selectedEmploymentType = EmploymentType.fromJson(findValueConstantObject(
        list: ListDropdown.employmentType,
        keyValue: jobDetail!.employmentType));
    selectedJobTimeTable = jobDetail!.jobTimetable;
    fromTiming.text = jobDetail!.jobTimeFrom!;
    toTiming.text = jobDetail!.jobTimeTo!;
    selectedNoOfPositions = jobDetail!.numberOfPosition.toString();
    noOfPositionsController.text = selectedNoOfPositions.toString();
    isWorkFromHome = WFHType.fromJson(findValueConstantObject(
        list: ListDropdown.wfh, keyValue: jobDetail!.workFromHome));
    selectedSalaryType = SalaryType.fromJson(findValueConstantObject(
        list: ListDropdown.salaryType, keyValue: jobDetail!.paidType));
    salaryAmount = jobDetail!.salaryType == "amount_in_range"
        ? SalaryAmount.rangeOfAmounts
        : jobDetail!.salaryType == "fixed_amount"
            ? SalaryAmount.fixedAmuont
            : SalaryAmount.uptoCertainAmount;
    specifyContractDurationController.text =
        jobDetail!.contractDuration.toString();
    salaryInToController.text = jobDetail!.salaryTo.toString();
    salaryInFromController.text = jobDetail!.salaryFrom.toString();
    salaryController.text = jobDetail!.salary.toString();
    if (jobDetail!.jobPostSkills!.isNotEmpty) {
      selectedSkills = jobDetail!.jobPostSkills!
          .map((e) => SubSkill.fromJson({
                'id': e.skillSubCategories!.id,
                'name': e.skillSubCategories!.name,
                'skill_category_id': e.skillSubCategories!.skillCategoryId
              }))
          .toList();
    }
    isExperienceRequired = YesNoType.fromJson(findValueConstantObject(
        list: ListDropdown.yesNo, keyValue: jobDetail!.experienceRequired));
    isEducationRequired = YesNoType.fromJson(findValueConstantObject(
        list: ListDropdown.yesNo, keyValue: jobDetail!.educationRequired));
    jobDescriptioncontroller.text = jobDetail!.jobDescription.toString();
    if (jobDetail!.expFrom != null) {
      selectedExperienceFromType = SalaryType.fromJson(findValueConstantObject(
          list: ListDropdown.experienceType, keyValue: jobDetail!.expFromType));
      experienceInFromController.text = calculateExperienceForEdit(
          jobDetail!.expFrom, selectedExperienceFromType);
    }
    if (jobDetail!.expTo != null) {
      selectedExperienceToType = SalaryType.fromJson(findValueConstantObject(
          list: ListDropdown.experienceType, keyValue: jobDetail!.expToType));
      experienceInToController.text = calculateExperienceForEdit(
          jobDetail!.expTo, selectedExperienceToType);
    }
    if (jobDetail!.educationDatum != null) {
      selectedEducation = Education.fromJson({
        'id': jobDetail!.educationDatum!.id,
        'name': jobDetail!.educationDatum!.name
      });
    }
    yesNoRadio = 'N' == jobDetail!.submitResume ? YesNo.no : YesNo.yes;
    specifyEmailController.text = jobDetail!.email ?? '';
    controllers = jobDetail!.questions!.map((e) {
      TextEditingController question =
          TextEditingController(text: e.questions.toString());
      return question;
    }).toList();
    EasyLoading.dismiss();
    setState(() {});
  }

  fetchIndustries() async {
    industry = await fetchIndustry(context);
  }

  fetchJobRoleTypes() async {
    jobRoleType = await fetchJobRoleType(context);
  }

  fetchEducation() async {
    educations = await fetchEducations(context);
  }

  fetchSectors(industryId) async {
    selectedSector = null;
    sector = [];
    sector = await fetchSector(context, industryId: industryId);
    setState(() {});
  }

  fetchState() async {
    state = await fetchStates(context);
    setState(() {});
  }

  fetchJobType() async {
    jobTypes = await fetchJobTypes(context);
    setState(() {});
  }

  fetchCity(id, {pinLocation}) async {
    selectedCity = null;
    city = [];
    city = await fetchCities(context, stateId: id.toString());
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

  salaryValueChange(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      salaryAmount = value;
    });
  }

  yesNoValueChange(value) {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      yesNoRadio = value;
    });
  }

  bool isSelectedSkillCheck(id) {
    if (selectedSkillCategory == null) {
      return true;
    }
    return selectedSkillCategory!.id == id;
  }

  createJob(
      {companyName,
      jobTitle,
      roleOfHiring,
      industryId,
      sectorId,
      employmentType,
      contractType,
      contractDuration,
      jobSchedule,
      jobTimetable,
      workFromHome,
      otherContractType,
      numberOfPosition,
      jobDescription,
      salaryType,
      paidType,
      salary,
      salaryFrom,
      salaryTo,
      educationRequired,
      educationId,
      experienceRequired,
      expFrom,
      expTo,
      submitResume,
      email,
      userQuestion,
      otherRoleOfHiring,
      skillSubCategoryId,
      education,
      stateId,
      cityId,
      pinCode,
      userId,
      isForPreview}) async {
    if (ref.read(companyProfile).jobBoostingAll &&
        selectedBrandPostState == null) {
      return showSnack(
          context: context,
          msg: "Select State for Branding your job",
          type: 'error');
    }

    var experienceFrom, experienceTo;
    if (experienceRequired == 'Y') {
      experienceFrom = selectedExperienceFromType!.key == 'M'
          ? experienceInFromController.text
          : int.parse(experienceInFromController.text) * 12;
      experienceTo = selectedExperienceToType!.key == 'M'
          ? experienceInToController.text
          : int.parse(experienceInToController.text) * 12;
      if (int.parse("$experienceFrom") > int.parse("$experienceTo")) {
        return showSnack(
            context: context,
            msg: "Invalied Experience selection",
            type: 'error');
      }
    }

    var previewData = {
      "name": companyName,
      "job_title": jobTitle,
      "job_role_type_id": roleOfHiring,
      "other_role_of_hiring": otherContractType,
      "industry_id": industryId,
      "sector_id": sectorId,
      "employment_type": employmentType,
      "contract_type": contractType,
      "contract_duration": contractDuration == '' ||
              contractDuration == null ||
              contractDuration == 'null'
          ? null
          : int.parse(contractDuration),
      "job_schedule": jobSchedule,
      "job_time_from": fromTiming.text,
      "job_time_to": toTiming.text,
      "work_from_home": workFromHome,
      "number_of_position": int.parse(numberOfPosition),
      "job_description": jobDescription,
      "salary_type": salaryType,
      "paid_type": paidType,
      "salary": checkValueAddNull(salary),
      "salary_from": checkValueAddNull(salaryFrom),
      "salary_to": checkValueAddNull(salaryTo),
      "education_required": educationRequired,
      "experience_required": experienceRequired,
      "exp_from": experienceFrom,
      "exp_to": experienceTo,
      "submit_resume": submitResume,
      "email": email,
      "contract_other_type": otherContractType,
      "job_type_id": 1,
      "education_id": educationId,
      "user_question": userQuestion,
      "skill_sub_category_id": skillSubCategoryId.toString(),
      "EducationDatum": {
        "id": selectedEducation?.id,
        "name": selectedEducation?.name
      },
      "state_id": stateId,
      "city_id": cityId,
      "pin_code": int.parse(pinCode),
      'sub_skills': selectedSkills,
      'cityName': selectedCity!.name,
      'jobTypeName': 'Private',
      'stateName': selectedState!.name,
      // 'JobType': selectedJobType
    };
    if (widget.jobsEditId != null) {
      previewData['id'] = int.parse(widget.jobsEditId.toString());
    }
    var jobData = {
      "name": companyName,
      "job_title": jobTitle,
      "job_role_type_id": roleOfHiring,
      "industry_id": industryId,
      "subscription_plan_id": ref.read(companyProfile).subscribedPlanId,
      "sector_id": sectorId.toString(),
      "employment_type": employmentType,
      "contract_type": contractType,
      "contract_other_type": otherContractType,
      "contract_duration": contractDuration.toString(),
      "job_schedule": jobSchedule,
      "job_time_from": fromTiming.text,
      "job_time_to": toTiming.text,
      "work_from_home": workFromHome,
      "number_of_position": numberOfPosition.toString(),
      "job_description": jobDescription,
      "salary_type": salaryType,
      "paid_type": paidType,
      "salary": salary,
      "salary_from": salaryFrom.toString(),
      "salary_to": salaryTo.toString(),
      "education_required": educationRequired,
      "experience_required": experienceRequired,
      "exp_from": checkValueAddNull(experienceFrom),
      // 'exp_from_type': "M",
      "exp_to": checkValueAddNull(experienceTo),
      // 'exp_to_type': 'year',
      "submit_resume": submitResume,
      "email": email,
      "job_type_id": 1,
      "education_id": educationId.toString(),
      // "user_id":userId.toString(),
      "user_question": userQuestion,
      "other_role_of_hiring": otherRoleOfHiring,
      "skill_sub_category_id": skillSubCategoryId.toString(),
      "education": education,
      "state_id": stateId.toString(),
      "city_id": cityId.toString(),
      "pin_code": pinCode.toString(),
      "boosting_state_id": selectedBrandPostState != null
          ? selectedBrandPostState!.id.toString()
          : null
    };
    if (experienceRequired == 'Y') {
      jobData['exp_from_type'] = selectedExperienceFromType!.key;
      jobData['exp_to_type'] = selectedExperienceToType!.key;
      previewData['exp_from_type'] = selectedExperienceFromType!.key;
      previewData['exp_to_type'] = selectedExperienceToType!.key;
    }
    jobData.removeWhere(
        (key, value) => value == null || value == '' || value == 'null');
    var bool;
    if (isForPreview) {
      bool = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobPreviewPage(
              jobDetail: JobsTwo.fromJson(previewData), jobPostData: jobData),
        ),
      );
    }

    if (!isForPreview) {
      if (widget.jobsEditId != null) {
        jobData['id'] = widget.jobsEditId;
        await editAJob(context, jobData);
      } else {
        await addAJob(context, context.vRouter, jobData);
        ref.read(companyProfile).checkSubscription();
      }
    }
  }

  List<Widget> _buildList() {
    int i;
    if (controllers.length < fieldCount) {
      for (i = controllers.length; i < fieldCount; i++) {
        controllers.add(TextEditingController());
      }
    }
    i = 0;
    return controllers.map<Widget>((TextEditingController controller) {
      int displayNumber = i + 1;
      i++;
      return !Responsive.isDesktop(context)
          ? Column(
              children: [
                removebutton(i, controller),
                SizedBox(
                  height: 15,
                ),
                addQuetion(displayNumber),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  height: 1,
                  color: MyAppColor.greyfulldark,
                ),
                SizedBox(
                  height: 15,
                )
              ],
            )
          : Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          width: Sizeconfig.screenWidth! / 2.1,
                          child: addQuetion(displayNumber),
                        ),
                      ),
                    ],
                  ),
                SizedBox(width: 30, child: removebutton(i, controller)),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Divider(
                    height: 1,
                    color: MyAppColor.greyfulldark,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            );
    }).toList();
  }

  Padding removebutton(int i, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        if (i != 1)
          InkWell(
            onTap: () {
              setState(() {
                fieldCount--;
                controllers.remove(controller);
              });
            },
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1)),
              child: Icon(
                Icons.close,
                size: 15,
              ),
            ),
          ),
      ]),
    );
  }

  Widget addQuetion(int displayNumber) {
    return TextField(
      controller: controllers[displayNumber - 1],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(color: Colors.white),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: "Add question",
          hintStyle: blackDarkOpacityM12(),
          contentPadding:
              EdgeInsets.only(top: 2, left: 8, right: 8, bottom: 10)),
    );
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      key: _drawerKey,
      appBar: CompanyAppBar(
        drawerKey: _drawerKey,
        back: "HOME / CREATE A JOB POST",
        isWeb: Responsive.isDesktop(context),
      ),
      body: ListView(
        children: [
          Container(
            color: MyAppColor.backgroundColor,
            child: _body(styles, context, _buildList()),
          ),
        ],
      ),
    ));
  }

  Widget _body(TextStyle styles, BuildContext context, List<Widget> children) {
    children.add(
      GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.centerRight,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                fieldCount++;
              });
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: Colors.black),
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Text(
                      "+ ADD MORE",
                      style: blackDarkOpacityM12(),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
    return Container(
      color: MyAppColor.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            createJobpost(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child:
                  Text(".    .    .    .    .    .    .    .    .    .    ."),
            ),
            Form(
              key: _formJobKey,
              child: Column(
                children: [
                  Container(
                    width: !Responsive.isDesktop(context)
                        ? Sizeconfig.screenWidth!
                        : Sizeconfig.screenWidth! / 2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        if (!Responsive.isDesktop(context))
                          Column(
                            children: [
                              Container(
                                width: Sizeconfig.screenWidth,
                                height: 40,
                                color: MyAppColor.greynormal,
                                child: Center(
                                  child: Text(
                                    "JOB DETAILS",
                                    style: blackdarkM12,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              companyName(),
                              SizedBox(
                                height: 8,
                              ),
                              jobRoleHiringType(),
                              SizedBox(
                                height: 15,
                              ),
                              jobTitleRes(),
                              SizedBox(
                                height: 8,
                              ),
                              pincoderes(),
                              SizedBox(
                                height: 8,
                              ),
                              statesRes(),
                              SizedBox(
                                height: 15,
                              ),
                              if (city.isNotEmpty) cityRes(),
                              SizedBox(
                                height: 15,
                              ),
                              industryRes(),
                              SizedBox(
                                height: 15,
                              ),
                              if (sector.isNotEmpty) sectorRes(),
                              SizedBox(
                                height: 15,
                              ),
                              // selectjobType(),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              selectemploymentType(),
                              SizedBox(
                                height: 15,
                              ),
                              contractTypeRes(),
                              if (selectedContractType != null &&
                                  (selectedContractType!.key == 'other'))
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    contractTypeField(),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              if (selectedContractType != null &&
                                  (selectedContractType!.key == 'contracted' ||
                                      selectedContractType!.key ==
                                          'internship'))
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    NumberTextFormFieldWidget(
                                        text: "Specify Duration(in Months)",
                                        control:
                                            specifyContractDurationController,
                                        isRequired: true,
                                        maxLength: 2,
                                        type: TextInputType.number),
                                  ],
                                ),
                              SizedBox(
                                height: 8,
                              ),
                              selectedJobShedule(),
                              SizedBox(
                                height: 15,
                              ),
                              selectjobTime(),
                              SizedBox(
                                height: 15,
                              ),
                              selectPOsition(),
                              SizedBox(
                                height: 15,
                              ),
                              workFromeHere(),
                            ],
                          ),
                        SizedBox(
                          height: 8,
                        ),
                        if (Responsive.isDesktop(context))
                          Column(
                            children: [
                              Container(
                                width: Sizeconfig.screenWidth,
                                height: 40,
                                color: MyAppColor.greynormal,
                                child: Center(
                                    child: Text(
                                  "JOB DETAILS",
                                  style: blackdarkM12,
                                )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: companyName(),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                    child: jobRoleHiringType(),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: jobTitleRes(),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: pincoderes(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            child: statesRes()),
                                        if (city.isNotEmpty)
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 20),
                                              child: cityRes()),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: industryRes(),
                                        ),
                                        if (sector.isNotEmpty)
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 20),
                                              child: sectorRes()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: selectemploymentType(),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(child: workFromeHere()),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        contractTypeRes(),
                                        if (selectedContractType != null &&
                                            (selectedContractType!.key ==
                                                'other'))
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 15,
                                              ),
                                              contractTypeField(),
                                              SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          ),
                                        if (selectedContractType != null &&
                                            (selectedContractType!.key ==
                                                    'contracted' ||
                                                selectedContractType!.key ==
                                                    'internship'))
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 15,
                                              ),
                                              NumberTextFormFieldWidget(
                                                text:
                                                    "Specify Duration(in Months)",
                                                control:
                                                    specifyContractDurationController,
                                                isRequired: true,
                                                maxLength: 2,
                                                type: TextInputType.number,
                                              ),
                                            ],
                                          ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      selectedJobShedule(),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      selectjobTime()
                                    ],
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: selectPOsition(),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                            ".    .    .    .    .    .    .    .    .    .    ."),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: Sizeconfig.screenWidth,
                          height: 40,
                          color: MyAppColor.greynormal,
                          child: Center(
                              child: Text(
                            "JOB DESCRIPTION",
                            style: blackdarkM12,
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: !Responsive.isDesktop(context) ? 5 : 20,
                              horizontal:
                                  !Responsive.isDesktop(context) ? 13 : 0),
                          child: TextField(
                            controller: jobDescriptioncontroller,
                            textAlign: TextAlign.justify,
                            maxLength:
                                ref.read(companyProfile).descriptionLimit,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Job Description',
                              contentPadding:
                                  EdgeInsets.only(left: 16, top: 20),
                              hintStyle: !Responsive.isDesktop(context)
                                  ? blackDarkOpacityM14()
                                  : blackDarkOpacityM12(),
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: !Responsive.isDesktop(context) ? 8 : 3,
                          ),
                        ),
                        Text(
                            ".    .    .    .    .    .    .    .    .    .    ."),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: Sizeconfig.screenWidth,
                          height: 40,
                          color: MyAppColor.greynormal,
                          child: Center(
                              child: Text(
                            "SALARY DETAILS",
                            style: blackdarkM12,
                          )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            !Responsive.isDesktop(context)
                                ? Column(
                                    children: [
                                      saleryAmount(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      rangeofam(),
                                      fixedAmount(),
                                      uptocertain(),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding: paddingvertical30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                saleryAmount(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                rangeofam(),
                                                fixedAmount(),
                                                uptocertain(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [],
                                      ),
                                    ],
                                  ),
                            Column(
                                children:
                                    SalaryAmount.rangeOfAmounts == salaryAmount
                                        ? [
                                            saleryAmountfrom(context),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("To"),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            saleryAmountTo(context),
                                          ]
                                        : [
                                            saleryAmount2(context),
                                          ]),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  !Responsive.isDesktop(context) ? 0.0 : 30),
                          child: Text(
                              ".    .    .    .    .    .    .    .    .    .    ."),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: Sizeconfig.screenWidth,
                          height: 40,
                          color: MyAppColor.greynormal,
                          child: Center(
                              child: Text(
                            "SKILLS REQUIRED",
                            style: blackdarkM12,
                          )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                runSpacing: 10.0,
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: List.generate(
                                    selectedSkills.length,
                                    (index) => tagChip(
                                          text: selectedSkills[index].name,
                                          onTap: (name) {
                                            selectedSkills
                                                .remove(selectedSkills[index]);
                                            setState(() {});
                                          },
                                          action: 'Add',
                                        )).toList(),
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ]),
                        Container(
                          width: Sizeconfig.screenWidth,
                          child: Container(
                            color: MyAppColor.greynormal,
                            child: Responsive.isDesktop(context)
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15,
                                                  bottom: 15,
                                                  left: 15),
                                              child: Text(
                                                "SELECT A SKILLS CATEGORY",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            skillcategoryResponse(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 15, left: 15),
                                          child: Text(
                                            "SELECT SKILLS",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        subcatogaryResponse(context)
                                      ])),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 15, left: 15),
                                        child: Text(
                                          "SELECT A SKILLS CATEGORY",
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ),
                                      skillcategoryResponse(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, left: 15, top: 15),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                      ),
                                      if (subSkills.isNotEmpty)
                                        subcatogaryResponse(context),
                                    ],
                                  ),
                          ),
                        ),
                        Text(
                            ".    .    .    .    .    .    .    .    .    .    ."),
                        Container(
                          height: 15,
                        ),
                        Container(
                          width: Sizeconfig.screenWidth,
                          height: 40,
                          color: MyAppColor.greynormal,
                          child: Center(
                              child: Text(
                            "APPLICANTS REQUIREMENTS & INFO",
                            style: blackdarkM12,
                          )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        !Responsive.isDesktop(context)
                            ? Column(
                                children: [
                                  selectexperienced(),
                                  if (isExperienceRequired != null &&
                                      isExperienceRequired!.key == 'Y')
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
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
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: Sizeconfig.screenWidth! /
                                                    2.3,
                                                child:
                                                    dynamicDropDownListOfFields(
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
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("To"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width:
                                                    Sizeconfig.screenWidth! / 2,
                                                child:
                                                    NumberTextFormFieldWidget(
                                                        text: "Experience To",
                                                        control:
                                                            experienceInToController,
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
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: Sizeconfig.screenWidth! /
                                                    2.3,
                                                child:
                                                    dynamicDropDownListOfFields(
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  selectEducation(),
                                  if (isEducationRequired != null &&
                                      isEducationRequired!.key == 'Y')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        dynamicDropDownListOfFields(
                                          label: DropdownString
                                              .selectRequiredEducation,
                                          dropDownList: educations,
                                          selectingValue: selectedEducation,
                                          setValue: (value) {
                                            if (DropdownString
                                                    .selectRequiredEducation ==
                                                value!) {
                                              return;
                                            }
                                            selectedEducation = educations
                                                .firstWhere((element) =>
                                                    element.name == value);
                                          },
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Select requires to submit Resume?"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      radioButtonWithText(
                                          value: YesNo.yes,
                                          groupValue: yesNoRadio,
                                          text: "Yes",
                                          onChanged: (v) =>
                                              yesNoValueChange(v)),
                                      radioButtonWithText(
                                          value: YesNo.no,
                                          groupValue: yesNoRadio,
                                          text: "No",
                                          onChanged: (v) =>
                                              yesNoValueChange(v)),
                                      radioButtonWithText(
                                          value: YesNo.optional,
                                          groupValue: yesNoRadio,
                                          text: "Optional",
                                          onChanged: (v) =>
                                              yesNoValueChange(v)),
                                    ],
                                  ),
                                  if (userData!.userRoleType ==
                                      RoleTypeConstant.company)
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextFormFieldWidget(
                                            text:
                                                "Specify the Email that Receives Applications",
                                            control: specifyEmailController,
                                            isRequired: false,
                                            type: TextInputType.emailAddress,
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (ref.read(companyProfile).jobBoostingAll)
                                    Padding(
                                        padding: EdgeInsets.only(top: 15),
                                        child: statesBrandRes()),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            selectexperienced(),
                                            if (isExperienceRequired != null &&
                                                isExperienceRequired!.key ==
                                                    'Y')
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          width: Sizeconfig
                                                                  .screenWidth! /
                                                              2,
                                                          child:
                                                              NumberTextFormFieldWidget(
                                                                  text:
                                                                      "Experience From",
                                                                  control:
                                                                      experienceInFromController,
                                                                  isRequired:
                                                                      true,
                                                                  onTap: () {
                                                                    if (selectedExperienceFromType ==
                                                                        null) {
                                                                      return showSnack(
                                                                          context:
                                                                              context,
                                                                          msg:
                                                                              "Please select experience  type first",
                                                                          type:
                                                                              'error');
                                                                    }
                                                                  },
                                                                  enableInterative:
                                                                      false,
                                                                  type: selectedExperienceFromType !=
                                                                          null
                                                                      ? TextInputType
                                                                          .number
                                                                      : TextInputType
                                                                          .none),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          width: Sizeconfig
                                                                  .screenWidth! /
                                                              2.3,
                                                          child:
                                                              dynamicDropDownListOfFields(
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
                                                                  experiencePeriodType!.firstWhere(
                                                                      (element) =>
                                                                          element
                                                                              .name ==
                                                                          value);
                                                              setState(() {});
                                                            },
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
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          width: Sizeconfig
                                                                  .screenWidth! /
                                                              2,
                                                          child:
                                                              NumberTextFormFieldWidget(
                                                                  text:
                                                                      "Experience To",
                                                                  control:
                                                                      experienceInToController,
                                                                  onTap: () {
                                                                    if (selectedExperienceToType ==
                                                                        null) {
                                                                      return showSnack(
                                                                          context:
                                                                              context,
                                                                          msg:
                                                                              "Please select experience type first",
                                                                          type:
                                                                              'error');
                                                                    }
                                                                  },
                                                                  type: selectedExperienceToType !=
                                                                          null
                                                                      ? TextInputType
                                                                          .number
                                                                      : TextInputType
                                                                          .none,
                                                                  isRequired:
                                                                      true),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          width: Sizeconfig
                                                                  .screenWidth! /
                                                              2.3,
                                                          child:
                                                              dynamicDropDownListOfFields(
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
                                                                  experiencePeriodType!.firstWhere(
                                                                      (element) =>
                                                                          element
                                                                              .name ==
                                                                          value);

                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          selectEducation(),
                                          if (isEducationRequired != null &&
                                              isEducationRequired!.key == 'Y')
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                dynamicDropDownListOfFields(
                                                  label: DropdownString
                                                      .selectRequiredEducation,
                                                  dropDownList: educations,
                                                  selectingValue:
                                                      selectedEducation,
                                                  setValue: (value) {
                                                    if (DropdownString
                                                            .selectRequiredEducation ==
                                                        value!) {
                                                      return;
                                                    }
                                                    selectedEducation =
                                                        educations.firstWhere(
                                                            (element) =>
                                                                element.name ==
                                                                value);
                                                  },
                                                ),
                                              ],
                                            ),
                                        ],
                                      ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                      ".    .    .    .    .    .    .    .    .    .    ."),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          selectSubmitResume(),
                                          // SizedBox(
                                          //   height: 20,
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          yesRadioBtn(),
                                          NoRadioBtn(),
                                          noRadioBtn(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                            ".    .    .    .    .    .    .    .    .    .    ."),
                        SizedBox(
                          height: 15,
                        ),
                        if (Responsive.isDesktop(context))
                          Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  text:
                                      "Specify the Email that Receives Applications",
                                  control: specifyEmailController,
                                  isRequired: false,
                                  type: TextInputType.emailAddress,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: ref.read(companyProfile).jobBoostingAll
                                    ? statesBrandRes()
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        Text(
                            ".    .    .    .    .    .    .    .    .    .    ."),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: Sizeconfig.screenWidth,
                          height: 40,
                          color: MyAppColor.greynormal,
                          child: Center(
                              child: Text(
                            "QUESTIONS FOR APPLICANTS",
                            style: blackdarkM12,
                          )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        !Responsive.isDesktop(context)
                            ? ListView(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: children,
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Wrap(
                                      children: children,
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          height: 1,
                          color: MyAppColor.greyfulldark,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();

                                if (!isFormValid(_formJobKey)) {
                                  return;
                                }
                                if (salaryAmount ==
                                    SalaryAmount.rangeOfAmounts) {
                                  if (salaryInFromController.text != '' &&
                                      salaryInToController.text != '') {
                                    if (int.tryParse(
                                            salaryInToController.text)! <=
                                        int.parse(
                                            salaryInFromController.text)) {
                                      return showSnack(
                                          context: context,
                                          msg: "Salary range amount is invalid",
                                          type: 'error');
                                    }
                                  }
                                }

                                if (selectedSkills.isEmpty) {
                                  return showSnack(
                                      context: context,
                                      msg: 'Select skills',
                                      type: 'error');
                                }
                                String subSkill = selectedSkills
                                    .map((e) => e.id)
                                    .toList()
                                    .join(",");
                                List<String> questions = [];
                                for (var e in controllers) {
                                  questions.add(e.text);
                                }
                                if (jobDescriptioncontroller.text == '') {
                                  return showSnack(
                                      context: context,
                                      msg: "Job description cannot empty",
                                      type: 'error');
                                } else if (!(jobDescriptioncontroller
                                        .text.length >
                                    30)) {
                                  return showSnack(
                                      context: context,
                                      msg:
                                          "Job description cannot be less than 30 or more than 1000 words",
                                      type: 'error');
                                }
                                await createJob(
                                    companyName: companyController.text,
                                    jobTitle: jobTitleController.text,
                                    roleOfHiring: selectedRole!.id,
                                    industryId: selectedIndustry!.id,
                                    sectorId: selectedSector!.id,
                                    employmentType: selectedEmploymentType!.key,
                                    userId: userData!.id,
                                    contractType: selectedContractType!.key,
                                    contractDuration:
                                        specifyContractDurationController.text,
                                    otherContractType: otherContractType.text,
                                    jobSchedule: selectedJobSchedule!.key,
                                    jobTimetable: selectedJobTimeTable,
                                    workFromHome: isWorkFromHome!.key,
                                    numberOfPosition:
                                        noOfPositionsController.text,
                                    jobDescription:
                                        jobDescriptioncontroller.text,
                                    salaryType: salaryAmount ==
                                            SalaryAmount.rangeOfAmounts
                                        ? "amount_in_range"
                                        : salaryAmount ==
                                                SalaryAmount.fixedAmuont
                                            ? "fixed_amount"
                                            : 'upto_amount',
                                    salaryFrom: salaryInFromController.text,
                                    salaryTo: salaryInToController.text,
                                    cityId: selectedCity!.id,
                                    educationId: selectedEducation == null
                                        ? null
                                        : selectedEducation!.id,
                                    educationRequired: isEducationRequired!.key,
                                    email: specifyEmailController.text.trim(),
                                    expFrom: experienceInFromController.text
                                        .toString(),
                                    expTo: experienceInToController.text
                                        .toString(),
                                    experienceRequired:
                                        isExperienceRequired!.key,
                                    paidType: selectedSalaryType!.key,
                                    pinCode: pinCodeController.text,
                                    salary: salaryController.text.toString(),
                                    skillSubCategoryId: subSkill,
                                    stateId: selectedState!.id,
                                    submitResume:
                                        yesNoRadio == YesNo.no ? 'N' : 'Y',
                                    userQuestion: questions.join(','),
                                    isForPreview: true);
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                child: Text(
                                  "PREVIEW JOB",
                                  style: blackDarkO40M12,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                child: Text(
                                  widget.jobsEditId != null
                                      ? 'SAVE EDIT JOB'
                                      : 'POST THE JOB',
                                  style: whiteR12(),
                                ),
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (!isFormValid(_formJobKey)) {
                                  return;
                                }
                                if (salaryAmount ==
                                    SalaryAmount.rangeOfAmounts) {
                                  if (salaryInFromController.text != '' &&
                                      salaryInToController.text != '') {
                                    if (int.parse(salaryInToController.text) <=
                                        int.parse(
                                            salaryInFromController.text)) {
                                      return showSnack(
                                          context: context,
                                          msg: "Salary range amount is invalid",
                                          type: 'error');
                                    }
                                  }
                                }
                                if (selectedSkills.isEmpty) {
                                  return showSnack(
                                      context: context,
                                      msg: "select skills",
                                      type: 'error');
                                }

                                String subSkill = selectedSkills
                                    .map((e) => e.id)
                                    .toList()
                                    .join(",");
                                List<String> questions = [];
                                for (var e in controllers) {
                                  questions.add(e.text);
                                }
                                String jobDescription =
                                    jobDescriptioncontroller.text;
                                if (jobDescription.isEmpty) {
                                  return showSnack(
                                      context: context,
                                      msg: "Job description cannot empty",
                                      type: 'error');
                                } else if (!(jobDescription.length > 30 &&
                                    jobDescription.length < 1000)) {
                                  return showSnack(
                                      context: context,
                                      msg:
                                          "Job description cannot be less than 30 or more than 1000 words",
                                      type: 'error');
                                }
                                await createJob(
                                    companyName: companyController.text,
                                    jobTitle: jobTitleController.text,
                                    roleOfHiring: selectedRole!.id,
                                    industryId: selectedIndustry!.id,
                                    sectorId: selectedSector!.id,
                                    employmentType: selectedEmploymentType!.key,
                                    userId: userData!.id,
                                    contractType: selectedContractType!.key,
                                    otherContractType:
                                        otherContractType.text.toString(),
                                    contractDuration:
                                        specifyContractDurationController.text,
                                    jobSchedule: selectedJobSchedule!.key,
                                    jobTimetable: selectedJobTimeTable,
                                    workFromHome: isWorkFromHome!.key,
                                    numberOfPosition:
                                        noOfPositionsController.text,
                                    jobDescription:
                                        jobDescriptioncontroller.text,
                                    salaryType: salaryAmount ==
                                            SalaryAmount.rangeOfAmounts
                                        ? "amount_in_range"
                                        : salaryAmount ==
                                                SalaryAmount.fixedAmuont
                                            ? "fixed_amount"
                                            : 'upto_amount',
                                    salaryFrom: salaryInFromController.text,
                                    salaryTo: salaryInToController.text,
                                    cityId: selectedCity!.id,
                                    educationId: selectedEducation == null
                                        ? null
                                        : selectedEducation!.id,
                                    educationRequired: isEducationRequired!.key,
                                    email: specifyEmailController.text.trim(),
                                    expFrom: experienceInFromController.text
                                        .toString(),
                                    expTo: experienceInToController.text
                                        .toString(),
                                    experienceRequired:
                                        isExperienceRequired!.key,
                                    otherRoleOfHiring:
                                        roleOfHiringController.text.toString(),
                                    paidType: selectedSalaryType!.key,
                                    pinCode: pinCodeController.text,
                                    salary: salaryController.text.toString(),
                                    skillSubCategoryId: subSkill,
                                    stateId: selectedState!.id,
                                    submitResume:
                                        yesNoRadio == YesNo.no ? 'N' : 'Y',
                                    userQuestion: questions.join(','),
                                    isForPreview: false);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        MyAppColor.orangelight),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Footer()
          ],
        ),
      ),
    );
  }

  Widget saleryAmount2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            width: Sizeconfig.screenWidth! / 2,
            child: NumberTextFormFieldWidget(
                text: "Salary Amount",
                control: salaryController,
                onTap: () {
                  if (selectedSalaryType == null) {
                    return showSnack(
                        context: context,
                        msg: "Please select salary type first",
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
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            width: Sizeconfig.screenWidth! / 2.3,
            child: dynamicDropDownListOfFields(
              label: DropdownString.selectSalaryType,
              dropDownList: salaryType,
              selectingValue: selectedSalaryType,
              setValue: (value) {
                if (DropdownString.selectSalaryType == value!) {
                  selectedSalaryType = null;
                  setState(() {});
                  return;
                }
                selectedSalaryType =
                    salaryType!.firstWhere((element) => element.name == value);
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Row saleryAmountTo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            width: Sizeconfig.screenWidth! / 2,
            child: NumberTextFormFieldWidget(
                text: "Salary Amount",
                control: salaryInToController,
                onTap: () {
                  if (selectedSalaryType == null) {
                    return showSnack(
                        context: context,
                        msg: "Please select salary type first",
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
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            width: Sizeconfig.screenWidth! / 2.3,
            child: dynamicDropDownListOfFields(
              label: DropdownString.selectSalaryType,
              dropDownList: salaryType,
              selectingValue: selectedSalaryType,
              setValue: (value) {
                if (DropdownString.selectSalaryType == value!) {
                  selectedSalaryType = null;
                  setState(() {});
                  return;
                }
                selectedSalaryType =
                    salaryType!.firstWhere((element) => element.name == value);
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Row saleryAmountfrom(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            width: Sizeconfig.screenWidth! / 2,
            child: NumberTextFormFieldWidget(
                text: "Salary Amount",
                control: salaryInFromController,
                isRequired: true,
                onTap: () {
                  if (selectedSalaryType == null) {
                    return showSnack(
                        context: context,
                        msg: "Please select salary type first",
                        type: 'error');
                  }
                },
                enableInterative: false,
                type: selectedSalaryType != null
                    ? TextInputType.number
                    : TextInputType.none),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            width: Sizeconfig.screenWidth! / 2.3,
            child: dynamicDropDownListOfFields(
              label: DropdownString.selectSalaryType,
              dropDownList: salaryType,
              selectingValue: selectedSalaryType,
              setValue: (value) {
                if (DropdownString.selectSalaryType == value!) {
                  selectedSalaryType = null;
                  setState(() {});
                  return;
                }
                selectedSalaryType =
                    salaryType!.firstWhere((element) => element.name == value);
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  noRadioBtn() {
    return radioButtonWithText(
        value: YesNo.optional,
        groupValue: yesNoRadio,
        text: "Optional",
        onChanged: (v) => yesNoValueChange(v));
  }

  NoRadioBtn() {
    return radioButtonWithText(
        value: YesNo.no,
        groupValue: yesNoRadio,
        text: "No",
        onChanged: (v) => yesNoValueChange(v));
  }

  yesRadioBtn() {
    return radioButtonWithText(
        value: YesNo.yes,
        groupValue: yesNoRadio,
        text: "Yes",
        onChanged: (v) => yesNoValueChange(v));
  }

  Text selectSubmitResume() => Text("Select applicant to submit Resume?");

  selectEducation() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectEducationReq,
      dropDownList: yesNo,
      selectingValue: isEducationRequired,
      setValue: (value) {
        if (DropdownString.selectEducationReq == value!) {
          return;
        }
        setState(() {
          isEducationRequired =
              yesNo!.firstWhere((element) => element.name == value);
        });
      },
    );
  }

  selectexperienced() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectExperienceReq,
      dropDownList: yesNo,
      selectingValue: isExperienceRequired,
      setValue: (value) {
        if (DropdownString.selectExperienceReq == value!) {
          return;
        }
        isExperienceRequired =
            yesNo!.firstWhere((element) => element.name == value);
        setState(() {});
      },
    );
  }

  uptocertain() {
    return radioButtonWithText(
        value: SalaryAmount.uptoCertainAmount,
        groupValue: salaryAmount,
        text: "Upto a certain Amount",
        onChanged: (v) => salaryValueChange(v));
  }

  fixedAmount() {
    return radioButtonWithText(
        value: SalaryAmount.fixedAmuont,
        groupValue: salaryAmount,
        text: "Fixed Amount",
        onChanged: (v) => salaryValueChange(v));
  }

  rangeofam() {
    return radioButtonWithText(
        value: SalaryAmount.rangeOfAmounts,
        groupValue: salaryAmount,
        text: "Range of Amounts",
        onChanged: (v) => salaryValueChange(v));
  }

  Text saleryAmount() => Text("Select Salary Amount Type");

  workFromeHere() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectWFHOption,
      dropDownList: wfhList,
      selectingValue: isWorkFromHome,
      setValue: (value) {
        if (DropdownString.selectWFHOption == value!) {
          return;
        }
        isWorkFromHome =
            wfhList!.firstWhere((element) => element.name == value);
      },
    );
  }

  selectPOsition() {
    return dropDownListOfFields(
      label: DropdownString.selectNoOfPositions,
      dropDownList: ListDropdown.number,
      selectingValue: selectedNoOfPositions,
      setValue: (value) {
        if (DropdownString.selectNoOfPositions == value!) {
          return;
        }
        selectedNoOfPositions = value;
        noOfPositionsController.text = value.toString();
      },
    );
  }

  selectjobTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            child: TextFormFieldWidget(
                text: "From",
                control: fromTiming,
                isRequired: true,
                onTap: () async {
                  String time = await _selectTime(context);
                  fromTiming.text = time;
                  setState(() {});
                },
                enableCursor: false,
                enableInterative: false,
                type: TextInputType.none),
          ),
          SizedBox(
            width: 150,
            child: TextFormFieldWidget(
                text: "To",
                control: toTiming,
                isRequired: true,
                onTap: () async {
                  String time = await _selectTime(context);
                  toTiming.text = time;
                  setState(() {});
                },
                enableCursor: false,
                enableInterative: false,
                type: TextInputType.none),
          )
        ],
      ),
    );
    dropDownListOfFields(
      label: DropdownString.selectJobTime,
      dropDownList: ListDropdown.jobTimeTable,
      selectingValue: selectedJobTimeTable,
      setValue: (value) {
        if (DropdownString.selectJobTime == value!) {
          return;
        }
        selectedJobTimeTable = value;
      },
    );
  }

  selectedJobShedule() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectJobSchedule,
      dropDownList: jobSchedule,
      selectingValue: selectedJobSchedule,
      setValue: (value) {
        if (DropdownString.selectJobSchedule == value!) {
          return;
        }
        selectedJobSchedule =
            jobSchedule!.firstWhere((element) => element.name == value);
      },
    );
  }

  TextFormFieldWidget contractTypeField() {
    return TextFormFieldWidget(
        text: "Contract Type",
        control: otherContractType,
        isRequired: true,
        type: TextInputType.multiline);
  }

  contractTypeRes() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectContractType,
      dropDownList: contractType,
      selectingValue: selectedContractType,
      setValue: (value) {
        if (DropdownString.selectContractType == value!) {
          return;
        }
        selectedContractType =
            contractType!.firstWhere((element) => element.name == value);
      },
    );
  }

  selectemploymentType() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectEmploymentType,
      dropDownList: employmentType,
      selectingValue: selectedEmploymentType,
      setValue: (value) {
        if (DropdownString.selectEmploymentType == value!) {
          return;
        }
        selectedEmploymentType =
            employmentType!.firstWhere((element) => element.name == value);
      },
    );
  }

  selectjobType() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectJobType,
      dropDownList: jobTypes,
      selectingValue: selectedJobType,
      setValue: (value) {
        if (DropdownString.selectJobType == value!) {
          return;
        }
        selectedJobType =
            jobTypes!.firstWhere((element) => element.name == value);
      },
    );
  }

  sectorRes() {
    return dynamicDropDownListOfFields(
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
  }

  industryRes() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectIndustry,
      dropDownList: industry,
      selectingValue: selectedIndustry,
      setValue: (value) async {
        if (DropdownString.selectIndustry == value!) {
          return;
        }
        selectedIndustry =
            industry.firstWhere((element) => element.name == value);
        await fetchSectors(selectedIndustry!.id);
      },
    );
  }

  jobRoleHiringType() {
    return dynamicDropDownListOfFields(
      label: DropdownString.roleInHiring,
      dropDownList: jobRoleType,
      selectingValue: selectedRole,
      setValue: (value) async {
        if (DropdownString.roleInHiring == value!) {
          return;
        }
        selectedRole =
            jobRoleType.firstWhere((element) => element.name == value);
      },
    );
  }

  cityRes() {
    return dynamicDropDownListOfFields(
        label: DropdownString.selectCity,
        dropDownList: city,
        selectingValue: selectedCity,
        setValue: (value) {
          if (DropdownString.selectCity == value!) {
            return;
          }
          setState(() {
            selectedCity = city.firstWhere((element) => element.name == value);
          });
        },
        isValidDrop: selectedState != null,
        alertMsg: AlertString.selectState);
  }

  statesRes() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectState,
      dropDownList: state,
      selectingValue: selectedState,
      setValue: (value) async {
        if (DropdownString.selectState == value!) {
          return;
        }
        selectedState =
            state.firstWhere((element) => element.name.toString() == value);

        await fetchCity(selectedState!.id);
      },
    );
  }

  statesBrandRes() {
    return dynamicDropDownListOfFields(
      label: DropdownString.selectState + " For Boosting",
      dropDownList: state,
      selectingValue: selectedBrandPostState,
      setValue: (value) async {
        if (DropdownString.selectState == value!) {
          selectedBrandPostState = null;
          return;
        }
        selectedBrandPostState =
            state.firstWhere((element) => element.name.toString() == value);
      },
    );
  }

  NumberTextFormFieldWidget pincoderes() {
    return NumberTextFormFieldWidget(
        text: "Pin Code",
        control: pinCodeController,
        isRequired: true,
        maxLength: 6,
        onChanged: (value) async {
          if (value.length == 6) {
            await setLocationOnTheBasisOfPinCode(value);
          }
        },
        type: TextInputType.number);
  }

  TextFormFieldWidget jobTitleRes() {
    return TextFormFieldWidget(
        text: "Job Title",
        control: jobTitleController,
        isRequired: true,
        type: TextInputType.multiline);
  }

  Widget subcatogaryResponse(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 20),
      child: Container(
        width: !Responsive.isDesktop(context)
            ? Sizeconfig.screenWidth!
            : Sizeconfig.screenWidth! / 4,
        color: MyAppColor.greynormal,
        child: subSkills.isEmpty
            ? SizedBox()
            : Container(
                height: 300,
                child: ListView(
                    children: List.generate(
                        subSkills.length,
                        (index) => tagListElement(
                            index: index,
                            text: subSkills[index].name,
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());

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

  Widget skillcategoryResponse() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        width: Responsive.isDesktop(context)
            ? Sizeconfig.screenWidth! / 4
            : Sizeconfig.screenWidth!,
        height: 300,
        color: MyAppColor.greynormal,
        padding: EdgeInsets.all(10),
        // color: MyAppColor.greynormal,
        child: skillCategory.isEmpty
            ? SizedBox()
            : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        skillCategory.length,
                        (index) => courseListElement(
                            skillCategory[index].name,
                            index,
                            isSelectedSkillCheck(skillCategory[index].id)))),
              ),
      ),
    );
  }

  companyName() {
    return NonEditableTextField(
      label: "Company Name",
      value: companyController.text,
    );
  }

  Text createJobpost() {
    return Text(
      "CREATE A JOB POST",
      style: blackDarkR14(),
      textAlign: TextAlign.justify,
    );
  }

  Widget postJob(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Text(
          'POST THE JOB',
          style: Mytheme.lightTheme(context)
              .textTheme
              .headline1!
              .copyWith(color: MyAppColor.backgroundColor, fontSize: 16),
        ),
      ),
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(MyAppColor.orangelight),
      ),
    );
  }

  Widget previewJob() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.0, color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Text(
          "PREVIEW JOB",
          style: TextStyle(color: MyAppColor.greyfulldark, fontSize: 14),
        ),
      ),
    );
  }

  Widget divider() {
    return Divider(
      height: 1,
      color: MyAppColor.greyfulldark,
    );
  }

  Widget questionsfor() {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth
          : Sizeconfig.screenWidth! / 1.9,
      height: 40,
      color: MyAppColor.greynormal,
      child: Center(child: Text("QUESTIONS FOR APPLICANTS")),
    );
  }

  Widget optionRadio() {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (v) {},
          ),
          Text("Optional")
        ],
      ),
    );
  }

  Widget noRadio() {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (v) {},
          ),
          Text("No")
        ],
      ),
    );
  }

  Container yesRadio() {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (v) {},
          ),
          Text("Yes")
        ],
      ),
    );
  }

  Text selectRequires() => Text("Select applicant to submit Resume?");

  Container _application() {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth
          : Sizeconfig.screenWidth! / 1.9,
      height: 40,
      color: MyAppColor.greynormal,
      child: Center(child: Text("APPLICANTS REQUIREMENTS & INFO")),
    );
  }

  Container _upto() {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (v) {},
          ),
          Text("Upto a certain Amount")
        ],
      ),
    );
  }

  Container dropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: Responsive.isMobile(context) ? 46 : 35,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MyAppColor.white),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          child: DropdownButton<String>(
            value: DropdownString.functionalArea,
            icon: IconFile.arrow,
            iconSize: 25,
            elevation: 16,
            style: TextStyle(color: MyAppColor.blackdark),
            underline: Container(
              height: 3,
              width: MediaQuery.of(context).size.width,
              color: MyAppColor.blackdark,
            ),
            onChanged: (String? newValue) {
              setState(() {
                DropdownString.functionalArea = newValue!;
              });
            },
            items: ListDropdown.functions
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
    );
  }

  Container dropdown1(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: Responsive.isMobile(context) ? 46 : 30,
      width: Responsive.isMobile(context)
          ? double.infinity
          : Sizeconfig.screenWidth! / 8.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MyAppColor.white),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          child: DropdownButton<String>(
            value: DropdownString.functionalArea,
            icon: IconFile.arrow,
            iconSize: 25,
            elevation: 16,
            style: TextStyle(color: MyAppColor.blackdark),
            underline: Container(
              height: 3,
              width: MediaQuery.of(context).size.width,
              color: MyAppColor.blackdark,
            ),
            onChanged: (String? newValue) {
              setState(() {
                DropdownString.functionalArea = newValue!;
              });
            },
            items: ListDropdown.functions
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
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: !Responsive.isDesktop(context) ? 27 : 22,
                child: CircleAvatar(
                    backgroundColor: MyAppColor.backgray,
                    child: Icon(
                      Icons.arrow_back,
                      size: !Responsive.isDesktop(context) ? 21 : 18,
                      color: Colors.black,
                    )),
              ),
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
            Text("HOME / CREATE A JOB POST",
                style: GoogleFonts.darkerGrotesque(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  courseListElement(text, index, isSelected) {
    Color color = isSelected ? Colors.white : Colors.transparent;
    return InkWell(
      onTap: () async {
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
    return Container(
      color: selectedSkills.contains(subSkills[index])
          ? MyAppColor.orangelight
          : Colors.transparent,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    color: selectedSkills.contains(subSkills[index])
                        ? Colors.white
                        : Colors.black,
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
      ),
    );
  }

  radioButtonWithText({groupValue, value, text, onChanged}) {
    return Container(
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

  dropDownListOfFields(
      {String? label, List? dropDownList, selectingValue, Function? setValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 00.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        // height: Responsive.isMobile(context) ? 46 : 35,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth!,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            child: Container(
              child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  validator: (value) {
                    if (selectingValue == null) return "Select $label";
                    return null;
                  },
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  value: selectingValue ?? label,
                  icon: IconFile.arrow,
                  iconSize: 25,
                  elevation: 16,
                  style: TextStyle(color: MyAppColor.blackdark),
                  onChanged: (String? newValue) => setValue!(newValue),
                  items: [
                    DropdownMenuItem<String>(
                      value: label,
                      child: Text(
                        "$label",
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // height: !Responsive.isDesktop(context) ? 00 : 35,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MyAppColor.white),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          buttonColor: Colors.red,
          child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              )),
              validator: (value) {
                if (selectingValue == null) return "Select $label";
                return null;
              },
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
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
                    "$label",
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
}
