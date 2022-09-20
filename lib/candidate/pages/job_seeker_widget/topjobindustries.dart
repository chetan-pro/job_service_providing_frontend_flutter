import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class TopJobIndustries extends StatelessWidget {
  const TopJobIndustries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Container(
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 6 : null,
      decoration: BoxDecoration(
        // color: Colors.red,
        image: const DecorationImage(
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
                'INDUSTRIES',
                style: whiteRegularGalano10,
              ),
              Text(
                'Character Design',
                style: whiteSemiBoldGalano18,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '3,523 Jobs',
                    style: whiteRegularGalano12,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'explore',
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
