import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:hindustan_job/candidate/candidateWidget/tag_chip_widget.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/resume_model.dart';
import 'package:hindustan_job/candidate/model/skill_category.dart';
import 'package:hindustan_job/candidate/model/skill_sub_category_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/resume_view.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/api_services/resume_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/dialog_show_pop_up.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/drop_down_widget/pop_picker.dart';
import 'package:hindustan_job/widget/drop_down_widget/pop_selector.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as i;

import 'package:vrouter/vrouter.dart';

import '../header/back_text_widget.dart';

class ResumeBuilder extends ConsumerStatefulWidget {
  bool isFromConnectedRoutes;
  ResumeBuilder({Key? key, required this.isFromConnectedRoutes})
      : super(key: key);

  @override
  _ResumeBuilderState createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends ConsumerState<ResumeBuilder> {
  int _activeStepIndex = 0;
  var newprofile;
  XFile? main_image;
  XFile? croppedFile;
  final picker = ImagePicker();
  PlatformFile? logo;
  String? networkImage;
  i.File? _image;
  int educationCount = 1;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<Hobbies> hobbiesList = [];
  States? selectedState;
  List<States> state = [];
  City? selectedCity;
  List<City> city = [];
  List selectedHobbies = [];
  TextEditingController firstNameController =
      TextEditingController(text: userData!.name ?? '');
  TextEditingController designationController =
      TextEditingController(text: userData!.yourDesignation ?? '');
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController =
      TextEditingController(text: userData!.email ?? '');
  TextEditingController contactNoController =
      TextEditingController(text: userData!.mobile ?? '');
  TextEditingController pincodeController =
      TextEditingController(text: userData!.pinCode ?? '');
  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController linkdinController =
      TextEditingController(text: userData!.linkdinId ?? '');
  TextEditingController behanceController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();
  List<SubSkill> selectedSkills = [];
  List<EducationResume> educationResume = [];
  List<EducationResume> experienceResume = [];
  List<EducationResume> referenceResume = [];
  ResumeModel? resumeData;

  @override
  void initState() {
    super.initState();
    fetchState();
    if (kIsWeb) {
      ref.read(editProfileData).checkSubscription();
    }
    for (var element in ListDropdown.hobbies) {
      hobbiesList.add(Hobbies.fromJson(element));
    }
  }

  getResumeData() async {
    ApiResponse response = await getResume(context);
    if (response.status == 200) {
      resumeData = ResumeModel.fromJson(response.body!.data);
      if (resumeData != null) {
        networkImage = resumeData!.image ?? userData!.image;
        firstNameController.text = resumeData!.name ?? userData!.name!;
        designationController.text =
            resumeData!.designation ?? userData!.yourDesignation!;
        descriptionController.text = resumeData!.description ?? '';
        emailController.text = resumeData!.email ?? userData!.email!;
        contactNoController.text = resumeData!.contact ?? userData!.mobile!;
        pincodeController.text =
            (resumeData!.pinCode ?? userData!.pinCode).toString();
        facebookController.text = resumeData!.facebook ?? '';
        instagramController.text = resumeData!.instagram ?? '';
        linkdinController.text = resumeData!.linkedin ?? '';
        behanceController.text = resumeData!.behance ?? '';

        await setLocationOnTheBasisOfPinCode(resumeData!.pinCode);
        if (resumeData!.state != null) {
          selectedState = resumeData!.state;
          fetchCity(selectedState!.id);
          selectedCity = resumeData!.city;
        }

        if (resumeData!.resumeEducations!.isEmpty) {
          educationResume.add(EducationResume(
            title: TextEditingController(),
            description: TextEditingController(),
            from: TextEditingController(),
            to: TextEditingController(),
          ));
        } else {
          for (var element in resumeData!.resumeEducations!) {
            educationResume.add(EducationResume(
              id: element.id,
              title: TextEditingController(text: element.title),
              description: TextEditingController(text: element.description),
              from: TextEditingController(text: element.from.toString()),
              to: TextEditingController(text: element.to.toString()),
            ));
          }
        }
        if (resumeData!.resumeExperiences!.isEmpty) {
          experienceResume.add(EducationResume(
            title: TextEditingController(),
            description: TextEditingController(),
            designation: TextEditingController(),
            from: TextEditingController(),
            to: TextEditingController(),
          ));
        } else {
          for (var element in resumeData!.resumeExperiences!) {
            experienceResume.add(EducationResume(
              id: element.id,
              title: TextEditingController(text: element.title),
              description: TextEditingController(text: element.description),
              from: TextEditingController(text: element.from.toString()),
              to: TextEditingController(text: element.to.toString()),
            ));
          }
        }
        if (resumeData!.resumeReferences!.isEmpty) {
          referenceResume.add(EducationResume(
            title: TextEditingController(),
            designation: TextEditingController(),
            phoneNumber: TextEditingController(),
            email: TextEditingController(),
          ));
        } else {
          for (var element in resumeData!.resumeReferences!) {
            referenceResume.add(EducationResume(
              id: element.id,
              title: TextEditingController(text: element.title),
              designation: TextEditingController(text: element.designation),
              phoneNumber:
                  TextEditingController(text: element.phone.toString()),
              email: TextEditingController(text: element.email.toString()),
            ));
          }
        }

        if (resumeData!.resumeSkills!.isEmpty) {
          selectedSkills = [];
        } else {
          for (var element in resumeData!.resumeSkills!) {
            var obj = {
              'id': int.parse(element.skillSubCategoryId.toString()),
              'name': element.skillSubCategory!.name,
              'isSelected': true,
              'rating': element.rating != null
                  ? int.parse(element.rating.toString())
                  : '',
              'resume_skill_id': element.id,
              'skill_category_id': element.skillCategoryId
            };
            selectedSkills.add(SubSkill.fromJson(obj));
          }
        }
        if (resumeData!.resumeHobbies!.isEmpty) {
          selectedHobbies = [];
        } else {
          for (var element in resumeData!.resumeHobbies!) {
            var hobby = hobbiesList
                .where((el) => el.name == element.hobbyName)
                .toList();
            if (hobby.isNotEmpty) {
              hobby.first.isSelected = true;
            }
            selectedHobbies.add(Hobbies(
                name: element.hobbyName, id: element.id, isSelected: true));
          }
        }
      }
      setState(() {});
    } else if (response.status == 400) {
      educationResume.add(EducationResume(
        title: TextEditingController(),
        description: TextEditingController(),
        from: TextEditingController(),
        to: TextEditingController(),
      ));
      referenceResume.add(EducationResume(
        title: TextEditingController(),
        designation: TextEditingController(),
        phoneNumber: TextEditingController(),
        email: TextEditingController(),
      ));
      experienceResume.add(EducationResume(
        title: TextEditingController(),
        description: TextEditingController(),
        designation: TextEditingController(),
        from: TextEditingController(),
        to: TextEditingController(),
      ));
      setState(() {});
    }
    if (networkImage != null) {
      networkImage = userData?.image;
      setState(() {});
    }
  }

  basicDetailsAdd({firstName, designation, description, image}) async {
    Map<String, dynamic> carryData = {
      "name": firstName,
      "designation": designation,
      "description": description,
    };
    if (image != null) {
      carryData["image"] = kIsWeb
          ? MultipartFile.fromBytes(image.bytes, filename: image.name)
          : await MultipartFile.fromFile(image.path,
              filename: image.path.toString().split('/').last);
    }
    ApiResponse response;
    if (resumeData != null) {
      response = await resumeUpdate(context, carryData, id: resumeData!.id);
    } else {
      response = await resumeCreate(context, carryData);
    }
    if (response.status == 200) {
      resumeData = ResumeModel.fromJson(response.body!.data);
      return showSnack(context: context, msg: response.body!.message);
    } else {
      return showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  contactDetailsAdd({emailAddress, contactNo, pincode, state, city}) async {
    Map<String, dynamic> carryData = {
      "email": emailAddress,
      "contact": contactNo,
      "pin_code": pincode,
      "state_id": state,
      "city_id": city
    };
    ApiResponse response =
        await resumeUpdate(context, carryData, id: resumeData!.id);
    if (response.status == 200) {
      resumeData = ResumeModel.fromJson(response.body!.data);
      return showSnack(context: context, msg: response.body!.message);
    } else {
      return showSnack(context: context, msg: response.body!.message);
    }
  }

  educationDetailsAdd(index, {title, description, from, to, id}) async {
    Map<String, dynamic> carryData = {
      "title": title,
      "description": description,
      "from": from,
      "to": to,
      "resume_id": resumeData!.id,
    };

    ApiResponse response;
    if (id != null) {
      response = await resumeEducationUpdate(context, body: carryData, id: id);
    } else {
      response = await resumeEducationCreate(
        context,
        carryData,
      );
      ResumeEducations education =
          ResumeEducations.fromJson(response.body!.data);
      educationResume[index] = EducationResume(
        id: education.id,
        title: TextEditingController(text: education.title),
        description: TextEditingController(text: education.description),
        from: TextEditingController(text: education.from.toString()),
        to: TextEditingController(text: education.to.toString()),
      );
      setState(() {});
    }
    if (response.status == 200) {
      if (id == null) {
        resumeData!.resumeEducations!
            .add(ResumeEducations.fromJson(response.body!.data));
      }
      return showSnack(context: context, msg: response.body!.message);
    } else {
      return showSnack(context: context, msg: response.body!.message);
    }
  }

  experienceDetailsAdd(
    index, {
    title,
    description,
    designation,
    from,
    to,
    id,
  }) async {
    Map<String, dynamic> carryData = {
      "title": title,
      "description": description,
      "designation": designation,
      "from": from,
      "to": to,
      "resume_id": resumeData!.id,
    };
    ApiResponse response;
    if (id != null) {
      response = await resumeExperienceUpdate(context, body: carryData, id: id);
    } else {
      response = await resumeExperienceCreate(
        context,
        carryData,
      );

      ResumeEducations experience =
          ResumeEducations.fromJson(response.body!.data);
      experienceResume[index] = EducationResume(
        id: experience.id,
        title: TextEditingController(text: experience.title),
        description: TextEditingController(text: experience.description),
        designation: TextEditingController(text: experience.designation),
        from: TextEditingController(text: experience.from.toString()),
        to: TextEditingController(text: experience.to.toString()),
      );
      setState(() {});
    }
    if (response.status == 200) {
      if (id == null) {
        resumeData!.resumeExperiences!
            .add(ResumeEducations.fromJson(response.body!.data));
      }
      return showSnack(context: context, msg: response.body!.message);
    } else {
      return showSnack(context: context, msg: response.body!.message);
    }
  }

  referenceDetailsAdd(
    index, {
    title,
    designation,
    phone,
    email,
    id,
  }) async {
    Map<String, dynamic> carryData = {
      "title": title,
      "designation": designation,
      "phone": phone,
      "email": email,
      "resume_id": resumeData!.id,
    };

    ApiResponse response;
    if (id != null) {
      response = await resumeReferenceUpdate(context, body: carryData, id: id);
    } else {
      response = await resumeReferenceCreate(
        context,
        carryData,
      );
      ResumeReferences reference =
          ResumeReferences.fromJson(response.body!.data);
      referenceResume[index] = EducationResume(
        id: reference.id,
        title: TextEditingController(text: reference.title),
        designation: TextEditingController(text: reference.designation),
        phoneNumber: TextEditingController(text: reference.phone.toString()),
        email: TextEditingController(text: reference.email.toString()),
      );
      setState(() {});
    }
    if (response.status == 200) {
      if (id == null) {
        resumeData!.resumeReferences!
            .add(ResumeReferences.fromJson(response.body!.data));
      }
      return showSnack(context: context, msg: response.body!.message);
    } else {
      return showSnack(context: context, msg: response.body!.message);
    }
  }

  linkDetailsAdd({facebook, instagram, behance, linkdin}) async {
    Map<String, dynamic> carryData = {
      "facebook": facebook,
      "instagram": instagram,
      "behance": behance,
      "linkedin": linkdin
    };
    ApiResponse response =
        await resumeUpdate(context, carryData, id: resumeData!.id);
    if (response.status == 200) {
      resumeData = ResumeModel.fromJson(response.body!.data);
      return showSnack(context: context, msg: response.body!.message);
    } else {
      return showSnack(context: context, msg: response.body!.message);
    }
  }

  hobbiesAdd(hobbies) async {
    Map<String, dynamic> carryData = {
      "resume_id": resumeData!.id,
      "hobbyName": hobbies
    };
    await resumeHobbiesCreate(context, carryData);
  }

  subSkillsAdd(index, skills) async {
    Map<String, dynamic> carryData = {
      "resume_id": resumeData!.id,
      "skillSubCategory_id": skills.id,
      "rating": skills.rating
    };
    ApiResponse response;
    if (skills.resumeSkillId != null) {
      response = await resumeSkillsUpdate(context,
          body: carryData, id: skills.resumeSkillId);
    } else {
      response = await resumeSkillsCreate(context, carryData);
    }
    if (response.status == 200) {
      selectedSkills[index].resumeSkillId = response.body!.data["id"];
    } else {}
  }

  deleteEducation(index, id) async {
    if (id != null) {
      ApiResponse response = await resumeEducationDelete(context, id: id);
      if (response.status == 200) {
        educationResume.removeAt(index);
      }
    } else {
      educationResume.removeAt(index);
    }
    setState(() {});
  }

  deleteHobby(index, id) async {
    if (id != null) {
      ApiResponse response = await resumeHobbiesDelete(context, id: id);
      if (response.status == 200) {
        selectedHobbies.removeAt(index);
      }
    } else {
      selectedHobbies.removeAt(index);
    }
    setState(() {});
  }

  deleteExperience(index, id) async {
    if (id != null) {
      ApiResponse response = await resumeExperienceDelete(context, id: id);
      if (response.status == 200) {
        experienceResume.removeAt(index);
      }
    } else {
      experienceResume.removeAt(index);
    }
    setState(() {});
  }

  deleteReference(index, id) async {
    if (id != null) {
      ApiResponse response = await resumeReferenceDelete(context, id: id);
      if (response.status == 200) {
        referenceResume.removeAt(index);
      }
    } else {
      referenceResume.removeAt(index);
    }
    setState(() {});
  }

  deleteSkills(index, id) async {
    if (id != null) {
      ApiResponse response = await resumeSkillsDelete(context, id: id);
      if (response.status == 200) {
        selectedSkills.removeAt(index);
      }
    } else {
      selectedSkills.removeAt(index);
    }
    setState(() {});
  }

  List<Step> stepList() => [
        basicDetails(),
        contactDetails(),
        linksDetails(),
        educationDetails(),
        experienceDetails(),
        referenceDetails(),
        skillsDetails(),
        hobbiesDetails(),
      ];

  List<PostOffice> postOffices = [];

  setLocationOnTheBasisOfPinCode(pincode) async {
    var response = await fetchLocationOnBasisOfPinCode(context, pincode);
    if (response != null) {
      postOffices = response;
    }
    if (postOffices.isNotEmpty) {
      PostOffice object = postOffices.first;
      List<States> pinState =
          await fetchStates(context, filterByName: object.state);
      selectedState = pinState.first;
      await fetchCity(selectedState!.id);
      List<City> pinCity = await fetchCities(context,
          stateId: selectedState!.id, filterByName: object.district);
      selectedCity = pinCity.first;
    }
    setState(() {});
  }

  fetchState() async {
    state = await fetchStates(context);
    if (state.isNotEmpty) {
      selectedState = userData!.state;
      await fetchCity(userData!.stateId);
      if (city.isNotEmpty) {
        selectedCity = userData!.city;
      }
    }
    getResumeData();
    // setState(() {});
  }

  fetchCity(
    id,
  ) async {
    setState(() {
      selectedCity = null;
      city = [];
    });
    city = await fetchCities(context, stateId: id.toString());
    setState(() {});
  }

  callFunction(step) {
    switch (step) {
      case 0:
        basicDetailsAdd(
            firstName: trimControllerValue(firstNameController),
            designation: trimControllerValue(designationController),
            description: trimControllerValue(descriptionController),
            image: newprofile);
        break;
      case 1:
        contactDetailsAdd(
            emailAddress: trimControllerValue(emailController),
            contactNo: trimControllerValue(contactNoController),
            pincode: trimControllerValue(pincodeController),
            state: selectedState?.id,
            city: selectedCity?.id);
        break;
      case 2:
        linkDetailsAdd(
          behance: trimControllerValue(behanceController),
          instagram: trimControllerValue(instagramController),
          facebook: trimControllerValue(facebookController),
          linkdin: trimControllerValue(linkdinController),
        );
        break;
      case 3:
        educationResume.forEachIndexed((index, element) {
          if (element.title!.text.isEmpty) {
            return;
          }
          educationDetailsAdd(index,
              id: element.id,
              title: element.title?.text,
              description: element.description?.text,
              from: element.from?.text,
              to: element.to?.text);
        });
        break;
      case 4:
        experienceResume.forEachIndexed((index, element) {
          if (element.title!.text.isEmpty) {
            return;
          }

          experienceDetailsAdd(index,
              id: element.id,
              title: element.title?.text,
              description: element.description?.text,
              designation: element.designation?.text,
              from: element.from?.text,
              to: element.to?.text);
        });
        break;
      case 5:
        referenceResume.forEachIndexed((index, element) {
          if (element.title!.text.isEmpty) {
            return;
          }
          referenceDetailsAdd(index,
              id: element.id,
              title: element.title?.text,
              phone: element.phoneNumber?.text,
              email: element.email?.text,
              designation: element.designation?.text);
        });
        break;
      case 6:
        selectedSkills.forEachIndexed((index, element) {
          subSkillsAdd(index, element);
        });
        break;
      case 7:
        String hobbies = selectedHobbies.map((e) => e.name).join(',');
        hobbiesAdd(hobbies);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      bool isCandidateSubscribed =
          ref.watch(editProfileData).isCandidateSubscribed;
      return Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        appBar: widget.isFromConnectedRoutes
            ? PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: BackWithText(text: 'HOME (JOB-SEEKER) / Resume builder'))
            : CustomAppBar(
                context: context,
                drawerKey: _drawerKey,
                isDisable: true,
                back: "HOME (JOB-SEEKER) / Resume builder",
              ),
        key: _drawerKey,
        resizeToAvoidBottomInset: false, // fluter 2.x
        floatingActionButton: InkWell(
            onTap: () {
              if (!isCandidateSubscribed) {
                subscriptionaAlertBox(
                  context,
                  "You are not subscribed user please click on yes if want to subscribe",
                  title: 'Subscribe Now',
                );
              } else {
                if (!kIsWeb) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResumeView()));
                } else {
                  context.vRouter.toExternal(
                    'https://admin.hindustaanjobs.com/api/resume-html-no-auth?id=${userData!.id}',
                  );
                }
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    color: MyAppColor.floatButtonColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                padding: EdgeInsets.all(5.0),
                child: Text("Preview & Download", style: whiteR16()))),
        drawer: Drawer(
          child: DrawerJobSeeker(),
        ),
        body: Center(
          child: SizedBox(
            width: Responsive.isDesktop(context) ? 500 : null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _activeStepIndex,
                steps: stepList(),
                onStepContinue: () {
                  if (_activeStepIndex < (stepList().length - 1)) {
                    setState(() {
                      _activeStepIndex += 1;
                    });
                  } else {}
                },
                onStepCancel: () {
                  if (_activeStepIndex == 0) {
                    return;
                  }

                  setState(() {
                    _activeStepIndex -= 1;
                  });
                },
                onStepTapped: (int index) {
                  setState(() {
                    _activeStepIndex = index;
                  });
                },
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  final isLastStep = _activeStepIndex == stepList().length - 1;
                  return Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              callFunction(_activeStepIndex);
                            },
                            child: (isLastStep)
                                ? const Text('Submit')
                                : const Text('Save'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    MyAppColor.orangelight)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (_activeStepIndex > 0)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Back'),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      MyAppColor.orangelight)),
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  basicDetails() {
    return Step(
      state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: const Text('Basic Details'),
      content: Column(
        children: [
          _camera(),
          textField('First Name',
              controller: firstNameController, isEditable: false),
          textField('Designation', controller: designationController),
          descriptionTextField()
        ],
      ),
    );
  }

  contactDetails() {
    return Step(
      state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: const Text('Contact Details'),
      content: Container(
        child: Column(
          children: [
            textField('Email Address',
                controller: emailController, isEditable: false),
            textField('Contact No.',
                controller: contactNoController, isEditable: false),
            textField('Pincode', controller: pincodeController,
                onChanged: (value) {
              if (value.length == 6) {
                setLocationOnTheBasisOfPinCode(value);
              }
            }),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8),
              child: DynamicDropDownListOfFields(
                label: DropdownString.selectState,
                dropDownList: state,
                selectingValue: selectedState,
                setValue: (value) async {
                  if (DropdownString.selectState == value!) {
                    return;
                  }
                  selectedState = state.firstWhere(
                      (element) => element.name.toString() == value);
                  await fetchCity(
                    selectedState!.id,
                  );
                },
              ),
            ),
            if (city.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                child: DynamicDropDownListOfFields(
                  label: DropdownString.selectCity,
                  dropDownList: city,
                  selectingValue: selectedCity,
                  setValue: (value) async {
                    if (DropdownString.selectCity == value!) {
                      return;
                    }
                    selectedCity = city.firstWhere(
                        (element) => element.name.toString() == value);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  educationDetails() {
    return Step(
      state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: const Text('Education Details'),
      content: Container(
        child: Column(
          children: List.generate(
              educationResume.length, (index) => educationFields(index)),
        ),
      ),
    );
  }

  experienceDetails() {
    return Step(
      state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: const Text('Experience Details'),
      content: Column(
        children: List.generate(
            experienceResume.length, (index) => experienceFields(index)),
      ),
    );
  }

  skillsDetails() {
    return Step(
      state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: const Text('Skills'),
      content: Consumer(builder: (context, ref, child) {
        List<Skill> skillCategory = ref.watch(listData).skillCategory;
        return Column(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                  selectedSkills.length,
                  (index) => Column(
                        children: [
                          InkWell(
                              onTap: () {
                                deleteSkills(
                                    index, selectedSkills[index].resumeSkillId);
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 14,
                                      child: Icon(
                                        Icons.cancel,
                                        size: 18.0,
                                        color: Color(0xff755F55),
                                      ),
                                    ),
                                  ])),
                          TextFormFieldWidget(
                            type: TextInputType.number,
                            isRequired: true,
                            labelText: 'Rating',
                            text: selectedSkills[index].name,
                            textStyle: blackDarkR18,
                            onChanged: (value) {
                              selectedSkills[index].rating = value;
                              setState(() {});
                            },
                            // control: TextEditingController(
                            //     // text: selectedSkills[index].rating
                            //     ),
                          ),
                        ],
                      )),
            ),
            InkWell(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) => PopSelector(
                          title: 'title',
                          list: skillCategory,
                          allreadySelected: selectedSkills,
                        ));
                setState(() {});
              },
              child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border:
                          Border.all(color: MyAppColor.blackdark, width: 1)),
                  child: Text("Add Skills", style: blackRegularGalano14)),
            )
          ],
        );
      }),
    );
  }

  referenceDetails() {
    return Step(
      state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: const Text('Reference'),
      content: Container(
        child: Column(
          children: List.generate(
              referenceResume.length, (index) => referenceFields(index)),
        ),
      ),
    );
  }

  hobbiesDetails() {
    return Step(
        state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 0,
        title: const Text('Hobbies'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                  selectedHobbies.length,
                  (index) => TagChip(
                        text: selectedHobbies[index].name,
                        onTap: () {
                          deleteHobby(index, selectedHobbies[index].id);
                        },
                      )),
            ),
            InkWell(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) => PopPicker(
                          title: 'Hobbies',
                          list: hobbiesList,
                          flag: 'hobby',
                          allReadySelected: selectedHobbies,
                        ));
                setState(() {});
              },
              child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border:
                          Border.all(color: MyAppColor.blackdark, width: 1)),
                  child: Text("Add Hobbies", style: blackRegularGalano14)),
            )
          ],
        ));
  }

  linksDetails() {
    return Step(
      state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: const Text('Links'),
      content: Container(
        child: Column(children: [
          textField("Facebook Link", controller: facebookController),
          textField("Instagram Link", controller: instagramController),
          textField("Behance Link", controller: behanceController),
          textField("Linkedin Link", controller: linkdinController),
        ]),
      ),
    );
  }

  educationFields(index) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter innerSetState) {
      return Column(
        children: [
          if (index > 0)
            Padding(
              padding: EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    if (educationResume.length > 1) {
                      deleteEducation(index, educationResume[index].id);
                    }
                  },
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(
                        Icons.cancel,
                        size: 18.0,
                        color: Color(0xff755F55),
                      ),
                    ),
                  ])),
            ),
          textField('Title', controller: educationResume[index].title),
          textField('Description',
              controller: educationResume[index].description),
          yearPicker(context, 'From', value: educationResume[index].from!.text,
              onSelect: (date) {
            innerSetState(() {
              FocusScope.of(context).requestFocus(new FocusNode());
              educationResume[index].from!.text = date;
            });
          }),
          yearPicker(context, 'To', value: educationResume[index].to!.text,
              onSelect: (date) {
            innerSetState(() {
              FocusScope.of(context).requestFocus(new FocusNode());
              educationResume[index].to!.text = date;
            });
          }),
          if (educationResume.length - 1 == index)
            Padding(
              padding: EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    educationResume.add(EducationResume(
                      title: TextEditingController(),
                      description: TextEditingController(),
                      from: TextEditingController(),
                      to: TextEditingController(),
                    ));
                    setState(() {});
                  },
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(
                        Icons.add,
                        size: 18.0,
                        color: Color(0xff755F55),
                      ),
                    ),
                  ])),
            ),
        ],
      );
    });
  }

  referenceFields(index) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter innerSetState) {
      return Column(
        children: [
          if (index > 0)
            Padding(
              padding: EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    if (referenceResume.length > 1) {
                      deleteReference(index, referenceResume[index].id);
                    }
                  },
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(
                        Icons.cancel,
                        size: 18.0,
                        color: Color(0xff755F55),
                      ),
                    ),
                  ])),
            ),
          textField('Title', controller: referenceResume[index].title),
          textField('Designation',
              controller: referenceResume[index].designation),
          textField('Contact Number',
              controller: referenceResume[index].phoneNumber),
          textField('Email', controller: referenceResume[index].email),
          if (referenceResume.length - 1 == index)
            Padding(
              padding: EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    referenceResume.add(EducationResume(
                      title: TextEditingController(),
                      designation: TextEditingController(),
                      phoneNumber: TextEditingController(),
                      email: TextEditingController(),
                    ));
                    setState(() {});
                  },
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(
                        Icons.add,
                        size: 18.0,
                        color: Color(0xff755F55),
                      ),
                    ),
                  ])),
            ),
        ],
      );
    });
  }

  experienceFields(index) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter innerSetState) {
      return Column(
        children: [
          if (index > 0)
            Padding(
              padding: EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    if (experienceResume.length > 1) {
                      deleteExperience(index, experienceResume[index].id);
                    }
                  },
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(
                        Icons.cancel,
                        size: 18.0,
                        color: Color(0xff755F55),
                      ),
                    ),
                  ])),
            ),
          textField('Company/WorkSpace Name',
              controller: experienceResume[index].title),
          textField('Designation',
              controller: experienceResume[index].designation),
          textField('Description',
              controller: experienceResume[index].description),
          yearPicker(context, 'From', value: experienceResume[index].from!.text,
              onSelect: (date) {
            innerSetState(() {
              FocusScope.of(context).requestFocus(new FocusNode());
              experienceResume[index].from!.text = date;
            });
          }),
          yearPicker(context, 'To', value: experienceResume[index].to!.text,
              onSelect: (date) {
            innerSetState(() {
              FocusScope.of(context).requestFocus(new FocusNode());
              experienceResume[index].to!.text = date;
            });
          }),
          if (experienceResume.length - 1 == index)
            Padding(
              padding: EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    experienceResume.add(EducationResume(
                      title: TextEditingController(),
                      description: TextEditingController(),
                      designation: TextEditingController(),
                      from: TextEditingController(),
                      to: TextEditingController(),
                    ));
                    setState(() {});
                  },
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(
                        Icons.add,
                        size: 18.0,
                        color: Color(0xff755F55),
                      ),
                    ),
                  ])),
            ),
        ],
      );
    });
  }

  textField(text, {controller, onChanged, bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
      child: TextFormFieldWidget(
        type: isEditable ? TextInputType.multiline : TextInputType.none,
        text: text,
        enableCursor: isEditable ? true : false,
        enableInterative: isEditable ? false : true,
        control: controller,
        onChanged: onChanged,
      ),
    );
  }

  descriptionTextField() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 5),
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: TextField(
          controller: descriptionController,
          textAlign: TextAlign.justify,
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
            hintText: 'About You',
            contentPadding: EdgeInsets.only(left: 16, top: 20),
            hintStyle: !Responsive.isDesktop(context)
                ? blackDarkOpacityM14()
                : blackDarkOpacityM12(),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 8,
        ),
      ),
    );
  }

  _camera() {
    return InkWell(
      onTap: () async {
        if (kIsWeb) {
          _openGallery(context);
        } else {
          await _showChoiceDialog(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
          clipBehavior: Clip.hardEdge,
          // margin: EdgeInsets.symmetric(horizontal: 80),
          height: Sizeconfig.screenHeight! / 8,
          width: Responsive.isMobile(context)
              ? Sizeconfig.screenWidth! / 4
              : Sizeconfig.screenWidth! / 16,
          padding: EdgeInsets.all(
              newprofile != null || networkImage != null ? 0 : 20),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: MyAppColor.greylight),
          child: newprofile != null
              ? kIsWeb
                  ? Image.memory(
                      newprofile!.bytes!,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      newprofile!,
                      fit: BoxFit.cover,
                    )
              : networkImage != null
                  ? Image.network(
                      currentUrl(networkImage),
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
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
    var croppedFile = await ImageCropper().cropImage(
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
    if (kIsWeb) {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
      setState(() {
        if (pickedFile != null) {
          logo = pickedFile.files.first;
          newprofile = pickedFile.files.first;
          Navigator.pop(context);
        }
      });
    } else {
      var pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          main_image = pickedFile;
          cropImage(context, pickedFile.path);
          Navigator.pop(context);
        }
      });
    }
  }

  Future _openCamera(context) async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        main_image = pickedFile;
        cropImage(context, pickedFile.path);
        Navigator.pop(context);
      }
    });
  }
}

class EducationResume {
  int? id;
  TextEditingController? title;
  TextEditingController? designation;
  TextEditingController? phoneNumber;
  TextEditingController? email;
  TextEditingController? description;
  TextEditingController? from;
  TextEditingController? to;

  EducationResume(
      {this.id,
      this.title,
      this.designation,
      this.email,
      this.phoneNumber,
      this.description,
      this.from,
      this.to});

  EducationResume.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    designation!.text = json['designation'];
    phoneNumber!.text = json['phoneNumber'];
    email!.text = json['email'];
    title!.text = json['title'];
    description!.text = json['description'];
    from!.text = json['from'];
    to!.text = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class Hobbies {
  String? name;
  int? id;
  bool? isSelected = false;
  Hobbies({this.name, this.id, this.isSelected});

  Hobbies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = id;
    return data;
  }
}
