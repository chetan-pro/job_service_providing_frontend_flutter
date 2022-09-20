// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/add_staff_member.dart';
import 'package:hindustan_job/company/home/pages/show_staff.dart';
import 'package:hindustan_job/company/home/widget/createjob_findjob.dart';
import 'package:hindustan_job/company/home/widget/home_filter_options.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/bottom_sheet_utility_functions.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../widget/drop_down_widget/text_drop_down_widget.dart';
import 'home/homepage.dart';

class OurStaff extends ConsumerStatefulWidget {
  final List<UserData>? staff;

  OurStaff({
    Key? key,
    this.staff,
  }) : super(key: key);

  @override
  _OurStaffState createState() => _OurStaffState();
}

class _OurStaffState extends ConsumerState<OurStaff> {
  @override
  void initState() {
    super.initState();
    ref.read(companyProfile).getStaffDataShow(context);
  }

  @override
  Widget build(BuildContext context) {
    final styles1 = Mytheme.lightTheme(context).textTheme;
    return Consumer(builder: (context, ref, child) {
      bool isUserSubscribed = ref.watch(companyProfile).isUserSubscribed;
      return Scaffold(
        body: Responsive.isDesktop(context)
            ? Container(
                // width: Sizeconfig.screenWidth! / 1.3,
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    HomeFilterOptions(
                        flag: 'addStaff', isUserSubscribed: isUserSubscribed),
                    SizedBox(height: 22),
                    SizedBox(
                      // width: Sizeconfig.screenWidth! / 2,
                      child: sortBy(),
                    ),
                    SizedBox(height: 23),
                    _table(),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          CreateFindJOb(
                            isUserSubscribed: isUserSubscribed,
                            buttonText: 'ADD A STAFF',
                            buttonRoute: AddStaffMember(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          sortBy(),
                          Consumer(builder: (context, ref, child) {
                            List<UserData> staff =
                                ref.watch(companyProfile).staffShow;
                            return staffMemberBox(staff);
                          }),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Footer()
                  ],
                ),
              ),
      );
    });
  }

  String sortValue = "Sort by relevance";

  sortBy() {
    return AppDropdownInput(
      hintText: "Sort by relevance",
      options: ['Ascending', 'Descending'],
      value: sortValue,
      changed: (String value) async {
        sortValue = value;
        setState(() {});
        if (value != 'Sort by relevance') {
          ref.read(companyProfile).getStaffDataShow(context, sortBy: value);
        } else {
          ref.read(companyProfile).getStaffDataShow(context);
        }
      },
      getLabel: (String value) => value,
    );
  }

  staffMemberBox(
    List<UserData?> staff,
  ) {
    return Column(
      children: List.generate(
        staff.length,
        (x) => Container(
          margin: EdgeInsets.only(top: 7),
          color: MyAppColor.greynormal,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "#${(x + 1).toString()}",
                    ),
                    Text(
                      staff[x]!.isStaffActive! ? 'Enabled' : 'Disabled',
                      style: TextStyle(
                          color: staff[x]!.isStaffActive!
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  getCapitalizeString(staff[x]!.name.toString()),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  staff[x]!.mobile.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Container(
                      color: MyAppColor.grayplane,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              staff[x]!.email.toString(),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddStaffMember(
                                  staff: staff[x],
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black)),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            ref.read(companyProfile).deleteStaffNotify(
                                  context,
                                  stffdelete: staff[x]!.id,
                                );
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black)),
                        )
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StaffSDataShow(
                              satffs: staff[x],
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _table() {
    return Consumer(builder: (context, ref, child) {
      List<UserData> staff = ref.watch(companyProfile).staffShow;
      return Container(
        padding: EdgeInsets.symmetric(
            vertical: !Responsive.isDesktop(context) ? 20.0 : 00),
        child: Table(
          border: TableBorder.all(color: Colors.white, width: 1.0),
          children: [
            TableRow(
                decoration: new BoxDecoration(color: MyAppColor.greynormal),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'S.No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Mobile Number',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Action',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),

            // if (staff.isNotEmpty && staff != null)
            for (var index = 0; index < staff.length; index++)
              TableRow(
                  decoration: BoxDecoration(color: MyAppColor.greynormal),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        (index + 1).toString(),
                        style: blackdarkM12,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        staff[index].name.toString(),
                        style: blackdarkM12,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        staff[index].mobile.toString(),
                        style: blackdarkM12,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        staff[index].email.toString(),
                        style: blackdarkM12,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        staff[index].status == 1 ? "Enabled" : "Disabled",
                        style: staff[index].status == 1
                            ? TextStyle(color: Colors.green)
                            : TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StaffSDataShow(
                                        satffs: staff[index],
                                      ),
                                    ),
                                  );
                                },
                                child: buttonDEA(
                                  icon: Icons.arrow_forward,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddStaffMember(
                                        staff: staff[index],
                                      ),
                                    ),
                                  );
                                },
                                child: buttonDEA(
                                  icon: Icons.edit,
                                ),
                              ),
                              SizedBox(
                                width: 20,
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
                                          stffdelete: staff[index].id,
                                        );
                                    Navigator.pop(context);
                                  }
                                },
                                child: buttonDEA(
                                  icon: Icons.delete,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
          ],
        ),
      );
    });
  }

  buttonDEA({IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.5),
        color: Colors.transparent,
        border: Border.all(color: MyAppColor.blackdark),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      child: Icon(
        icon,
        size: 17,
        color: Colors.black,
      ),
    );
  }
}
