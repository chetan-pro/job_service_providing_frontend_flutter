// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/image/image.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomJob extends StatefulWidget {
  CustomJob({
    Key? key,
  }) : super(key: key);

  @override
  _CustomJobState createState() => _CustomJobState();
}

class _CustomJobState extends State<CustomJob> {
  List<String> items = ['items1', 'items2', 'items3', 'items4'];

  String? seleectedValue;

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
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _dividersIndexes.add(i);
      }
    }
    return _dividersIndexes;
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Container(
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 1.1
          : Sizeconfig.screenHeight! / 1.3,
      width: !Responsive.isDesktop(context)
          ? double.infinity
          : Sizeconfig.screenWidth! / 2.3,
      decoration: BoxDecoration(
        image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                MyAppColor.blackplane.withOpacity(0.3), BlendMode.softLight),
            image: ImageFile.woman,
            fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          SizedBox(
            height: Sizeconfig.screenHeight! / 35,
          ),
          Text(Mystring.customfreejobs, style: backgroundColorR16),
          Responsive.isMobile(context) ? Spacer() : Spacer(),
          !Responsive.isDesktop(context)
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          bottom: Responsive.isDesktop(context) ? 7 : 8),
                      child: TextfieldWidget(
                        text: Mystring.email,
                      ),
                    ),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 70,
                    ),
                    roleDropdown(context),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 40,
                    ),
                    industryDropdown(context),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 40,
                    ),
                    companyDropdown(context),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 40,
                    ),
                    functionDropdown(context),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 40,
                    ),
                    locationDropdown(context),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 40,
                    ),
                    getStartedButton(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: Sizeconfig.screenWidth! / 40,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 14, left: 14),
                                child: SizedBox(
                                  height: 35,
                                  child: TextfieldWidget(
                                    styles: desktopstyle,
                                    text: Mystring.email,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Sizeconfig.screenHeight! / 50,
                              ),
                              functionDropdown(context),
                              SizedBox(
                                height: Sizeconfig.screenHeight! / 50,
                              ),
                              industryDropdown(context)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                roleDropdown(context),
                                SizedBox(
                                  height: Sizeconfig.screenHeight! / 50,
                                ),
                                companyDropdown(context),
                                SizedBox(
                                  height: Sizeconfig.screenHeight! / 50,
                                ),
                                locationDropdown(context),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Sizeconfig.screenWidth! / 40,
                        ),
                      ],
                    ),
                    getStartedButton(),
                  ],
                ),
        ],
      ),
    );
  }

  Padding getStartedButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 28),
      child: OutlinedButton(
        onPressed: () {
          if (!Responsive.isDesktop(context)) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          } else {
            showDialog(
              context: context,
              routeSettings: const RouteSettings(name: Login.route),
              builder: (_) => Container(
                constraints:
                    BoxConstraints(maxWidth: Sizeconfig.screenWidth! / 2.9),
                child: Dialog(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.symmetric(
                      horizontal: Sizeconfig.screenWidth! / 2.9, vertical: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(00),
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
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: !Responsive.isDesktop(context)
              ? EdgeInsets.symmetric(horizontal: 25, vertical: 12)
              : EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            Mystring.getAlert,
            style: whiteR14(),
          ),
        ),
        style:
            OutlinedButton.styleFrom(side: BorderSide(color: MyAppColor.white)),
      ),
    );
  }

  Widget locationDropdown(BuildContext context) {
    return customDropdown(
      setdata: (newValue) {
        setState(
          () {
            DropdownString.location = newValue!;
          },
        );
      },
      selectingValue: DropdownString.location,
      context: context,
      label: "Select Location",
      listDropdown: ListDropdown.locations,
    );
  }

  Widget functionDropdown(BuildContext context) {
    return customDropdown(
      setdata: (newValue) {
        setState(
          () {
            DropdownString.functionalArea = newValue!;
          },
        );
      },
      selectingValue: DropdownString.functionalArea,
      context: context,
      label: "Functional Area",
      listDropdown: ListDropdown.functions,
    );
  }

  Widget companyDropdown(BuildContext context) {
    return customDropdown(
      setdata: (newValue) {
        setState(
          () {
            DropdownString.company = newValue!;
          },
        );
      },
      selectingValue: DropdownString.company,
      context: context,
      label: "Company",
      listDropdown: ListDropdown.companies,
    );
  }

  Widget industryDropdown(BuildContext context) {
    return customDropdown(
      setdata: (newValue) {
        setState(
          () {
            DropdownString.selectIndustry = newValue!;
          },
        );
      },
      selectingValue: DropdownString.selectIndustry,
      context: context,
      label: 'Select Industry',
      listDropdown: ListDropdown.selectIndustries,
    );
  }

  Widget roleDropdown(BuildContext context) {
    return customDropdown(
      selectingValue: DropdownString.salutation,
      setdata: (newValue) {
        setState(
          () {
            DropdownString.salutation = newValue!;
          },
        );
      },
      context: context,
      label: "Select job role",
      listDropdown: ListDropdown.salutations,
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
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Container(
        height: Responsive.isMobile(context!) ? 46 : 35,
        width: !Responsive.isDesktop(context)
            ? double.infinity
            : Sizeconfig.screenWidth!,
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

  Widget dynamicDropDownListOfFields(
      {String? label,
      List? dropDownList,
      selectingValue,
      Function? setValue,
      bool isValidDrop = true,
      String? alertMsg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // height: Responsive.isMobile(context) ? 46 : 35,
      // width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MyAppColor.white),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              )),
              validator: (value) {
                if (selectingValue == null) return "Select ${label}";
                return null;
              },
              onTap: () {
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
                    "${label}",
                    style: TextStyle(
                        color: Colors.grey[400], fontWeight: FontWeight.bold),
                  ),
                ),
                ...dropDownList!.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value.name.toString(),
                      child: Text(
                        "${value.name}",
                        style: Mytheme.lightTheme(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: Colors.grey[400], fontSize: 19),
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
