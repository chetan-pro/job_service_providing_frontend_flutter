import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/jobs_rejected_by_you.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/not_interested_jobs.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/rejected_jobs.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/shortlisted.dart';
import 'package:hindustan_job/candidate/pages/landing_page/search_job_here.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';

import '../../theme_modeule/desktop_style.dart';
import 'applied_job.dart';
import 'favorite_jobs.dart';
import 'hired_jobs.dart';
import 'offer_letter.dart';

class MyJobTab extends ConsumerStatefulWidget {
  const MyJobTab({Key? key}) : super(key: key);
  static const String route = '/my-job';

  @override
  _MyJobTabState createState() => _MyJobTabState();
}

class _MyJobTabState extends ConsumerState<MyJobTab>
    with SingleTickerProviderStateMixin {
  TabController? _control;

  @override
  void initState() {
    super.initState();
    ref.read(jobData).fetchOfferedJobs(context);
    setState(() {
      _control = TabController(initialIndex: 0, length: 8, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme;
    return Consumer(builder: (context, ref, child) {
      return Responsive.isMobile(context)
          ? TabBarSliverAppbar(
              length: 7,
              tabs: _tab(styles),
              tabsWidgets: [
                AppliedJob(),
                FavoritesJobs(),
                ShortListed(),
                OfferLetter(),
                HiredJobs(),
                RejectedJobs(),
                RejectedByYouJobs(),
                NotInterestedJobs(),
              ],
              control: _control!,
            )
          : TabBarSliverAppbar(
              length: 8,
              tabs: _tab(styles),
              headColumn: SerchJobHere(),
              toolBarHeight: 90,
              tabsWidgets: [
                AppliedJob(),
                FavoritesJobs(),
                ShortListed(),
                OfferLetter(),
                HiredJobs(),
                RejectedJobs(),
                RejectedByYouJobs(),
                NotInterestedJobs(),
              ],
              control: _control!,
          );
    });
  }

  TabBar _tab(TextTheme styles) {
    return TabBar(
      isScrollable: true,
      indicatorColor: MyAppColor.orangelight,
      indicatorWeight: 2.5,
      controller: _control,
      labelColor: MyAppColor.blacklight,
      unselectedLabelColor: Colors.black,
      tabs: [
        if (!Responsive.isDesktop(context)) tabText('Applied\nJobs'),
        if (Responsive.isDesktop(context))
          Text(
            'Applied Jobs',
            style: blackdarkM12,
          ),
        if (!Responsive.isDesktop(context)) tabText('Favorite\nJobs'),
        if (Responsive.isDesktop(context))
          Text(
            'Favorite Jobs',
            style: blackdarkM12,
          ),
        if (!Responsive.isDesktop(context)) tabText('Jobs\nShort-Listed'),
        if (Responsive.isDesktop(context))
          Text(
            'Jobs Short-Listed',
            style: blackdarkM12,
          ),
        if (!Responsive.isDesktop(context)) tabText('Jobs with\nOffer Letter'),
        if (Responsive.isDesktop(context))
          Text(
            'Jobs with Offer Letter ',
            style: blackdarkM12,
          ),
        if (!Responsive.isDesktop(context)) tabText('Jobs with\nHired'),
        if (Responsive.isDesktop(context))
          Text(
            'Jobs with Hired ',
            style: blackdarkM12,
          ),
        if (!Responsive.isDesktop(context)) tabText('Jobs with\nRejected'),
        if (Responsive.isDesktop(context))
          Text(
            'Jobs with Rejected ',
            style: blackdarkM12,
          ),
        if (!Responsive.isDesktop(context)) tabText('Jobs You\nRejected'),
        if (Responsive.isDesktop(context))
          Text(
            'Jobs you Rejected ',
            style: blackdarkM12,
          ),
        if (!Responsive.isDesktop(context)) tabText('Not Interested\nJob'),
        if (Responsive.isDesktop(context))
          Text(
            'Not Interested Job',
            style: blackdarkM12,
          ),
      ],
    );
  }

  tabText(label) {
    return Text(
      label,
      style: blackMediumGalano12,
      textAlign: TextAlign.center,
    );
  }
}
