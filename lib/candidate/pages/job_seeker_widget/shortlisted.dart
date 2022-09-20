import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/widget/infinite_scroll_widget.dart';

class ShortListed extends ConsumerStatefulWidget {
  ShortListed({Key? key}) : super(key: key);
  @override
  _ShortListedState createState() => _ShortListedState();
}

class _ShortListedState extends ConsumerState<ShortListed> {
  @override
  void initState() {
    super.initState();
    ref.read(jobData).fetchShortListedJobs(context);
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      List<JobsTwo> jobs = ref.read(jobData).shortListedJobs;
      return IntrinsicHeight(
        child: PaginationJobs(
          flag: 'shortList',
          cardState: CardState.shortListed,
          isReceivedOfferLetter: false,
          isShortListed: true,
          applied: false,
          head: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.expand_more),
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
          getJobsList: (page, sortByRelevance) => ref
              .read(jobData)
              .fetchShortListedJobs(context,
                  page: page, sortByRelevance: sortByRelevance),
        ),
      );
    });
    // : ListView(
    //     children: [
    //       // if (Responsive.isMobile(context))
    //       //   Padding(
    //       //     padding: const EdgeInsets.symmetric(horizontal: 10),
    //       //     child: Row(
    //       //       mainAxisAlignment: MainAxisAlignment.end,
    //       //       children: [
    //       //         IconButton(
    //       //           onPressed: () {},
    //       //           icon: Icon(Icons.expand_more),
    //       //         ),
    //       //         Text('Sort by Relevance', style: blackMediumGalano14),
    //       //       ],
    //       //     ),
    //       //   ),
    //       if (Responsive.isDesktop(context))
    //         Center(
    //           child: Wrap(
    //               children: List.generate(
    //                   jobs.length, (index) => ShortlistedCard())
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               //   ShortlistedCard(),
    //               // ],
    //               ),
    //         ),
    //       if (Responsive.isMobile(context))
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
    //           child: Column(
    //             children: List.generate(
    //                 jobs.length,
    //                 (index) => InkWell(
    //                       onTap: () {
    //                         Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) => JobViewPage(
    //                                     id: 1, flag: 'shortList')));
    //                       },
    //                       child: JobCard(
    //                         job: JobsTwo(),
    //                         isShortListed: true,
    //                       ),
    //                     )),
    //           ),
    //         ),
    //       Footer(),
    //       Container(
    //         alignment: Alignment.center,
    //         color: MyAppColor.normalblack,
    //         height: 30,
    //         width: double.infinity,
    //         child: Text(Mystring.hackerkernel,
    //             style: Mytheme.lightTheme(context)
    //                 .textTheme
    //                 .headline1!
    //                 .copyWith(color: MyAppColor.white)),
    //       ),
    //     ],
    //   );
  }
}
