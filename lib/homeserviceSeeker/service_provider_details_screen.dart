// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/model/provider_model.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/services/api_services/service_seeker_services.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/drop_down_widget/text_drop_down_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:vrouter/vrouter.dart';

import '../candidate/header/back_text_widget.dart';
import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../widget/common_app_bar_widget.dart';

class ServiceProviderDetailsScreen extends StatefulWidget {
  String id;
  ServiceProviderDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ServiceProviderDetailsScreen> createState() =>
      _ServiceProviderDetailsScreenState();
}

class _ServiceProviderDetailsScreenState
    extends State<ServiceProviderDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServiceProvierDetails();
  }

  ServiceProvider? serviceProvider;

  getServiceProvierDetails({sortBy}) async {
    serviceProvider =
        await getServiceProviderById(context, widget.id, sortBy: sortBy);
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);

    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: !kIsWeb
          ? PreferredSize(
              child:
                  BackWithText(text: "HOME (SERVICE-SEEKER) /PROVIDER DETAILS"),
              preferredSize: Size.fromHeight(50))
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(Responsive.isDesktop(context) ? 150 : 150),
              child: CommomAppBar(
                drawerKey: _drawerKey,
                back: "HOME (SERVICE-SEEKER) /PROVIDER DETAILS",
              ),
            ),
      body: Responsive.isDesktop(context)
          ? serviceProvider == null
              ? loaderIndicator(context)
              : SizedBox(
                  height: Sizeconfig.screenHeight! - 150,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 48.0),
                                  child: Container(
                                    child: detailsPart(),
                                  ),
                                )),
                            Expanded(
                                flex: 7,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'SERVICES PROVIDED BY THE PROVIDER'),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              const Icon(Icons.arrow_drop_down),
                                              Text(LabelString.sortByRelevance,
                                                  style: black12)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 2,
                                      runSpacing: 10,
                                      children: [
                                        for (int i = 0;
                                            i <
                                                serviceProvider!
                                                    .services!.length;
                                            i++)
                                          listItem(
                                              serviceProvider!.services![i])
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Footer()
                    ],
                  ),
                )
          : Container(
              child: ListView(
                children: [
                  serviceProvider != null
                      ? detailsPart()
                      : loaderIndicator(context),
                  Footer()
                ],
              ),
            ),
    );
  }

  detailsPart() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            color: MyAppColor.greyDark,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('SERVICE PROVIDER DETAILS'),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              color: MyAppColor.greynormal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Image.network(
                        currentUrl(serviceProvider!.image),
                      ),
                    ),
                  ),
                  Text(
                    '${serviceProvider!.name}',
                    style: blackdarkM16,
                  ),
                  Text(
                    '${serviceProvider!.mobile}',
                    style: blackdarkM16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      color: MyAppColor.greyDark,
                      width: MediaQuery.of(context).size.width / 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Branch Name',
                              style: appleColorR10,
                            ),
                            Text(
                              'Bharat Service Co.',
                              style: blackMedium14,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      color: MyAppColor.greyDark,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Address',
                              style: appleColorR10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Image.asset('assets/orange_lock_small.png'),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    '${locationShow(city: serviceProvider!.city, state: serviceProvider!.state)}',
                                    style: blackMedium14,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //
                  subscribeToCall()
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          if (!Responsive.isDesktop(context))
            serviceprovidedByProviderMobileview()
        ],
      ),
    );
  }

  subscribeToCall() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: InkWell(
        onTap: () async {
          await FlutterPhoneDirectCaller.callNumber(serviceProvider!.mobile!);
        },
        child: Container(
          color: MyAppColor.greylight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Call Provider", style: white16)],
            ),
          ),
        ),
      ),
    );
  }

  String sortBy = "Sort by Relevance";

  serviceprovidedByProviderMobileview() {
    return Container(
        color: MyAppColor.greynormal,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('SERVICES PROVIDED BY THE PROVIDER'),
          ),
          AppDropdownInput(
            hintText: 'Sort by Relevance',
            options: [
              'Ascending',
              'Descending',
            ],
            value: sortBy,
            changed: (String value) async {
              sortBy = value;
              setState(() {});
              if (sortBy != "Sort by Relevance") {
                await getServiceProvierDetails(sortBy: value);
              }
            },
            getLabel: (String value) => value,
          ),
          Column(
            children: List.generate(
                serviceProvider!.services!.length,
                (index) => Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: listItem(serviceProvider!.services![index]),
                    )),
          )
        ]));
  }

  listItem(Services services) {
    return Container(
      color: MyAppColor.greyDark,
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 5
          : Sizeconfig.screenWidth,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                //for image
                if (services.serviceImages != null &&
                    services.serviceImages!.isNotEmpty)
                  Column(
                    children: [
                      Image.network(
                          currentUrl(services.serviceImages!.first.image),
                          height: 100,
                          width: 100)
                    ],
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
                          // Image.asset('assets/orange_lock_small.png'),
                          ratingBar()
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text('${services.serviceName}',
                                overflow: TextOverflow.clip,
                                style: Responsive.isDesktop(context)
                                    ? blackDarkSemiBold16
                                    : blackDarkSemiBold16),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${serviceProvider!.name}',
                            style: appleColorM12,
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    if (services.serviceCategories!.isNotEmpty)
                      HashTag(
                        text:
                            '${services.serviceCategories!.first.categoryName}',
                      ),
                    HashTag(
                      text: '...',
                    ),
                  ],
                ),
                Text('₹ ${services.serviceCharge}',
                    overflow: TextOverflow.clip, style: BlackDarkSb18())
              ],
            ),
          ),
          // const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Wrap(
                    children: [
                      Image.asset('assets/location_icon.png'),
                      Text(
                        '${locationShow(city: serviceProvider!.city, state: serviceProvider!.state)}',
                        style: !Responsive.isDesktop(context)
                            ? blackDarkSb10()
                            : blackDarkSb10(),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (kIsWeb) {
                      context.vRouter.to(
                          "/home-service-seeker/request-service/${services.id.toString()}/${services.serviceProviderStatus}/${services.serviceRequestId}");
                    }
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Book a service ',
                          style: !Responsive.isDesktop(context)
                              ? orangeDarkSb10()
                              : orangeDarkSb10()),
                      Image.asset(
                        'assets/forward_arrow.png',
                        color: MyAppColor.orangedark,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget container({text, double? width, image}) {
    return Parallelogram(
      cutLength: 5.0,
      edge: Edge.RIGHT,
      child: Container(
        color: MyAppColor.greylight,
        width: width,
        height: 25.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(image),
                  )
                : const SizedBox(),
            Center(child: Text(text, style: whiteBoldGalano12)),
          ],
        ),
      ),
    );
  }

  ratingBar() {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: MyAppColor.white,
      itemCount: 5,
      itemSize: 18.0,
      //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          //   _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }
}
