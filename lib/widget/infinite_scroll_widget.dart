// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hindustan_job/candidate/model/job_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/job_view_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/widget/cards/dynamic_job_card_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vrouter/vrouter.dart';
import '../utility/function_utility.dart';
import 'cards/job_card_widget.dart';
import 'drop_down_widget/text_drop_down_widget.dart';

// ignore: must_be_immutable
class PaginationJobs extends StatefulWidget {
  List<JobsTwo> jobs;
  String? cardState;
  bool isShortListed;
  bool applied;
  bool isReceivedOfferLetter;
  Function getJobsList;
  Widget head;
  String flag;
  PaginationJobs(
      {Key? key,
      required this.cardState,
      required this.head,
      required this.flag,
      required this.jobs,
      required this.getJobsList,
      required this.applied,
      required this.isShortListed,
      required this.isReceivedOfferLetter})
      : super(key: key);

  @override
  State<PaginationJobs> createState() => _PaginationJobsState();
}

class _PaginationJobsState extends State<PaginationJobs> {
  int page = 1;

  // ignore: prefer_final_fields
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    page = 1;
    await widget.getJobsList(page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    // return;
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    page += 1;
    await widget.getJobsList(page);
    _refreshController.loadComplete();
  }

  String sortValue = "Sort by relevance";

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return widget.jobs.isNotEmpty
        ? SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext? context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: !Responsive.isDesktop(context)
                ? ListView.builder(
                    itemBuilder: (c, i) => i == 0
                        ? AppDropdownInput(
                            hintText: "Sort by relevance",
                            options: ['Ascending', 'Descending'],
                            value: sortValue,
                            changed: (String value) async {
                              sortValue = value;
                              setState(() {});
                              if (value != 'Sort by relevance') {
                                await widget.getJobsList(page, value);
                              }
                            },
                            getLabel: (String value) => value,
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobViewPage(
                                    id: widget.jobs[i - 1].id,
                                    flag: widget.flag,
                                    offerletter: widget.jobs[i - 1].offerLetter,
                                    candidateStatus:
                                        widget.jobs[i - 1].candidateStatus,
                                    companyStatus:
                                        widget.jobs[i - 1].companyStatus,
                                    reason: widget.jobs[i - 1].reason,
                                  ),
                                ),
                              );
                            },
                            child: DynamicJobCard(
                              job: widget.jobs[i - 1],
                              isShortListed: widget.isShortListed,
                              applied: widget.applied,
                              isReceivedOfferLetter:
                                  widget.isReceivedOfferLetter,
                              cardState: widget.cardState!,
                            )),
                    itemCount: widget.jobs.length + 1,
                  )
                : Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      widget.jobs.length + 1,
                      (i) => i == 0
                          ? widget.head
                          : InkWell(
                              onTap: () async {
                                if (kIsWeb) {
                                  var queryParameters = {
                                    "offerLetter":
                                        widget.jobs[i - 1].offerLetter,
                                    "candidateStatus":
                                        widget.jobs[i - 1].candidateStatus,
                                    "companyStatus":
                                        widget.jobs[i - 1].companyStatus,
                                    "reason": widget.jobs[i - 1].reason,
                                  };
                                  Map<String, String> queryParams =
                                      await removeNulEmptyFromObj(
                                          queryParameters);
                                  context.vRouter.to(
                                      '/hindustaan-jobs/job-view-page/${widget.jobs[i - 1].id}/${widget.flag}',
                                      queryParameters: queryParams);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobViewPage(
                                        id: widget.jobs[i - 1].id,
                                        flag: widget.flag,
                                        offerletter:
                                            widget.jobs[i - 1].offerLetter,
                                        candidateStatus:
                                            widget.jobs[i - 1].candidateStatus,
                                        companyStatus:
                                            widget.jobs[i - 1].companyStatus,
                                        reason: widget.jobs[i - 1].reason,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: DynamicJobCard(
                                job: widget.jobs[i - 1],
                                isShortListed: widget.isShortListed,
                                applied: widget.applied,
                                isReceivedOfferLetter:
                                    widget.isReceivedOfferLetter,
                                cardState: widget.cardState!,
                              )),
                    )))
        : Center(
            child: Text(
              "No Data Found",
              style: blackRegularGalano14,
            ),
          );
  }
}
