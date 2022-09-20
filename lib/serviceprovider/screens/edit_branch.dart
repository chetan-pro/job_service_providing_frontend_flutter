// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/mybranch.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/service_provider.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../../candidate/header/back_text_widget.dart';
import '../../candidate/model/location_pincode_model.dart';
import '../../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../../widget/common_app_bar_widget.dart';
import '../../widget/drop_down_widget/drop_down_dynamic_widget.dart';
import '../../widget/number_input_text_form_field_widget.dart';
import '../../widget/text_form_field_widget.dart';

class EditServiceBranch extends ConsumerStatefulWidget {
  Branch? serviceFetch;
  EditServiceBranch({
    Key? key,
    this.serviceFetch,
  }) : super(key: key);

  @override
  ConsumerState<EditServiceBranch> createState() => _EditServiceBranchState();
}

class _EditServiceBranchState extends ConsumerState<EditServiceBranch> {
  List<City> city = [];
  List<States> state = [];
  States? selectedState;
  City? selectedCity;
  TextEditingController name = TextEditingController();
  TextEditingController adress1 = TextEditingController();
  TextEditingController adress2 = TextEditingController();
  TextEditingController pincode = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchState();
    DropdownString.city = 'City';
    DropdownString.state = 'State';
  }

  fetchbranch(context) async {
    widget.serviceFetch =
        await ref.read(serviceProviderData).getServiceBranchData();
  }

  fetchState() async {
    state = await fetchStates(context);
    if (state.isNotEmpty) {
      if (widget.serviceFetch != null) {
        setdata(widget.serviceFetch);
      }
      // await fetchCity(selectedState!.id);
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

  updatebranch() async {
    var addData = {
      "shop_name": name.text,
      "address1": adress1.text,
      "address2": adress2.text,
      "pin_code": pincode.text.toString(),
      "city_id": selectedCity!.id,
      "state_id": selectedState!.id,
    };

    if (widget.serviceFetch != null) {
      addData['branch_id'] = widget.serviceFetch!.id.toString();
    }
    ApiResponse response;
    response = await editServiceProviderBranch(addData);

    if (response.status == 200) {
      await showSnack(
        context: context,
        msg: response.body!.message,
        type: 'Updated Success',
      );
      fetchbranch(context);
      Navigator.pop(context);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  setdata(Branch? serviceFetch) async {
    EasyLoading.show();
    name.text = serviceFetch!.shopName.toString();

    adress1.text = serviceFetch.address1.toString();

    adress2.text = serviceFetch.address2.toString();

    pincode.text = serviceFetch.pinCode.toString();
    if (state.isNotEmpty) {
      selectedState =
          state.where((element) => element.id == serviceFetch.stateId).first;
      await fetchCity(selectedState!.id);
    }

    if (city.isNotEmpty) {
      selectedCity = city.where((ele) => ele.id == serviceFetch.cityId).first;
    }
    EasyLoading.dismiss();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return !kIsWeb
        ? Scaffold(
            key: _drawerKey,
            drawer: Drawer(
              child: DrawerJobSeeker(),
            ),
            appBar: !kIsWeb
                ? PreferredSize(
                    child: BackWithText(text: "HOME (JOB-SEEKER) /EDIT BRANCH"),
                    preferredSize: Size.fromHeight(50))
                : PreferredSize(
                    preferredSize: Size.fromHeight(
                        Responsive.isDesktop(context) ? 70 : 150),
                    child: CommomAppBar(
                      drawerKey: _drawerKey,
                      back: "HOME (JOB-SEEKER) /EDIT BRANCH",
                    ),
                  ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  addANewBranchWidget(),
                ],
              ),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
            child: Column(
              children: [
                addANewBranchWidget(),
              ],
            ),
          ));
  }

  Widget addANewBranchWidget() {
    return Container(
      child: Column(
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

                // width: Responsive.isDesktop(context)
                //     ? MediaQuery.of(context).size.width - 1205
                //     : MediaQuery.of(context).size.width - 20,
                width: Responsive.isDesktop(context) ? 329 : double.infinity,
                color: MyAppColor.grayplane,
                // ignore: prefer_const_constructors
                child: Text(
                  "Edit A Branch",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
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
                      TextFormFieldWidget(
                          type: TextInputType.multiline,
                          control: name,
                          text: 'Shop Name'),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormFieldWidget(
                        type: TextInputType.multiline,
                        control: adress1,
                        text: LabelString.address,
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                      if (city.isNotEmpty)
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
                                selectedCity = city.firstWhere(
                                    (element) => element.name == value);
                              });
                            },
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Responsive.isDesktop(context)
                          ? addBranchButton(function: () async {
                              await updatebranch();
                            })
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                addBranchButton(function: () async {
                                  await updatebranch();
                                })
                              ],
                            ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!kIsWeb) Footer(),
        ],
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
              onPressed: () => function(),
              style: ElevatedButton.styleFrom(
                primary: MyAppColor.orangelight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'update',
                      style: whiteRegular14,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget cityDropdown(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6, left: 6, right: 6, bottom: 00),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenHeight! / 2.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: EdgeInsets.only(right: 8),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
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
                    child: widget.serviceFetch!.city?.name.toString() != null
                        ? Text(widget.serviceFetch!.city!.name!.toString())
                        : Text(
                            'Select City',
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
                              ? blackDarkOpacityM14()
                              : blackDarkOpacityM12(),
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
          top: !Responsive.isDesktop(context) ? 0 : 0,
          left: 6,
          right: 6,
          bottom: 8,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          width: !Responsive.isDesktop(context)
              ? double.infinity
              : Sizeconfig.screenHeight! / 2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
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
                  onChanged: (value) async {
                    if (DropdownString.state == value!) {
                      return;
                    }
                    selectedState =
                        state.firstWhere((element) => element.name == value);
                    await fetchCity(selectedState!.id);
                    setState(() {});
                    // selectedState!.name = value;
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'State',
                      child: Text(
                        widget.serviceFetch!.state!.name.toString(),
                        style: !Responsive.isDesktop(context)
                            ? blackDarkOpacityM14()
                            : blackDarkOpacityM12(),
                      ),
                    ),
                    ...state.map(
                      (value) {
                        return DropdownMenuItem(
                          onTap: () {},
                          value: value.name.toString(),
                          child: Text(
                            "${value.name}",
                            style: !Responsive.isDesktop(context)
                                ? blackDarkOpacityM14()
                                : blackDarkOpacityM12(),
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
}
