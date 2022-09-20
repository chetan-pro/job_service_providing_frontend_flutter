// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/job_view_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';

import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:vrouter/vrouter.dart';

class DynamicJobCard extends ConsumerStatefulWidget {
  String cardState;
  bool isShortListed;
  bool applied;
  bool isReceivedOfferLetter;
  JobsTwo job;
  DynamicJobCard(
      {Key? key,
      required this.cardState,
      this.isShortListed = false,
      this.applied = false,
      this.isReceivedOfferLetter = false,
      required this.job})
      : super(key: key);

  @override
  ConsumerState<DynamicJobCard> createState() => _DynamicJobCardState();
}

class _DynamicJobCardState extends ConsumerState<DynamicJobCard> {


  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      bool isCandidateSubscribed =
          ref.watch(editProfileData).isCandidateSubscribed;
      return Card(
        elevation: 0,
        child: Container(
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width / 4.8
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
                    if (widget.cardState == CardState.rejected)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        color: MyAppColor.grayplane,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'You are Rejected',
                              style: greylightBoldGalano10,
                            ),
                          ],
                        ),
                      ),
                    if (widget.cardState == CardState.notInterested)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        color: MyAppColor.grayplane,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'You are not insterested',
                              style: greylightBoldGalano10,
                            ),
                          ],
                        ),
                      ),
                    if (widget.cardState == CardState.hired)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                              'You are Hired',
                              style: greylightBoldGalano10,
                            ),
                          ],
                        ),
                      ),
                    if (widget.isShortListed)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                    if (widget.isReceivedOfferLetter)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                    if (widget.applied)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                        await ref.read(jobData).likeUnlike(
                            context, widget.job.id, widget.cardState);
                      },
                      child: Container(
                        color: widget.job.userLikedJob != null ||
                                widget.cardState == CardState.fav
                            ? MyAppColor.pink
                            : MyAppColor.grayplane,
                        child: ImageIcon(
                          AssetImage('assets/heart.png'),
                          size: 24,
                          color: MyAppColor.white,
                        ),
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
                          AssetImage('assets/bag_icn.png'),
                          size: 18,
                          color: MyAppColor.applecolor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 6),
                          child: Text('${widget.job.jobTitle} ',
                              style: blackDarkSb16()),
                        ),
                        isCandidateSubscribed
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6, top: 5),
                                child: Text('${widget.job.name}',
                                    style: companyNameM14()),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6, top: 5),
                                child: Row(
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
                                      'Subscribe to Apply',
                                      style: orangeLightBold14,
                                    )
                                  ],
                                ),
                              ),
                        Padding(
                          padding: !Responsive.isDesktop(context)
                              ? EdgeInsets.symmetric(vertical: 5, horizontal: 0)
                              : EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(children: [
                                  HashTag(
                                      text:
                                          "${checkNullOverValueName(widget.job.industry)}"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  HashTag(
                                      text:
                                          "${checkNullOverValueName(widget.job.sector)}"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: HashTag(
                                        text: checkNullOverValueName(
                                            widget.job.jobRoleType)),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
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
                                    SizedBox(
                                      width: Responsive.isDesktop(context)
                                          ? 200
                                          : MediaQuery.of(context).size.width /
                                              2.5,
                                      child: Text(
                                        '${checkNullOverValueName(widget.job.city)} ${checkNullOverValueName(widget.job.state)}',
                                        style: !Responsive.isDesktop(context)
                                            ? blackDarkSb12()
                                            : blackDarkSb9(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                      
                                        if (kIsWeb) {
                                          var queryParameters = {
                                            "offerLetter":
                                                widget.job.offerLetter,
                                            "candidateStatus":
                                                widget.job.candidateStatus,
                                            "companyStatus":
                                                widget.job.companyStatus,
                                            "reason": widget.job.reason,
                                          };
                                          Map<String, String> queryParams =
                                              await removeNulEmptyFromObj(
                                                  queryParameters);
                                          context.vRouter.to(
                                              '/hindustaan-jobs/job-view-page/${widget.job.id}/${widget.cardState}',
                                              queryParameters: queryParams);
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => JobViewPage(
                                                id: widget.job.id,
                                                candidateStatus:
                                                    widget.job.candidateStatus,
                                                companyStatus:
                                                    widget.job.companyStatus,
                                                offerletter:
                                                    widget.job.offerLetter,
                                                reason: widget.job.reason,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text('explore',
                                              style: orangeDarkSb9()),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 3),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: MyAppColor.orangedark,
                                        size: !Responsive.isDesktop(context)
                                            ? 24
                                            : 20,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }
}
