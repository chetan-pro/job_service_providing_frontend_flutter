// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/model/Company/permission.dart';
import 'package:hindustan_job/candidate/model/role_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

class AddStaffMember extends ConsumerStatefulWidget {
  UserData? staff;
  AddStaffMember({Key? key, this.staff}) : super(key: key);
  static const String route = '/add-a-staff-member';

  @override
  ConsumerState createState() => _AddStaffMemberState();
}

class _AddStaffMemberState extends ConsumerState<AddStaffMember> {
  List<bool>? isSelected;

  bool isSwitch = false;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController designation = TextEditingController();
  List<PermissonModel> staffPermission = [];
  var _formKey = GlobalKey<FormState>();

  Roles? role;

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      setData(widget.staff);
    }
    ref.read(companyProfile).getStaffResponse(context,
        permission: widget.staff != null ? widget.staff!.permissons : []);
  }

  setData(UserData? staff) {
    name.text = staff!.name!;
    email.text = staff.email!;
    mobile.text = staff.mobile!;
    staffPermission = staff.permissons!;
    designation.text = staff.yourDesignation!;
    setState(() {});
  }

  addSatffComp() async {
    var staffData = {
      "name": name.text,
      "mobile": mobile.text,
      "email": email.text,
      "password": password.text,
      "permissions": staffPermission.map((e) => e.id).toList(),
      "your_designation": designation.text
    };

    ApiResponse response;
    if (widget.staff == null) {
      staffData["user_role_type"] = 'CS';
      staffData["company_id"] = userData!.id.toString();
      response = await addStaffCompany(staffData);
    } else {
      staffData['id'] = widget.staff!.id!;
      response = await editStaffNotify(staffData);
    }
    if (response.status == 200) {
      if (widget.staff == null) {
        ref.read(companyProfile).addStaffDataShow(response.body!.data);
      } else {
        ref.read(companyProfile).getStaffDataShow(response.body!.data);
      }
      Navigator.pop(context);
      await showSnack(
          context: context, msg: response.body!.message, type: 'success');
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final sizeBox = Responsive.isDesktop(context)
        ? Sizeconfig.screenWidth! / 4.1
        : Sizeconfig.screenWidth;
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      drawer: const Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: CustomAppBar(
        context: context,
        drawerKey: _drawerKey,
        back:
            "HOME (COMPANY ADMIN) / ${widget.staff != null ? 'EDIT' : 'ADD'} A STAFF MEMBER",
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
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${widget.staff != null ? "EDIT" : "ADD"} A STAFF MEMBER",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          ".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . "),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Sizeconfig.screenWidth,
                        height: 40,
                        color: MyAppColor.greynormal,
                        child: const Center(
                          child: Text(
                            "STAFF MEMBER DETAILS",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Form(
                        key: _formKey,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SizedBox(
                              width: sizeBox,
                              child: TextFormFieldWidget(
                                control: name,
                                text: "Full Name",
                                isRequired: true,
                                type: TextInputType.multiline,
                              ),
                            ),
                            SizedBox(
                              width: sizeBox,
                              child: NumberTextFormFieldWidget(
                                isRequired: true,
                                control: mobile,
                                text: "Mobile",
                                type: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              width: sizeBox,
                              child: TextFormFieldWidget(
                                  control: email,
                                  text: "Email",
                                  isRequired: true,
                                  type: TextInputType.emailAddress),
                            ),
                            SizedBox(
                              width: sizeBox,
                              child: TextFormFieldWidget(
                                  control: designation,
                                  text: "Designation",
                                  isRequired: true,
                                  type: TextInputType.multiline),
                            ),
                            if (widget.staff == null)
                              SizedBox(
                                width: sizeBox,
                                child: TextFormFieldWidget(
                                  control: password,
                                  text: "Password",
                                  isRequired: true,
                                  type: TextInputType.multiline,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Text(
                          ".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . "),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Sizeconfig.screenWidth,
                        height: 40,
                        color: MyAppColor.greynormal,
                        child: const Center(
                            child: Text(
                          "PERMISSIONS",
                          textAlign: TextAlign.center,
                        )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer(builder: (context, ref, child) {
                        List<PermissonModel> permission =
                            ref.watch(companyProfile).getstaffPermission;
                        return Column(
                            children: List.generate(
                                permission.length,
                                (index) => Container(
                                      color: MyAppColor.greynormal,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            permission[index].name!,
                                            style: blackBold16,
                                          ),
                                          Switch(
                                            value: permission[index].toggle!,
                                            onChanged: (value) {
                                              setState(() {
                                                permission[index].toggle =
                                                    value;
                                                if (permission[index].toggle!) {
                                                  staffPermission
                                                      .add(permission[index]);
                                                } else {
                                                  staffPermission.removeWhere(
                                                      (element) =>
                                                          element.id ==
                                                          permission[index].id);
                                                }
                                              });
                                            },
                                            activeColor: Colors.green,
                                          ),
                                        ],
                                      ),
                                    )));
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          ".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . "),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: MyAppColor.orangelight,
                        ),
                        onPressed: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          _formKey.currentState!.save();

                          await addSatffComp();
                        },
                        child: Text(
                          "${widget.staff == null ? 'ADD' : 'EDIT'} STAFF MEMBER",
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
