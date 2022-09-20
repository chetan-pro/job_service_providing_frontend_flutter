// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, non_constant_identifier_names, unused_import, use_key_in_widget_constructors, must_be_immutable

import 'dart:io' as i;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/role_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/pages/login_page/otp_confirm_page.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/checkbox/customchekbox.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:hindustan_job/widget/register_page_widget/password_widget.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:vrouter/vrouter.dart';

import '../../../clusterManager/cluster_manager_dashboard.dart';

bool? value = false;
bool _isSelected = false;
i.File? _image;
i.File? croppedFile;
final picker = ImagePicker();
PlatformFile? logo;

class Signup extends StatefulWidget {
  UserData? user;
  String? referralCode;

  bool isUserSocialLogin;
  Signup({this.user, required this.isUserSocialLogin, this.referralCode});
  static const String route = '/sign-up';
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> states) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in states) {
      _menuItems.addAll(
        [
          DropdownMenuItem(
            value: 'State',
            child: Text(
              "Select State",
              style: !Responsive.isDesktop(context)
                  ? blackDarkOpacityM14()
                  : blackDarkOpacityM12(),
            ),
          ),
          ...state.map(
            (value) {
              return DropdownMenuItem(
                value: value.name.toString(),
                child: Text(
                  "${value.name}",
                  style: !Responsive.isDesktop(context)
                      ? blackDarkOpacityM14()
                      : blackDarkOpacityM12(),
                ),
              );
            },
          ),
          //If it's last item, we will not add Divider after it.
          if (item != states.last)
            const DropdownMenuItem<String>(
              enabled: true,
              child: SizedBox(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<int> _getDividersIndexes() {
    List<int> _dividersIndexes = [];
    for (var i = 0; i < (ListDropdown.salutations.length * 2) - 1; i++) {
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _dividersIndexes.add(i);
      }
    }
    return _dividersIndexes;
  }

  List<City> city = [];
  List<States> state = [];
  List<Roles> roles = [];
  States? selectedState;
  City? selectedCity;
  Roles? selectedJobRole;
  var roleType;
  Uint8List? bytesFromPicker;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController referCodeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController companyNumberController = TextEditingController();
  TextEditingController companyDescriptionController = TextEditingController();
  TextEditingController companyWebsiteLinkController = TextEditingController();
  TextEditingController companyAddressLine1Controller = TextEditingController();
  TextEditingController companyAddressLine2Controller = TextEditingController();

  i.File? newprofile;
  XFile? main_image;
  XFile? croppedFile;
  final picker = ImagePicker();
  var _formKey = GlobalKey<FormState>();

  fetchJobRole() async {
    roles = await fetchRoles(context);
    setState(() {});
  }

  fetchState() async {
    state = await fetchStates(context);
    setState(() {});
  }

  fetchCity(id) async {
    selectedCity = null;
    city = [];
    city = await fetchCities(context, stateId: id.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // referCodeController.text = window.location.href.split('/').last;
    }
    city = [];
    state = [];
    roleType = RoleTypeConstant.jobSeeker;
    DropdownString.city = 'City';
    DropdownString.state = 'State';
    selectedState = null;
    selectedCity = null;
    referCodeController.text = widget.referralCode ?? '';
    fetchState();
    fetchJobRole();
    if (widget.user != null) {
      setSocialData(widget.user!);
    }
  }

  setSocialData(UserData userData) {
    nameController.text = userData.name!;
    companyNameController.text = userData.name!;
    if (userData.email != null) {
      emailController.text = userData.email!;
      companyEmailController.text = userData.email!;
    }
    setState(() {});
  }

  jobSeekerRegister(
      {name,
      email,
      mobileNumber,
      pinCode,
      state,
      city,
      password,
      confirmPassword,
      referCode,
      role}) async {
    if (checkPassword(context,
        password: password, confirmPassword: confirmPassword)) {
      return;
    } else if (role == null) {
      return showSnack(
          context: context, msg: "Please select role.", type: 'error');
    } else if (state == null) {
      return showSnack(
          context: context, msg: "Please select state.", type: 'error');
    } else if (city == null) {
      return showSnack(
          context: context, msg: "Please select city.", type: 'error');
    }
    var registerData = {
      "name": name,
      "mobile": mobileNumber,
      "email": email,
      "password": password.toString(),
      "confirm_password": confirmPassword.toString(),
      "state_id": state.id,
      "city_id": city.id,
      "pin_code": pinCode,
      "user_role_type": role.roleType
    };
    if (newprofile != null) {
      registerData["image"] = await MultipartFile.fromFile(newprofile!.path,
          filename: newprofile!.path.split('/').last);
    } else if (logo != null) {
      registerData["image"] =
          MultipartFile.fromBytes(logo!.bytes!, filename: logo!.name);
    } else if (widget.user != null && widget.user!.image != null) {
    } else {
      return showSnack(
          context: context,
          msg: "Please select logo for your image",
          type: 'error');
    }
    if (referCode != null) {
      registerData['referrer_code'] = referCode;
    }
    try {
      ApiResponse signUpResponse;
      if (widget.isUserSocialLogin) {
        signUpResponse =
            await socialUpdateSignUp(registerData, widget.user!.resetToken);
      } else {
        signUpResponse = await signUp(registerData);
      }
      if (signUpResponse.status == 200) {
        showSnack(
            context: context,
            msg: signUpResponse.body!.message,
            type: 'success');
        final resendData = {'email': email};
        await resendOTP(resendData);
        if (kIsWeb) {
          widgetPopDialog(
              OTPConfirmPage(
                email: email,
                token: UserData.fromJson(signUpResponse.body!.data).resetToken,
              ),
              context,
              width: Sizeconfig.screenWidth! / 2.9);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPConfirmPage(
                        email: email,
                        token: UserData.fromJson(signUpResponse.body!.data)
                            .resetToken,
                      )));
        }
      } else {
        return showSnack(
            context: context, msg: signUpResponse.body!.message, type: 'error');
      }
    } catch (error) {
      return showSnack(context: context, msg: error.toString(), type: 'error');
    }
  }

  homeServiceProvider(
      {name,
      hsPemail,
      mobileNumber,
      pinCode,
      state,
      city,
      password,
      confirmPassword,
      referCode,
      role}) async {
    if (checkPassword(context,
        password: password, confirmPassword: confirmPassword)) {
      return;
    } else if (role == null) {
      return showSnack(
          context: context, msg: "Please select role.", type: 'error');
    } else if (state == null) {
      return showSnack(
          context: context, msg: "Please select state.", type: 'error');
    } else if (city == null) {
      return showSnack(
          context: context, msg: "Please select city.", type: 'error');
    }
    var registerData = {
      "name": name,
      "mobile": mobileNumber,
      "email": hsPemail,
      "password": password.toString(),
      "confirm_password": confirmPassword.toString(),
      "state_id": state.id,
      "city_id": city.id,
      "pin_code": pinCode,
      "user_role_type": role.roleType
    };
    if (newprofile != null) {
      registerData["image"] = await MultipartFile.fromFile(newprofile!.path,
          filename: newprofile!.path.split('/').last);
    } else if (logo != null) {
      registerData["image"] =
          MultipartFile.fromBytes(logo!.bytes!, filename: logo!.name);
    } else if (widget.user != null && widget.user!.image != null) {
    } else {
      return showSnack(
          context: context, msg: "Please select image", type: 'error');
    }
    if (referCode != null) {
      registerData['referrer_code'] = referCode;
    }
    try {
      ApiResponse response;
      if (widget.isUserSocialLogin) {
        response =
            await socialUpdateSignUp(registerData, widget.user!.resetToken);
      } else {
        response = await signUp(registerData);
      }

      if (response.status == 200) {
        showSnack(
            context: context, msg: response.body!.message, type: 'success');

        final resendData = {'email': hsPemail};
        await resendOTP(resendData);
        if (kIsWeb) {
          widgetPopDialog(
              OTPConfirmPage(
                email: hsPemail,
                token: UserData.fromJson(response.body!.data).resetToken,
              ),
              context,
              width: Sizeconfig.screenWidth! / 2.9);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPConfirmPage(
                        email: hsPemail,
                        token:
                            UserData.fromJson(response.body!.data).resetToken,
                      )));
        }
      } else {
        return showSnack(
            context: context, msg: response.body!.message, type: 'error');
      }
    } catch (error) {
      return showSnack(context: context, msg: error.toString(), type: 'error');
    }
  }

  companyRegister({
    companyImage,
    companyName,
    companyEmail,
    companyMobileNumber,
    companyWebsiteLink,
    companyDescription,
    industryId,
    addressLine1,
    addressLine2,
    pinCode,
    fullName,
    designation,
    state,
    city,
    password,
    confirmPassword,
    referCode,
    role,
  }) async {
    if (checkPassword(context,
        password: password, confirmPassword: confirmPassword)) {
      return;
    } else if (role == null) {
      return showSnack(
          context: context, msg: "Please select role.", type: 'error');
    } else if (state == null) {
      return showSnack(
          context: context, msg: "Please select state.", type: 'error');
    } else if (city == null) {
      return showSnack(
          context: context, msg: "Please select city.", type: 'error');
    }

    var registerData = {
      "name": companyName,
      "mobile": companyMobileNumber,
      "email": companyEmail,
      "company_link": companyWebsiteLink,
      "company_description": companyDescription,
      "address_line1": addressLine1,
      "industry_id":industryId,
      "address_line2": addressLine2,
      "your_full_name": fullName,
      "your_designation": designation,
      "password": password.toString(),
      "confirm_password": confirmPassword.toString(),
      "state_id": state.id,
      "city_id": city.id,
      "pin_code": pinCode,
      "user_role_type": role.roleType,
    };

    if (referCode != null) {
      registerData['referrer_code'] = referCode;
    }

    if (companyImage != null) {
      registerData["image"] = kIsWeb
          ? MultipartFile.fromBytes(companyImage!.bytes,
              filename: companyImage!.name)
          : await MultipartFile.fromFile(newprofile!.path,
              filename: newprofile!.path.split('/').last);
    } else if (widget.user != null && widget.user!.image != null) {
    } else {
      return showSnack(
          context: context,
          msg: "Please select logo for your company",
          type: 'error');
    }
    try {
      ApiResponse response;
      if (widget.isUserSocialLogin) {
        response =
            await socialUpdateRegister(registerData, widget.user!.resetToken);
      } else {
        response = await register(registerData);
      }
      if (response.status == 200) {
        showSnack(
            context: context, msg: response.body!.message, type: 'success');
        final resendData = {'email': companyEmail};
        await resendOTP(resendData);
        if (kIsWeb) {
          widgetPopDialog(
              OTPConfirmPage(
                email: companyEmail,
                token: UserData.fromJson(response.body!.data).resetToken,
              ),
              context,
              width: Sizeconfig.screenWidth! / 2.9);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPConfirmPage(
                        email: companyEmail,
                        token:
                            UserData.fromJson(response.body!.data).resetToken,
                      )));
        }
      } else {
        return showSnack(
            context: context, msg: response.body!.message, type: 'error');
      }
    } catch (error) {
      return showSnack(context: context, msg: error.toString(), type: 'error');
    }
  }

  List<PostOffice> postOffices = [];

  setLocationOnTheBasisOfPinCode(pincode) async {
    postOffices = await fetchLocationOnBasisOfPinCode(context, pincode);
    if (postOffices.isNotEmpty) {
      PostOffice object = postOffices.first;
      List<States> pinState =
          await fetchStates(context, filterByName: object.state);
      selectedState = pinState.first;
      selectedCity = null;
      await fetchCity(selectedState!.id);
      List<City> pinCity = await fetchCities(context,
          stateId: selectedState!.id, filterByName: object.district);
      selectedCity = pinCity.first;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              !Responsive.isDesktop(context)
                  ? SizedBox(
                      child: Image.asset('assets/loginimage.png'),
                    )
                  : SizedBox(
                      child: Image.asset('assets/desktop_login.png'),
                    ),
              Center(
                child: SizedBox(
                  width: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      if (!Responsive.isDesktop(context))
                        SizedBox(
                          height: 10,
                        ),
                      !Responsive.isDesktop(context)
                          ? Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: backButton(context),
                                ),
                                SizedBox(
                                  width: 32,
                                ),
                                helloPlease(),
                                registerText(),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                helloPlease(),
                                registerText(),
                                SizedBox(height: Sizeconfig.screenHeight! / 10),
                              ],
                            ),
                      if (!Responsive.isDesktop(context))
                        roleJobseeker(context),
                      if (!Responsive.isDesktop(context))
                        const Text(
                          '.  .  .  .  .  .  .  .  .  .  .  .',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      Column(
                        children: roleType != RoleTypeConstant.company
                            ? [
                                Column(
                                  children: [
                                    if (Responsive.isDesktop(context))
                                      Padding(
                                        padding: paddingHorizontal25,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: roleJobseeker(context),
                                                ),
                                                Expanded(child: SizedBox()),
                                              ],
                                            ),
                                            const Text(
                                              '.  .  .  .  .  .  .  .  .  .  .  .',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey),
                                            ),
                                            _camera(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: fullname(),
                                                ),
                                                Expanded(
                                                  child: emailCandidate(),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: mobileNumber()),
                                                Expanded(child: SizedBox()),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (!Responsive.isDesktop(context))
                                      Column(
                                        children: [
                                          _camera(),
                                          fullname(),
                                          emailCandidate(),
                                          mobileNumber(),
                                        ],
                                      ),
                                  ],
                                ),
                              ]
                            : [
                                if (Responsive.isDesktop(context))
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: roleJobseeker(context),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                _camera(),
                                Column(
                                  children: [
                                    if (!Responsive.isDesktop(context))
                                      Column(
                                        children: [
                                          companyName(),
                                          CompanyMobileNo(),
                                          companyEmail(),
                                          companyWebsite(),
                                          companyDescription(context),
                                        ],
                                      ),
                                    if (Responsive.isDesktop(context))
                                      Padding(
                                        padding: paddingHorizontal25,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: companyName(),
                                                ),
                                                Expanded(
                                                  child: CompanyMobileNo(),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: companyEmail(),
                                                ),
                                                Expanded(
                                                  child: companyWebsite(),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: companyDescription(
                                                      context),
                                                ),
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                              ],
                                            ),

                                            // companyEmail(),
                                            // companyWebsite(),
                                            // companyDescription(context),
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              ],
                      ),
                      // const Text(
                      //   '.  .  .  .  .  .  .  .  .  .  .  .',
                      //   style: TextStyle(fontSize: 20, color: Colors.grey),
                      // ),
                      if (roleType == RoleTypeConstant.company)
                        !Responsive.isDesktop(context)
                            ? Column(
                                children: [
                                  companyAdressline1(),
                                  companyAdressline2(),
                                ],
                              )
                            : Padding(
                                padding: paddingHorizontal25,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: companyAdressline1(),
                                    ),
                                    Expanded(
                                      child: companyAdressline2(),
                                    ),
                                  ],
                                ),
                              ),
                      !Responsive.isDesktop(context)
                          ? Column(
                              children: [],
                            )
                          : Padding(
                              padding: paddingHorizontal25,
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: pinCode(),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: dropdown(context),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          if (!Responsive.isDesktop(context) &&
                                              city.isNotEmpty)
                                            cityDropdown(context),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                              ])),
                      // Text(
                      //   '.  .  .  .  .  .  .  .  .  .  .  .',
                      //   style: TextStyle(fontSize: 20, color: Colors.grey),
                      // ),
                      // if (roleType == RoleTypeConstant.company)
                      //   Column(children: [
                      //     _companyField(
                      //         control: companyAddressLine2Controller,
                      //         text: LabelString.flatNoBuild,
                      //         isRequired: false,
                      //         type: TextInputType.multiline),
                      //     _companyField(
                      //         control: companyAddressLine1Controller,
                      //         text: LabelString.address,
                      //         isRequired: true,
                      //         type: TextInputType.multiline),
                      //   ]),
                      if (!Responsive.isDesktop(context)) pinCode(),
                      if (!Responsive.isDesktop(context))
                        dropdown(
                          context,
                        ),
                      if (city.isNotEmpty) cityDropdown(context),

                      if (roleType == RoleTypeConstant.company)
                        Column(
                          children: [
                            const Text(
                              '.  .  .  .  .  .  .  .  .  .  .  .',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                            if (!Responsive.isDesktop(context))
                              Column(
                                children: [
                                  companyFullname(),
                                  yourDesignation(),
                                ],
                              ),
                            if (Responsive.isDesktop(context))
                              Padding(
                                padding: paddingHorizontal25,
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: companyFullname(),
                                      ),
                                      Expanded(
                                        child: yourDesignation(),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                          ],
                        ),
                      dots(),
                      !Responsive.isDesktop(context)
                          ? Column(children: [
                              password(context),
                              const SizedBox(height: 15),
                              confirmPassword(context),
                              dots(),
                              referCode(),
                            ])
                          : Padding(
                              padding: paddingHorizontal25,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: password(context),
                                      ),
                                      Expanded(
                                        child: confirmPassword(context),
                                      ),
                                    ],
                                  ),
                                  dots(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: referCode(),
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: buildCheckBox(),
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 20,
                      ),
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7.0, horizontal: 35),
                          child: Text(
                            "REGISTER",
                            style: !Responsive.isDesktop(context)
                                ? whiteR14()
                                : whiteM12(),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                !Responsive.isDesktop(context)
                                    ? Sizeconfig.screenWidth! / 2.1
                                    : Sizeconfig.screenWidth! / 8,
                                Sizeconfig.screenHeight! / 17),
                            primary: MyAppColor.orangelight),
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if (roleType == RoleTypeConstant.company) {
                            companyRegister(
                                companyName: companyNameController.text.trim(),
                                companyEmail:
                                    companyEmailController.text.trim(),
                                companyMobileNumber:
                                    companyNumberController.text.trim(),
                                companyDescription:
                                    companyDescriptionController.text.trim(),
                                companyWebsiteLink:
                                    companyWebsiteLinkController.text.trim(),
                                addressLine1:
                                    companyAddressLine1Controller.text.trim(),
                                addressLine2:
                                    companyAddressLine2Controller.text.trim(),
                                fullName: fullNameController.text.trim(),
                                designation: designationController.text.trim(),
                                companyImage: kIsWeb ? logo : newprofile,
                                pinCode: pincodeController.text.trim(),
                                state: selectedState,
                                city: selectedCity,
                                role: selectedJobRole,
                                referCode: referCodeController.text.trim(),
                                password: passwordController.text.trim(),
                                confirmPassword:
                                    confirmPasswordController.text.trim());
                          } else if (roleType ==
                              RoleTypeConstant.homeServiceProvider) {
                            homeServiceProvider(
                                name: nameController.text.trim(),
                                hsPemail: emailController.text.trim(),
                                mobileNumber: numberController.text.trim(),
                                pinCode: pincodeController.text.trim(),
                                state: selectedState,
                                city: selectedCity,
                                role: selectedJobRole,
                                referCode: referCodeController.text.trim(),
                                password: passwordController.text.trim(),
                                confirmPassword:
                                    confirmPasswordController.text.trim());
                          } else {
                            final isValid = _formKey.currentState!.validate();
                            if (!isValid) {
                              return;
                            }
                            _formKey.currentState!.save();
                            jobSeekerRegister(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                mobileNumber: numberController.text.trim(),
                                pinCode: pincodeController.text.trim(),
                                state: selectedState,
                                city: selectedCity,
                                role: selectedJobRole,
                                referCode: referCodeController.text.trim(),
                                password: passwordController.text.trim(),
                                confirmPassword:
                                    confirmPasswordController.text.trim());
                          }
                        },
                      ),
                      Padding(
                        padding: paddingAll25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already a member? ',
                              style: blackDarkR12(),
                            ),
                            InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () {
                                !Responsive.isDesktop(context)
                                    ? Navigator.pop(context)
                                    : showDialog(
                                        context: context,
                                        builder: (_) => Container(
                                          constraints: BoxConstraints(
                                              maxWidth:
                                                  Sizeconfig.screenWidth! /
                                                      2.9),
                                          child: Dialog(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.symmetric(
                                                horizontal:
                                                    Sizeconfig.screenWidth! /
                                                        2.9,
                                                vertical: 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(00),
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        color: MyAppColor
                                                            .backgroundColor,
                                                        alignment:
                                                            Alignment.topRight,
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
                              },
                              child: Text(
                                'log in',
                                style: orangeLightM12(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget yourDesignation() {
    return _companyField(
        text: "Your Designation",
        control: designationController,
        isRequired: true,
        type: TextInputType.multiline);
  }

  Widget companyFullname() {
    return _companyField(
        text: "Your Full Name",
        control: fullNameController,
        isRequired: true,
        type: TextInputType.multiline);
  }

  Widget companyDescription(BuildContext context) {
    return _companyDescription(context, companyDescriptionController);
  }

  Widget companyWebsite() {
    return _companyField(
        control: companyWebsiteLinkController,
        text: "Company Website Link",
        isRequired: true,
        type: TextInputType.url);
  }

  Widget companyEmail() {
    return _companyField(
      control: companyEmailController,
      text: "Company Email",
      isRequired: true,
      type: TextInputType.emailAddress,
    );
  }

  Widget CompanyMobileNo() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 4),
        child: NumberTextFormFieldWidget(
            control: companyNumberController,
            text: "Company Mobile no.",
            isRequired: true,
            maxLength: 10,
            type: TextInputType.number));
  }

  Widget companyName() {
    return _companyField(
        control: companyNameController,
        text: "Company Name",
        isRequired: true,
        type: TextInputType.multiline);
  }

  Widget companyAdressline2() {
    return _companyField(
        control: companyAddressLine2Controller,
        text: LabelString.address,
        isRequired: true,
        type: TextInputType.multiline);
  }

  Widget companyAdressline1() {
    return _companyField(
        control: companyAddressLine1Controller,
        text: LabelString.flatNoBuild,
        isRequired: true,
        type: TextInputType.multiline);
  }

  Widget role(BuildContext context) {
    return customDropdown(
      selectingValue: DropdownString.role,
      setdata: (newValue) {
        setState(
          () {
            DropdownString.role = newValue!;
          },
        );
      },
      context: context,
      label: "Role",
      listDropdown: ListDropdown.roles,
    );
  }

  Widget customDropdown({
    BuildContext? context,
    List<String>? listDropdown,
    String? label,
    String? selectingValue,
    Function? setdata,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9),
      child: Container(
        height: !Responsive.isDesktop(context!) ? 46 : 35,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            buttonElevation: 00,
            icon: IconFile.arrow,
            iconSize: Responsive.isDesktop(context) ? 20 : 24,
            isExpanded: true,
            hint: Text(
              // ,
              label!,
              style: blackDarkOpacityM14(),
            ),
            items: _addDividersAfterItems(listDropdown!),
            customItemsIndexes: _getDividersIndexes(),
            customItemsHeight: 4,
            value: selectingValue, style: blackDarkOpacityM14(),
            onChanged: (value) => setdata!(value),
            buttonWidth: Sizeconfig.screenWidth! / 1.2,
            buttonPadding: EdgeInsets.symmetric(horizontal: 8),
            itemPadding: EdgeInsets.all(5),
            dropdownPadding: EdgeInsets.all(20),
            buttonHeight: 40,
            // dropdownDecoration:
            //     BoxDecoration(borderRadius: BorderRadius.circular(50)),            // buttonWidth: 140,
            itemHeight: 40,
            // itemWidth: Sizeconfig.screenWidth,
            //  // itemPadding:
            //       const EdgeInsets.(vertical: 8.0),
          ),
        ),
      ),
    );
  }

  Widget dots() {
    return Text(
      '.  .  .  .  .  .  .  .  .  .  .  .',
      style: TextStyle(fontSize: 20, color: Colors.grey),
    );
  }

  Widget registerText() => Text(
        'Register',
        style: !Responsive.isDesktop(context)
            ? orangeDarkSb18()
            : orangeDarkSb16(),
      );

  Widget helloPlease() {
    return Text(
      'Hello, Please ',
      style: !Responsive.isDesktop(context) ? BlackDarkSb18() : blackDarkSb16(),
    );
  }

  Widget backButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        size: 22,
        color: MyAppColor.blackdark,
      ),
    );
  }

  Widget confirmPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15, left: 15, bottom: 6, top: 6),
      child: Container(
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        // height: !Responsive.isDesktop(context) ? 53 : 35,
        child: TextfieldPass(
          control: confirmPasswordController,
          pass: Mystring.confirmPassword,
        ),
      ),
    );
  }

  Widget password(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15, left: 15, bottom: 00, top: 00),
      child: Container(
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4,
        // height: !Responsive.isDesktop(context) ? 53 : 35,
        child: TextfieldPass(
          control: passwordController,
          pass: Mystring.password,
        ),
      ),
    );
  }

  Widget pinCode() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 4),
      child: NumberTextFormFieldWidget(
          control: pincodeController,
          text: "Pin Code",
          isRequired: true,
          maxLength: 6,
          // styles: desktopstyle,
          textStyle: !Responsive.isDesktop(context)
              ? blackDarkOpacityM14()
              : blackDarkOpacityM12(),
          type: TextInputType.number,
          onChanged: (value) async {
            if (value.length == 6) {
              await setLocationOnTheBasisOfPinCode(value);
            }
          }),
    );
  }

  Widget mobileNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 4),
      child: NumberTextFormFieldWidget(
          control: numberController,
          text: "Mobile Number",
          isRequired: true,
          maxLength: 10,
          textStyle: !Responsive.isDesktop(context)
              ? blackDarkOpacityM14()
              : blackDarkOpacityM12(),
          type: TextInputType.number),
    );
  }

  Widget emailCandidate() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 4),
      child: TextFormFieldWidget(
          control: emailController,
          text: "Email",
          isRequired: true,
          styles: desktopstyle,
          textStyle: !Responsive.isDesktop(context)
              ? blackDarkOpacityM14()
              : blackDarkOpacityM12(),
          type: TextInputType.emailAddress),
    );
  }

  Widget fullname() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 4),
      child: TextFormFieldWidget(
        control: nameController,
        text: "Full Name",
        styles: desktopstyle,
        textStyle: !Responsive.isDesktop(context)
            ? blackDarkOpacityM14()
            : blackDarkOpacityM12(),
        isRequired: true,
        type: TextInputType.multiline,
      ),
    );
  }

  Widget referCode() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 4),
      child: TextFormFieldWidget(
        control: referCodeController,
        text: "Refer Code",
        styles: desktopstyle,
        textStyle: !Responsive.isDesktop(context)
            ? blackDarkOpacityM14()
            : blackDarkOpacityM12(),
        isRequired: false,
        type: TextInputType.multiline,
      ),
    );
  }

  Widget roleJobseeker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: !Responsive.isDesktop(context) ? 15 : 10,
          left: 15,
          right: 15,
          bottom: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13),
        // height: !Responsive.isDesktop(context) ? 50 : 32,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenHeight! / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              // alignedDropdown: true,
              child: DropdownButton<String>(
                value: selectedJobRole != null
                    ? selectedJobRole!.name
                    : DropdownString.salutation,
                icon: IconFile.arrow,
                iconSize: !Responsive.isDesktop(context) ? 24 : 18,
                elevation: 16,
                style: TextStyle(color: MyAppColor.blackdark),
                underline: Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  color: MyAppColor.blackdark,
                ),
                onChanged: (String? newValue) {
                  if (newValue == DropdownString.salutation) return;
                  selectedJobRole =
                      roles.where((element) => element.name == newValue).first;
                  roleType = selectedJobRole!.roleType;
                  setState(() {});
                },
                items: [
                  DropdownMenuItem(
                    value: DropdownString.salutation,
                    child: Text(
                      DropdownString.salutation,
                      style: !Responsive.isDesktop(context)
                          ? blackDarkO40M14
                          : blackDarkM12(),
                    ),
                  ),
                  ...roles.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value.name.toString(),
                        child: Text(
                          "${getCapitalizeString(value.name)}",
                          style: !Responsive.isDesktop(context)
                              ? blackDarkM14()
                              : blackDarkM12(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cityDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        // height: !Responsive.isDesktop(context) ? 50 : 35,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenHeight! / 2.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              // alignedDropdown: true,
              child: DropdownButton<String>(
                value: selectedCity != null
                    ? selectedCity!.name
                    : DropdownString.city,
                icon: IconFile.arrow,
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: MyAppColor.blackdark),
                underline: Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width,
                    color: MyAppColor.blackdark),
                onChanged: (newValue) {
                  selectedCity = city
                      .where((element) => element.name == newValue)
                      .toList()
                      .first;
                  setState(() {});
                },
                items: [
                  DropdownMenuItem(
                    value: 'City',
                    child: Text(
                      "Select city",
                      style: !Responsive.isDesktop(context)
                          ? blackDarkOpacityM14()
                          : blackDarkOpacityM12(),
                    ),
                  ),
                  ...city.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value.name.toString(),
                        child: Text(
                          "${value.name}",
                          style: !Responsive.isDesktop(context)
                              ? blackDarkM14()
                              : blackDarkM12(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdown(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: !Responsive.isDesktop(context) ? 17 : 14,
            left: 15,
            right: 15,
            bottom: 4),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          // height: !Responsive.isDesktop(context) ? 50 : 35,
          width: !Responsive.isDesktop(context)
              ? double.infinity
              : Sizeconfig.screenHeight! / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: MyAppColor.white),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                child: DropdownButton<String>(
                  value: selectedState != null
                      ? selectedState!.name
                      : DropdownString.state,
                  icon: IconFile.arrow,
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: MyAppColor.blackdark),
                  underline: Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width,
                    color: MyAppColor.blackdark,
                  ),
                  onChanged: (value) {
                    selectedState =
                        state.where((element) => element.name == value).first;
                    fetchCity(selectedState!.id);
                    setState(() {});
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'State',
                      child: Text(
                        "Select State",
                        style: !Responsive.isDesktop(context)
                            ? blackDarkOpacityM14()
                            : blackDarkOpacityM12(),
                      ),
                    ),
                    ...state.map(
                      (value) {
                        return DropdownMenuItem(
                          value: value.name.toString(),
                          child: Text(
                            "${value.name}",
                            style: !Responsive.isDesktop(context)
                                ? blackDarkM14()
                                : blackDarkM12(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _companyDescription(BuildContext context, controller) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: !Responsive.isDesktop(context) ? 5 : 0, horizontal: 13),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.justify,
        style: blackDarkM14(),
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
          hintText: 'Company Description',
          contentPadding: EdgeInsets.only(left: 16, top: 20),
          hintStyle: !Responsive.isDesktop(context)
              ? blackDarkOpacityM14()
              : blackDarkOpacityM12(),
        ),
        keyboardType: TextInputType.multiline,
        minLines: null,
        maxLines: !Responsive.isDesktop(context) ? 8 : 3,
      ),
    );
  }

  Widget _companyField({control, text, isRequired, type, isUrl}) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 4),
        child: TextFormFieldWidget(
          control: control,
          text: text,
          isRequired: isRequired,
          type: type,
          isUrl: isUrl,
        ));
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

  _camera() {
    return InkWell(
      onTap: () async {
        !Responsive.isDesktop(context)
            ? _showChoiceDialog(context)
            : webGallery(context);
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
              newprofile != null || logo != null || widget.user != null
                  ? 0
                  : 20),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: MyAppColor.greylight),
          child: kIsWeb
              ? logo != null
                  ? kIsWeb
                      ? Image.memory(
                          logo!.bytes!,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        )
                  : Icon(
                      Icons.camera_alt_outlined,
                      color: MyAppColor.white,
                      size: 30,
                    )
              : newprofile != null
                  ? Image.file(
                      newprofile!,
                      fit: BoxFit.cover,
                    )
                  : widget.user != null && widget.user!.image != null
                      ? Image.network(
                          widget.user!.image!,
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
            primary: false,
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
          // cropImage(context, pickedFile.path);
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

  Widget buildCheckBox() {
    return CustomcheckBox(
        label: " I agree all",
        term: "terms & conditions",
        padding: EdgeInsets.only(
          left: 8,
          top: 20,
        ),
        value: _isSelected,
        onChanged: (bool newValue) {
          setState(() {
            _isSelected = newValue;
          });
        });
  }

  // Widget buildCheckBox() => Theme(
  //       data: ThemeData(
  //         toggleableActiveColor: Colors.red,
  //         unselectedWidgetColor: MyAppColor.orangelight,
  //       ),
  //       child: Material(
  //         type: MaterialType.transparency,
  //         child: CheckboxListTile(
  //           selectedTileColor: Colors.red,
  //           tileColor: Colors.transparent,
  //           activeColor: MyAppColor.orangelight,
  //           title: Row(
  //             children: [
  //               Text(
  //                 " I agree all",
  //                 style: blackDarkR12(),
  //               ),
  //               SizedBox(
  //                 width: 5,
  //               ),
  //               Text(
  //                 "terms & conditions",
  //                 style: orangeDarkSb12(),
  //               ),
  //             ],
  //           ),
  //           value: value,
  //           onChanged: (newValue) {
  //             setState(() {
  //               value = newValue;
  //             });
  //           },
  //           controlAffinity: ListTileControlAffinity.leading,
  //         ),
  //       ),
  //     );
}
