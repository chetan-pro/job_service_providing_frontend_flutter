// ignore_for_file: camel_case_types

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/model/experience_filter_model.dart';
import 'package:hindustan_job/candidate/model/provider_model.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/topjobindustries.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/homeserviceSeeker/home_service_view_screen.dart';
import 'package:hindustan_job/homeserviceSeeker/search_home_service_list_screen.dart';
import 'package:hindustan_job/homeserviceSeeker/service_provider_details_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/ServicesRequests/view_service_request_details_screen.dart';
import 'package:hindustan_job/services/api_services/seeker_service_search.dart';
import 'package:hindustan_job/services/api_services/service_seeker_services.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:vrouter/vrouter.dart';

import '../candidate/dropdown/dropdown_list.dart';
import '../candidate/dropdown/dropdown_string.dart';
import '../candidate/model/serviceProviderModal/alldata_get_modal.dart';
import '../candidate/model/service_categories_model.dart';
import '../services/api_service_serviceProvider/category.dart';
import '../services/auth/auth.dart';
import '../services/services_constant/constant.dart';
import '../widget/drop_down_widget/drop_down_dynamic_widget.dart';

class SeekerHomeTab extends StatefulWidget {
  bool isUserSubscribed;
  SeekerHomeTab({Key? key, required this.isUserSubscribed}) : super(key: key);
  static const String route = '';

  @override
  State<SeekerHomeTab> createState() => _SeekerHomeTabState();
}

class _SeekerHomeTabState extends State<SeekerHomeTab> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  TextEditingController searchController = TextEditingController();
  List<ExperienceFilter> serviceChargeList = [];
  ExperienceFilter? selectedServiceChargeList;

  @override
  void initState() {
    super.initState();
    serviceChargeList =
        ExperienceFilterModel.fromJson(ListDropdown.serviceChargeList)
            .experienceFilter!;
    getServiceCategoryList();
    fetchcatogary();
  }

  List<ServiceCountCategory> serviceCountCategoryList = [];
  List<ServiceCategories> catogaries = [];
  ServiceCategories? selectedCategory;

  fetchcatogary() async {
    catogaries = await categoryData(context);
    setState(() {});
  }

  getServiceCategoryList() async {
    serviceCountCategoryList = await getCategoryCountInfo();
    setState(() {});
  }

  int group = 1;
  List cardList = [
    for (var i = 0; i < 4; i++) const TopJobIndustries(),
  ];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: !Responsive.isDesktop(context)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      if (!Responsive.isDesktop(context))
                        SeekerSearch(isUserSubscribed: true, isNavigater: true),
                      Padding(
                        padding: const EdgeInsets.only(top: 34, bottom: 20),
                        child: Text(
                          "LATEST HOME-SERVICES FOR YOU",
                          style: blackDarkR16,
                        ),
                      ),
                      Consumer(builder: (context, ref, child) {
                        List<Services> latestServices =
                            ref.watch(serviceSeeker).lastestServices;
                        return LatestJObssSlider(
                          cardList: latestServices,
                        );
                      }),
                      viewAllOutLinedButton(styles, false),
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        'TOP HOME-SERVICE CATEGORIES',
                        style: blackDarkR16,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          serviceCountCategoryList.isEmpty
                              ? loaderIndicator(context)
                              : CarouselSlider.builder(
                                  itemCount: serviceCountCategoryList.length,
                                  itemBuilder: (context, index, _) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: TopHomeServiceCategories(
                                        serviceCountCategory:
                                            serviceCountCategoryList[index],
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    enableInfiniteScroll: true,
                                    height: 150,
                                    aspectRatio: 3,
                                    autoPlay: true,
                                    onPageChanged: (index, _) {
                                      setState(
                                        () {
                                          current = index;
                                        },
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Text(
                          'HIGHEST RATED SERVICE PROVIDERS\nNEAR YOU (@${getCapitalizeString(userData!.city!.name)})',
                          style: blackDarkR16,
                          textAlign: TextAlign.center),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer(builder: (context, ref, child) {
                        List<ServiceProvider> serviceProviders =
                            ref.watch(serviceSeeker).serviceProvider;
                        return HighestSlider(
                          serviceProviders: serviceProviders,
                        );
                        //stop
                      }),
                      viewAllOutLinedButton(styles, true),
                      const SizedBox(
                        height: 55,
                      ),
                      Text(
                        'LATEST SERVICE PROVIDERS\nNEAR YOU (@${userData!.city!.name})',
                        textAlign: TextAlign.center,
                        style: blackDarkR16,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Consumer(builder: (context, ref, child) {
                        List<ServiceProvider> serviceProviders =
                            ref.watch(serviceSeeker).serviceProvider;
                        return HighestSlider(
                          serviceProviders: serviceProviders,
                        );
                      }),
                      const SizedBox(
                        height: 8,
                      ),
                      viewAllOutLinedButton(styles, true),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                  Footer(),
                  Container(
                    alignment: Alignment.center,
                    color: MyAppColor.normalblack,
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      Mystring.hackerkernel,
                      style: Mytheme.lightTheme(context)
                          .textTheme
                          .headline1!
                          .copyWith(color: MyAppColor.white),
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: Responsive.isMobile(context) ? 10 : 60.0,
                      left: Responsive.isMobile(context) ? 10 : 60),
                  child: Column(
                    children: [
                      SizedBox(
                          height: Responsive.isDesktop(context) ? 20.0 : 25),
                      Container(
                        color: MyAppColor.greynormal,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RadioButton(
                                text: 'Search Home-Services',
                                groupValue: group,
                                onChanged: (value) => setState(() {
                                  group = value;
                                }),
                                value: 1,
                              ),
                              RadioButton(
                                text: 'Search Home-Service Providers',
                                groupValue: group,
                                onChanged: (value) => setState(() {
                                  group = value;
                                }),
                                value: 2,
                              ),
                              const Spacer(),
                              SizedBox(
                                width: Sizeconfig.screenWidth! / 7,
                                child: TextFormFieldWidget(
                                  text: 'Search Services here..',
                                  type: TextInputType.multiline,
                                  control: searchController,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              selectCategoryDropdown(),
                              const SizedBox(
                                width: 10,
                              ),
                              serviceChargeDropdown(),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  var carryData = {
                                    "categoryIds": selectedCategory != null
                                        ? selectedCategory!.id.toString()
                                        : '',
                                    "priceRange[0]":
                                        selectedServiceChargeList != null
                                            ? selectedServiceChargeList!.from
                                                .toString()
                                            : '',
                                    "priceRange[1]":
                                        selectedServiceChargeList != null
                                            ? selectedServiceChargeList!.to
                                                .toString()
                                            : '',
                                  };
                                  carryData[group == 2
                                          ? 'ServiceProviderName'
                                          : 'service_name'] =
                                      searchController.text.trim();
                                  context.vRouter.to(
                                      "/home-service-seeker/search-service/false",
                                      queryParameters: carryData);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4.0)),
                                        color: MyAppColor.orangelight),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.search,
                                        size: 17,
                                        color: MyAppColor.white,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child:
                            _jobViewAll(text: 'LATEST HOME-SERVICES FOR YOU'),
                      ),
                      Consumer(builder: (context, ref, child) {
                        List<Services> latestServices =
                            ref.watch(serviceSeeker).lastestServices;

                        return Row(
                            children: List.generate(
                                latestServices.length > 4
                                    ? 4
                                    : latestServices.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child:
                                          latestHomeServiceListViewItemWidget(
                                              latestServices[index]),
                                    )));
                      }),
                      SizedBox(height: Sizeconfig.screenHeight! / 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: _jobViewAll(text: 'TOP HOME-SERVICE CATEGORIES'),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            serviceCountCategoryList.length,
                            (index) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: TopHomeServiceCategory(
                                  serviceCountCategory:
                                      serviceCountCategoryList[index],
                                )),
                          )),
                      SizedBox(height: Sizeconfig.screenHeight! / 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: _jobViewAll(
                            text: 'HIGHEST RATED HOME-SERVICES NEAR YOU'),
                      ),
                      Consumer(builder: (context, ref, child) {
                        List<ServiceProvider> serviceProviders =
                            ref.watch(serviceSeeker).serviceProvider;
                        return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              serviceProviders.length > 4
                                  ? 4
                                  : serviceProviders.length,
                              (index) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: highestRatedServiceproviderContainer(
                                      serviceProviders[index])),
                            ));
                      }),
                      SizedBox(height: Sizeconfig.screenHeight! / 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: _jobViewAll(
                            text: 'LATEST SERVICE PROVIDERS NEAR YOU ',
                            isProvider: true),
                      ),
                      Consumer(builder: (context, ref, child) {
                        List<ServiceProvider> serviceProviders =
                            ref.watch(serviceSeeker).serviceProvider;
                        return Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              serviceProviders.length > 4
                                  ? 4
                                  : serviceProviders.length,
                              (index) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: highestRatedServiceproviderContainer(
                                      serviceProviders[index])),
                            ));
                      }),
                    ],
                  ),
                ),
                SizedBox(height: Sizeconfig.screenHeight! / 15),
                Footer(),
                Container(
                  alignment: Alignment.center,
                  color: MyAppColor.normalblack,
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    Mystring.hackerkernel,
                    style: Mytheme.lightTheme(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: MyAppColor.white),
                  ),
                ),
              ],
            ),
    );
  }

  viewAllOutLinedButton(styles, isProvider) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchHomeServicesListScreen(
                      isProvider: isProvider,
                    )));
      },
      child: Container(
        alignment: Alignment.center,
        width: Sizeconfig.screenWidth! / 3,
        child: Text("VIEW ALL", style: blackRegular12),
      ),
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
    );
  }

  orangeCircleDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(cardList, (index, url) {
        return Container(
          width: 4.0,
          height: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: current == index ? MyAppColor.orangedark : Colors.grey,
          ),
        );
      }),
    );
  }

  latestHomeServiceListViewItemWidget(Services service) {
    return InkWell(
      onTap: () {
        if (kIsWeb) {
          context.vRouter.to(
              "/home-service-seeker/request-service/${service.id.toString()}/${service.serviceProviderStatus}/${service.serviceRequestId}");
        }
      },
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(0.0)
            : const EdgeInsets.all(10.0),
        child: Container(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth!
              : Sizeconfig.screenWidth! / 4.5,
          color: MyAppColor.greynormal,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Image.network(
                            currentUrl(service.serviceImages!.first.image),
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
                              Wrap(
                                children: [
                                  Image.asset('assets/maintenance_grey.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              ratingBar(rate: service.mean)
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text('${service.serviceName}',
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
                                '${service.user!.name}',
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
                        if (service.serviceCategories!.isNotEmpty)
                          HashTag(
                            text:
                                '${service.serviceCategories!.first.categoryName}',
                          ),
                        HashTag(
                          text: '...',
                        ),
                      ],
                    ),
                    Text('₹${service.serviceCharge}',
                        overflow: TextOverflow.clip, style: BlackDarkSb18())
                  ],
                ),
              ),
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
                            '${locationShow(state: service.user!.state, city: service.user!.city)}',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb10()
                                : blackDarkSb10(),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
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
                    )
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

  highestRatedServiceproviderContainer(ServiceProvider serviceProvider) {
    return InkWell(
      onTap: () {
        if (kIsWeb) {
          context.vRouter.to(
              "/home-service-seeker/service-provider-details-screen/${serviceProvider.id.toString()}");
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ServiceProviderDetailsScreen(
                        id: serviceProvider.id.toString(),
                      )));
        }
      },
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(0.0)
            : const EdgeInsets.all(10.0),
        child: Container(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth!
              : Sizeconfig.screenWidth! / 4.5,
          color: MyAppColor.greynormal,
          child: Column(
            children: [
              //menu row
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //for image
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image.network(
                              currentUrl(serviceProvider.image),
                              height: 50,
                              width: 50,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/profileIcon.png',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ))
                      ],
                    ),
                    const SizedBox(width: 8), //for rating and all
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ///   Image.asset('assets/maintenance_grey.png'),
                              ratingBar()
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text('${serviceProvider.name}',
                                    overflow: TextOverflow.clip,
                                    style: Responsive.isDesktop(context)
                                        ? blackDarkSemiBold16
                                        : blackDarkSemiBold16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${serviceProvider.email}',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        container(
                            text: 'Service Provider',
                            image: 'assets/setting.png',
                            width: 150),
                        container(text: '...', width: 30),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Wrap(
                        children: [
                          Image.asset('assets/location_icon.png'),
                          Text(
                            '${locationShow(state: serviceProvider.state, city: serviceProvider.city)}',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb10()
                                : blackDarkSb10(),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
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
                    )
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

  ratingBar({rate}) {
    return RatingBar.builder(
      initialRating: rate ?? 0,
      minRating: rate ?? 0,
      maxRating: rate ?? 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      ignoreGestures: true,
      unratedColor: MyAppColor.white,
      itemCount: 5,
      itemSize: 18.0,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {},
    );
  }

  TextEditingController searchServicesHereController = TextEditingController();
  Widget searchSrviceHereTextField({label, controller}) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: MyAppColor.white,
          borderRadius: const BorderRadius.all(const Radius.circular(5))),
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: searchServicesHereController,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10, bottom: 5),
            border: InputBorder.none,
            hintText: label,
            hintStyle: blackMedium14),
      ),
    );
  }

  selectCategoryDropdown() {
    return DynamicDropDownListOfFields(
        label: DropdownString.category,
        dropDownList: catogaries,
        selectingValue: selectedCategory,
        setValue: (value) {
          if (DropdownString.category != value) {
            selectedCategory =
                catogaries.firstWhere((element) => element.name == value);
          }
        });
  }

  serviceChargeDropdown() {
    return DynamicDropDownListOfFields(
        label: "Service Charge",
        dropDownList: serviceChargeList,
        selectingValue: selectedServiceChargeList,
        setValue: (value) {
          if ('Service Charge' != value) {
            selectedServiceChargeList = serviceChargeList
                .firstWhere((element) => element.name == value);
          }
        });
  }

  subscribeToPremiumConatiner() {
    return Center(
      child: Padding(
        padding: !Responsive.isDesktop(context)
            ? const EdgeInsets.symmetric(horizontal: 10.0)
            : const EdgeInsets.only(left: 0.0),
        child: Container(
            color: MyAppColor.pinkishOrange,
            height: Responsive.isDesktop(context) ? 60 : 80,
            width: Responsive.isDesktop(context)
                ? 750
                : MediaQuery.of(context).size.width,
            child: Padding(
              padding: !Responsive.isDesktop(context)
                  ? const EdgeInsets.symmetric(horizontal: 10.0)
                  : const EdgeInsets.only(left: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Image.asset(
                      'assets/orange_diamond_small.png',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Responsive.isDesktop(context) ? 0 : 10.0),
                    child: Text(
                        Responsive.isDesktop(context)
                            ? 'Subscribe to our Premium Plans starting from ₹ 99 to unlock all Home-Service Providers in your city.'
                            : '  Subscribe to our Premium Plans\n  starting from ₹ 99 to unlock all\n  Home-Service Providers in your city.',
                        style: whiteM12()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Responsive.isDesktop(context) ? 48.0 : 75),
                    child: Image.asset('assets/mask.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Responsive.isDesktop(context) ? 0.0 : 25),
                    child: Icon(
                      Icons.arrow_forward,
                      color: MyAppColor.white,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget _jobViewAll({text, isProvider}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          _viewAll(isProvider ?? false),
        ],
      ),
    );
  }

  Widget _viewAll(isProvider) {
    return OutlinedButton(
      onPressed: () {
        context.vRouter.to("/home-service-seeker/search-service/$isProvider");
      },
      child: Container(
          alignment: Alignment.center,
          width: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('VIEW ALL', style: blackRegular12),
          )),
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
    );
  }
}

class LatestJObssSlider extends StatefulWidget {
  List cardList;
  String? cardState;
  bool isShortListed;
  LatestJObssSlider(
      {Key? key,
      required this.cardList,
      this.cardState,
      this.isShortListed = false})
      : super(key: key);
  @override
  State<LatestJObssSlider> createState() => _LatestJObssSliderState();
}

class _LatestJObssSliderState extends State<LatestJObssSlider> {
  int currentLate = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    int len = list.length > 4 ? 4 : list.length;
    for (var i = 0; i < len; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          itemCount: widget.cardList.length > 4 ? 4 : widget.cardList.length,
          itemBuilder: (context, index, _) {
            return latestHomeServiceListViewItemWidget(
                service: widget.cardList[index]);
          },
          options: CarouselOptions(
            viewportFraction: 2.0,
            enableInfiniteScroll: false,
            height: Responsive.isDesktop(context)
                ? Sizeconfig.screenHeight! / 4
                : Sizeconfig.screenHeight! / 2.8,
            aspectRatio: 3,
            autoPlay: true,
            onPageChanged: (index, _) {
              setState(
                () {
                  currentLate = index;
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(widget.cardList, (index, url) {
            return Container(
              width: 4.0,
              height: 4.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    currentLate == index ? MyAppColor.orangedark : Colors.grey,
              ),
            );
          }),
        ),
      ],
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

  ratingBar(rating) {
    return RatingBar.builder(
      initialRating: double.parse((rating ?? "0").toString()),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: MyAppColor.white,
      itemCount: 5,
      itemSize: 18.0,
      ignoreGestures: true,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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

  latestHomeServiceListViewItemWidget({Services? service}) {
    return InkWell(
      onTap: () {
        if (kIsWeb) {
          context.vRouter.to(
              "/home-service-seeker/request-service/${service!.id.toString()}/${service.serviceProviderStatus}/${service.serviceRequestId}");
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeServiceViewScreen(
                        serviceId: service!.id.toString(),
                      )));
        }
      },
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(0.0)
            : const EdgeInsets.all(10.0),
        child: Container(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth!
              : Sizeconfig.screenWidth! / 4.5,
          color: MyAppColor.greynormal,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    //for image
                    if (service!.serviceImages != null)
                      Column(
                        children: [
                          service.serviceImages!.isEmpty
                              ? Image.network(defaultImage,
                                  height: 100, width: 100, fit: BoxFit.cover)
                              : Image.network(
                                  currentUrl(
                                      service.serviceImages!.first.image),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover, errorBuilder:
                                      (BuildContext context, Object exception,
                                          StackTrace? stackTrace) {
                                  return Image.network(defaultImage,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover);
                                })
                        ],
                      ),
                    const SizedBox(width: 8),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                children: [
                                  Image.asset('assets/maintenance_grey.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  // Image.asset('assets/orange_lock_small.png'),
                                ],
                              ),
                              ratingBar(service.mean)
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text('${service.serviceName}',
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
                                '${service.user?.name}',
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
                        container(
                            text: 'AC', image: 'assets/setting.png', width: 60),
                        container(
                            text: 'Electrician',
                            image: 'assets/setting.png',
                            width: 110),
                        container(text: '...', width: 30),
                      ],
                    ),
                    Text('${service.serviceCharge}',
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
                            '${checkUserLocationValue(service.user?.city)}, ${checkUserLocationValue(service.user?.state)} ',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb10()
                                : blackDarkSb10(),
                          ),
                        ],
                      ),
                    ),
                    exploreWidget(service.id!)
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

  ratingAnaALl(rating) {
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: [
                  Image.asset('assets/maintenance_grey.png'),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset('assets/orange_lock_small.png'),
                ],
              ),
              ratingBar(rating)
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Text('Air Conditioning Fitting,\nService & Repair',
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
                'Bharat Services Co.',
                style: appleColorM12,
              )
            ],
          )
        ],
      ),
    );
  }

  acElectricianSEttingWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            children: [
              container(text: 'AC', image: 'assets/setting.png', width: 60),
              container(
                  text: 'Electrician', image: 'assets/setting.png', width: 110),
              container(text: '...', width: 30),
            ],
          ),
          Text('599.0', overflow: TextOverflow.clip, style: BlackDarkSb18())
        ],
      ),
    );
  }

  locationWithEXploreWidget(id) {
    return Padding(
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
                  'Bhopal, Madhya Pradesh ',
                  style: !Responsive.isDesktop(context)
                      ? blackDarkSb10()
                      : blackDarkSb10(),
                ),
              ],
            ),
          ),
          exploreWidget(id)
        ],
      ),
    );
  }

  exploreWidget(id) {
    return InkWell(
      onTap: () {
        if (kIsWeb) {
          context.vRouter
              .to("/home-service-seeker/request-service/${id.toString()}");
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeServiceViewScreen(serviceId: id.toString())));
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
    );
  }
}

//

class JobCard extends StatelessWidget {
  String? cardState;
  bool isShortListed;
  bool applied;
  bool isReceivedOfferLetter;
  JobCard(
      {Key? key,
      this.cardState,
      this.isShortListed = false,
      this.applied = false,
      this.isReceivedOfferLetter = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Card(
      child: Container(
          margin: EdgeInsets.only(
            left: Responsive.isDesktop(context) ? 13 : 00,
          ),
          width: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width / 4.7
              : 500,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isShortListed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3),
                      // width: Responsive.isMobile(context)
                      //     ? Sizeconfig.screenWidth! / 3
                      //     : null,
                      color: MyAppColor.grayplane,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/shortlist-image.png',
                            height: 18,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'You are Short-Listed',
                            style: greylightBoldGalano10,
                          ),
                        ],
                      ),
                    ),
                  if (isReceivedOfferLetter)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3),

                      // width: Responsive.isMobile(context)
                      //     ? Sizeconfig.screenWidth! / 2.5
                      //     : null,
                      // height: 20,
                      color: MyAppColor.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/offer-letter-image.png',
                            height: 18,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            'You Received Offer Letter',
                            style: styles.copyWith(
                                fontSize: 10,
                                color: MyAppColor.backgroundColor),
                          ),
                        ],
                      ),
                    ),
                  if (applied)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3),
                      // width: Responsive.isMobile(context)
                      //     ? Sizeconfig.screenWidth! / 3
                      //     : null,
                      color: MyAppColor.grayplane,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/applied-succes-image.png',
                            height: 18,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'You Applied',
                            style: greylightBoldGalano10,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    width: 2,
                  ),
                  Container(
                    color: cardState != null && cardState == CardState.fav
                        ? MyAppColor.pink
                        : MyAppColor.grayplane,
                    child: ImageIcon(
                      const AssetImage('assets/heart.png'),
                      size: 24,
                      color: MyAppColor.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 20 : 10,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageIcon(
                        const AssetImage('assets/bag_icn.png'),
                        size: 18,
                        color: MyAppColor.applecolor,
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 6 : 8,
                      ),
                      Text('Chief Motion Designer & Animation \nEngineer ',
                          style: blackDarkSb16()),
                      !Responsive.isDesktop(context)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 5),
                              child: Text('Lakshaya Corparation',
                                  style: companyNameM14()),
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: MyAppColor.orangedark,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Subscribe to Unlock Company info',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: MyAppColor.orangedark),
                                )
                              ],
                            ),
                      Row(
                        children: [
                          Container(
                            padding: paddingAllver5,
                            alignment: Alignment.center,
                            color: MyAppColor.greylight,
                            child: Center(
                              child: Responsive.isMobile(context)
                                  ? Text(
                                      "# Design",
                                      style: whiteM12(),
                                    )
                                  : Text(
                                      "# Design",
                                      style: whiteM12(),
                                    ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 5),
                            color: MyAppColor.greylight,
                            child: Center(
                              child: Text(
                                "# Animation",
                                style: styles.copyWith(
                                    fontSize: 13,
                                    color: MyAppColor.backgroundColor),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 3),
                            padding: paddingAllver5,
                            color: MyAppColor.greylight,
                            child: Center(
                              child: Text(
                                "# Graphics",
                                style: styles.copyWith(
                                    fontSize: 13,
                                    color: MyAppColor.backgroundColor),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 0),
                            padding: paddingAllver5,
                            color: MyAppColor.greylight,
                            child: Center(
                              child: Text(
                                "..",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MyAppColor.white,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 12,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text('Bhopal Madhaya Pradesh',
                                    style: blackDarkSb14()),
                              ],
                            ),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // verticalDirection: VerticalDirection.down,
                              children: [
                                Row(
                                  children: [
                                    Text('Book a service',
                                        style: orangeDarkSb12()),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, left: 3),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: MyAppColor.orangedark,
                                    size: !Responsive.isDesktop(context)
                                        ? 24
                                        : 15,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

//

class LatestJob extends StatefulWidget {
  LatestJob({
    Key? key,
  }) : super(key: key);

  @override
  State<LatestJob> createState() => _LatestJobState();
}

class _LatestJobState extends State<LatestJob> {
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Container(
        decoration: BoxDecoration(
          color: MyAppColor.greynormal,
        ),
        child: Column(
          crossAxisAlignment: !Responsive.isDesktop(context)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  color: MyAppColor.backgray,
                  child: new Image.asset(
                    'assets/heart.png',
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 7 : 6,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isMobile(context) ? 20 : 10,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/bag_icn.png',
                      width: 15,
                    ),

                    /*Icon(
                      Icons.wallet_travel,
                      color: Colors.black,
                      size: 15,
                    ),*/
                    SizedBox(
                      height: !Responsive.isDesktop(context) ? 5 : 0,
                    ),
                    Text(
                      'Chief Motion Designer & Animation \nEngineer ',
                      style: !Responsive.isDesktop(context)
                          ? blackDarkSb16()
                          : blackDarkSb14(),
                    ),
                    !Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 6),
                            child: Text('Lakshaya Corparation',
                                style: companyNameM14()),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(bottom: 11.0, top: 3),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: MyAppColor.lightYellow,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Subscribe to Unlock Company info',
                                  style: lightYellowM12desktop,
                                )
                              ],
                            ),
                          ),
                    Row(
                      children: [
                        Container(
                          padding: !Responsive.isDesktop(context)
                              ? const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10.5)
                              : const EdgeInsets.all(3),
                          alignment: Alignment.center,
                          color: MyAppColor.greylight,
                          child: Center(
                              child: Text(
                            "# Design",
                            style: !Responsive.isDesktop(context)
                                ? whiteM12()
                                : whiteM10(),
                          )),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 3),
                          padding: !Responsive.isDesktop(context)
                              ? const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10.5)
                              : const EdgeInsets.all(3),
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# Animation",
                              style: !Responsive.isDesktop(context)
                                  ? whiteM12()
                                  : whiteM10(),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 3),
                          padding: !Responsive.isDesktop(context)
                              ? const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10)
                              : const EdgeInsets.all(3),
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# Graphics",
                              style: !Responsive.isDesktop(context)
                                  ? whiteM12()
                                  : whiteM10(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 0),
                          padding: !Responsive.isDesktop(context)
                              ? const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10.5)
                              : const EdgeInsets.all(3),
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "..",
                              style: !Responsive.isDesktop(context)
                                  ? whiteM12()
                                  : whiteM10(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical:
                              !Responsive.isDesktop(context) ? 10.5 : 10.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text('Bhopal Madhaya Pradesh',
                                  style: !Responsive.isDesktop(context)
                                      ? blackDarkSb12()
                                      : blackDarkSb9()),
                            ],
                          ),
                          if (Responsive.isDesktop(context))
                            SizedBox(
                              width: Sizeconfig.screenWidth! / 30,
                            ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // verticalDirection: VerticalDirection.down,
                            children: [
                              Row(
                                children: [
                                  Text('Book a service',
                                      style: orangeDarkSb9()),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, left: 3),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: MyAppColor.orangedark,
                                  size:
                                      !Responsive.isDesktop(context) ? 24 : 20,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

//

//

class TopHomeServiceCategory extends StatelessWidget {
  ServiceCountCategory serviceCountCategory;
  TopHomeServiceCategory({Key? key, required this.serviceCountCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Container(
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 6 : null,
      decoration: const BoxDecoration(
        // color: Colors.red,
        image: DecorationImage(
          image: NetworkImage(
              'https://static1.makeuseofimages.com/wordpress/wp-content/uploads/2017/02/Photoshop-Replace-Background-Featured.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.8),
          ],
        )),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'HOME-SERVICE CATEGORY',
                style: whiteRegularGalano10,
              ),
              Text(
                '${serviceCountCategory.serviceCategory != null ? serviceCountCategory.serviceCategory!.categoryName : ''}',
                style: whiteSemiBoldGalano18,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${serviceCountCategory.categoryCount} services',
                    style: whiteRegularGalano12,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Book a service',
                        style: whiteBoldGalano12,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: MyAppColor.white,
                        size: Responsive.isMobile(context) ? 16 : 15,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//

class SearchTextfieldWidget extends StatelessWidget {
  final String? text;
  final TextEditingController? control;
  Function? onChanged;
  TextInputType? inputType;
  final TextStyle? styles;
  final bool? icon;

  SearchTextfieldWidget(
      {Key? key,
      this.inputType,
      this.text,
      this.icon,
      this.control,
      this.styles,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: control,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchHomeServicesListScreen(
                        isProvider: false,
                      )));
        },
        style: blackDarkM14(),
        onChanged: (value) => onChanged != null ? onChanged!(value) : {},
        keyboardType: inputType ?? TextInputType.multiline,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(const Radius.circular(4.0)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIconConstraints:
              const BoxConstraints(minHeight: 24, minWidth: 24),
          prefixIcon: icon == true
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.asset(
                    'assets/orange_search_icon_small.png',
                    width: 24,
                    height: 24,
                  ),
                )
              : null,
          contentPadding: Responsive.isDesktop(context)
              ? const EdgeInsets.only(top: 13, left: 15, right: 8, bottom: 0)
              : const EdgeInsets.only(top: 0, left: 15, right: 8, bottom: 3),
          fillColor: Colors.white,
          filled: true,
          hintText: text,

          hintStyle: !Responsive.isDesktop(context)
              ? blackDarkO40M14
              : blackDarkO40M12,
          // labelText: "$text",
          // labelStyle:
          //     !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M12,
        ),
      ),
    );
  }
}

//highested rated slider
class HighestSlider extends StatefulWidget {
  List<ServiceProvider> serviceProviders;
  HighestSlider({Key? key, required this.serviceProviders}) : super(key: key);

  @override
  State<HighestSlider> createState() => _HighestSliderState();
}

class _HighestSliderState extends State<HighestSlider> {
  int currentLate = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.serviceProviders.length,
          itemBuilder: (context, index, _) {
            return highestRatedServiceproviderContainer(
                widget.serviceProviders[index]);
          },
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            height: Responsive.isDesktop(context)
                ? Sizeconfig.screenHeight! / 4
                : Sizeconfig.screenHeight! / 3.2,
            aspectRatio: 3,
            autoPlay: true,
            onPageChanged: (index, _) {
              setState(
                () {
                  currentLate = index;
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(widget.serviceProviders, (index, url) {
            return Container(
              width: 4.0,
              height: 4.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    currentLate == index ? MyAppColor.orangedark : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  highestRatedServiceproviderContainer(ServiceProvider serviceProvider) {
    return InkWell(
      onTap: () {
        if (kIsWeb) {
          context.vRouter.to(
              "/home-service-seeker/service-provider-details-screen/${serviceProvider.id.toString()}");
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ServiceProviderDetailsScreen(
                        id: serviceProvider.id.toString(),
                      )));
        }
      },
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(0.0)
            : const EdgeInsets.all(10.0),
        child: Container(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth!
              : Sizeconfig.screenWidth! / 4.5,
          color: MyAppColor.greynormal,
          child: Column(
            children: [
              //menu row

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    //for image
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 20,
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                currentUrl(serviceProvider.image),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(width: 8), //for rating and all
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ///   Image.asset('assets/maintenance_grey.png'),
                              ratingBar()
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text("${serviceProvider.name}",
                                    overflow: TextOverflow.clip,
                                    style: Responsive.isDesktop(context)
                                        ? blackDarkSemiBold16
                                        : blackDarkSemiBold16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Bharat Services Co.',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        container(
                            text: 'AC', image: 'assets/setting.png', width: 60),
                        container(
                            text: 'Electrician',
                            image: 'assets/setting.png',
                            width: 110),
                        container(text: '...', width: 30),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        Image.asset('assets/location_icon.png'),
                        Text(
                          '${locationShow(city: serviceProvider.city, state: serviceProvider.state)}',
                          style: !Responsive.isDesktop(context)
                              ? blackDarkSb10()
                              : blackDarkSb10(),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (kIsWeb) {
                          context.vRouter.to(
                              "/home-service-seeker/service-provider-details-screen/${serviceProvider.id.toString()}");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ServiceProviderDetailsScreen(
                                        id: serviceProvider.id.toString(),
                                      )));
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
        ),
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
      ignoreGestures: true,
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

class TopHomeServiceCategories extends StatelessWidget {
  ServiceCountCategory serviceCountCategory;
  TopHomeServiceCategories({Key? key, required this.serviceCountCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchHomeServicesListScreen(
                      isProvider: false,
                      filterData: {
                        'categoryIds': serviceCountCategory.categoryId
                      },
                    )));
      },
      child: Container(
        width:
            Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 6 : null,
        decoration: BoxDecoration(
          // color: Colors.red,
          image: DecorationImage(
            image: NetworkImage(currentUrl(serviceCountCategory
                .serviceCategory!.image!
                .split("\n")
                .first)),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.8),
            ],
          )),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Service Catergory',
                  style: whiteRegularGalano10,
                ),
                Text(
                  '${serviceCountCategory.serviceCategory!.categoryName}',
                  style: whiteSemiBoldGalano18,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${serviceCountCategory.categoryCount} Services',
                      style: whiteRegularGalano12,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Book a service',
                          style: whiteBoldGalano12,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: MyAppColor.white,
                          size: Responsive.isMobile(context) ? 16 : 15,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
