// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/Company/permission.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';

class UpdateStaff extends ConsumerStatefulWidget {
  UserData? satffs;
  UpdateStaff({Key? key, this.satffs}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateStaffState();
}

class _UpdateStaffState extends ConsumerState<UpdateStaff> {
  List<PermissonModel> permission = [];
  @override
  void initState() {
    super.initState();
    // setData(widget.satffs.toString());

    if (widget.satffs != null) {
      setData(widget.satffs!);
    }
  }

  fetchStaff(context) async {
    widget.satffs = await ref.read(companyProfile).getStaffDataShow(context);
  }

  updateStaff() async {
    var staffData = {
      "name": name.text,
      "mobile": mobile.text,
      "email": email.text,
      "permissions": permission,
    };

    if (widget.satffs != null) {
      staffData['id'] = widget.satffs!.id.toString();
    }
    ApiResponse response;

    response = await editStaffNotify(staffData);

    if (response.status == 200) {
      await showSnack(
        context: context,
        msg: response.body!.message,
        type: 'Updated Success',
      );

      fetchStaff(context);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  setData(UserData staffs) {
    email.text = staffs.email.toString();
    name.text = staffs.name.toString();
    password.text = staffs.password.toString();
    mobile.text = staffs.mobile.toString();
  }

  bool isSwitch = true;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeBox = Responsive.isDesktop(context)
        ? Sizeconfig.screenWidth! / 4.1
        : Sizeconfig.screenWidth;
    return Scaffold(
      appBar: CompanyAppBar(
        drawerKey: _drawerKey,
        isWeb: Responsive.isDesktop(context),
        back: 'add staff',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 25,
              ),
              child: Center(
                child: SizedBox(
                  width: Responsive.isDesktop(context)
                      ? Sizeconfig.screenWidth! / 2
                      : Sizeconfig.screenWidth,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ADD A STAFF MEMBER",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . "),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Sizeconfig.screenWidth,
                        height: 40,
                        color: MyAppColor.greynormal,
                        child: Center(
                          child: Text(
                            "STAFF MEMBER DETAILS",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          SizedBox(
                            width: sizeBox,
                            child: TextfieldWidget(
                              control: name,
                              text: "Full Name",
                            ),
                          ),
                          SizedBox(
                            width: sizeBox,
                            child: TextfieldWidget(
                              control: mobile,
                              text: "Mobile",
                            ),
                          ),
                          SizedBox(
                            width: sizeBox,
                            child: TextfieldWidget(
                              control: email,
                              text: "Email",
                            ),
                          ),
                          // SizedBox(
                          //   width: sizeBox,
                          //   child: TextfieldWidget(
                          //     control: password,
                          //     text: "Password",
                          //   ),
                          // ),
                        ],
                      ),
                      Text(".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . "),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Sizeconfig.screenWidth,
                        height: 40,
                        color: MyAppColor.greynormal,
                        child: Center(
                            child: Text(
                          "PERMISSIONS",
                          textAlign: TextAlign.center,
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(children: [
                        Container(
                          color: MyAppColor.greynormal,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'hhjjj',
                                style: blackBold16,
                              ),
                              Switch(
                                value: isSwitch,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitch = value;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                        )
                        // : Container(),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      Text(".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . "),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: MyAppColor.orangelight,
                        ),
                        onPressed: () {
                          updateStaff();
                        },
                        child: Text(
                          'Update staff member',
                          style: TextStyle(color: MyAppColor.backgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Footer()
          ],
        ),
      ),
    );
  }
}
