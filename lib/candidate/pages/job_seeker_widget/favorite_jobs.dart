// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/widget/infinite_scroll_widget.dart';


class FavoritesJobs extends ConsumerStatefulWidget {
const FavoritesJobs({Key? key}) : super(key: key);

  @override
  _FavoritesJobsState createState() => _FavoritesJobsState();
}

class _FavoritesJobsState extends ConsumerState<FavoritesJobs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(jobData).fetchFavoriteJobs(context);
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      List<JobsTwo> jobs = ref.watch(jobData).favJobs;

      return IntrinsicHeight(
        child: PaginationJobs(
            flag: 'fav',
            cardState: CardState.fav,
            isReceivedOfferLetter: false,
            isShortListed: false,
            applied: false,
            head: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!Responsive.isDesktop(context))
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.expand_more),
                  ),
                if (!Responsive.isDesktop(context))
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
            getJobsList: (page, sortByRelevance) {
              ref.read(jobData).fetchFavoriteJobs(context,
                  page: page, sortByRelevance: sortByRelevance);
            }),
      );
    });
    // : ListView(
    //     children: [
    //       // if (Responsive.isMobile(context))
    //       //   Row(
    //       //     mainAxisAlignment: MainAxisAlignment.end,
    //       //     children: [
    //       //       IconButton(
    //       //         onPressed: () {},
    //       //         icon: Icon(Icons.expand_more),
    //       //       ),
    //       //       Padding(
    //       //         padding: const EdgeInsets.only(right: 10.0),
    //       //         child: Text(
    //       //           'Sort by Relevance',
    //       //           style: blackMediumGalano14,
    //       //         ),
    //       //       ),
    //       //     ],
    //       //   ),
    //       if (Responsive.isDesktop(context))
    //         Center(
    //           child: Wrap(
    //               children: List.generate(
    //                   jobs.length, (index) => CardFavoriteJobs())),
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
    //                                       id: jobs[index].id,
    //                                       flag: 'fav',
    //                                     )));
    //                       },
    //                       child: JobCard(
    //                         cardState: CardState.fav,
    //                         job: jobs[index],
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
