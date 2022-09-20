// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/company_posted_job_view.dart';
import 'package:hindustan_job/company/home/openjob_box.dart';
import 'package:hindustan_job/company/home/search/searchcompany.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/landing_page_widget/latest_goverment_job.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/search_widget.dart/candidate_search_widget.dart';
import 'package:vrouter/vrouter.dart';

class CloseJobs extends ConsumerStatefulWidget {
  bool isUserSubscribed;
  CloseJobs({Key? key, required this.isUserSubscribed}) : super(key: key);

  @override
  _CloseJobsState createState() => _CloseJobsState();
}

class _CloseJobsState extends ConsumerState<CloseJobs> {
  @override
  void initState() {
    super.initState();
    ref.read(jobData).fetchCloseJob(context);
  }

  TextEditingController searchController = TextEditingController();
  int group = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      List<JobsTwo> closeJobs = ref.watch(jobData).closeJobs;
      return Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              if (!Responsive.isDesktop(context))
                CandidateSearch(
                  isUserSubscribed: widget.isUserSubscribed,
                ),
              if (Responsive.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: Sizeconfig.screenWidth! / 1.2,
                        color: MyAppColor.greynormal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                RadioButton(
                                  text: "Search by name",
                                  groupValue: group,
                                  onChanged: (value) => setState(() {
                                    group = value;
                                  }),
                                  value: 1,
                                ),
                                RadioButton(
                                  text: "Search by Mobile Number",
                                  groupValue: group,
                                  onChanged: (value) => setState(() {
                                    group = value;
                                  }),
                                  value: 2,
                                ),
                                RadioButton(
                                  text: "Search by Email",
                                  groupValue: group,
                                  onChanged: (value) => setState(() {
                                    group = value;
                                  }),
                                  value: 3,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: Sizeconfig.screenWidth! / 6,
                                  child: TextfieldWidget(
                                    control: searchController,
                                    text: 'Search Applicants here..',
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                    onTap: () {
                                      var key = group == 1
                                          ? 'name'
                                          : group == 2
                                              ? 'mobile_no'
                                              : 'email';
                                      ref
                                          .read(jobData)
                                          .fetchJobAppliedCandidates(context,
                                              filterData: {
                                                key:
                                                    searchController.text.trim()
                                              },
                                              page: 1);
                                      context.vRouter.to(
                                        "/home-company/search-candidates",
                                      );
                                    },
                                    child: _resume()),
                              ],
                            ),
                          
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
           
              SizedBox(
                height: 15,
              ),
              // if (!Responsive.isDesktop(context)) _sortBy(styles1),
              !Responsive.isDesktop(context)
                  ? Column(
                      children: List.generate(
                      closeJobs.length,
                      (index) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompanyPostedJobView(
                                        id: closeJobs[index].id.toString(),
                                      )));
                        },
                        child: OpenJobBox(
                          job: closeJobs[index],
                        ),
                      ),
                    )
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // OpenJobBox(),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // OpenJobBox(),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // OpenJobBox(),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // OpenJobBox(),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // OpenJobBox(),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // OpenJobBox(),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // OpenJobBox(),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // OpenJobBox(),

                      )
                  : Wrap(
                      runSpacing: 15,
                      children: List.generate(
                        closeJobs.length,
                        (index) => OpenJobBox(
                          job: closeJobs[index],
                        ),
                      )
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),
                      // OpenJobBox(),

                      ),
              SizedBox(
                height: 40,
              ),
              Footer(),
            ],
          ),
        ),
      );
    });
  }

  Row _sortBy(TextTheme styles1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.expand_more),
        ),
        Text(
          'Sort by Relevance',
          style: styles1.headline1!
              .copyWith(fontSize: 17, fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  _resume() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 12,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            'SEARCH APPLICANTS',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _searchByName() {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (v) {},
          ),
          Text("Search by name")
        ],
      ),
    );
  }

  Widget _searchByEmail() {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (v) {},
          ),
          Text("Search by Email")
        ],
      ),
    );
  }

  Widget _searchByMobile() {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (v) {},
          ),
          Text("Search by MobileNumber")
        ],
      ),
    );
  }
}
