// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/pages/drawer_landing_page/landing_drawer.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/widget/buttons/outline_buttons.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:vrouter/vrouter.dart';

class CustomHeader extends StatefulWidget {
  String? text;
  Widget body;

  CustomHeader({@required this.text, required this.body});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(item, style: blackDarkOpacityM12()),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
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

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        drawer: Drawer(
          child: DrawerLanding(),
        ),
        key: _drawerKey,
        appBar: PreferredSize(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!Responsive.isDesktop(context))
                SizedBox(
                  height: Sizeconfig.screenHeight! / 50,
                ),
              Padding(
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.symmetric(vertical: 22.0, horizontal: 30)
                    : EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    drawerImage(context),
                    if (Responsive.isDesktop(context))
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            serchJobDesktop(context),
                          ],
                        ),
                      ),
                    if (!isUserData()) loginButtons(context),
                  ],
                ),
              ),
              if (!Responsive.isDesktop(context) && !isUserData())
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Search(
                    route: Login(),
                  ),
                ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                color: MyAppColor.greynormal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 2,
                    ),
                    InkWell(
                      onTap: () {
                        context.vRouter.to('/home');
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
                      width: !Responsive.isDesktop(context) ? 3 : 00,
                    ),
                    Text("Back", style: grayLightM12()),
                    SizedBox(
                      width: !Responsive.isDesktop(context) ? 20 : 50,
                    ),
                    Text(
                      widget.text!,
                      style: blackDarkOpacityM10(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          preferredSize: Size.fromHeight(Sizeconfig.screenHeight!),
        ),
        body: widget.body,
      ),
    );
  }

  Widget loginButtons(BuildContext context) {
    return Padding(
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.all(00)
          : EdgeInsets.only(top: 7),
      child: Button(
        text: Mystring.login,
        func: () {
          !Responsive.isDesktop(context)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                )
              : showDialog(
                  context: context,
                  builder: (_) => Container(
                    constraints:
                        BoxConstraints(maxWidth: Sizeconfig.screenWidth! / 2.9),
                    child: Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.symmetric(
                          horizontal: Sizeconfig.screenWidth! / 2.9,
                          vertical: 30),
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
        },
      ),
    );
  }

  Widget serchJobDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: Sizeconfig.screenWidth! / 6,
            height: Sizeconfig.screenHeight! / 20,
            child: TextfieldWidget(
              styles: desktopstyle,
              text: 'Search by job title',
            ),
          ),
          SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.selectIndustry,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.selectIndustry = newValue!;
                },
              );
            },
            context: context,
            label: "Select job role",
            listDropdown: ListDropdown.selectIndustries,
          ),
          SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.sector,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.sector = newValue!;
                },
              );
            },
            context: context,
            label: "Select Sector",
            listDropdown: ListDropdown.sectors,
          ),
          SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.location,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.location = newValue!;
                },
              );
            },
            context: context,
            label: "Select Location",
            listDropdown: ListDropdown.locations,
          ),
          SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.experience,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.experience = newValue!;
                },
              );
            },
            context: context,
            label: "Select Expeience",
            listDropdown: ListDropdown.experiences,
          ),
          SizedBox(
            width: 5,
          ),
          search(),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 9),
      child: Container(
        height: Sizeconfig.screenHeight! / 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            autofocus: false,

            iconDisabledColor: MyAppColor.white,
            focusColor: MyAppColor.white,
            buttonElevation: 00,
            icon: IconFile.arrow,
            iconSize: 17,
            isExpanded: true,
            hint: Text(
              // ,
              label!,
              style: blackDarkOpacityR9(),
            ),
            items: _addDividersAfterItems(listDropdown!),
            customItemsIndexes: _getDividersIndexes(),
            customItemsHeight: 4,
            value: selectingValue, style: blackDarkOpacityR9(),
            onChanged: (value) => setdata!(value),
            buttonWidth: !Responsive.isDesktop(context!)
                ? Sizeconfig.screenWidth! / 1.2
                : Sizeconfig.screenWidth! / 9.1,
            buttonPadding: EdgeInsets.symmetric(horizontal: 0),

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

  Row drawerImage(BuildContext context) {
    return Row(
      children: [
        if (!isUserData())
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              _drawerKey.currentState!.openDrawer();
            },
            child: Image.asset(
              'assets/drawers.png',
              height: 19,
            ),
          ),
        SizedBox(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth! / 35
              : Sizeconfig.screenWidth! / 100,
        ),
        Image.asset(
          'assets/hind.png',
          height: 40,
        ),
        // if (Responsive.isDesktop(context))
        //   SizedBox(
        //     width: Sizeconfig.screenWidth! / 6,
        //   ),
      ],
    );
  }

  Widget selectindustry(BuildContext context) {
    return Container(
      height: Sizeconfig.screenHeight! / 20,
      padding: EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: MyAppColor.white),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          child: DropdownButton<String>(
            value: DropdownString.selectIndustry,
            icon: IconFile.arrow,
            iconSize: 17,
            elevation: 16,
            style: blackDarkM14(),

            // underline: Container(
            //   height: 3,
            //   width: MediaQuery.of(context).size.width,
            //   color: MyAppColor.black,
            // ),
            onChanged: (String? newValue) {
              setState(() {
                DropdownString.selectIndustry = newValue!;
              });
            },
            items: ListDropdown.selectIndustries
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: blackDarkR12(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  search() {
    return Container(
      padding: EdgeInsets.all(6),
      height: Sizeconfig.screenHeight! / 20,
      width: Sizeconfig.screenWidth! / 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: MyAppColor.orangelight,
      ),
      child: Image.asset(
        'assets/search_image.png',
        height: 10,
      ),
    );
  }
}
