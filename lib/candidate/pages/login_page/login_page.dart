// ignore_for_file: avoid_print, prefer_const_constructors, curly_braces_in_flow_control_structures, unused_import, unnecessary_import, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/login_model.dart';
import 'package:hindustan_job/candidate/model/role_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/landing_page/home_page.dart';
import 'package:hindustan_job/candidate/pages/login_page/otp_confirm_page.dart';
import 'package:hindustan_job/candidate/pages/register_page/register_page.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/register_page_widget/password_widget.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import '../../../clusterManager/cluster_manager_dashboard.dart';
import 'forget_password.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:vrouter/vrouter.dart';

class Login extends ConsumerStatefulWidget {
  Login({Key? key}) : super(key: key);
  static const String route = '/login';
  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
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

  var currentSelectedValue;
  var deviceTypes = ["Mac", "Windows", "Mobile"];

  bool isLoading = false;
  late bool loader = false;

  bool isLoggedIn = false;

  RoleModel? list;
  List<Roles> jobRole = [];
  List<String> drop_down = [];
  Roles? selectedJobRole;

  late LoginModel logindata;
  LoginModel? loginList;

  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  late String send;

  @override
  void initState() {
    super.initState();
    fetchRole();
  }

  fetchRole() async {
    jobRole = await fetchRoles(context);
    if (mounted) {
      setState(() {});
    }
  }

  authentication({email, password, role}) async {
    FocusScope.of(context).unfocus();

    if (checkEmail(context, email: email)) {
      return;
    } else if (password == '') {
      return showSnack(
          context: context, msg: "Please enter password.", type: 'error');
    }
    var authData = {
      "username": email,
      "password": password,
    };

    ApiResponse loginResponse = await login(authData);

    return authResult(loginResponse);
  }

  googleAuth(role) async {
    ApiResponse googleLoginResponse = await googleSocialLogin();
    
    return authResult(googleLoginResponse);
  }

  facebookAuth(role) async {
    ApiResponse facebookLoginResponse = ApiResponse();
    facebookLoginResponse = await facebookSocialLogin();

    return authResult(facebookLoginResponse);
  }

  authResult(ApiResponse loginResponse) async {
    if (loginResponse.status == 200) {
      LoginModel loginData = LoginModel.fromJson(loginResponse.body!.data);
      ApiResponse response = await getProfile(loginData.token);
      if (response.status == 401) {
        final resendData = {'email': loginData.email};
        await resendOTP(resendData);
        if (kIsWeb) {
          widgetPopDialog(
              OTPConfirmPage(
                email: loginData.email,
                token: loginData.token,
              ),
              context,
              width: Sizeconfig.screenWidth! / 2.9);
        } else {
          return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPConfirmPage(
                        email: loginData.email,
                        token: loginData.token,
                      )));
        }
      }
      UserData user = UserData.fromJson(response.body!.data);
      if (response.status == 200) {
        showSnack(context: context, msg: loginResponse.body!.message);
        await setUserData(user);
        ref.read(userDataProvider).updateUserData(user);
        if (userData != null) {
          if (user.userRoleType == RoleTypeConstant.companyStaff) {
            return Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePageAdmin()));
          } else if (user.userRoleType ==
                  RoleTypeConstant.businessCorrespondence ||
              user.userRoleType == RoleTypeConstant.clusterManager ||
              user.userRoleType == RoleTypeConstant.advisor ||
              user.userRoleType == RoleTypeConstant.fieldSalesExecutive) {
            return context.vRouter.to("/business-partner/home");
          }
        }
        if (user.stateId == null || user.stateId == 'null') {
          if (kIsWeb) {
            showDialog(
              context: context,
              routeSettings: RouteSettings(name: Signup.route),
              builder: (_) => Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: EdgeInsets.symmetric(
                    horizontal: Sizeconfig.screenWidth! / 4, vertical: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00),
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 25),
                      color: Colors.amber,
                      child: Signup(
                        user: user,
                        isUserSocialLogin: true,
                      ),
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
                          color: MyAppColor.backgroundColor,
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/back_buttons.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Signup(
                  user: user,
                  isUserSocialLogin: true,
                ),
              ),
            );
          }
        } else {
          await setUserData(user);
          ref.read(userDataProvider).updateUserData(user);
          if (checkRoleType(user.userRoleType)) {
            context.vRouter.to('/home-company');
          } else {
            if (RoleTypeConstant.jobSeeker == user.userRoleType) {
              ConnectedRoutes.toJobSeeker(context);
            } else if (RoleTypeConstant.homeServiceProvider ==
                user.userRoleType) {
              ConnectedRoutes.toHomeServiceProvider(context);
            } else if (RoleTypeConstant.homeServiceSeeker ==
                user.userRoleType) {
              ConnectedRoutes.toHomeServiceSeeker(context);
            } else {
              ConnectedRoutes.toLocalHunar(context);
            }
          }
        }
      } else {
        return showSnack(
            context: context, msg: response.body!.message, type: 'error');
      }
    } else {
      return showSnack(
          context: context,
          msg: loginResponse.body!.message.toString(),
          type: 'error');
    }
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
        height: Responsive.isMobile(context!) ? 46 : 35,
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
              style: blackDarkM14(),
            ),
            items: _addDividersAfterItems(listDropdown!),
            customItemsIndexes: _getDividersIndexes(),
            customItemsHeight: 4,
            value: selectingValue, style: blackDarkM14(),
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

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      body: ListView(
        children: [
          SizedBox(
            child: Image.asset('assets/loginimage.png'),
          ),
          Center(
              child: SizedBox(
            width: Responsive.isMobile(context)
                ? Sizeconfig.screenWidth!
                : Sizeconfig.screenWidth! / 4,
            child: Column(children: [
              Container(
                  constraints: BoxConstraints(),
                  width: !Responsive.isDesktop(context)
                      ? Sizeconfig.screenWidth
                      : Sizeconfig.screenWidth! / 4.5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: !Responsive.isDesktop(context)
                            ? Row(
                                children: [
                                  backbutton(context),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        helloPlease(),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        logIn(),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: paddingAll10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    helloPlease(),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    logIn(),
                                  ],
                                ),
                              ),
                      ),
                      const Text(
                        '.  .  .  .  .  .  .  .  .  .  .  .',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          // height: !Responsive.isDesktop(context) ? 50 : 35,
                          child: TextFormFieldWidget(
                            styles: desktopstyle,
                            control: EmailController,
                            text: 'Email Address',
                            type: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 15, left: 15, bottom: 7, top: 10),
                        child: Container(
                          // height: !Responsive.isDesktop(context) ? 50 : 35,
                          child: TextfieldPass(
                            control: PasswordController,
                            pass: Mystring.password,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 18,
                            ),
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              focusColor: MyAppColor.white,
                              onTap: () {
                                kIsWeb
                                    ? showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Sizeconfig.screenWidth! / 2.9,
                                              vertical: 30),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(00),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      right: 25),
                                                  color: Colors.amber,
                                                  child: ForgetPasswod()),
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
                                      )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForgetPasswod(),
                                        ),
                                      );
                              },
                              child: Text(
                                'forgot password',
                                style: orangeLightM12(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7.0, horizontal: 35),
                          child: Text(
                            "LOG IN",
                            style: whiteR14(),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                !Responsive.isDesktop(context)
                                    ? Sizeconfig.screenWidth! / 2.1
                                    : Sizeconfig.screenWidth! / 8,
                                Sizeconfig.screenHeight! / 17),
                            primary: MyAppColor.orangelight),
                        onPressed: () async {
                          await authentication(
                              email: EmailController.text.toString().trim(),
                              password:
                                  PasswordController.text.toString().trim(),
                              role: selectedJobRole);
                        },
                        //myHexColor: MyAppColor.orangedark,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'OR',
                        style: loginOrR12,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(8),
                        color: Colors.grey[300],
                        child: Column(
                          children: [
                            loginwithGoogleAndFacebook(
                                imagecolor: MyAppColor.white,
                                styles: !Responsive.isDesktop(context)
                                    ? whiteR14()
                                    : whiteR12(),
                                colors: MyAppColor.blue,
                                images: 'assets/facebook.png',
                                text: 'LOG IN WITH FACEBOOK',
                                func: () async {
                                  await facebookAuth(selectedJobRole);
                                }),
                            SizedBox(
                              height: Sizeconfig.screenHeight! / 80,
                            ),
                            loginwithGoogleAndFacebook(
                              imagecolor: MyAppColor.greynormal,
                              styles: !Responsive.isDesktop(context)
                                  ? blackDarkR14()
                                  : blackDarkR12(),
                              colors: MyAppColor.white,
                              images: 'assets/google.png',
                              text: 'LOG IN WITH  GOOGLE',
                              func: () async {
                                await googleAuth(selectedJobRole);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: !Responsive.isDesktop(context)
                            ? const EdgeInsets.all(0.0)
                            : EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Not a member already?',
                              style: blackDarkR12(),
                            ),
                            TextButton(
                              onPressed: () {
                                !Responsive.isDesktop(context)
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Signup(
                                                  isUserSocialLogin: false,
                                                )))
                                    : showDialog(
                                        context: context,
                                        routeSettings:
                                            RouteSettings(name: Signup.route),
                                        builder: (_) => Dialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Sizeconfig.screenWidth! / 4,
                                              vertical: 30),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(00),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 25),
                                                color: Colors.amber,
                                                child: Signup(
                                                  isUserSocialLogin: false,
                                                ),
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
                                      );
                              },
                              child: Text(
                                'register now',
                                style: orangeLightM12(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ))
            ]),
          )),
        ],
      ),
    ));
  }

  Widget logIn() {
    return Text(
      'Log In',
      style:
          !Responsive.isDesktop(context) ? orangeDarkSb18() : orangeDarkSb16(),
    );
  }

  Widget helloPlease() {
    return Text(
      'Hello, Please',
      style: !Responsive.isDesktop(context) ? BlackDarkSb18() : blackDarkSb16(),
    );
  }

  Widget backbutton(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (kIsWeb) {
                context.vRouter.to(context.vRouter.previousPath!);
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
            )),
      ],
    );
  }

  Widget loginwithGoogleAndFacebook({
    Function? func,
    String? text,
    Color? colors,
    String? images,
    TextStyle? styles,
    Color? imagecolor,
  }) {
    return InkWell(
      onTap: () {
        func!();
        // await facebookAuth(selectedJobRole);
        // showSnack(
        //     context: context,
        //     msg:
        //         "Facebook is not available right now",
        //     type: 'error');
        // initiateFacebookLogin();
        //  signInWithFacebook();
      },
      child: Container(
        child: Card(
          elevation: 00,
          color: colors,
          child: Row(
            children: [
              Container(
                margin: !Responsive.isDesktop(context)
                    ? EdgeInsets.all(6)
                    : EdgeInsets.all(4),
                child: Image.asset(images!),
                height: !Responsive.isDesktop(context) ? 35 : 25,
                width: !Responsive.isDesktop(context) ? 35 : 25,
                decoration: BoxDecoration(
                    color: imagecolor, borderRadius: BorderRadius.circular(3)),
              ),
              SizedBox(
                width: !Responsive.isDesktop(context)
                    ? Sizeconfig.screenWidth! / 15
                    : Sizeconfig.screenWidth! / 95,
              ),
              Text(
                text!,
                style: styles,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
