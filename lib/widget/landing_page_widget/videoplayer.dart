import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

import '../../localHunarAccount/model/local_hunar_video_model.dart';

class Videos extends StatefulWidget {
  LocalHunarVideo localHunarVideo;
  Videos({Key? key, required this.localHunarVideo}) : super(key: key);

  @override
  _VideoplayerState createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videos> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: Responsive.isMobile(context)
              ? Sizeconfig.screenHeight
              : Sizeconfig.screenHeight! / 1.5,
          width: Responsive.isMobile(context)
              ? Sizeconfig.screenWidth!
              : Sizeconfig.screenWidth! / 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    MyAppColor.blackplane.withOpacity(0.3),
                    BlendMode.softLight),
                image: AssetImage('assets/singer.png'),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 00,
                left: 00,
                child: Row(
                  children: [
                    Container(
                      height: 65,
                      width: 60,
                      color: Colors.amber,
                      child: widget.localHunarVideo.user!.image != null
                          ? Image.network(
                              currentUrl(widget.localHunarVideo.user!.image),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/Rectangle.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.localHunarVideo.user?.name ?? '',
                      style: !Responsive.isDesktop(context)
                          ? backgroundColorM16()
                          : backgroundColorM12(),
                    ),
                    SizedBox(
                      width: 135,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: Sizeconfig.screenHeight! / 27,
            right: 15,
            child: Text(
              widget.localHunarVideo.length ?? '',
              style: !Responsive.isDesktop(context)
                  ? backgroundColorM12()
                  : backgroundColorM10(),
            )),
        Positioned(
          top: !Responsive.isDesktop(context)
              ? Sizeconfig.screenHeight! / 3
              : Sizeconfig.screenHeight! / 3.2,
          left:
              !Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 15 : 0,
          right:
              Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 80 : 00,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyAppColor.backgroundColor,
            ),
            child: OutlinedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(17),
              ),
              child: Image.asset(
                'assets/arrow.png',
                height: 20,
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 25,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                        locationShow(
                            state: widget.localHunarVideo.user?.state,
                            city: widget.localHunarVideo.user?.city),
                        style: !Responsive.isDesktop(context)
                            ? backgroundColorSb12()
                            : backgroundColorSb10()),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(widget.localHunarVideo.title ?? '',
                    style: !Responsive.isDesktop(context)
                        ? backgroundColorSb18
                        : backgroundColorSb16()),
                SizedBox(
                  height: 3,
                ),
                Text('${widget.localHunarVideo.views ?? ''} Views',
                    style: !Responsive.isDesktop(context)
                        ? backgroundColorM14()
                        : backgroundColorM10()),
              ],
            ))
      ],
    );
  }
}
