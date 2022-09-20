import 'package:flutter/material.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';

import '../candidate/model/branch_model.dart';
import '../candidate/model/serviceProviderModal/mybranch.dart';
import '../candidate/theme_modeule/new_text_style.dart';
import '../candidate/theme_modeule/text_style.dart';
import '../utility/function_utility.dart';

class BranchCard extends StatelessWidget {
  Branch branch;
  BranchCard({Key? key, required this.branch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyAppColor.greynormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 5),
                      child: Image.asset('assets/bharat_service_co.png'),
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width * 0.2
                          : MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        branch.shopName.toString(),
                        style: BlackDarkSb20(),
                      ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 2.0, right: 2),
                                child: Image.asset('assets/location_icon.png'),
                              ),
                            ],
                          ),
                          Container(
                            color: MyAppColor.grayplane,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      branch.address1.toString(),
                                      style: blackDarkSemibold14,
                                    ),
                                    Text(
                                      locationShow(
                                          state: branch.state,
                                          city: branch.city),
                                      style: blackDarkSemibold14,
                                    ),
                                  ],
                                )
                              ],
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
        ],
      ),
    );
  }
}
