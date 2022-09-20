// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/company_posted_job_view.dart';
import 'package:hindustan_job/company/home/openjob_box.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/search_widget.dart/candidate_search_widget.dart';
import 'package:vrouter/vrouter.dart';

class OpenJobs extends ConsumerStatefulWidget {
  bool isUserSubscribed;
  OpenJobs({Key? key, required this.isUserSubscribed}) : super(key: key);

  @override
  _OpenJobsState createState() => _OpenJobsState();
}

class _OpenJobsState extends ConsumerState<OpenJobs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(jobData).fetchOpenJob(context);
  }

  TextEditingController searchController = TextEditingController();
  int group = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      body: Consumer(builder: (context, ref, child) {
        List<JobsTwo> openJobs = ref.watch(jobData).openJobs;
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
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
              const SizedBox(
                height: 15,
              ),
              !Responsive.isDesktop(context)
                  ? Wrap(
                      runSpacing: 15,
                      children: List.generate(
                        openJobs.length,
                        (index) => InkWell(
                          onTap: () {
                            if (kIsWeb) {
                              context.vRouter.to(
                                  '/home-company/company-posted-job-view/${openJobs[index].id.toString()}');
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyPostedJobView(
                                            id: openJobs[index].id.toString(),
                                          )));
                            }
                          },
                          child: OpenJobBox(
                            job: openJobs[index],
                          ),
                        ),
                      ))
                  : Wrap(
                      runSpacing: 15,
                      children: List.generate(
                          openJobs.length,
                          (index) => InkWell(
                                onTap: () {
                                  if (kIsWeb) {
                                    context.vRouter.to(
                                        '/home-company/company-posted-job-view/${openJobs[index].id.toString()}');
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CompanyPostedJobView(
                                                  id: openJobs[index]
                                                      .id
                                                      .toString(),
                                                )));
                                  }
                                },
                                child: OpenJobBox(
                                  job: openJobs[index],
                                ),
                              ))),
              const SizedBox(
                height: 40,
              ),
              Footer(),
            ],
          ),
        );
      }),
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

  radioButtonWithText({groupValue, value, text, onChanged}) {
    return Container(
      height: 25,
      child: Row(
        children: [
          Radio<dynamic>(
              activeColor: const Color(0xffEB8258),
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v)),
          Text("$text")
        ],
      ),
    );
  }

  _sortBy(TextTheme styles1) {
    radioButtonWithText({groupValue, value, text, onChanged}) {
      return Container(
        height: 25,
        child: Row(
          children: [
            Radio<dynamic>(
                activeColor: const Color(0xffEB8258),
                value: value,
                groupValue: groupValue,
                onChanged: (v) => onChanged(v)),
            Text("$text")
          ],
        ),
      );
    }

//   Row _sortBy(TextTheme styles1) {
// >>>>>>> 9b4a83963e2f48ce9bb9854bc19e137246c9003a
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         IconButton(
//           onPressed: () {},
//           icon: Icon(Icons.expand_more),
//         ),
//         Text(
//           'Sort by Relevance',
//           style: styles1.headline1!
//               .copyWith(fontSize: 17, fontWeight: FontWeight.w700),
//         )
//       ],
//     );
//   }

    _resume() {
      return ElevatedButton(
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                size: 12,
              ),
              const SizedBox(
                width: 3,
              ),
              const Text(
                'SEARCH APPLICANTS',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(primary: MyAppColor.applecolor),
      );
    }
  }
}
