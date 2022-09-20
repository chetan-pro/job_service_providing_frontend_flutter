// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, must_be_immutable, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/add_staff_member.dart';
import 'package:hindustan_job/company/home/create_job_post.dart';
import 'package:hindustan_job/company/home/search/searchcompany.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:vrouter/vrouter.dart';

import '../../../candidate/model/city_model.dart';
import '../../../candidate/model/industry_model.dart';
import '../../../candidate/model/sector_model.dart';
import '../../../candidate/model/state_model.dart';
import '../../../candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import '../../../constants/mystring_text.dart';
import '../../../widget/drop_down_widget/drop_down_dynamic_widget.dart';
import '../homepage.dart';

class HomeFilterOptions extends StatefulWidget {
  String flag;
  bool isUserSubscribed;
  HomeFilterOptions(
      {Key? key, required this.flag, required this.isUserSubscribed})
      : super(key: key);

  @override
  State<HomeFilterOptions> createState() => _HomeFilterOptionsState();
}

class _HomeFilterOptionsState extends State<HomeFilterOptions> {
  TextEditingController searchTextController = TextEditingController();
  Industry? selectedIndustry;
  Sector? selectedSector;
  List<States> stateList = [];
  States? selectedState;
  List<City> cityList = [];
  City? selectedCity;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Consumer(builder: (context, ref, child) {
        List<Industry> industry = ref.watch(listData).industry;
        List<States> state = ref.watch(listData).state;
        return Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  inputFieldText(context),
                  SizedBox(width: 10),
                  DynamicDropDownListOfFields(
                    label: DropdownString.selectIndustry,
                    dropDownList: industry,
                    selectingValue: selectedIndustry,
                    setValue: (value) async {
                      if (DropdownString.selectIndustry == value!) {
                        return;
                      }
                      selectedIndustry = industry.firstWhere(
                          (element) => element.name.toString() == value);
                      selectedSector = null;
                    },
                  ),
                  SizedBox(width: 10),
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
                      selectedCity = null;
                      await ref
                          .read(listData)
                          .fetchCity(context, id: selectedState!.id);
                    },
                  ),
                  SizedBox(width: 10),
                  Consumer(builder: (context, watch, child) {
                    List<City> city = ref.watch(listData).city;
                    return DynamicDropDownListOfFields(
                        label: DropdownString.selectCity,
                        dropDownList: city,
                        selectingValue: selectedCity,
                        setValue: (value) {
                          if (DropdownString.selectCity == value!) {
                            return;
                          }
                          setState(() {
                            selectedCity = city
                                .firstWhere((element) => element.name == value);
                          });
                        },
                        isValidDrop: selectedState != null,
                        alertMsg: AlertString.selectState);
                  }),
                  SizedBox(width: 30),
                  _resume(),
                ]),
                Spacer(),
                Container(
                  width: 2,
                  height: 50,
                  color: MyAppColor.greyDark,
                ),
                Spacer(),
                if (widget.flag == 'null') SizedBox(),
                if (widget.flag == 'post') _createJob(),
                if (widget.flag == 'addStaff') _addStaff(),
              ],
            ),
            SizedBox(height: 10),
            if (userData!.userRoleType != RoleTypeConstant.companyStaff)
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: Sizeconfig.screenHeight! / 16,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: MyAppColor.darkBlue),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubscriptionPlans(
                                          isCompanyBranding: true)));
                            },
                            child: Text('Company Branding')),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: VerticalDivider(
                      thickness: 3,
                      color: MyAppColor.greynormal,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: Sizeconfig.screenHeight! / 16,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: MyAppColor.darkBlue),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubscriptionPlans(
                                          isValidityPlan: true)));
                            },
                            child: Text("Job Branding")),
                      )),
                ],
              ),
          ],
        );
      }),
    );
  }

  _resume() {
    return ElevatedButton(
      onPressed: () {
        if (kIsWeb) {
          context.vRouter
              .to("/home-company/search-candidates", queryParameters: {
            "industry_id":
                selectedIndustry != null ? selectedIndustry!.id.toString() : '',
            "state_id":
                selectedState != null ? selectedState!.id.toString() : '',
            "cities": selectedCity != null ? selectedCity!.id.toString() : '',
            "pincode": searchTextController.text,
            "candidate": "NOT_APPLIED",
            'isNotApplied': 'true'
          });
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchCompany(
                      isUserSubscribed: widget.isUserSubscribed)));
        }
        return;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 17,
            ),
            SizedBox(width: 3),
            Text(
              'FIND RESUME',
              style: !Responsive.isDesktop(context) ? whiteR14() : whiteR12(),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(primary: MyAppColor.orangelight),
    );
  }

  _createJob() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: MyAppColor.darkBlue),
        onPressed: () {
          if (widget.isUserSubscribed) {
            if (kIsWeb) {
              context.vRouter.to('/home-company/create-job-post');
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateJobPost(),
                ),
              );
            }
          } else {
            if (userData!.userRoleType == RoleTypeConstant.companyStaff) {
              toast("Your company doesn't have any subscription plan");
            } else {
              alertBox(context,
                  "You are not subscribed user please click on yes if want to subscribe",
                  title: 'Subscribe Now',
                  route: SubscriptionPlans(isValidityPlan: true));
            }
          }

          return;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(
                Icons.add,
                size: 19,
              ),
              Text(
                'CREATE A JOB POST',
                style: !Responsive.isDesktop(context) ? whiteR14() : whiteR12(),
              ),
            ],
          ),
        ));
  }

  _addStaff() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: MyAppColor.darkBlue),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: InkWell(
            onTap: () {
              if (widget.isUserSubscribed) {
                if (kIsWeb) {
                  context.vRouter.to("/home-company/add-a-staff");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddStaffMember()));
                }
              } else {
                alertBox(context,
                    "You are not subscribed user please click on yes if want to subscribe",
                    title: 'Subscribe Now',
                    route: SubscriptionPlans(isValidityPlan: true));
              }
            },
            child: Row(
              children: [
                const Icon(
                  Icons.add,
                  size: 19,
                ),
                Text(
                  'ADD A STAFF MEMBER',
                  style:
                      !Responsive.isDesktop(context) ? whiteR14() : whiteR12(),
                ),
              ],
            ),
          ),
        ));
  }

  selectionDropDown(BuildContext context) {
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          buttonColor: Colors.white,
          child: DropdownButton<String>(
            value: DropdownString.skill,
            icon: IconFile.arrow,
            iconSize: Responsive.isMobile(context) ? 25 : 17,
            style: TextStyle(color: MyAppColor.blackdark),
            onChanged: (String? newValue) {
              DropdownString.sector = newValue!;
            },
            items: ListDropdown.skills
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? null : 11,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  inputFieldText(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5.8,
      child: TextFormField(
        controller: searchTextController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide.none,
          ),
          isDense: true,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          fillColor: Colors.white,
          filled: true,
          hintText: "Search by pincode...",
          hintStyle: !Responsive.isDesktop(context)
              ? blackDarkO40M14
              : blackDarkO40M12,
        ),
      ),
    );
  }
}
