// ignore_for_file: prefer_const_constructors, unused_import, avoid_print, avoid_unnecessary_containers, unrelated_type_equality_checks, import_of_legacy_library_into_null_safe

import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/alldata_get_modal.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/mybranch.dart';
import 'package:hindustan_job/candidate/model/service_categories_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_profile.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/service_details_screen.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/category.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:vrouter/vrouter.dart';
// import 'package:provider/provider.dart';
import '../../../candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import '../../../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../../../widget/drop_down_widget/select_dropdown.dart';
import 'ServicesRequests/view_service_request_details_screen.dart';
import 'add_a_service_screen.dart';

class MyServicesTab extends ConsumerStatefulWidget {
  Function? resetIndex;
  MyServicesTab({Key? key, this.resetIndex}) : super(key: key);

  @override
  _MyServicesTabState createState() => _MyServicesTabState();
}

class _MyServicesTabState extends ConsumerState<MyServicesTab> {
  List<ServiceCategories> catogaries = [];

  ServiceCategories? catg;

  fetchcatogary() async {
    catogaries = await categoryData(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.resetIndex != null) {
      widget.resetIndex!();
    }
    ref.read(serviceProviderData).getServiceBranchData();
    ref.read(serviceProviderData).getAlldataservice();
  }

  String? selectedSortBy;
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    bool isUserSubscribed =
        ref.watch(serviceProviderData).isCandidateSubscribed;
    return Container(
      height: MediaQuery.of(context).size.height,
      color: MyAppColor.backgroundColor,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: Responsive.isMobile(context) ? 0 : 40.0,
                left: Responsive.isMobile(context) ? 0 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Responsive.isDesktop(context)
                    ? SizedBox(
                        height: 30,
                      )
                    : SizedBox(
                        height: 10,
                      ),
                rowTitleMyServiceWidget(isUserSubscribed),
                SizedBox(height: 30),
                Responsive.isDesktop(context)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.arrow_drop_down),
                              Text(
                                'Both Active & Non-Active',
                                style: blackMedium14,
                              ),
                              SizedBox(
                                width: 30,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 176,
                            child: BuildDropdown(
                              itemsList: const ['Ascending', 'Descending'],
                              dropdownHint: LabelString.sortByRelevance,
                              onChanged: (value) {
                                setState(() {
                                  selectedSortBy = value;
                                  ref
                                      .read(serviceProviderData)
                                      .getAlldataservice(
                                          status: selectedStatus,
                                          sortBy: LabelString.sortByRelevance !=
                                                  value
                                              ? selectedSortBy
                                              : null);
                                });
                              },
                              height: 47,
                              selectedValue: selectedSortBy,
                              defaultValue: LabelString.sortByRelevance,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 176,
                              child: BuildDropdown(
                                itemsList: const ['Ascending', 'Descending'],
                                dropdownHint: LabelString.sortByRelevance,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSortBy = value;
                                    ref
                                        .read(serviceProviderData)
                                        .getAlldataservice(
                                            status: selectedStatus,
                                            sortBy:
                                                LabelString.sortByRelevance !=
                                                        value
                                                    ? selectedSortBy
                                                    : null);
                                  });
                                },
                                height: 47,
                                selectedValue: selectedSortBy,
                                defaultValue: LabelString.sortByRelevance,
                              ),
                            ),
                            SizedBox(
                              width: 213,
                              child: BuildDropdown(
                                itemsList: const ['Active', 'Deactive'],
                                dropdownHint: "Both Active & Non-Active",
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value;
                                    ref
                                        .read(serviceProviderData)
                                        .getAlldataservice(
                                            status:
                                                "Both Active & Non-Active" !=
                                                        value
                                                    ? selectedStatus
                                                    : null,
                                            sortBy: selectedSortBy);
                                  });
                                },
                                height: 47,
                                selectedValue: selectedStatus,
                                defaultValue: "Both Active & Non-Active",
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 30),
                Consumer(
                  builder: (context, watch, child) {
                    List<AllServiceFetch> all =
                        ref.watch(serviceProviderData).alldata;
                    return SizedBox(child: listViewItemWidget(all));
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Footer()
        ],
      )),
    );
  }

  listViewItemWidget(List<AllServiceFetch> all) {
    return !Responsive.isDesktop(context)
        ? Column(
            children: List.generate(
            all.length,
            (index) => cardWidget(all, index),
          ))
        : Wrap(
            spacing: 18,
            runSpacing: 15,
            children: List.generate(
              all.length,
              (index) => cardWidget(all, index),
            ),
          );
  }

  InkWell cardWidget(List<AllServiceFetch> all, int index) {
    return InkWell(
      onTap: () async {
        if (kIsWeb) {
          context.vRouter.to(
            '/hindustaan-jobs/service-details-screen/${all[index].id}',
          );
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailsScreen(
                allservice: all[index],
              ),
            ),
          );
        }
        ref.read(serviceProviderData).getAlldataservice();
      },
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.all(0.0)
            : EdgeInsets.all(10.0),
        child: Container(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth!
              : Sizeconfig.screenWidth! / 4.5,
          color: MyAppColor.greynormal,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: MyAppColor.grayplane,
                    child: Image.asset('assets/menus.png'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    //for image
                    Column(
                      children: List.generate(
                        all[index].serviceImages!.length > 1
                            ? 1
                            : all[index].serviceImages!.length,
                        (i) => Image.network(
                            currentUrl(
                              all[index].serviceImages![i].image.toString(),
                            ),
                            // all[index].serviceImages![i].image.toString(),
                            height: 100,
                            width: 100),
                      ),

                      //  [
                      //   Image.asset('assets/photo.png', height: 100, width: 100)
                      // ],
                    ),
                    const SizedBox(width: 8), //for rating and all
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/maintenance_grey.png'),
                              ratingBar(),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(all[index].serviceName.toString(),
                                    overflow: TextOverflow.clip,
                                    style: Responsive.isDesktop(context)
                                        ? blackDarkSemiBold16
                                        : blackDarkSemiBold16),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Wrap(
                                children: [
                                  Text('Status: ', style: blackMedium14),
                                  Text(
                                    all[index].serviceStatus == 'Y'
                                        ? 'Active'
                                        : 'Deactive',
                                    style: greenMedium14,
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: List.generate(
                        all[index].serviceCategories!.length,
                        (i) => container(
                            text: all[index].serviceCategories![i].name,
                            image: 'assets/setting.png',
                            width: 60),
                      ),
                    ),
                    Text("₹ ${all[index].serviceCharge.toString()}",
                        overflow: TextOverflow.clip, style: BlackDarkSb18())
                  ],
                ),
              ),
              // const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Wrap(
                        children: [
                          Image.asset('assets/location_icon.png'),
                          Text(
                            '${all[index].user!.city!.name.toString()}',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb10()
                                : blackDarkSb10(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${all[index].user!.state!.name.toString()}',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb10()
                                : blackDarkSb10(),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             ViewServiceRequestDetailsScreen(
                        //               flag: 'REJECT',
                        //             )));
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'view ',
                            style: !Responsive.isDesktop(context)
                                ? orangeDarkSb10()
                                : orangeDarkSb10(),
                          ),
                          Image.asset(
                            'assets/forward_arrow.png',
                            color: MyAppColor.orangedark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget container({text, double? width, image}) {
    return Parallelogram(
      cutLength: 5.0,
      edge: Edge.RIGHT,
      child: Container(
        padding: EdgeInsets.all(6),
        color: MyAppColor.greylight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(image),
                  )
                : SizedBox(),
            Center(child: Text(text, style: whiteBoldGalano12)),
          ],
        ),
      ),
    );
  }

  ratingBar() {
    return RatingBar.builder(
      initialRating: 0,
      ignoreGestures: true,
      minRating: 0,
      direction: Axis.horizontal,
      unratedColor: MyAppColor.white,
      itemCount: 5,
      itemSize: 18.0,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {},
      updateOnDrag: false,
    );
  }

  rowTitleMyServiceWidget(isUserSubscribed) {
    return Consumer(builder: (context, ref, child) {
      List<Branch> service = ref.watch(serviceProviderData).serviceget;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: Responsive.isDesktop(context)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: Responsive.isDesktop(context) ? 8 : 0),
            child: Text(LabelString.myServices, style: black16),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: MyAppColor.logoBlue,
                  ),
                  onPressed: () {
                    if (isUserSubscribed) {
                      if (service.isEmpty) {
                        return showSnack(
                            context: context,
                            msg:
                                'Please add your branch first before adding services',
                            type: 'error');
                      }
                      if (kIsWeb) {
                        context.vRouter
                            .to("/home-service-provider/add-service");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAServiceScreen()));
                      }
                    } else {
                      alertBox(context,
                          "You are not subscribed user please click on yes if want to subscribe",
                          title: 'Subscribe Now',
                          route: SubscriptionPlans(isLimitPlans: false));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4, left: 4),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.add,
                            color: MyAppColor.white,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            LabelString.addaService,
                            style: whiteR14(),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      );
    });
  }
}
