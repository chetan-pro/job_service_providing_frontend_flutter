// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

import '../../../services/api_services/landing_page_services.dart';
import '../../../services/services_constant/response_model.dart';

class TestominialsSlider extends StatefulWidget {
  const TestominialsSlider({Key? key}) : super(key: key);

  @override
  _TestominialsSliderState createState() => _TestominialsSliderState();
}

class _TestominialsSliderState extends State<TestominialsSlider> {
  final CarouselController _controller = CarouselController();

  List<UserData> testimonialUsers = [];
  @override
  void initState() {
    super.initState();
    fetchLandingPageTestimonials();
  }

  fetchLandingPageTestimonials() async {
    ApiResponse response = await getLandingPageTestimonials();
    if (response.status == 200) {
      testimonialUsers = UserDataModel.fromJson(response.body!.data).userData!;
      setState(() {});
    }
  }

  int currentLate = 0;

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!.copyWith(
        fontStyle: FontStyle.italic, fontWeight: FontWeight.w400, fontSize: 17);
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          items: [
            for (var i = 0; i < testimonialUsers.length; i++)
              Padding(
                padding: const EdgeInsets.all(9),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: MyAppColor.greynormal,
                          borderRadius: BorderRadius.circular(5)),
                      height: !Responsive.isDesktop(context)
                          ? Sizeconfig.screenHeight! / 2.2
                          : Sizeconfig.screenHeight! / 3.5,
                      width: !Responsive.isDesktop(context)
                          ? double.infinity
                          : Sizeconfig.screenWidth! / 1.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: !Responsive.isDesktop(context) ? 10 : 20,
                          ),
                          Text('TESTIMONIALS', style: grayLightR16()),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0,
                            ),
                            child: !Responsive.isDesktop(context)
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/right-testmonial.png',
                                          height: 25,
                                        ),
                                        Text(testimonialUsers[i].message ?? '',
                                            style: blackdarkItalic14()),
                                        Image.asset(
                                          'assets/left-testomial.png',
                                          height: 25,
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/right-testmonial.png',
                                            height: 25,
                                          ),
                                          Text(
                                              testimonialUsers[i].message ?? '',
                                              style: blackdarkItalic14()),
                                          Image.asset(
                                            'assets/left-testomial.png',
                                            height: 25,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: !Responsive.isDesktop(context)
                          ? Sizeconfig.screenHeight! / 2.5
                          : Sizeconfig.screenHeight! / 4.1,
                      left: !Responsive.isDesktop(context)
                          ? Sizeconfig.screenWidth! / 7.8
                          : null,
                      right: Responsive.isDesktop(context) ? 30 : null,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: !Responsive.isDesktop(context) ? 70 : 55,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyAppColor.grayplane,
                              borderRadius: BorderRadius.circular(3)),
                          height: !Responsive.isDesktop(context) ? 70 : 55,
                          child: Row(
                            children: [
                              Container(
                                width: !Responsive.isDesktop(context) ? 70 : 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          currentUrl(testimonialUsers[i].image),
                                        ),
                                        fit: BoxFit.cover),
                                    color: Colors.amber),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      testimonialUsers[i].name ?? '',
                                      style: blackDarkM18(),
                                    ),
                                    Text(
                                        locationShow(
                                            state: testimonialUsers[i].state,
                                            city: testimonialUsers[i].city),
                                        style: grayLightSb14()),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 00,
                        top: !Responsive.isDesktop(context)
                            ? Sizeconfig.screenHeight! / 5
                            : Sizeconfig.screenHeight! / 10,
                        child: IconButton(
                          onPressed: () => _controller.previousPage(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: Responsive.isDesktop(context) ? 17 : null,
                          ),
                        )),
                    Positioned(
                        right: 00,
                        top: !Responsive.isDesktop(context)
                            ? Sizeconfig.screenHeight! / 5
                            : Sizeconfig.screenHeight! / 10,
                        child: IconButton(
                            onPressed: () => _controller.nextPage(),
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: Responsive.isDesktop(context) ? 17 : null,
                            )))
                  ],
                ),
              ),
          ],
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            height: Sizeconfig.screenHeight! / 1.7,
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
      ],
    );
  }
}
