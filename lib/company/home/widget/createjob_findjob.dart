import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'package:hindustan_job/company/home/create_job_post.dart';
import 'package:hindustan_job/company/home/search/searchcompany.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import '../homepage.dart';

class CreateFindJOb extends ConsumerStatefulWidget {
  bool isUserSubscribed;
  String? text;
  String? buttonText;
  var buttonRoute;
  var route;
  CreateFindJOb(
      {Key? key,
      required this.isUserSubscribed,
      this.text,
      this.route,
      this.buttonRoute,
      this.buttonText})
      : super(key: key);

  @override
  ConsumerState<CreateFindJOb> createState() => _CreateFindJObState();
}

class _CreateFindJObState extends ConsumerState<CreateFindJOb> {
  @override

  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Search(
                    text: widget.text ?? "Resume Access",
                    route: widget.route ??
                        SearchCompany(
                          isNotApplied: true,
                          data: const {"candidate": "NOT_APPLIED"},
                          // data: const {},
                          isUserSubscribed: widget.isUserSubscribed,
                        ),
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
                  flex: 4,
                  child: SizedBox(
                    height: Sizeconfig.screenHeight! / 16,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: MyAppColor.darkBlue),
                        onPressed: () async {
                          if (widget.isUserSubscribed) {
                            if (widget.buttonRoute != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          widget.buttonRoute));
                            } else {
                              if (userData!.userRoleType ==
                                  RoleTypeConstant.companyStaff) {
                                bool isCreatedJob = false;
                                for (var element in userData!.permissons!) {
                                  if (element.name ==
                                      PermissionConstant.postJob) {
                                    isCreatedJob = true;
                                  }
                                }
                                if (!isCreatedJob) {
                                  return toast(
                                      "You don't have permission to post job");
                                }
                              }
                              if (ref.read(companyProfile).availableJobLimits ==
                                  0) {
                                return await alertBox(context,
                                    "You have no job post limit please subscribed to get access",
                                    title: "Job Limit Reached",
                                    route:
                                        SubscriptionPlans(isLimitPlans: true));
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateJobPost(),
                                ),
                              );
                            }
                          } else {
                            alertBox(context,
                                "You are not subscribed user please click on yes if want to subscribe",
                                title: 'Subscribe Now',
                                route: SubscriptionPlans(isValidityPlan: true));
                          }
                        },
                        child: Text(widget.buttonText ?? 'CREATE A JOB')),
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (userData!.userRoleType != RoleTypeConstant.companyStaff)
            Row(
              children: [
                Expanded(
                    flex: 4,
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
                    flex: 4,
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
      ),
    );
  }
}
