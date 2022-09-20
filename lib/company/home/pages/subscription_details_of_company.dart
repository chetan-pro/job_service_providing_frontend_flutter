import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/active_subscription_details_model.dart';
import 'package:hindustan_job/company/home/homepage.dart' as company;
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';

import '../../../candidate/header/app_bar.dart';
import '../../../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../../../candidate/pages/job_seeker_page/home/homeappbar.dart'
    as candidate;
import '../../../candidate/theme_modeule/new_text_style.dart';
import '../../../config/responsive.dart';
import '../../../constants/colors.dart';
import '../../../services/api_services/subscription_services.dart';
import '../../../services/auth/auth.dart';
import '../../../utility/function_utility.dart';
import '../../../widget/body/tab_bar_body_widget.dart';

class SubscriptionDetailsCompany extends ConsumerStatefulWidget {
  static const String route = '/subscription-details';

  const SubscriptionDetailsCompany({Key? key}) : super(key: key);

  @override
  ConsumerState<SubscriptionDetailsCompany> createState() =>
      _SubscriptionDetailsCompanyState();
}

class _SubscriptionDetailsCompanyState
    extends ConsumerState<SubscriptionDetailsCompany>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userData!.userRoleType == RoleTypeConstant.company) {
        ref.read(company.companyProfile).checkSubscription();
      } else {
        ref.read(candidate.editProfileData).checkSubscription();
      }
    });
    _control = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  checkProviderInstance() {
    return userData!.userRoleType == RoleTypeConstant.company
        ? company.companyProfile
        : candidate.editProfileData;
  }

  TabController? _control;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        key: _drawerKey,
        drawer: const Drawer(
          child: DrawerJobSeeker(),
        ),
        appBar: CompanyAppBar(
          drawerKey: _drawerKey,
          back: "Subscription Details",
          isWeb: Responsive.isDesktop(context),
        ),
        body: Consumer(builder: (context, ref, child) {
          List<ActiveSubscriptionDetail> activeSubscriptionDetail =
              ref.watch(checkProviderInstance()).activeSubscriptionDetails;
          List<ActiveSubscriptionDetail> inactiveSubscriptionDetail =
              ref.watch(checkProviderInstance()).inactiveSubscriptionDetails;
          return TabBarSliverAppbar(
            headColumn: SizedBox(),
            toolBarHeight: 0,
            length: 2,
            tabs: _tab(),
            tabsWidgets: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: _otherPlanLayout(activeSubscriptionDetail, 'Active'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: _otherPlanLayout(inactiveSubscriptionDetail, 'InActive'),
              ),
            ],
            control: _control!,
          );
        }));
  }

  TabBar _tab() {
    return TabBar(
        isScrollable: true,
        controller: _control,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: MyAppColor.orangelight,
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: 12,
        ),
        tabs: [
          Text(
            "Active",
            style: blackDarkSemibold14,
            textAlign: TextAlign.center,
          ),
          Text(
            "InActive",
            style: blackDarkSemibold14,
            textAlign: TextAlign.center,
          ),
        ]);
  }

  cardWidget() {
    return Column(
      children: [
        Container(
          color: MyAppColor.applecolor,
          height: 100,
          child: Image.asset(
            'assets/company_home2.png',
            height: 10,
          ),
        ),
      ],
    );
  }

  ///other plan layouts
  Widget _otherPlanLayout(
      List<ActiveSubscriptionDetail> activeSubscriptionDetails, status) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _otherPlansLabel(status),
            _planRow(activeSubscriptionDetails),
          ],
        ),
      ),
    );
  }

  Widget _planRow(List<ActiveSubscriptionDetail> activeSubscriptionDetail) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(
        activeSubscriptionDetail.length,
        (index) => _standardPlanBox(activeSubscriptionDetail[index]),
      ),
    );
  }

  ///Standard plan box
  Widget _standardPlanBox(ActiveSubscriptionDetail activeSubscriptionDetail) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white60,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        splashColor: Colors.orangeAccent[100],
        highlightColor: Colors.white,
        onTap: () => {},
        child: Container(
          color: MyAppColor.greynormal,
          width: MediaQuery.of(context).size.width * 0.90,
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildPlanLabel(
                  '${activeSubscriptionDetail.subscriptionPlans!.title}'),
              _buildPlanPrice(
                  '\₹${activeSubscriptionDetail.subscriptionPlans!.discountedAmount}/${activeSubscriptionDetail.subscriptionPlans!.expiryDays} days'),
              if (userData!.userRoleType == RoleTypeConstant.company)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        activeSubscriptionDetail.planType ==
                                SubscriptionType.resumeDataAccessPlan
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    _buildTextLabel("Email limits",
                                        '${activeSubscriptionDetail.availableEmailLimits}'),
                                    SizedBox(width: 15),
                                    _buildTextLabel("CV limits",
                                        '${activeSubscriptionDetail.availableCvlLimits}'),
                                  ])
                            : _buildTextLabel("Job limits",
                                '${activeSubscriptionDetail.availableJobLimits}'),
                      ]),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _buildFeatureLabel(
                    activeSubscriptionDetail.subscriptionPlans!.description!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Expire Date :- ${formatDate(activeSubscriptionDetail.expiryDate)}"),
                  toggleShow(
                    text: "Staff Status",
                    status: activeSubscriptionDetail.status == 1 ? true : false,
                    subscriptionPlanId: activeSubscriptionDetail.id,
                    isChanged: true,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  toggleShow({text, status, isChanged, subscriptionPlanId}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          status ? "Active" : "Deactive",
        ),
        Switch(
          value: status,
          onChanged: (value) async {
            if (value) {
              var feedBack = await alertBox(
                context,
                "If you active this your old plan will be expire. Are you sure to active this plan ?",
                title: "Subscription plan Deactive",
              );
              if (feedBack == 'Done') {
                if (!status) {
                  ApiResponse response = await activateSubscribedPlans(
                      {"subscription_id": subscriptionPlanId});
                  print("response");
                  print(response.status);
                  print(response.body?.message);
                  if (userData!.userRoleType == RoleTypeConstant.company) {
                    ref.read(company.companyProfile).checkSubscription();
                  } else {
                    ref.read(candidate.editProfileData).checkSubscription();
                  }
                }
              }
            }
          },
          activeColor: Colors.green,
        ),
      ],
    );
  }

  ///build price
  Widget _buildPlanPrice(String price) {
    return Text(
      price,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  ///build feature row label
  Widget _buildFeatureLabel(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 13),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildPlanLabel(String label) {
    return Text(
      label,
      style: TextStyle(
          letterSpacing: 0.1,
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextLabel(String label, String value) {
    return Text(
      label + " : " + value,
      style: TextStyle(
          letterSpacing: 0.1,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 14),
      textAlign: TextAlign.center,
    );
  }

  ///other plan label at bottom
  Widget _otherPlansLabel(status) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.06),
      child: Text(
        '$status Plans',
        style: TextStyle(
            letterSpacing: 0.5,
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
