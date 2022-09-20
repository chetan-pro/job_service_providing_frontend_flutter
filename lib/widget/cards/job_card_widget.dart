import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';

import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';

class JobCard extends ConsumerWidget {
  String? cardState;
  JobsTwo job;
  bool isShortListed;
  bool applied;
  bool isReceivedOfferLetter;
  JobCard(
      {Key? key,
      required this.job,
      this.cardState,
      this.isShortListed = false,
      this.applied = false,
      this.isReceivedOfferLetter = false})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                          SizedBox(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 3),

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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'You Applied',
                            style: greylightBoldGalano10,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: 2,
                  ),
                  InkWell(
                      onTap: () async {
                        await ref
                            .read(jobData)
                            .likeUnlike(context, job.id, cardState);
                      },
                      child: Container(
                        color: job.userLikedJob != null
                            ? MyAppColor.pink
                            : MyAppColor.grayplane,
                        child: ImageIcon(
                          AssetImage('assets/heart.png'),
                          size: 24,
                          color: MyAppColor.white,
                        ),
                      )),
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
                        AssetImage('assets/bag_icn.png'),
                        size: 18,
                        color: MyAppColor.applecolor,
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 6 : 8,
                      ),
                      Text(
                          job.jobTitle != null
                              ? "${job.jobTitle}"
                              : 'Chief Motion Designer & ${job.jobTitle} \nEngineer',
                          style: blackDarkSb16()),
                      !Responsive.isDesktop(context)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 5),
                              child: Text(
                                  job.user != null
                                      ? "${job.user!.name}"
                                      : 'Lakshaya Corparation',
                                  style: companyNameM14()),
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: MyAppColor.orangedark,
                                  size: 13,
                                ),
                                SizedBox(
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
                      Wrap(runSpacing: 10, spacing: 10, children: [
                        HashTag(
                            text:
                                "${job.industry != null ? job.industry!.name : "industry"}"),
                        HashTag(
                            text:
                                "${job.sector != null ? job.sector!.name : "sector"}"),
                        HashTag(
                            text:
                                "${job.jobRoleType != null ? job.jobRoleType!.name! : "role"}"),
                      ]),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                job.city != null
                                    ? Text(
                                        '${job.city!.name} ${job.state!.name}',
                                        style: blackDarkSb14())
                                    : Text('city state',
                                        style: blackDarkSb14()),
                              ],
                            ),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // verticalDirection: VerticalDirection.down,
                              children: [
                                Row(
                                  children: [
                                    Text('explore', style: orangeDarkSb12()),
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
