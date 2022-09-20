import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hindustan_job/candidate/pages/login_page/change_password.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/pages/company_home_pages.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/homeserviceSeeker/service_seeker_edit_profile.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/add_a_service_screen.dart';
import 'package:hindustan_job/serviceprovider/widget/radialPainter.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:vrouter/vrouter.dart';

class MyProfileTab extends StatefulWidget {
  @override
  _MyProfileTabState createState() => _MyProfileTabState();
}

class _MyProfileTabState extends State<MyProfileTab>
    with TickerProviderStateMixin {
  bool? _value = false;
  List<bool?>? _isChecked;
  int selectedTabIndex = 0;
  bool isSwitched = false;
  final List<Widget> myTabs = [
    const Tab(text: 'My Profile'),
    const Tab(text: 'My Branches'),
  ];

  TabController? _tabController;
  int _tabIndex = 0;

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController!.index;
      });
    }
  }

  onPressedAddBranch() {}
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final size = 200.00;
    final styles = Mytheme.lightTheme(context).textTheme;
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      body: SizedBox(
        height: Sizeconfig.screenHeight!,
        child: Responsive.isDesktop(context)
            ? ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 130, vertical: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Container(
                                color: MyAppColor.greyDark,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'MY PROFILE',
                                        textAlign: TextAlign.center,
                                      ),
                                      Wrap(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: Sizeconfig
                                                              .screenWidth! /
                                                          2.9),
                                                  child: Dialog(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    insetPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Sizeconfig
                                                                    .screenWidth! /
                                                                2.9,
                                                            vertical: 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              00),
                                                    ),
                                                    child: Container(
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            color: Colors
                                                                .transparent,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 25,
                                                            ),
                                                            child:
                                                                ChangePasswod(
                                                              email: userData!
                                                                  .email!,
                                                              flag: 'change',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 0.0,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Container(
                                                                height: 25,
                                                                width: 25,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                color: MyAppColor
                                                                    .backgroundColor,
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
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
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.vpn_key,
                                                  size: 15,
                                                  color: MyAppColor.orangedark,
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(LabelString.changePassword,
                                                    style:
                                                        orangeDarkSemibold12),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (kIsWeb) {
                                                context.vRouter.to(
                                                    '/home-service-seeker/edit-profile');
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ServiceSeekerEditProfile()));
                                              }
                                            },
                                            child: Row(children: [
                                              Image.asset(
                                                  'assets/edit_small_icon.png'),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(LabelString.editProfile,
                                                  style: orangeDarkSemibold12),
                                            ]),
                                          ),
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              MyProfile(size)
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 70),
                              child: blueContainerForMobileView(),
                            ))
                      ],
                    ),
                  ),
                  Footer()
                ],
              )
            : ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: MyAppColor.greynormal,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: const Text(
                          'MY PROFILE',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              await widgetFullScreenPopDialog(
                                  ChangePasswod(
                                    email: userData!.email!,
                                    flag: 'change',
                                  ),
                                  context,
                                  width: Sizeconfig.screenWidth);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.vpn_key,
                                  size: 15,
                                  color: MyAppColor.orangedark,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(LabelString.changePassword,
                                    style: orangeDarkSemibold12),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          InkWell(
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ServiceSeekerEditProfile()));
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Image.asset('assets/edit_small_icon.png'),
                                Text(LabelString.editProfile,
                                    style: orangeDarkSemibold12),
                                const SizedBox(
                                  width: 15.0,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  MyProfile(size),
                  Footer()
                ],
              ),
      ),
    );
  }

  Widget MyProfile(size) {
    return Responsive.isDesktop(context)
        ? myProfileDesktopView(size)
        : myProfileMobileView(size);
  }

  Widget myProfileDesktopView(size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          height: Sizeconfig.screenHeight! / 5,
          child: currentUrl(userData!.image) != null
              ? CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    "${currentUrl(userData!.image)}",
                  ),
                )
              : const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: const AssetImage(
                    'assets/profileIcon.png',
                  ),
                ),
        ),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: container(
                  label: LabelString.fullName, text: '${userData!.name}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: container(
                  label: LabelString.email, text: '${userData!.email}'),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: container(
                  label: LabelString.mobileNumber, text: '${userData!.mobile}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: container(
                  label: LabelString.gender,
                  text: getCapitalizeString(userData!.gender ?? '')),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: container(
                  label: LabelString.dob,
                  text: '${formatDate(userData!.dob ?? '')}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width - 1150,
                color: MyAppColor.greylight,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Text('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .'),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: containerWeb(
                  label: LabelString.state,
                  text: checkNullOverValueName(userData!.state) ?? ''),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: containerWeb(
                  label: LabelString.city,
                  text: checkNullOverValueName(userData!.city) ?? ''),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: container(
                  label: LabelString.pinCode, text: userData!.pinCode ?? ''),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width - 1150,
                color: MyAppColor.greylight,
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            container(
                label: LabelString.flatNoBuild,
                text: userData!.addressLine1 ?? ''),
            const SizedBox(
              width: 20,
            ),
            container(
                label: LabelString.address, text: userData!.addressLine2 ?? ''),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        // containerImage(
        //   size: size,
        //   label: LabelString.idProofUniqueNumber,
        // ),
      ],
    );
  }

  Widget myProfileMobileView(size) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: Sizeconfig.screenHeight! / 5,
                child: currentUrl(userData!.image) != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          "${currentUrl(userData!.image)}",
                        ),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage(
                          'assets/profileIcon.png',
                        ),
                      ),
              ),

              container(
                  label: LabelString.fullName, text: userData!.name ?? ''),
              container(label: LabelString.email, text: userData!.email ?? ''),
              container(
                  label: LabelString.mobileNumber,
                  text: userData!.mobile ?? ''),
              container(
                  label: LabelString.gender,
                  text: userData!.gender != null
                      ? getCapitalizeString(userData!.gender)
                      : ''),
              container(
                  label: LabelString.dob,
                  text: formatDate(userData!.dob) ?? ''),
              const Text('.   .   .   .   .   .   .   .   .   .'),
              const SizedBox(
                height: 20,
              ),
              container(
                  label: LabelString.state,
                  text: checkNullOverValueName(userData!.state) ?? ''),
              container(
                  label: LabelString.city,
                  text: checkNullOverValueName(userData!.city) ?? ''),
              container(
                  label: LabelString.pinCode, text: userData!.pinCode ?? ''),
              container(
                  label: LabelString.flatNoBuild,
                  text: userData!.addressLine1 ?? ''),
              container(
                  label: LabelString.address,
                  text: userData!.addressLine2 ?? ''),

              const SizedBox(
                height: 20,
              ),
              __subscription(context, size),
              // _activesubscription(),
              // _subscribe(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _subscribe() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: !Responsive.isDesktop(context) ? 10 : 20),
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Subscribed on:',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
          ),
          Text(
            '27.03.2021',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
          ),
        ],
      ),
    );
  }

  Container _activesubscription() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: !Responsive.isDesktop(context) ? 10 : 20),
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //used expanded for web
          Text(
            'Active Subscription Plan:',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'HSS Ocean Plan',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  blueContainerForMobileView() {
    return Column(
      children: [
        Container(
          color: MyAppColor.darkBlue,
          height: Responsive.isDesktop(context) ? 486 : 400,
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isDesktop(context) ? 10.0 : 20,
              ),
              Image.asset('assets/company_homel.png'),
              SizedBox(
                height: Responsive.isDesktop(context) ? 10.0 : 10,
              ),

              Text('YOU HAVE A FREE SUBSCRIPTION', style: whitishMedium12),
              SizedBox(
                height: Responsive.isDesktop(context) ? 10.0 : 20,
              ),
              Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/company_circle1.png')),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 170,
                        child: CustomPaint(
                          foregroundPainter: RadialPainter(
                              bgColor: Colors.grey,
                              lineColor: Colors.orange,
                              percent: 15.0,
                              width: 2.0),
                          child: const Center(
                            child: Text(
                              'Not Limited\nDays',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Image.asset('assets/company_circle1.png'),
              SizedBox(
                height: Responsive.isDesktop(context) ? 10.0 : 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Access & Request un-limited\nHome Services in your City',
                    style: Responsive.isDesktop(context)
                        ? whiteMedium16
                        : whiteMediumItalic14,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              SizedBox(
                height: Responsive.isDesktop(context) ? 10.0 : 10,
              ),
            ],
          ),
        ),

        //
        SizedBox(
          height: Responsive.isDesktop(context) ? 3.0 : 0,
        ),
        Container(
          height: Responsive.isDesktop(context) ? 50 : 0,
          color: MyAppColor.simplegrey,
          child: Padding(
            padding: EdgeInsets.all(
              Responsive.isDesktop(context) ? 8.0 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Subscription Plan:',
                    style: Responsive.isDesktop(context)
                        ? greyLightMedium14
                        : greyLightMedium12),
                Text('HSS FREE Plan',
                    style: Responsive.isDesktop(context)
                        ? blackdarkM16
                        : greyLightMedium12)
              ],
            ),
          ),
        ),
        SizedBox(
          height: Responsive.isDesktop(context) ? 3.0 : 0,
        ),
        Container(
          height: Responsive.isDesktop(context) ? 50 : 0,
          color: MyAppColor.simplegrey,
          child: Padding(
            padding: EdgeInsets.all(
              Responsive.isDesktop(context) ? 8.0 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('Subscribed on:',
                      style: Responsive.isDesktop(context)
                          ? greyLightMedium14
                          : greyLightMedium12),
                ),
                Text('${formatDate(userData!.createdAt)}',
                    style: Responsive.isDesktop(context)
                        ? blackdarkM16
                        : greyLightMedium12)
              ],
            ),
          ),
        )
      ],
    );
  }

  GestureDetector __subscription(BuildContext context, double size) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => SubscriptionPlans()));
      },
      child: Container(
        width: double.infinity,
        padding: !Responsive.isDesktop(context)
            ? const EdgeInsets.all(20)
            : const EdgeInsets.symmetric(horizontal: 30, vertical: 37),
        color: MyAppColor.darkBlue,
        child: Column(
          children: [
            Image.asset('assets/company_homel.png'),
            Text(
              'YOU HAVE A FREE SUBSCRIPTION',
              style: whiteR12(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                height: 240,
                width: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.asset(
                    'assets/company_circle.png',
                  ).image),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(

                        // shape: BoxShape.circle,

                        ),
                    height: 200,
                    width: 200,
                    child: Stack(
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return SweepGradient(
                              colors: [
                                MyAppColor.orangelight,
                                MyAppColor.white
                              ],
                              startAngle: 0.0,
                              center: Alignment.center,
                              endAngle: TWO_PI,
                            ).createShader(rect);
                          },
                          child: Container(
                            height: size,
                            width: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyAppColor.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: size - 15,
                            width: size - 15,
                            decoration: BoxDecoration(
                                color: MyAppColor.darkBlue,
                                shape: BoxShape.circle),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Not Limited',
                                  style: whiteSb18(),
                                ),
                                Text(
                                  'Days left',
                                  style: whiteR12(),
                                ),
                                Text(
                                  'in Subscription',
                                  style: whiteR12(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Get Access & Request un-limited ',
              style: whiteR12(),
            ),
            Text(
              ' Home Services in your City  ',
              style: whiteR12(),
            ),
          ],
        ),
      ),
    );
  }

  Widget containerWeb({label, text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            Text(
              text,
              style: blackMedium14,
            )
          ],
        ),
      ),
    );
  }

  Widget container({label, text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            const SizedBox(
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

  containerImage({label, image, size}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            Container(
              height: 180,
              child: Image.asset(
                'assets/female-slider.png',
                height: 180,
                width: size.width,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget MyBranches() {
    return Responsive.isDesktop(context)
        ? Container(
            width: Sizeconfig.screenWidth! / 1.3,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 00.0, vertical: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  addANewBranchWidget(),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Column(children: [
                      newBranchItemContainerBharat(),
                      const SizedBox(
                        height: 5,
                      ),
                      newBranchItemContainerBharat(),
                      const SizedBox(
                        height: 5,
                      ),
                      newBranchItemContainerBharat(),
                      const SizedBox(
                        height: 5,
                      ),
                      newBranchItemContainerBharat(),
                    ]),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        newBranchItemContainerBharat(),
                        const SizedBox(
                          height: 5,
                        ),
                        newBranchItemContainerBharat(),
                        const SizedBox(
                          height: 5,
                        ),
                        newBranchItemContainerBharat()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Column(
            children: [
              const SizedBox(height: 20),
              addANewBranchWidget(),
              const SizedBox(height: 30),
              //////generatatta
              Column(
                children: List.generate(
                    20,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: newBranchItemContainerBharat(),
                        )).toList(),
              ),
            ],
          );
  }

  Widget addANewBranchWidget() {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Responsive.isDesktop(context) ? 0 : 10),

                padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 15),

                // width: Responsive.isDesktop(context)
                //     ? MediaQuery.of(context).size.width - 1205
                //     : MediaQuery.of(context).size.width - 20,
                width: Responsive.isDesktop(context) ? 329 : double.infinity,
                color: MyAppColor.grayplane,
                // ignore: prefer_const_constructors
                child: Text(
                  LabelString.addNewBranch,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Responsive.isDesktop(context) ? 0 : 10),
                color: MyAppColor.greynormal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 8),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textFieldContainer(
                          label: 'Shop Name', controller: shopNameController),
                      textFieldContainer(
                          label: 'Address Name 1',
                          controller: addressLine1Controller),
                      textFieldContainer(
                          label: 'Address Name 2',
                          controller: addressLine2Controller),
                      textFieldContainer(
                          label: 'PIN Code', controller: pincodeController),
                      Container(
                        height: 40,
                        width: 300,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                            color: MyAppColor.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text('State', style: blackMedium14),
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
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 40,
                        width: 300,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                            color: MyAppColor.white,
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Responsive.isDesktop(context)
                          ? addBranchButton(function: onPressedAddBranch)
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                addBranchButton(function: onPressedAddBranch),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  TextEditingController shopNameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  textFieldContainer({label, controller}) {
    return Container(
      height: 40,
      width: 300,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: MyAppColor.white,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10, bottom: 5),
            border: InputBorder.none,
            hintText: label,
            hintStyle: blackMedium14),
      ),
    );
  }

  Widget addBranchButton({required Function function}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () => function,
              style: ElevatedButton.styleFrom(
                primary: MyAppColor.orangelight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      LabelString.addBranch,
                      style: whiteRegular14,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget newBranchItemContainerBharat() {
    return Container(
      color: MyAppColor.greynormal,
      // height: 164,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        //  mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  color: MyAppColor.grayplane,
                  child: Image.asset('assets/edit_black.png')),
              const SizedBox(width: 4),
              Container(
                  color: MyAppColor.grayplane,
                  child: Image.asset('assets/delete_black.png'))
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 5),
                        child: Image.asset('assets/bharat_service_co.png'),
                      ),
                      Text(LabelString.bharataSrviceCo, style: BlackDarkSb20()),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: MyAppColor.grayplane,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2.0, right: 2),
                                  child:
                                      Image.asset('assets/location_icon.png'),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                color: MyAppColor.grayplane,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Shop No.222/B Shooping Complex,',
                                      style: blackDarkSemibold14,
                                    ),
                                    Text(
                                      'MP Nagar Zone ll,',
                                      style: blackDarkSemibold14,
                                    ),
                                    Text(
                                      'Bhopal, Madhya Pradesh',
                                      style: blackDarkSemibold14,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
