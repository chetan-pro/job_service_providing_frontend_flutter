import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/homeserviceSeeker/service_provider_details_screen.dart';
import 'package:hindustan_job/utility/function_utility.dart';

import '../candidate/model/provider_model.dart';
import '../candidate/theme_modeule/new_text_style.dart';
import '../candidate/theme_modeule/text_style.dart';
import '../constants/colors.dart';

class ServiceProviderCard extends StatelessWidget {
  ServiceProvider serviceProvider;
  ServiceProviderCard({Key? key, required this.serviceProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // onClickhighestRatedServiceprovider();
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
                              // ratingBar()
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

                              //lock

                              // Image.asset('assets/orange_lock_small.png'),
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
                            '${locationShow(city: serviceProvider.city, state: serviceProvider.state)}',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb10()
                                : blackDarkSb10(),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ServiceProviderDetailsScreen(
                                      id: serviceProvider.id.toString(),
                                    )));
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
}
