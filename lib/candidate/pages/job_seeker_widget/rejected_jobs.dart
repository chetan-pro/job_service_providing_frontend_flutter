// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/widget/infinite_scroll_widget.dart';

class RejectedJobs extends ConsumerStatefulWidget {
  RejectedJobs({Key? key}) : super(key: key);

  @override
  _RejectedJobsState createState() => _RejectedJobsState();
}

class _RejectedJobsState extends ConsumerState<RejectedJobs> {
  @override
  void initState() {
    super.initState();
    ref.read(jobData).fetchRejectedJobs(context);
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      List<JobsTwo> jobs = ref.watch(jobData).rejectedJobs;
      return IntrinsicHeight(
        child: PaginationJobs(
          flag: 'rejected',
          cardState: CardState.rejected,
          isReceivedOfferLetter: false,
          isShortListed: false,
          applied: false,
          head: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.expand_more),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  'Sort by Relevance',
                  style: blackMediumGalano14,
                ),
              ),
            ],
          ),
          jobs: jobs,
          getJobsList: (page,sortByRelevance) =>
              ref.read(jobData).fetchOfferedJobs(context, page: page,sortByRelevance: sortByRelevance),
        ),
      );
    });
    // : ListView(
    //     children: [
    //       if (Responsive.isMobile(context))
    //         if (Responsive.isDesktop(context))
    //           Center(
    //             child: Wrap(
    //               children: [
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //                 const OfferLetterCard(),
    //               ],
    //             ),
    //           ),
    //       // if (Responsive.isMobile(context))
    //       //   Padding(
    //       //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
    //       //     child: Column(
    //       //       children: List.generate(
    //       //           7,
    //       //           (index) => JobCard(
    //       //                 job: JobsTwo(),
    //       //                 isReceivedOfferLetter: true,
    //       //               )),
    //       //     ),
    //       //   ),
    //       // Footer(),
    //       // Container(
    //       //   alignment: Alignment.center,
    //       //   color: MyAppColor.normalblack,
    //       //   height: 30,
    //       //   width: double.infinity,
    //       //   child: Text(Mystring.hackerkernel,
    //       //       style: Mytheme.lightTheme(context)
    //       //           .textTheme
    //       //           .headline1!
    //       //           .copyWith(color: MyAppColor.white)),
    //       // ),
    //     ],
    //   );
  }
}
