// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/homeserviceSeeker/home_tab.dart';
import 'package:hindustan_job/services/api_services/seeker_service_search.dart';
import 'package:hindustan_job/widget/common_app_bar_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';

class ViewServiceRequestDetailsScreen1 extends StatefulWidget {
  final dynamic flag;

  const ViewServiceRequestDetailsScreen1({Key? key, this.flag})
      : super(key: key);

  @override
  _ViewServiceRequestDetailsScreen1State createState() =>
      _ViewServiceRequestDetailsScreen1State();
}

class _ViewServiceRequestDetailsScreen1State
    extends State<ViewServiceRequestDetailsScreen1> {
  int group = 1;
  var listOfDays = [
    LabelString.monday,
    LabelString.tuesday, //
    LabelString.wednesday,
    LabelString.thursday,
    LabelString.friday,
    LabelString.saturday,
    LabelString.sunday
  ];
  var listOfDaysLetters = [
    LabelString.m,
    LabelString.t,
    LabelString.w,
    LabelString.t,
    LabelString.f,
    LabelString.s,
    LabelString.s
  ];
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return DefaultTabController(
      length: 4,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(statusBarColor: MyAppColor.backgroundColor),
        child: SafeArea(
          child: Scaffold(
              drawerEnableOpenDragGesture: false,
              backgroundColor: MyAppColor.backgroundColor,
              key: _drawerKey,
              drawer: Drawer(
                child: DrawerJobSeeker(),
              ),
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(Responsive.isDesktop(context) ? 70 : 150),
                child: CommomAppBar(
                  drawerKey: _drawerKey,
                ),
              ),
              body: backButtonContainer()),
        ),
      ),
    );
  }

  backButtonContainer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              color: MyAppColor.greynormal,
              height: Responsive.isDesktop(context) ? 50 : 40,
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
              )),
          mainBody()
        ],
      ),
    );
  }

  var sizeBoxHeight = 20.0;
  Widget mainBody() {
    return SizedBox(
      height: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: Responsive.isDesktop(context)
                    ? Sizeconfig.screenWidth! / 3
                    : MediaQuery.of(context).size.width - 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    SizedBox(height: sizeBoxHeight),

                    if (Responsive.isDesktop(context))
                      SizedBox(height: sizeBoxHeight),
                    SeekerSearch(isUserSubscribed: true,isNavigater: true),
                    SizedBox(height: sizeBoxHeight),
                    SizedBox(height: sizeBoxHeight),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: widget.flag == 'completed'
                                  ? MyAppColor.green
                                  : widget.flag == 'pending'
                                      ? MyAppColor.greylight
                                      : MyAppColor.darkBlue,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    header(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    if (widget.flag != 'completed')
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: Responsive.isDesktop(
                                                        context)
                                                    ? 8.0
                                                    : 2.0),
                                            child: cancelRequestButton(
                                                function: cancelRequestFun,
                                                text: Responsive.isDesktop(
                                                        context)
                                                    ? widget.flag == 'pending'
                                                        ? 'REJECT REQUEST'
                                                        : 'CANCEL REQUEST'
                                                    : 'CANCEL REQUEST'),
                                          ),
                                          widget.flag != 'pending'
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          Responsive.isDesktop(
                                                                  context)
                                                              ? 8.0
                                                              : 2),
                                                  child: button(
                                                      function: markAsCompleted,
                                                      text: widget.flag ==
                                                              'pending'
                                                          ? 'ACCEPT REQUEST'
                                                          : 'MARK AS COMPLETED'))
                                              : Container()
                                        ],
                                      ),
                                    if (widget.flag != 'completed')
                                      SizedBox(
                                        height: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ), //blue container

                            Container(
                              color: MyAppColor.greynormal,
                              margin: EdgeInsets.only(bottom: 5),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Wrap(
                                          children: [
                                            Image.asset(
                                                'assets/maintenance_grey.png'),
                                            Text('HOME-SERVICE')
                                          ],
                                        ),
                                        ratingBar()
                                      ],
                                    ),
                                    Responsive.isDesktop(context)
                                        ? Row(
                                            children: [
                                              Text(
                                                  'Air Conditioning Fitting, Service & Repair',
                                                  style: BlackDarkSb18())
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                  'Air Conditioning Fitting,\nService & Repair',
                                                  style: BlackDarkSb18())
                                            ],
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      // alignment: WrapAlignment.start,
                                      // crossAxisAlignment: WrapCrossAlignment.start,
                                      children: [
                                        container(
                                            text: 'AC',
                                            image: 'assets/setting.png',
                                            width: 60),
                                        container(
                                            text: 'Electrician',
                                            image: 'assets/setting.png',
                                            width: 110),
                                        container(text: '...', width: 30),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('599.0', style: BlackDarkSb18()),
                                    Text('Service Charge')
                                  ],
                                ),
                              ),
                            ), //stop
                            //next
                            // containersLabelsTextDetails(
                            //     lable: 'CLIENT NAME', text: 'John Kumar Cena'),
                            //     SizedBox(height: 5),

                            containersLabelsTextDetails(
                                lable: 'CONTACT NUMBER', text: '858483764876'),
                            darkGreyContainer(),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  child: Text('SERVICE PHOTOS'),
                                ),
                                Wrap(
                                  crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                  spacing: 20,
                                  runSpacing: 20,
                                  runAlignment: WrapAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/photo.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                    Image.asset(
                                      'assets/photo.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                    Image.asset(
                                      'assets/photo.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                    Image.asset(
                                      'assets/photo.png',
                                      width: 200,
                                      height: 200,
                                    )
                                  ],
                                ),
                              ],
                            ),

                            Container(
                                color: MyAppColor.greynormal,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        Responsive.isDesktop(context)
                                            ? LabelString
                                                .daysAvailableInWeekForBooking
                                            : LabelString
                                                .daysAvailableInWeekForBookingMobile,
                                        textAlign: TextAlign.center,

                                        ///    style:grey
                                      ),
                                      Wrap(
                                        spacing: 30,
                                        runSpacing: 30,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runAlignment: WrapAlignment.spaceEvenly,
                                        children: [
                                          for (int i = 0;
                                              i < listOfDays.length;
                                              i++)
                                            Container(
                                              alignment: Alignment.center,
                                              height: 94,
                                              width: 94,
                                              color: MyAppColor.grayplane,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    listOfDaysLetters[i],
                                                    style: greenMedium24,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  Text(
                                                    listOfDays[i],
                                                    style: grey12,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                            Text('.   .   .   .   .   .   .'),
                            //
                            Container(
                                color: MyAppColor.greyDark,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Text('REVIEWS'),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: Responsive.isDesktop(context)
                                                ? 12.0
                                                : 0,
                                            right: Responsive.isDesktop(context)
                                                ? 5
                                                : 5),
                                        child: Container(
                                            // height: Responsive.isDesktop(context) ? 45 : 60,
                                            color: MyAppColor.greynormal,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ratingBar(),
                                                  Text(
                                                      '  11,233 ' +
                                                          LabelString.rating,
                                                      style: blackDark12,
                                                      textAlign:
                                                          TextAlign.center)
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: Responsive.isDesktop(context)
                                                ? 12.0
                                                : 0,
                                            left: Responsive.isDesktop(context)
                                                ? 5
                                                : 5),
                                        child: Container(

                                            ///  height: Responsive.isDesktop(context) ? 45 : 60,
                                            color: MyAppColor.greynormal,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '312',
                                                    textAlign: TextAlign.center,
                                                    style: blackBold20,
                                                  ),
                                                  Text('Total no. of Reviews',
                                                      style: blackDark12,
                                                      textAlign:
                                                          TextAlign.center)
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  ]),
                            ),
                            Wrap(
                              children: [
                                for (int i = 0; i < 10; i++) reviewList()
                              ],
                            ),

                            SizedBox(height: 5),
                            Row(
                              children: const [Text('SIMILAR SERVICES')],
                            ),
                            cardSlider(),
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        'VIEW ALL',
                                        style: whiteRegular14,
                                      ),
                                    ),
                                  ],
                                )),
                          ]),
                    ),
                    //next
                    SizedBox(
                      height: sizeBoxHeight,
                    ),
                    SizedBox(
                      height: sizeBoxHeight,
                    ),
                  ]),
                )),
            Footer()
          
          ],
        ),
      ),
    );
  }

  int currentLate = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  List cardList = [
    for (var i = 0; i < 4; i++) LatestJob(),
  ];
  cardSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 9,
          itemBuilder: (context, index, _) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: MyAppColor.greynormal,
                margin: EdgeInsets.only(bottom: 5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            children: [
                              Image.asset('assets/maintenance_grey.png'),
                              Text('HOME-SERVICE')
                            ],
                          ),
                          ratingBar()
                        ],
                      ),
                      Responsive.isDesktop(context)
                          ? Row(
                              children: [
                                Text(
                                    'Air Conditioning Fitting, Service & Repair',
                                    style: BlackDarkSb18())
                              ],
                            )
                          : Row(
                              children: [
                                Text(
                                    'Air Conditioning Fitting,\nService & Repair',
                                    style: BlackDarkSb18())
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                   
                        children: [
                          container(
                              text: 'AC',
                              image: 'assets/setting.png',
                              width: 60),
                          container(
                              text: 'Electrician',
                              image: 'assets/setting.png',
                              width: 110),
                          container(text: '...', width: 30),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('599.0', style: BlackDarkSb18()),
                      Text('Service Charge')
                    ],
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,

            height: 225,

            //  height: double.maxFinite,

            aspectRatio: 3,
            // autoPlay: true,
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
          children: map<Widget>(cardList, (index, url) {
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

  sliderItem() {
    return Padding(
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
            //menu row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AddAServiceScreen()));
                  },
                  child: Container(
                      color: MyAppColor.grayplane,
                      child: Image.asset('assets/menus.png')),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  //for image
                  Column(
                    children: [
                      Image.asset('assets/photo.png', height: 100, width: 100)
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
                            Image.asset('assets/maintenance_grey.png'),
                            ratingBar()
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                  'Air Conditioning Fitting,\nService & Repair',
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
                  Text('599.0',
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
                  Wrap(
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

  reviewList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: MyAppColor.greynormal,
        height: Responsive.isDesktop(context) ? 200 : 300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 25,
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('John Kumar Cena', style: blackBold20),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('26.04.2021 | 10:30 am', style: blackDark12),
                  const SizedBox(
                    height: 10,
                  ),
                  ratingBar(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Responsive.isDesktop(context)
                        ? 'The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. \nJunk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, \nbad nymph, for quick jigs vex! Fox nymphs.'
                        : 'The quick, brown fox jumps over\n a lazy dog. DJs flock by \nwhen MTV ax quiz prog. Junk \nMTV quiz graced by fox whelps.\nBawds jog, flick quartz, vex \nnymphs. Waltz, bad nymph, for\nquick jigs vex! Fox nymphs.',
                    style: Responsive.isDesktop(context)
                        ? blackRegular16
                        : blackRegular14,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  darkGreyContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Container(
        color: MyAppColor.applecolor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: const [
                  Text('SERVICE PROVIDER'),
                  Text('Bharat Services Co.')
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      5.0,
                    ),
                  ),
                  border: Border.all(
                    color: MyAppColor.black,
                  ),
                ),
                child: Image.asset(
                  'assets/forward_arrow.png',
                ),
              )
              // Container(
              //   alignment: Alignment.center,
              //   margin: const EdgeInsets.only(left: 8),
              //   height: Responsive.isDesktop(context) ? 55 : 0,
              //   color: MyAppColor.black,
              //   child: Container(
              //       margin: const EdgeInsets.fromLTRB(0.0, 10, 10, 10),
              //       padding: const EdgeInsets.all(0.0),
              // decoration: BoxDecoration(
              //     borderRadius: const BorderRadius.all(Radius.circular(
              //             5.0) //                 <--- border radius here
              //               ),
              //           border: Border.all(color: MyAppColor.black)),
              //       child:),
            ],
          ),
        ),
      ),
    );
  }

  callServiceButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: MyAppColor.orangelight,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Text(
                  'CALL SERVICE PROVIDER',
                  style: whiteRegular14,
                ),
              ),
            ],
          )),
    );
  }

  header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.flag == 'pending'
            ? Image.asset(
                'assets/service_icon.png',
              )
            : widget.flag == 'completed'
                ? Image.asset(
                    'assets/service_icon.png',
                  )
                : Image.asset(
                    'assets/accept_request.png',
                  ),
        if (!Responsive.isDesktop(context)) SizedBox(width: 10),
        widget.flag == 'upcoming'
            ? Text(
                Responsive.isDesktop(context)
                    ? 'You have accepted this Service Request.'
                    : 'You have accepted this\nService Request.',
                style: greyMedium18,
              )
            : widget.flag == 'completed'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Responsive.isDesktop(context)
                            ? 'This Home-Service is completed'
                            : 'You have Completed this\nService Request.',
                        style: greyMedium18,
                      ),
                      Text(
                        '26.04.2021',
                        style: greyMedium18,
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Responsive.isDesktop(context)
                            ? 'Client has requested for this Service'
                            : 'You have requested for this Job.\nPlease wait for Approval from\nService Provider.',
                        style: greyMedium18,
                      ),
                      Text(
                        '26.04.2021',
                        style: greyMedium18,
                      )
                    ],
                  )
      ],
    );
  }

  containersLabelsTextDetails({lable, text}) {
    return Container(
      color: MyAppColor.greynormal,
      margin: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lable, style: blackRegular12),
                Text(
                  text,
                  style: blackdarkM16,
                ),
                callServiceButton()
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget container({text, double? width, image}) {
  //   return Parallelogram(
  //     cutLength: 5.0,
  //     edge: Edge.RIGHT,
  //     child: Container(
  //       color: MyAppColor.greylight,
  //       width: width,
  //       height: 25.0,
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           image != null
  //               ? Padding(
  //                   padding: const EdgeInsets.only(right: 8.0),
  //                   child: Image.asset(image),
  //                 )
  //               : SizedBox(),
  //           Text(text, style: whiteBoldGalano12),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
      itemBuilder: (context, _) => Icon(
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

  markAsCompleted() {}

  cancelRequestFun() {}

  Widget cancelRequestButton({required Function function, text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () => function,
            style: ElevatedButton.styleFrom(
                primary: widget.flag != 'pending'
                    ? MyAppColor.darkBlue
                    : MyAppColor.greylight,
                side: BorderSide(width: 1.0, color: MyAppColor.white)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    text,
                    style: whiteRegular14,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget button({required Function function, text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () => function,
            style: ElevatedButton.styleFrom(
              primary: MyAppColor.orangelight,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    text,
                    style: whiteRegular14,
                  ),
                ),
              ],
            )),
      ],
    );
  }
//   Widget button({required Function function, text}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 18.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//               onPressed: () => function,
//               style: ElevatedButton.styleFrom(
//                 primary: MyAppColor.orangelight,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       text,
//                       style: whiteRegular14,
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
}

// class BottomBarGreyForWindow extends StatelessWidget {
//   const BottomBarGreyForWindow({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     bottomRow({title, text1, text2, text3, text4, text5}) {
//       return Expanded(
//         flex: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(title, style: white16),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text1,
//               style: greyRegular14,
//             ),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text2,
//               style: greyRegular14,
//             ),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text3 ?? '',
//               style: greyRegular14,
//             ),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text4 ?? '',
//               style: greyRegular14,
//             ),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text5 ?? '',
//               style: greyRegular14,
//             ),
//           ],
//         ),
//       );
//     }

//     bottomBarWidget(context) {
//       return Container(
//         height: Responsive.isDesktop(context) ? 333 : 0,
//         // width: 47,
//         child: Column(
//           children: [
//             Container(
//               height: Responsive.isDesktop(context) ? 283 : 0,
//               color: MyAppColor.greylight,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     flex: 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset('assets/Group.png'),
//                         SizedBox(
//                           height: Responsive.isDesktop(context) ? 20 : 0,
//                         ),
//                         Text(
//                           '©2022 All Rights Reserved',
//                           style: greyRegular14,
//                         ),
//                       ],
//                     ),
//                   ),
//                   bottomRow(
//                     title: 'Links',
//                     text1: 'About Us',
//                     text2: 'Privacy Policy',
//                     text3: 'T & C',
//                     text4: 'Subscription',
//                   ),
//                   bottomRow(
//                       title: 'Roles',
//                       text1: 'Job-Seekers',
//                       text2: 'Company',
//                       text3: 'Home-Service Provider',
//                       text4: 'Home-Service Seeker',
//                       text5: 'Local Hunar'),
//                   bottomRow(
//                       title: 'Work with Us',
//                       text1: 'Business Correspondence',
//                       text2: 'Cluster Manager',
//                       text3: 'Advisor',
//                       text4: 'Field Sales Executive'),
//                   bottomRow(
//                       title: 'Contact',
//                       text1: '+91 987 654 3210',
//                       text2: '+91 987 654 3210',
//                       text3: 'support@hindustanjobs.com'),
//                 ],
//               ),
//             ),
//             Container(
//               height: Responsive.isDesktop(context) ? 50 : 0,
//               color: MyAppColor.normalblack,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Wrap(
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     children: [
//                       Text(
//                         'Designed by Akash Divya, HackerKernel with',
//                         style: greyRegular12,
//                       ),
//                       Image.asset('assets/heart.png', height: 20, width: 20)
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return bottomBarWidget(context);
//   }
// }
