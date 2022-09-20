// ignore_for_file: must_be_immutable, unused_import, prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/job_view_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/cards/dynamic_job_card_widget.dart';
import 'package:hindustan_job/widget/cards/job_card_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/latest_goverment_job.dart';
import 'package:vrouter/vrouter.dart';

class LatestJObsSlider extends ConsumerStatefulWidget {
  String cardState;
  bool isShortListed;
  List<JobsTwo> listOfJobs;
  LatestJObsSlider(
      {Key? key,
      required this.listOfJobs,
      required this.cardState,
      this.isShortListed = false})
      : super(key: key);

  @override
  ConsumerState<LatestJObsSlider> createState() => _LatestJObsSliderState();
}

class _LatestJObsSliderState extends ConsumerState<LatestJObsSlider> {
  int currentLate = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      bool isLoading = ref.watch(jobData).isLoading;
      return widget.listOfJobs.isNotEmpty
          ? Column(
              children: [
                CarouselSlider.builder(
                  itemCount: widget.listOfJobs.length > 4
                      ? 4
                      : widget.listOfJobs.length,
                  itemBuilder: (context, i, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          if (kIsWeb) {
                            context.vRouter.to(
                                '/hindustaan-jobs/job-view-page/${widget.listOfJobs[i].id}/${widget.cardState}',
                                queryParameters: {
                                  "offerLetter":
                                      widget.listOfJobs[i].offerLetter!,
                                  "candidateStatus":
                                      widget.listOfJobs[i].candidateStatus!,
                                  "companyStatus":
                                      widget.listOfJobs[i].companyStatus!,
                                  "reason": widget.listOfJobs[i].reason!,
                                });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JobViewPage(
                                        id: widget.listOfJobs[i].id,
                                        flag: widget.cardState,
                                        offerletter:
                                            widget.listOfJobs[i].offerLetter,
                                        candidateStatus: widget
                                            .listOfJobs[i].candidateStatus,
                                        companyStatus:
                                            widget.listOfJobs[i].companyStatus,
                                        reason: widget.listOfJobs[i].reason)));
                          }
                          return;
                        },
                        child: DynamicJobCard(
                            cardState: widget.cardState,
                            job: widget.listOfJobs[i]),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    height: 230,
                    aspectRatio: 3,
                    autoPlay: true,
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
                  children: List.generate(
                      widget.listOfJobs.length > 4
                          ? 4
                          : widget.listOfJobs.length, (index) {
                    return Container(
                      width: 4.0,
                      height: 4.0,
                      margin: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentLate == index
                            ? MyAppColor.orangedark
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            )
          : SizedBox(
              height: 200,
              child: isLoading
                  ? loaderIndicator(context)
                  : Center(
                      child: Text(
                        "No Data Found",
                        style: blackRegularGalano14,
                      ),
                    ));
    });
  }
}
