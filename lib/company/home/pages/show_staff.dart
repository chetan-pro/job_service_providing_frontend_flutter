// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/add_staff_member.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

class StaffSDataShow extends ConsumerStatefulWidget {
  UserData? satffs;
  StaffSDataShow({Key? key, this.satffs}) : super(key: key);

  @override
  _StaffSDataShowState createState() => _StaffSDataShowState();
}

class _StaffSDataShowState extends ConsumerState<StaffSDataShow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyProfile).activeInActiveStaffStatus(
          widget.satffs!.isStaffActive, widget.satffs!.id);
    });
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        appBar: CompanyAppBar(
          drawerKey: _drawerKey,
          isWeb: Responsive.isDesktop(context),
          back: '/staff-member-details',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'STAFF MEMBER DETAILS',
                        style: companyNameM14(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (cotext) => AddStaffMember(
                                    staff: widget.satffs,
                                  ),
                                ),
                              );
                            },
                            child: staffProfile(text: 'edit staff profile'),
                          ),
                          InkWell(
                            onTap: () async {
                              var val = await alertBox(
                                context,
                                'Are you sure you want to delete this staff ?',
                                title: 'Delete Staff',
                              );
                              if (val == 'Done') {
                                await ref
                                    .read(companyProfile)
                                    .deleteStaffNotify(
                                      context,
                                      stffdelete: widget.satffs!.id,
                                    );
                                Navigator.pop(context);
                              }
                            },
                            child: staffProfile(text: 'delete staff profile'),
                          )
                        ],
                      ),
                    ),
                    Consumer(builder: (context, ref, child) {
                      bool activeInActiveStaffStatus =
                          ref.watch(companyProfile).isStaffActive;
                      return toggleShow(
                          text: "Staff Status",
                          status: activeInActiveStaffStatus,
                          isChanged: true);
                    }),
                    SizedBox(
                      height: 25,
                    ),
                    showData(title: 'Full Name', text: widget.satffs!.name),
                    SizedBox(
                      height: 25,
                    ),
                    showData(
                        title: 'Mobile Number', text: widget.satffs!.mobile),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width,
                      child: Column(
                          children: List.generate(
                              widget.satffs!.permissons!.length,
                              (index) => toggleShow(
                                  text: widget.satffs!.permissons![index].name,
                                  status: true,
                                  isChanged: false))),
                    ),
                  ],
                ),
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }

  editable({TextEditingController? control, String? text}) {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormFieldWidget(
          text: text,
          isRequired: false,
          control: control,
          // .text = widget.getAdd!.branchName.toString(),
          styles: blackDark12,
          type: TextInputType.name),
    );
  }

  toggleShow({text, status, isChanged}) {
    return Container(
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width / 2
          : MediaQuery.of(context).size.width,
      color: MyAppColor.greynormal,
      margin: EdgeInsets.only(top: 25),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$text: ${status ? 'Enabled' : 'Disabled'}',
            style: blackDarkM14(),
          ),
          Switch(
            value: status,
            onChanged: (value) async {
              if (isChanged) {
                ApiResponse response = await activeInactiveStaff(
                    staffId: widget.satffs!.id, status: value);
                if (response.status == 200) {
                  ref
                      .read(companyProfile)
                      .activeInActiveStaffStatus(value, widget.satffs!.id);
                }
              }
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget showData({String? text, String? title}) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: EdgeInsets.all(10),
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: appleColorsb10,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                text!,
                style: blackdarkM12,
              )
            ],
          ),
        ],
      ),
    );
  }

  staffProfile({String? text}) {
    return Padding(
      padding:
          EdgeInsets.only(right: !Responsive.isDesktop(context) ? 10 : 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            "assets/editdetail.png",
            height: 14,
            width: 14,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            text!,
            style: orangeDarkSb12(),
          ),
        ],
      ),
    );
  }
}
