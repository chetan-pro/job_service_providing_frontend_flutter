import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/candidateWidget/skill_tag_widget.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class SearchWidget extends StatelessWidget {
  String? text;
  UserData? candidate;
  SearchWidget({Key? key, required this.text, this.candidate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: MyAppColor.greynormal,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (text == 'applied') flag(),
                    if (text == 'offer') succces(),
                    if (text == 'short') shortlisted(),
                    if (text == 'accept') accept(),
                    if (text == 'hire') hire(),
                    if (text == 'apply') apply(),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 15, top: 00),
                  child: Column(
                    children: [
                      details(context),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                          children: List.generate(
                        candidate!.userSkills!.length > 3
                            ? 3
                            : candidate!.userSkills!.length,
                        (index) => SkillTag(
                            text:
                                "${candidate!.userSkills![index].skillSubCategory!.name}"),
                      )),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: !Responsive.isDesktop(context) ? 10 : 8,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              if (candidate!.city != null &&
                                  candidate!.state != null)
                                Text(
                                  '${locationShow(city: candidate!.city, state: candidate!.state)}',
                                  style: !Responsive.isDesktop(context)
                                      ? blackDarkSb10()
                                      : blackDarkSb8(),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'View profile',
                                style: !Responsive.isDesktop(context)
                                    ? orangeDarkSb10()
                                    : orangeDarkSb8(),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: MyAppColor.orangedark,
                                size: Responsive.isMobile(context) ? 14 : 16,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          salery(context),
          const SizedBox(
            height: 2,
          ),
          chief(
            context,
          )
        ],
      ),
    );
  }

  shortlisted() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
    );
  }

  succces() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
            style: whiteM10(),
          ),
        ],
      ),
    );
  }

  hire() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      color: MyAppColor.orangelight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/offer-letter-image.png',
            height: 18,
            fit: BoxFit.cover,
          ),
          Text(
            'Applicant Hired',
            style: whiteM10(),
          ),
        ],
      ),
    );
  }

  accept() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      color: MyAppColor.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/offer-letter-image.png',
            height: 18,
            fit: BoxFit.cover,
          ),
          Text(
            'Applicant accepted Offer',
            style: whiteM10(),
          ),
        ],
      ),
    );
  }

  details(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: !Responsive.isDesktop(context) ? 50 : 30,
          width: !Responsive.isDesktop(context) ? 50 : 30,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(currentUrl(candidate?.image)),
                fit: BoxFit.cover),
            color: MyAppColor.applecolor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getCapitalizeString(candidate!.name),
                  style: !Responsive.isDesktop(context)
                      ? blackDarkM16()
                      : blackDarkSb14()),
              // Text(
              //   'Experience: 3+ Years',
              //   style: !Responsive.isDesktop(context)
              //       ? blackDarkSb9()
              //       : blackDarkSb8(),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  salery(context, {text}) {
    return Container(
      color: MyAppColor.grayplane,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Currently Salary per Annum:',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM10,
          ),
          Text(
            text ?? '₹ --------',
            style: !Responsive.isDesktop(context)
                ? blackDarkSb12()
                : blackDarkSb10(),
          ),
        ],
      ),
    );
  }

  chief(context) {
    return Container(
      color: MyAppColor.graydf,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 5,
          ),
          if (candidate!.userAppliedJobs != null &&
              candidate!.userAppliedJobs!.isNotEmpty)
            Text(
              candidate!.userAppliedJobs!.first.jobPost!.name ?? '',
              style: !Responsive.isDesktop(context)
                  ? blackDarkSb12()
                  : blackDarkSb10(),
            ),
        ],
      ),
    );
  }

  flag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      // width: Responsive.isMobile(context)
      //     ? Sizeconfig.screenWidth! / 3
      //     : null,
      color: MyAppColor.grayplane,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  apply() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      // width: Responsive.isMobile(context)
      //     ? Sizeconfig.screenWidth! / 3
      //     : null,
      color: MyAppColor.grayplane,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
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
            'Applicant Applied',
            style: greylightBoldGalano10,
          ),
        ],
      ),
    );
  }
}
