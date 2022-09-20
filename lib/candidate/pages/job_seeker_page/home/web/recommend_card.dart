// ignore_for_file: must_be_immutable, avoid_unnecessary_containers

import 'package:auto_route/annotations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/job_view_page.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/cards/dynamic_job_card_widget.dart';
import 'package:vrouter/vrouter.dart';

class RecommendCard extends StatefulWidget {
  String cardState;
  bool isShortListed;
  List<JobsTwo> listOfJobs;
  RecommendCard({
    Key? key,
    required this.cardState,
    this.isShortListed = false,
    required this.listOfJobs,
  }) : super(key: key);

  @override
  _RecommendCardState createState() => _RecommendCardState();
}

class _RecommendCardState extends State<RecommendCard> {
  @override
  Widget build(BuildContext context) {
    return widget.listOfJobs.isNotEmpty
        ? Container(
            child: Row(
              children: List.generate(
                widget.listOfJobs.length > 4 ? 4 : widget.listOfJobs.length,
                (i) => InkWell(
                  onTap: () async {
                    if (kIsWeb) {
                      var queryParameters = {
                        "offerLetter": widget.listOfJobs[i].offerLetter,
                        "candidateStatus": widget.listOfJobs[i].candidateStatus,
                        "companyStatus": widget.listOfJobs[i].companyStatus,
                        "reason": widget.listOfJobs[i].reason,
                      };
                      Map<String, String> queryParams =
                          await removeNulEmptyFromObj(queryParameters);

                      context.vRouter.to(
                          '/hindustaan-jobs/job-view-page/${widget.listOfJobs[i].id}/${widget.cardState}',
                          queryParameters: queryParams);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobViewPage(
                            id: widget.listOfJobs[i].id,
                            flag: widget.cardState,
                            offerletter: widget.listOfJobs[i].offerLetter,
                            candidateStatus:
                                widget.listOfJobs[i].candidateStatus,
                            companyStatus: widget.listOfJobs[i].companyStatus,
                            reason: widget.listOfJobs[i].reason,
                          ),
                        ),
                      );
                    }
                    return;
                  },
                  child: DynamicJobCard(
                    cardState: widget.cardState,
                    job: widget.listOfJobs[i],
                  ),
                ),
              ),
            ),
          )
        : SizedBox(height: 200, child: loaderIndicator(context));
  }
}
