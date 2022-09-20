import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:vrouter/vrouter.dart';

class SubscriptionAlertBox extends StatelessWidget {
  String? flag;
  bool isFromConnectedRoutes;
  SubscriptionAlertBox({
    Key? key,
    this.flag,
    required this.isFromConnectedRoutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (kIsWeb) {
          context.vRouter.to("/hindustaan-jobs/subscription-plans",
              queryParameters: {"isValidityPlan": 'true'});
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubscriptionPlans(
                        isValidityPlan: true,
                        isFromConnectedRoutes: isFromConnectedRoutes,
                      )));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        color: MyAppColor.pinkishOrange,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: MyAppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(19))),
              child: ImageIcon(
                AssetImage("assets/dark_blue.png"),
                size: 25,
                color: MyAppColor.orangelight,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      flag != null
                          ? "Currently you are not on any Subscription Plan. Please subscribe to our affordable Plans starting from ₹ 99 & get access to millions of Candidates & Post un-limited Jobs & Hire un-limited Candidates."
                          : "Subscribe to our Premium Plans starting from ₹ 99 to unlock endless career possibilities along with Professional Resume Builder & find Jobs tailored just for you.",
                      style: whiteRegularGalano12,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_alt,
                    color: MyAppColor.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
