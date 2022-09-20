import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class Cradwidget extends StatelessWidget {
  UserData company;
  Cradwidget({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Container(
      height: Responsive.isMobile(context) ? 50 : 40,
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 9.6
          : Sizeconfig.screenWidth! / 2.3,
      color: MyAppColor.greylight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left:5),
            height: Responsive.isMobile(context) ? 25 : 25,
            width: Responsive.isMobile(context) ? 25 : 30,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network('${currentUrl(company.image)}',
                fit: BoxFit.cover, errorBuilder: (BuildContext context,
                    Object exception, StackTrace? stackTrace) {
              return Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    currentUrl(defaultImage),
                    fit: BoxFit.cover,
                  ));
            }),
          ),
          SizedBox(
            width: Responsive.isMobile(context) ? 5 : 4,
          ),
          Text(
            '${company.name}',
            style: TextStyle(
                color: MyAppColor.white,
                fontSize: Responsive.isMobile(context) ? 17 : 12),
          ),
        ],
      ),
    );
  }
}
