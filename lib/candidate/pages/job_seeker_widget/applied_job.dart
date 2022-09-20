// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/widget/infinite_scroll_widget.dart';

class AppliedJob extends ConsumerStatefulWidget {
  AppliedJob({Key? key}) : super(key: key);

  @override
  ConsumerState<AppliedJob> createState() => _AppliedJobState();
}

class _AppliedJobState extends ConsumerState<AppliedJob> {
  @override
  void initState() {
    super.initState();
    ref.read(jobData).fetchAppliedJobs(context);
  }

  String gender = 'Male';
  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      List<JobsTwo> jobs = ref.watch(jobData).appliedJobs;
      return PaginationJobs(
        isReceivedOfferLetter: false,
        flag: "applied",
        isShortListed: false,
        applied: true,
        cardState: CardState.applied,
        head: SizedBox(),
        jobs: jobs,
        getJobsList: (page, sortByRelevance) {
          ref.read(jobData).fetchAppliedJobs(context,
              page: page, sortByRelevance: sortByRelevance);
        },
      );
    });
  }
}
