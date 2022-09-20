// ignore_for_file: prefer_const_constructors, unused_import, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, avoid_print, unused_element, non_constant_identifier_names, must_be_immutable, sized_box_for_whitespace, unused_local_variable, avoid_types_as_parameter_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/document_data.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/mybranch.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/pages/login_page/change_password.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/provider/serviceProvider/service_provider.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/add_a_service_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/complete_your_profile_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/edit_branch.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/service_provider.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:vrouter/vrouter.dart';

import '../../../candidate/model/location_pincode_model.dart';
import '../../../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../../../widget/drop_down_widget/drop_down_dynamic_widget.dart';
import '../../../widget/number_input_text_form_field_widget.dart';
import 'ServicesRequests/view_service_request_details_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class MyProfileScreen extends ConsumerStatefulWidget {
  Branch? serviceFetch;
  int? index;
  Function? resetIndex;
  TabController? tabBarController;
  MyProfileScreen(
      {Key? key,
      this.serviceFetch,
      this.tabBarController,
      this.index,
      this.resetIndex})
      : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen>
    with TickerProviderStateMixin {
  TextEditingController name = TextEditingController();
  TextEditingController adress1 = TextEditingController();
  TextEditingController adress2 = TextEditingController();
  TextEditingController pincode = TextEditingController();
  List<City> city = [];
  List<States> state = [];
  States? selectedState;
  City? selectedCity;

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
  void initState() {
    ref.read(serviceProviderData).documetFetchData();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.index ?? 0);
    _tabIndex = widget.index ?? 0;
    if (widget.resetIndex != null) {
      widget.resetIndex!();
    }
    _tabController!.addListener(_handleTabSelection);
    super.initState();
    city = [];
    state = [];
    DropdownString.city = 'City';
    DropdownString.state = 'State';
    selectedState = null;
    selectedCity = null;
    fetchState();
    ref.read(serviceProviderData).getServiceBranchData();
    if (widget.serviceFetch != null) {
      setdata(widget.serviceFetch);
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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

  fetchState() async {
    state = await fetchStates(context);
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

  setdata(Branch? serviceFetch) {
    name.text = serviceFetch!.shopName.toString();
    adress1.text = serviceFetch.address1.toString();
    adress2.text = serviceFetch.address2.toString();
    pincode.text = serviceFetch.pinCode.toString();
    selectedCity!.name = serviceFetch.city!.name.toString();
    selectedState!.name = serviceFetch.state!.name.toString();
  }

  fetchbranch(context) async {
    widget.serviceFetch =
        await ref.read(serviceProviderData).getServiceBranchData();
  }

  addMybranch() async {
    var addData = {
      "shop_name": name.text,
      "address1": adress1.text,
      "address2": adress2.text,
      "pin_code": pincode.text.toString(),
      "city_id": selectedCity!.id,
      "state_id": selectedState!.id,
    };
    ApiResponse response;
    response = await addServiceProviderBranch(addData);
    if (response.status == 200) {
      await fetchbranch(context);
      FocusScope.of(context).unfocus();
      clearFields();
      await showSnack(
          context: context, msg: response.body!.message, type: 'succes');
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  clearFields() {
    name.clear();
    adress1.clear();
    adress2.clear();
    pincode.clear();
    selectedCity = null;
    selectedState = null;
    setState(() {});
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.height - 110
                    : MediaQuery.of(context).size.height - 180,
                child: ListView(
                  children: <Widget>[
                    Responsive.isDesktop(context)
                        ? const SizedBox(
                            height: 30,
                          )
                        : const SizedBox(
                            height: 30,
                          ),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 150),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    child: Center(
                                      child: TabBar(
                                        controller: _tabController,
                                        labelColor: Colors.black,
                                        isScrollable: true,
                                        tabs: myTabs,
                                        indicatorWeight: 2,
                                        indicatorColor: MyAppColor.orangelight,
                                        labelStyle: blackBold14,
                                      ),
                                    ),
                                  ),
                                ),
                                //

                                _tabIndex != 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              widgetPopDialog(
                                                  ChangePasswod(
                                                    email: userData!.email!,
                                                    flag: 'change',
                                                  ),
                                                  context,
                                                  width:
                                                      Sizeconfig.screenWidth);
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/edit_small_icon.png'),
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
                                                    "/home-service-provider/edit-profile");
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CompleteYourProfileScreen()));
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/edit_small_icon.png'),
                                                Text(LabelString.editProfile,
                                                    style:
                                                        orangeDarkSemibold12),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.width - 1000
                                  : MediaQuery.of(context).size.width - 100,
                              child: Center(
                                child: TabBar(
                                  controller: _tabController,
                                  labelColor: Colors.black,

                                  ///     isScrollable: true,
                                  tabs: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Tab(text: 'My Profile')),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Tab(text: 'My Branches')),
                                  ],
                                  indicatorWeight: 2,
                                  indicatorColor: MyAppColor.orangelight,
                                  labelStyle: blackBold14,
                                ),
                              ),
                            ),
                          ),
                    Center(
                      child: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              if (!Responsive.isDesktop(context))
                                _tabIndex != 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                            InkWell(
                                              onTap: () {
                                                widgetFullScreenPopDialog(
                                                    ChangePasswod(
                                                      email: userData!.email!,
                                                      flag: 'change',
                                                    ),
                                                    context,
                                                    width:
                                                        Sizeconfig.screenWidth);
                                              },
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Image.asset(
                                                        'assets/edit_small_icon.png'),
                                                    Text(
                                                        LabelString
                                                            .changePassword,
                                                        style:
                                                            orangeDarkSemibold12),
                                                    const SizedBox(
                                                      width: 15.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CompleteYourProfileScreen()));
                                                setState(() {});
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      'assets/edit_small_icon.png'),
                                                  Text(LabelString.editProfile,
                                                      style:
                                                          orangeDarkSemibold12),
                                                  const SizedBox(
                                                    width: 15.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ])
                                    : const SizedBox(),
                              MyProfile(size),
                              Footer(),
                            ],
                          ),
                        ),
                        //2nd tab
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              MyBranches(),
                              Footer(),
                            ],
                          ),
                        ),
                      ][_tabIndex],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _tabSection(BuildContext context, size) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Responsive.isDesktop(context)
              ? Padding(
                  padding: EdgeInsets.only(
                      left: Responsive.isDesktop(context) ? 90.0 : 10,
                      right: Responsive.isDesktop(context) ? 90 : 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width - 1000
                            : MediaQuery.of(context).size.width - 100,
                        child: TabBar(
                          /// controller: tabController,
                          onTap: (value) {
                            setState(() {
                              selectedTabIndex = value;
                            });
                          },
                          isScrollable: true,
                          labelColor: Colors.black,
                          indicatorWeight: 2,
                          indicatorColor: MyAppColor.orangelight,
                          labelStyle: blackBold14,
                          tabs: [
                            Container(
                              child: Tab(
                                text: LabelString.myProfile,
                              ),
                            ),
                            Container(
                              child: const Tab(
                                text: LabelString.myBranches,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (Responsive.isDesktop(context))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Row(children: [
                                Image.asset('assets/edit_small_icon.png'),
                                Text(LabelString.changePassword,
                                    style: orangeDarkSemibold12),
                              ]),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            InkWell(
                              onTap: () {
                                context.vRouter.to(
                                    "/hindustaan-jobs/home-service-provider/edit-profile");
                              },
                              child: Row(
                                children: [
                                  Image.asset('assets/edit_small_icon.png'),
                                  Text(LabelString.editProfile,
                                      style: orangeDarkSemibold12),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                      left: Responsive.isDesktop(context) ? 90.0 : 20,
                      right: Responsive.isDesktop(context) ? 90 : 20),
                  child: Column(
                    ///  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width - 1000
                            : MediaQuery.of(context).size.width - 20,
                        child: TabBar(
                          /// controller: tabController,
                          onTap: (value) {
                            setState(() {
                              selectedTabIndex = value;
                            });
                          },
                          isScrollable: false,
                          labelColor: Colors.black,
                          indicatorWeight: 2,
                          indicatorColor: MyAppColor.orangelight,
                          labelStyle: Responsive.isDesktop(context)
                              ? blackBold14
                              : blackdarkM12,
                          tabs: [
                            Tab(
                              text: LabelString.myProfile,
                            ),
                            const Tab(
                              text: LabelString.myBranches,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      selectedTabIndex == 0
                          ? Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChangePasswod(
                                            email: userData!.email!,
                                            flag: 'change',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/edit_small_icon.png'),
                                        Text(LabelString.changePassword,
                                            style: orangeDarkSemibold12),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Image.asset('assets/edit_small_icon.png'),
                                  Text(LabelString.editProfile,
                                      style: orangeDarkSemibold12),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.pink,
              child: TabBarView(
                children: [
                  MyProfile(size),
                  MyBranches(),
                ],
              ),
            ),
          ),
          // AllRightsReservedContainerMobileView()
        ],
      ),
    );
  }

  Widget MyProfile(size) {
    return Responsive.isDesktop(context)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 365.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                currentUrl(userData!.image) != null
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
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: container(
                        label: LabelString.fullName,
                        text: userData!.name,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: container(
                          label: LabelString.email, text: userData!.email),
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
                          label: LabelString.mobileNumber,
                          text: userData!.mobile),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: container(
                          label: LabelString.gender, text: userData!.gender),
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
                          text: formatDate(userData!.dob)),
                    ),
                    SizedBox(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: container(
                          label: LabelString.state,
                          text: checkUserLocationValue(userData!.state)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: container(
                          label: LabelString.city,
                          text: checkUserLocationValue(userData!.city)),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: container(
                          label: LabelString.flatNoBuild,
                          text: userData!.addressLine1),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: container(
                          label: LabelString.address,
                          text: userData!.addressLine2),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    '.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .'),
                const SizedBox(
                  height: 20,
                ),
                Consumer(builder: (context, ref, child) {
                  var docs = ref.watch(serviceProviderData).doc;
                  return docs != null
                      ? Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: container(
                                      label: LabelString.serviceExperience,
                                      text: docs.serviceExperience),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width -
                                        1150,
                                    color: MyAppColor.greylight,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: containerWeb(
                                      label: LabelString.idProofDocument,
                                      text: docs.documentName),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: containerWeb(
                                      label: LabelString.idProofUniqueNumber,
                                      text: docs.documentNumber),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            containerImage(
                              size: size,
                              image: docs.image,
                              image2: docs.imageBack,
                              label: LabelString.idProofUniqueNumber,
                            ),
                          ],
                        )
                      : SizedBox();
                }),
              ],
            ),
          )
        : myProfileMobileView(size);
  }

  Widget myProfileMobileView(size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              currentUrl(userData!.image) != null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        "${currentUrl(userData!.image)}",
                      ),
                    )
                  : const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: const AssetImage(
                        'assets/profileIcon.png',
                      ),
                    ),
              SizedBox(
                height: 40,
              ),
              container(label: LabelString.fullName, text: userData!.name),
              container(label: LabelString.email, text: userData!.email),
              container(
                  label: LabelString.mobileNumber, text: userData!.mobile),
              container(label: LabelString.gender, text: userData!.gender),
              container(
                  label: LabelString.dob, text: formatDate(userData!.dob)),
              container(label: LabelString.pinCode, text: userData!.pinCode),
              container(
                  label: LabelString.state,
                  text: checkUserLocationValue(userData!.state)),
              container(
                  label: LabelString.city,
                  text: checkUserLocationValue(userData!.city)),
              container(
                  label: LabelString.flatNoBuild, text: userData!.addressLine1),
              container(
                  label: LabelString.address, text: userData!.addressLine2),
              Text('.   .   .   .   .   .   .   .   .   .'),
              SizedBox(
                height: 20,
              ),
              Text('.   .   .   .   .   .   .   .   .   .'),
              SizedBox(
                height: 20,
              ),
              Consumer(builder: (context, ref, child) {
                var docs = ref.watch(serviceProviderData).doc;
                return docs != null
                    ? Column(
                        children: [
                          container(
                              label: LabelString.serviceExperience,
                              text: docs.serviceExperience),
                          container(
                              label: LabelString.idProofDocument,
                              text: docs.documentName),
                          container(
                              label: LabelString.idProofUniqueNumber,
                              text: docs.documentNumber.toString()),
                          containerImage(
                            image: docs.image,
                            image2: docs.imageBack,
                            size: size,
                            label: LabelString.idProofImage,
                          ),
                        ],
                      )
                    : SizedBox();
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget containerWeb({
    label,
    text,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
              "${text ?? ''}",
              style: blackMedium14,
            )
          ],
        ),
      ),
    );
  }

  containerImage({label, image, image2, size}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 10),
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
              if (image != null)
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
              if (image2 != null)
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

  Widget MyBranches() {
    return Consumer(builder: (context, ref, child) {
      List<Branch> service = ref.watch(serviceProviderData).serviceget;
      if (Responsive.isDesktop(context)) {
        return Container(
          width: Sizeconfig.screenWidth! / 1.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addANewBranchWidget(),
                SizedBox(width: 50),
                Wrap(children: [
                  if (service.isNotEmpty) newBranchItemContainerBharat(service),
                ]),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              addANewBranchWidget(),
              SizedBox(height: 30),
              newBranchItemContainerBharat(service),

              //////generatatta
            ],
          ),
        );
      }
    });
  }

  Widget addANewBranchWidget() {
    return Column(
      children: [
        SizedBox(
          height: 3,
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Responsive.isDesktop(context) ? 0 : 10),
              padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 15),
              width: Responsive.isDesktop(context) ? 345 : double.infinity,
              color: MyAppColor.grayplane,
              child: Text(
                LabelString.addNewBranch,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              width: Responsive.isDesktop(context)
                  ? 340
                  : MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                  horizontal: Responsive.isDesktop(context) ? 0 : 10),
              color: MyAppColor.greynormal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 8),
                child: Column(
                  children: [
                    TextFormFieldWidget(
                        type: TextInputType.multiline,
                        control: name,
                        text: 'Shop Name'),
                    SizedBox(height: 20),
                    TextFormFieldWidget(
                      type: TextInputType.multiline,
                      control: adress1,
                      text: LabelString.address,
                    ),
                    SizedBox(height: 20),
                    NumberTextFormFieldWidget(
                      text: LabelString.pinCode,
                      control: pincode,
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
                      widthRatio: 1,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: DynamicDropDownListOfFields(
                          widthRatio: 1,
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
                    SizedBox(
                      height: 20,
                    ),
                    Responsive.isDesktop(context)
                        ? addBranchButton(function: () async {
                            await addMybranch();
                          })
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              addBranchButton(function: () async {
                                await addMybranch();
                              })
                            ],
                          )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  TextEditingController shopNameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  Widget addBranchButton({required Function function}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
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

  Widget newBranchItemContainerBharat(List<Branch> service) {
    return Column(
      children: [
        for (var x = 0; x < service.length; x++)
          Container(
            color: MyAppColor.greynormal,
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (kIsWeb) {
                          widgetPopDialog(
                              EditServiceBranch(
                                serviceFetch: service[x],
                              ),
                              context,
                              width: Sizeconfig.screenWidth);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditServiceBranch(
                                serviceFetch: service[x],
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        color: MyAppColor.grayplane,
                        child: Image.asset('assets/edit_black.png'),
                      ),
                    ),
                    SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.3),
                                  offset: Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                            child: AlertDialog(
                              backgroundColor: MyAppColor.backgroundColor,
                              elevation: 10,
                              title: Text(
                                "Delete Branch",
                                style: TextStyle(
                                    color: MyAppColor.blackdark, fontSize: 18),
                              ),
                              content: Text(
                                  "Are you sure to delete this branch ?",
                                  style:
                                      TextStyle(color: MyAppColor.blackdark)),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: Text(
                                    'No',
                                    style:
                                        TextStyle(color: MyAppColor.blackdark),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await ref
                                        .read(serviceProviderData)
                                        .deleteServiceData(
                                            service[x].id.toString(), context);

                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes',
                                      style: TextStyle(
                                          color: MyAppColor.blackdark)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: MyAppColor.grayplane,
                        child: Image.asset('assets/delete_black.png'),
                      ),
                    ),
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 5),
                              child:
                                  Image.asset('assets/bharat_service_co.png'),
                            ),
                            Text(
                              service[x].shopName.toString(),
                              style: BlackDarkSb20(),
                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2.0, right: 2),
                                        child: Image.asset(
                                            'assets/location_icon.png'),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      color: MyAppColor.grayplane,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            service[x].address1.toString(),
                                            style: blackDarkSemibold14,
                                          ),
                                          Text(
                                            service[x].city!.name.toString(),
                                            style: blackDarkSemibold14,
                                          ),
                                          Text(
                                            service[x].state!.name.toString(),
                                            style: blackDarkSemibold14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
          ),
      ],
    );
  }
}
