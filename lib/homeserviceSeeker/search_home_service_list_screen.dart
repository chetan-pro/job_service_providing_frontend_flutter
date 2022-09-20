import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/homeserviceSeeker/provider_card.dart';
import 'package:hindustan_job/services/api_services/seeker_service_search.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:flutter/foundation.dart';
import '../candidate/dropdown/dropdown_list.dart';
import '../candidate/model/experience_filter_model.dart';
import '../candidate/model/provider_model.dart';
import '../candidate/model/serviceProviderModal/alldata_get_modal.dart';
import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../candidate/pages/resume_builder_form.dart';
import '../services/api_service_serviceProvider/category.dart';
import '../widget/common_app_bar_widget.dart';
import '../widget/drop_down_widget/select_dropdown.dart';
import '../widget/filter_section/filter_section_one_widget.dart';
import '../widget/filter_section/filter_section_two_widget.dart';
import 'home_service_view_screen.dart';
import '../candidate/header/back_text_widget.dart';

class SearchHomeServicesListScreen extends ConsumerStatefulWidget {
  bool isProvider;
  var filterData;
  SearchHomeServicesListScreen(
      {Key? key, required this.isProvider, this.filterData})
      : super(key: key);

  @override
  ConsumerState<SearchHomeServicesListScreen> createState() =>
      _SearchHomeServicesListScreenState();
}

class _SearchHomeServicesListScreenState
    extends ConsumerState<SearchHomeServicesListScreen> {
  int group = 1;
  List<ServiceCategories> catogaries = [];
  List<ServiceCategories> selectedCatogaries = [];
  List<Hobbies> ratingsList = [];
  List<ExperienceFilter> serviceChargeList = [];
  ExperienceFilter? selectedServiceChargeList;
  List<Hobbies> selectedRatingsList = [];
  String? selectedSorting;
  var filterData = {};
  bool isProvider = false;
  @override
  void initState() {
    super.initState();
    fetchcatogary();
    filterData = widget.filterData;
    isProvider = widget.isProvider;
    for (var element in ListDropdown.ratingsList) {
      ratingsList.add(Hobbies.fromJson(element));
    }
    serviceChargeList =
        ExperienceFilterModel.fromJson(ListDropdown.serviceChargeList)
            .experienceFilter!;
    ref.read(serviceSeeker).filterServicesAndProviders(context,
        isProvider: isProvider, filterData: filterData);
  }

  fetchcatogary() async {
    EasyLoading.show();
    catogaries = await categoryData(context);
    setState(() {});
    EasyLoading.dismiss();
  }

  changeStatus(value) {
    setState(() {
      isProvider = value;
    });
  }

  final etSkillScore1Key = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: !kIsWeb
          ? PreferredSize(
              child: BackWithText(text: "HOME (SERVICE-SEEKER) SEARCH SERVICE"),
              preferredSize: Size.fromHeight(50))
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(Responsive.isDesktop(context) ? 150 : 150),
              child: CommomAppBar(
                  drawerKey: _drawerKey,
                  back: "HOME (SERVICE-SEEKER) SEARCH SERVICE"),
            ),
      body: Responsive.isDesktop(context)
          ? ListView(children: [
              Padding(
                padding: EdgeInsets.only(
                    right: Responsive.isMobile(context) ? 10 : 110.0,
                    left: Responsive.isMobile(context) ? 10 : 110),
                child: Column(children: [
                  const SizedBox(height: 30),
                  SizedBox(height: Responsive.isDesktop(context) ? 20.0 : 25),
                  radioButtonsWithSearch(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      partLeft1(),
                      partRight2(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
              ),
              Footer()
            ])
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(00.0),
                  child: SizedBox(
                    height: Sizeconfig.screenHeight! - 214,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: SeekerSearch(
                              isProvider: changeStatus,
                              isUserSubscribed: true,
                              isNavigater: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: searchForText(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    await bottomFilterSheet();
                                  },
                                  child: Image.asset(
                                      'assets/filter_small_icon.png')),
                              SizedBox(
                                width: 174,
                                child: BuildDropdown(
                                  itemsList: const [
                                    'Ascending',
                                    'Descending',
                                  ],
                                  dropdownHint: 'Sort by relevance',
                                  onChanged: (value) {
                                    selectedSorting = value;
                                    filterData['sortBy'] = value;
                                    ref
                                        .read(serviceSeeker)
                                        .filterServicesAndProviders(context,
                                            isProvider: isProvider,
                                            filterData: filterData);
                                  },
                                  height: 47,
                                  selectedValue: selectedSorting,
                                  defaultValue: 'Sort by relevance',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer(builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          List<Services> services =
                              ref.watch(serviceSeeker).filterServices;
                          List<ServiceProvider> serviceProviders =
                              ref.watch(serviceSeeker).filterServiceProvider;
                          bool isUserSubscribed =
                              ref.watch(editProfileData).isCandidateSubscribed;
                          return serviceProviders.isNotEmpty
                              ? Column(
                                  children: List.generate(
                                  serviceProviders.length,
                                  (index) => ServiceProviderCard(
                                    serviceProvider: serviceProviders[index],
                                  ),
                                ))
                              : Column(
                                  children: List.generate(
                                  services.length,
                                  (index) =>
                                      latestHomeServiceListViewItemWidget(
                                          services: services[index],
                                          isUserSubscribed: isUserSubscribed),
                                ));
                        }),
                        // Footer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  RangeValues _currentRangeValues = const RangeValues(40, 80);

  bottomFilterSheet() {
    return showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (_) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return Consumer(builder: (context, ref, child) {
                return FractionallySizedBox(
                    heightFactor: 0.7,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20),
                        child: Stack(
                          children: [
                            ListView(
                              children: [
                                filterHead(),
                                FilterSection1(
                                    label: 'Service Category',
                                    list: catogaries,
                                    onTap: () {},
                                    onSelecting: (value, index) {
                                      catogaries[index].isSelected = value;
                                      if (selectedCatogaries
                                          .contains(catogaries[index])) {
                                        selectedCatogaries
                                            .remove(catogaries[index]);
                                      } else {
                                        selectedCatogaries
                                            .add(catogaries[index]);
                                      }
                                      setState(() {});
                                    }),
                                FilterSection2(
                                  label: 'Service Charge',
                                  list: serviceChargeList,
                                  onTap: () {},
                                  onSelecting: (value, index) {
                                    selectedServiceChargeList =
                                        serviceChargeList[index];
                                    setState(() {});
                                  },
                                  selectedValue: selectedServiceChargeList,
                                ),
                                FilterSection1(
                                    label: 'Ratings',
                                    list: ratingsList,
                                    onTap: () {},
                                    onSelecting: (value, index) {
                                      ratingsList[index].isSelected = value;
                                      if (selectedRatingsList
                                          .contains(ratingsList[index])) {
                                        selectedRatingsList
                                            .remove(ratingsList[index]);
                                      } else {
                                        selectedRatingsList
                                            .add(ratingsList[index]);
                                      }
                                      setState(() {});
                                    }),
                                InkWell(
                                  onTap: () {
                                    filterData['categoryIds'] =
                                        selectedCatogaries
                                            .map((e) => e.id)
                                            .join(',');
                                    filterData['rating'] = selectedRatingsList
                                        .map((e) => e.id)
                                        .join(',');
                                    if (selectedServiceChargeList != null) {
                                      filterData["priceRange[0]"] =
                                          selectedServiceChargeList!.from
                                              .toString();
                                      filterData['priceRange[1]'] =
                                          selectedServiceChargeList!.to
                                              .toString();
                                    }
                                    ref
                                        .read(serviceSeeker)
                                        .filterServicesAndProviders(context,
                                            isProvider: isProvider,
                                            filterData: filterData);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 40),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: MyAppColor.blackdark)),
                                      child: const Text('DONE')),
                                ),
                              ],
                            ),
                          ],
                        )));
              });
            }));
  }

  filterHead() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 30, right: 12, top: 13, bottom: 12),
      color: MyAppColor.simplegrey,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:
          // ignore: prefer_const_literals_to_create_immutables
          [
        Text(
          'Filters',
          style: blackRegularGalano14,
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
            filterData = {};
            selectedCatogaries = [];
            selectedRatingsList = [];
            selectedSorting = null;
            ref.read(serviceSeeker).filterServicesAndProviders(context,
                isProvider: isProvider, filterData: filterData);
          },
          child: Row(
            children: [
              Text(
                'Clear all Filters',
                style: blackRegularGalano14,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Icon(Icons.close),
              )
            ],
          ),
        ),
      ]),
    );
  }

  //
  backButtonContainer() {
    return Container(
        color: MyAppColor.greynormal,
        height: Responsive.isDesktop(context) ? 40 : 40,
        child: Row(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: Responsive.isDesktop(context) ? 40 : 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 20,
                    child: CircleAvatar(
                      radius: Responsive.isDesktop(context) ? 20.0 : 15,
                      backgroundColor: MyAppColor.backgray,
                      child: Icon(
                        Icons.arrow_back,
                        color: MyAppColor.greylight,
                        size: Responsive.isDesktop(context) ? 20 : 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Responsive.isDesktop(context) ? 20 : 10,
                ),
                Text(
                  LabelString.back,
                  style: grey14,
                ),
                SizedBox(
                  width: Responsive.isDesktop(context) ? 40 : 20,
                ),
                Text(
                  'HOME (HSP) / COMPLETE PROFILE',
                  style: greyMedium10,
                )
              ],
            )
          ],
        ));
  }

  bool value = false;
  partLeft1() {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Container(
              color: MyAppColor.greynormal,
              margin: const EdgeInsets.only(bottom: 5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filters'),
                    const Text('Clear all Filters'),
                  ],
                ),
              )),
          FilterSection1(
              label: 'Service Category',
              list: catogaries,
              onTap: () {},
              onSelecting: (value, index) {
                catogaries[index].isSelected = value;
                if (selectedCatogaries.contains(catogaries[index])) {
                  selectedCatogaries.remove(catogaries[index]);
                } else {
                  selectedCatogaries.add(catogaries[index]);
                }
                var data = {...filterData};
                data['categoryIds'] =
                    selectedCatogaries.map((e) => e.id).join(',');
                ref.read(serviceSeeker).filterServicesAndProviders(context,
                    isProvider: isProvider, filterData: data);

                setState(() {});
              }),
          FilterSection2(
            label: 'Service Charge',
            list: serviceChargeList,
            onTap: () {},
            onSelecting: (value, index) {
              selectedServiceChargeList = serviceChargeList[index];
              var data = {...filterData};
              if (selectedServiceChargeList != null) {
                data["priceRange[0]"] =
                    selectedServiceChargeList!.from.toString();
                data['priceRange[1]'] =
                    selectedServiceChargeList!.to.toString();
              }
              ref.read(serviceSeeker).filterServicesAndProviders(context,
                  isProvider: isProvider, filterData: data);
              setState(() {});
            },
            selectedValue: selectedServiceChargeList,
          ),
          FilterSection1(
              label: 'Ratings',
              list: ratingsList,
              onTap: () {},
              onSelecting: (value, index) {
                ratingsList[index].isSelected = value;
                if (selectedRatingsList.contains(ratingsList[index])) {
                  selectedRatingsList.remove(ratingsList[index]);
                } else {
                  selectedRatingsList.add(ratingsList[index]);
                }
                var data = {...filterData};
                data['rating'] = selectedRatingsList.map((e) => e.id).join(',');
                ref.read(serviceSeeker).filterServicesAndProviders(context,
                    isProvider: isProvider, filterData: data);
                setState(() {});
              }),
        ],
      ),
    );
  }

  List listOfServiceCategory = [
    'Plumbing',
    'Electrician',
    'Masonary',
    'Cleaning',
    'Automobile'
  ];
  radioButtonListTileForCategory({text}) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onChanged: (bool? value) {},
          value: value,
        ),
        Text(text)
      ],
    );
  }

  searchForText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          group == 1
              ? Text(
                  'Search Result ',
                  style: !Responsive.isDesktop(context)
                      ? blackRegular12
                      : blackRegular14,
                )
              : Text(
                  'Search Result ',
                  style: !Responsive.isDesktop(context)
                      ? blackRegular12
                      : blackRegular14,
                ),
          !Responsive.isDesktop(context)
              ? const SizedBox()
              : Text(LabelString.sortByRelevance, style: blackMedium14)
        ],
      ),
    );
  }

  partRight2() {
    return Expanded(
      flex: 9,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            searchForText(),
            const SizedBox(
              height: 20,
            ),
            Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              List<Services> services = ref.watch(serviceSeeker).filterServices;
              List<ServiceProvider> serviceProviders =
                  ref.watch(serviceSeeker).filterServiceProvider;
              bool isUserSubscribed =
                  ref.watch(editProfileData).isCandidateSubscribed;
              return serviceProviders.isNotEmpty
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        serviceProviders.length,
                        (index) => ServiceProviderCard(
                          serviceProvider: serviceProviders[index],
                        ),
                      ))
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        services.length,
                        (index) => latestHomeServiceListViewItemWidget(
                            services: services[index],
                            isUserSubscribed: isUserSubscribed),
                      ));
            }),
          ],
        ),
      ),
    );
  }

  latestHomeServiceListViewItemWidget({Services? services, isUserSubscribed}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeServiceViewScreen(
                      serviceId: services!.id.toString(),
                    )));
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
                    Column(
                      children: [
                        services!.serviceImages!.isNotEmpty
                            ? Image.network(
                                '${currentUrl(services.serviceImages!.first.image)}',
                                height: 100,
                                width: 100)
                            : Image.asset('assets/photo.png',
                                height: 100, width: 100)
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
                              if (!isUserSubscribed)
                                Image.asset('assets/orange_lock_small.png'),
                              ratingBar(services.mean)
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
                                '${services.user?.name}',
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
                      children: List.generate(
                        services.serviceCategories!.length,
                        (index) => HashTag(
                          text:
                              '${services.serviceCategories![index].categoryName}',
                          iconUrl: 'assets/setting.png',
                          showHide: true,
                          cutLength: 5.0,
                        ),
                      ),
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
                            '${locationShow(city: services.user?.city, state: services.user?.state)}',
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
                        //             HomeServiceViewScreen()));
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('Book a Service',
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

  highestRatedServiceproviderContainer() {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? const EdgeInsets.all(0.0)
          : const EdgeInsets.symmetric(vertical: 5.0),
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
                          child: Image.asset('assets/photo1.png',
                              height: 100, width: 100))
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
                            ratingBar(null)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text('Dave Singh Batista',
                                  overflow: TextOverflow.clip,
                                  style: Responsive.isDesktop(context)
                                      ? blackDarkSemiBold16
                                      : blackDarkSemiBold16),
                            ),

                            //lock

                            ///  Image.asset('assets/orange_lock_small.png'),
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
                          'Bhopal,Madhya Pradesh ',
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
                      //             ViewServiceRequestDetailsScreen()));
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('view ',
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
      initialRating: double.parse((rating ?? '0').toString()),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: MyAppColor.white,
      itemCount: 5,
      itemSize: 18.0,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {});
      },
      updateOnDrag: true,
    );
  }

  //
  radioButtonsWithSearch() {
    return Container(
      color: MyAppColor.greynormal,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
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
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  serviceChargeDropdown() {
    return Container(
      height: 30,
      // width: 300,
      ///   margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: MyAppColor.white,
        // borderRadius: BorderRadius.all(Radius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text('Service Charge', style: blackMedium14),
            items: <String>['State', 'B', 'C', 'D'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }

  selectCategoryDropdown() {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: MyAppColor.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            ///  itemHeight: 10.0,
            hint: Text('Select category', style: blackDarkM14()),
            items: <String>['State', 'B', 'C', 'D'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
