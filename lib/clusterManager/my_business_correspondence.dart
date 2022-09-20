import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/registree_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/clusterManager/cluster_manager_dashboard.dart';
import 'package:hindustan_job/clusterManager/registree_details_screen.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../services/auth/auth.dart';
import '../utility/function_utility.dart';
import '../widget/drop_down_widget/text_drop_down_widget.dart';

class MyBusinessCorespondenceScreen extends ConsumerStatefulWidget {
  const MyBusinessCorespondenceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyBusinessCorespondenceScreen> createState() =>
      _MyBusinessCorespondenceScreenState();
}

class _MyBusinessCorespondenceScreenState
    extends ConsumerState<MyBusinessCorespondenceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref
        .read(businessCorrespondance)
        .getRegistreeByRoleType(RoleTypeConstant.businessCorrespondence);
  }

  String sortValue = "Sort by relevance";

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      List<Registree> registreeSubBcList =
          ref.watch(businessCorrespondance).registreeSubBcList;

      return userData!.referrerCode == null
          ? Center(
              child: Text(
                'Not Approved By Admin',
                style: blackDarkR12(),
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Responsive.isDesktop(context) ? 120.0 : 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: Responsive.isDesktop(context)
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            const Text('SUB BUSINESS CORRESPONDANCE'),
                            if (Responsive.isDesktop(context))
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.arrow_drop_down),
                                  Text(LabelString.sortByRelevance,
                                      style: black12)
                                ],
                              ),
                          ],
                        ),
                      ),
                      if (!Responsive.isDesktop(context))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppDropdownInput(
                              hintText: "Sort by relevance",
                              options: ['Ascending', 'Descending'],
                              value: sortValue,
                              changed: (String value) async {
                                sortValue = value;
                                setState(() {});
                                if (value != 'Sort by relevance') {
                                  ref
                                      .read(businessCorrespondance)
                                      .getRegistreeByRoleType(
                                          RoleTypeConstant
                                              .businessCorrespondence,
                                          sortBy: value);
                                }
                              },
                              getLabel: (String value) => value,
                            )
                          ],
                        ),
                      Correspondences(
                        registreeSubBcList: registreeSubBcList,
                      )
                    ],
                  ),
                ),
                Footer()
              ],
            );
    });
  }
}

//

class Correspondences extends StatefulWidget {
  List<Registree> registreeSubBcList;
  Correspondences({Key? key, required this.registreeSubBcList})
      : super(key: key);

  @override
  State<Correspondences> createState() => _CorrespondencesState();
}

class _CorrespondencesState extends State<Correspondences> {
  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? Container(
            height: Responsive.isDesktop(context) ? Sizeconfig.screenHeight : 0,
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 20 : 0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      itemWIndow(
                          text: 'S.NO',
                          flex: 1,
                          alignment: Alignment.center,
                          style: black10),
                      itemWIndow(
                        text: 'BUSINESS CORRESPONDENCE NAME',
                        flex: 3,
                        style: black10,
                      ),
                      itemWIndow(
                        flex: 2,
                        text: 'DATE REGISTERED',
                        style: black10,
                      ),
                      itemWIndow(
                        text: 'Last date of subscription purchased',
                        flex: 3,
                        style: black10,
                      ),
                      itemWIndow(
                          text: 'No of subscription purchased',
                          flex: 3,
                          style: black10),
                      itemWIndow(
                          text: 'ACTION',
                          flex: 1,
                          style: black10,
                          alignment: Alignment.center),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 0 : 0,
                  ),
                  Expanded(child: listViewWindow(widget.registreeSubBcList)),
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 20 : 0,
                  ),
                  //   viewAllButtonWindow()
                ],
              ),
            ))
        : listViewMobile(widget.registreeSubBcList);
  }

  Widget listViewMobile(List<Registree> registreeSubBcList) {
    return SizedBox(
      height: Sizeconfig.screenHeight,
      child: ListView.builder(
          itemCount: registreeSubBcList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                color: MyAppColor.greynormal,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${index + 1}", style: grey12),
                            Wrap(
                              children: [
                                Text(
                                    "${formatDate(registreeSubBcList[index].dateRegistered)}",
                                    style: blackDarkSb10()),
                                const Icon(Icons.calendar_today_rounded,
                                    size: 11)
                              ],
                            ),
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("${registreeSubBcList[index].registeredUser!.name}",
                          style: blackDarkSemiBold16),
                      Row(
                        children: [
                          Text('Role Registered for: ', style: blackMedium12),
                          Text(
                              "${registreeSubBcList[index].registeredUser!.userRoleType}",
                              style: blackMedium12)
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Container(
                      //       color: MyAppColor.grey,
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 10.0, vertical: 0),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                   '${formatDate(registreeSubBcList[index].lastSubscriptionPurchaseDate)}',
                      //                   style: blackDarkSemibold14),
                      //               Text('Last date of subscription',
                      //                   style: blackDarkR10())
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(color: MyAppColor.white, width: 10),
                      //     Container(
                      //       color: MyAppColor.grey,
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 10.0, vertical: 0),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                   '${registreeSubBcList[index].noSubscriptionPurchased}',
                      //                   style: blackDarkSemibold14),
                      //               Text('No of subscription purchased',
                      //                   style: blackDarkR10())
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          viewAllButtonMobile(
                              context, registreeSubBcList[index])
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  viewAllButtonMobile(context, Registree registree) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                            flag: 'bussiness-correspondence',
                            registree: registree,
                          )));
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: MyAppColor.greynormal,
                side: BorderSide(width: 1.0, color: MyAppColor.black)),
            child: Row(
              children: [
                Text(
                  'VIEW ',
                  style: blackRegular12,
                ),
                Image.asset(
                  'assets/forward_arrow.png',
                  color: MyAppColor.black,
                )
              ],
            )),
      ],
    );
  }

  //
  Widget listViewWindow(List<Registree> registreeSubBcList) {
    return ListView.builder(
        itemCount: registreeSubBcList.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemWIndow(
                flex: 1,
                text: "${index + 1}",
                alignment: Alignment.center,
              ),
              itemWIndow(
                  flex: 3,
                  text: "${registreeSubBcList[index].registeredUser!.name}",
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 2,
                  text:
                      "${formatDate(registreeSubBcList[index].dateRegistered)}",
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 3,
                  text:
                      "${formatDate(registreeSubBcList[index].lastSubscriptionPurchaseDate)}",
                  alignment: Alignment.centerRight),
              itemWIndow(
                  flex: 3,
                  text: '${registreeSubBcList[index].noSubscriptionPurchased}',
                  alignment: Alignment.centerRight),
              arrowButton(context, registreeSubBcList[index])
            ],
          );
        });
  }

  arrowButton(context, Registree registree) {
    return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                            flag: 'bussiness-correspondence',
                            registree: registree,
                          )));
            },
            child: Container(
              color: MyAppColor.grayplane,
              alignment: Alignment.center,
              height: Responsive.isDesktop(context) ? 37 : 55,
              child: Container(
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(
                              4.0) //                 <--- border radius here
                          ),
                      border: Border.all(color: MyAppColor.black)),
                  child: Image.asset(
                    'assets/forward_arrow.png',
                    color: MyAppColor.black,
                  )),
            ),
          ),
        ));
  }

  //
  itemWIndow({flex, text, alignment, style}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2),
        child: Container(
          alignment: alignment,
          color: MyAppColor.grayplane,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: style ?? black12,
            ),
          ),
        ),
      ),
    );
  }

  //
  viewAllButtonWindow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                primary: MyAppColor.greynormal,
                side: BorderSide(width: 1.0, color: MyAppColor.black)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: Text(
                'VIEW ALL',
                style: black14,
              ),
            )),
      ],
    );
  }
}
