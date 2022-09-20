// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/pages/resume_builder_form.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/filter_job_page.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/web/recommend_card.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/topjobindustries.dart';
import 'package:hindustan_job/candidate/pages/landing_page/search_job_here.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/customjob_alert.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/pages/company_home_pages.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/api_services/jobs_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/cards/dynamic_job_card_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:hindustan_job/widget/landing_page_widget/slider/latestjob.dart';
import 'package:hindustan_job/widget/subscription_alert_box.dart';
import 'package:vrouter/vrouter.dart';

import '../job_seeker_page/home/edit_profile.dart';
import '../job_seeker_page/home/job_view_page.dart';

class JobSeekar extends ConsumerStatefulWidget {
  const JobSeekar({Key? key}) : super(key: key);
  static const String route = '';

  @override
  ConsumerState<JobSeekar> createState() => _JobSeekarState();
}

class _JobSeekarState extends ConsumerState<JobSeekar> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  List cardList = [
    for (var i = 0; i < 4; i++) TopJobIndustries(),
  ];
  int current = 0;
  int govtJobCount = 0;
  int pvtJobCount = 0;
  @override
  void initState() {
    super.initState();
    ref.read(editProfileData).getAllData(context);
    getCount();
    ref.read(jobData).fetchHomeJobsCardData(context);
  }

  getCount() async {
    ApiResponse response = await getJobTypeCount();
    if (response.status == 200) {
      JobTypeCountModel data = JobTypeCountModel.fromJson(response.body!.data);
      govtJobCount = data.govtJobCount ?? 0;
      pvtJobCount = data.privateJobCount ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    final styles1 = Mytheme.lightTheme(context).textTheme;

    return Consumer(builder: (context, ref, child) {
      List<JobsTwo> nearJobs = ref.watch(jobData).nearJobs;
      List<JobsTwo> recommendJobs = ref.watch(jobData).recommendJobs;
      List<JobsTwo> latestJobs = ref.watch(jobData).latestJobs;
      bool isCandidateSubscribed =
          ref.watch(editProfileData).isCandidateSubscribed;
      bool isLoading = ref.watch(editProfileData).isLoading;
      int? remainingDays = ref.watch(editProfileData).remainingDays;
      String? planName = ref.watch(editProfileData).planName;
      String? startDataOfSubscription =
          ref.watch(editProfileData).startDateOfSubscription;
      int profilePercent = ref.watch(editProfileData).percentOfProfile;
      return !Responsive.isDesktop(context)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      if (!Responsive.isDesktop(context))
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, top: 28),
                          child: Search(),
                        ),
                      if (!isCandidateSubscribed && !isLoading)
                        SubscriptionAlertBox(isFromConnectedRoutes: true),
                      if ((userData!.image == null || profilePercent < 100) &&
                          !isLoading)
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: completeYourProfileDetails()),
                      Padding(
                        padding: const EdgeInsets.only(top: 34, bottom: 20),
                        child: Text(
                          "JOBS RECOMMENDED FOR YOU",
                          style: blackDarkR16,
                        ),
                      ),
                      LatestJObsSlider(
                        cardState: CardState.recommend,
                        listOfJobs: recommendJobs,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterJobPage(
                                flag: JobListFlag.recommended,
                                isFromConnectedRoutes: true,
                                isFromSearch: false,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: Sizeconfig.screenWidth! / 3,
                          child: Text("VIEW ALL", style: styles.copyWith()),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      // Text(
                      //   "TOP JOB INDUSTRIES FOR YOU",
                      //   style: blackDarkR16,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Column(
                      //   children: [
                      //     CarouselSlider.builder(
                      //       itemCount: cardList.length,
                      //       itemBuilder: (context, index, _) {
                      //         return Padding(
                      //           padding: const EdgeInsets.all(5),
                      //           child: TopJobIndustries(),
                      //         );
                      //       },
                      //       options: CarouselOptions(
                      //         enableInfiniteScroll: true,
                      //         height: 150,
                      //         aspectRatio: 3,
                      //         autoPlay: true,
                      //         onPageChanged: (index, _) {
                      //           setState(
                      //             () {
                      //               current = index;
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: map<Widget>(cardList, (index, url) {
                      //         return Container(
                      //           width: 4.0,
                      //           height: 4.0,
                      //           margin: EdgeInsets.symmetric(
                      //               vertical: 15.0, horizontal: 10.0),
                      //           decoration: BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             color: current == index
                      //                 ? MyAppColor.orangedark
                      //                 : Colors.grey,
                      //           ),
                      //         );
                      //       }),
                      //     ),
                      //   ],
                      // ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterJobPage(
                                flag: JobListFlag.recommended,
                                isFromConnectedRoutes: true,
                                isFromSearch: false,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: Sizeconfig.screenWidth! / 3,
                          child: Text("VIEW ALL", style: styles.copyWith()),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Text("LATEST JOBS FOR YOU", style: blackDarkR16),
                      SizedBox(
                        height: 10,
                      ),
                      LatestJObsSlider(
                        cardState: CardState.latest,
                        listOfJobs: latestJobs,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FilterJobPage(
                                      flag: JobListFlag.latest,
                                      isFromSearch: false,
                                      isFromConnectedRoutes: true,
                                      data: {'sortBy': 'ASC'})));

                          return;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: Sizeconfig.screenWidth! / 3,
                          child: Text("VIEW ALL", style: styles.copyWith()),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      if (!Responsive.isDesktop(context) &&
                          isCandidateSubscribed)
                        __subscription(context, styles1, 200.0,
                            daysLeft: remainingDays,
                            startDate: startDataOfSubscription,
                            planName: planName),
                      SizedBox(
                        height: 55,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterJobPage(
                                        flag: JobListFlag.near,
                                        isFromConnectedRoutes: true,
                                        isFromSearch: false,
                                        data: {'filter_by_job_type': '2'}),
                                  ),
                                );
                              },
                              child: JobTypeCard(
                                styles: styles,
                                type: 'Government\nJobs',
                                count: '$govtJobCount Jobs',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterJobPage(
                                        flag: JobListFlag.near,
                                        isFromSearch: false,
                                        isFromConnectedRoutes: true,
                                        data: {'filter_by_job_type': '1'}),
                                  ),
                                );
                              },
                              child: JobTypeCard(
                                styles: styles,
                                type: 'Private\nJobs',
                                count: '$pvtJobCount Jobs',
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (nearJobs.isNotEmpty)
                        SizedBox(
                          height: 55,
                        ),
                      if (nearJobs.isNotEmpty)
                        Column(
                          children: [
                            Text("JOBS NEAR YOU (@ ${userData!.city!.name})",
                                style: blackDarkR16),
                            SizedBox(
                              height: 10,
                            ),
                            LatestJObsSlider(
                              cardState: CardState.near,
                              listOfJobs: nearJobs,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterJobPage(
                                        flag: JobListFlag.near,
                                        isFromSearch: false,
                                        isFromConnectedRoutes: true,
                                        data: {
                                          'filter_by_state': userData!.stateId
                                        }),
                                  ),
                                );
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 110,
                                  child: Text(
                                    "View all",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )),
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.black)),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _customjob(styles),
                            _resumeBuilder(styles),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      if (nearJobs.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              "RECENTLY VIEWED JOBS",
                              style: blackDarkR16,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            LatestJObsSlider(
                              listOfJobs: nearJobs,
                              cardState: CardState.near,
                            ),
                            SizedBox(
                              height: 60,
                            ),
                          ],
                        )
                    ],
                  ),
                  Footer(),
                  Container(
                    alignment: Alignment.center,
                    color: MyAppColor.normalblack,
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      Mystring.hackerkernel,
                      style: Mytheme.lightTheme(context)
                          .textTheme
                          .headline1!
                          .copyWith(color: MyAppColor.white),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: Sizeconfig.screenWidth! * 0.86,
                    child: Column(
                      children: [
                        SerchJobHere(),
                        if (!isCandidateSubscribed && !isLoading)
                          SubscriptionAlertBox(isFromConnectedRoutes: true),
                        if ((userData!.image == null || profilePercent < 100) &&
                            !isLoading)
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: completeYourProfileDetails()),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 8.0, top: 12, bottom: 12),
                          child: _jobViewAll(
                              text: 'JOBS RECOMMENDED FOR YOU',
                              function: () {
                                context.vRouter.to(
                                    "/hindustaan-jobs/filter-job-search",
                                    queryParameters: {
                                      'flag': JobListFlag.recommended
                                    });
                              }),
                        ),

                        RecommendCard(
                          cardState: CardState.recommend,
                          listOfJobs: recommendJobs,
                        ),
                        // Row(
                        //   children: List.generate(
                        //     recommendJobs.length > 4 ? 4 : recommendJobs.length,
                        //     (index) => InkWell(
                        //       onTap: () {},
                        //       child: DynamicJobCard(
                        //         job: recommendJobs[index],
                        //         cardState: CardState.recommend,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: Sizeconfig.screenHeight! / 15),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 0, right: 0.0, top: 5, bottom: 5),
                        //   child: _jobViewAll(
                        //       text: "TOP JOB INDUSTRIES FOR YOU",
                        //       function: () {
                        //         context.vRouter.to(
                        //             "/hindustaan-jobs/filter-job-search",
                        //             queryParameters: {
                        //               'flag': JobListFlag.recommended
                        //             });

                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //     builder: (context) => FilterJobPage(
                        //         //       flag: JobListFlag.near,
                        //         //     ),
                        //         //   ),
                        //         // );
                        //       }),
                        // ),
                        // SizedBox(height: Sizeconfig.screenHeight! / 40),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Expanded(
                        //       child: TopJobIndustries(),
                        //     ),
                        //     SizedBox(
                        //       width: 13,
                        //     ),
                        //     Expanded(
                        //       child: TopJobIndustries(),
                        //     ),
                        //     SizedBox(
                        //       width: 13,
                        //     ),
                        //     Expanded(
                        //       child: TopJobIndustries(),
                        //     ),
                        //     SizedBox(
                        //       width: 13,
                        //     ),
                        //     Expanded(
                        //       child: TopJobIndustries(),
                        //     ),
                        //     SizedBox(
                        //       width: 13,
                        //     ),
                        //     Expanded(
                        //       child: TopJobIndustries(),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: Sizeconfig.screenHeight! / 15),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 8.0, top: 12, bottom: 12),
                          child: _jobViewAll(
                              text: "JOBS NEAR YOU (@ ${userData!.city!.name})",
                              function: () {
                                context.vRouter.to(
                                    "/hindustaan-jobs/filter-job-search",
                                    queryParameters: {
                                      'flag': JobListFlag.near,
                                      'filter_by_state': userData!.stateId!
                                    });
                              }),
                        ),
                        latestJobs.isNotEmpty
                            ? Row(
                                children: List.generate(
                                  nearJobs.length > 4 ? 4 : nearJobs.length,
                                  (index) => InkWell(
                                    onTap: () async {
                                      var queryParameters = {
                                        "offerLetter":
                                            nearJobs[index].offerLetter,
                                        "candidateStatus":
                                            nearJobs[index].candidateStatus,
                                        "companyStatus":
                                            nearJobs[index].companyStatus,
                                        "reason": nearJobs[index].reason,
                                      };
                                      Map<String, String> queryParams =
                                          await removeNulEmptyFromObj(
                                              queryParameters);
                                      context.vRouter.to(
                                          '/hindustaan-jobs/job-view-page/${nearJobs[index].id}/near}',
                                          queryParameters: queryParams);

                                      return;
                                    },
                                    child: DynamicJobCard(
                                      job: nearJobs[index],
                                      cardState: CardState.near,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 200,
                                child: loaderIndicator(context),
                              ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.vRouter.to(
                                      "/hindustaan-jobs/filter-job-search",
                                      queryParameters: {
                                        'filter_by_job_type': '2'
                                      });
                                },
                                child: JobTypeCard(
                                  styles: styles,
                                  type: 'Government Jobs',
                                  count: '$govtJobCount Jobs',
                                ),
                              ),
                              SizedBox(width: 20),
                              InkWell(
                                onTap: () {
                                  context.vRouter.to(
                                      "/hindustaan-jobs/filter-job-search",
                                      queryParameters: {
                                        'filter_by_job_type': '1'
                                      });
                                },
                                child: JobTypeCard(
                                  styles: styles,
                                  type: 'Private Jobs',
                                  count: '$pvtJobCount Jobs',
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 8.0),
                          child: _jobViewAll(
                              text: "LATEST JOBS FOR YOU",
                              function: () {
                                if (kIsWeb) {
                                  context.vRouter.to(
                                      "/hindustaan-jobs/filter-job-search",
                                      queryParameters: {
                                        'flag': JobListFlag.latest
                                      });
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FilterJobPage(
                                        flag: JobListFlag.latest,
                                        isFromConnectedRoutes: true,
                                        isFromSearch: false,
                                      ),
                                    ),
                                  );
                                }
                              }
                              // "RECENTLY VIEWED JOBS",
                              ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RecommendCard(
                          cardState: CardState.latest,
                          listOfJobs: latestJobs,
                        ),
                        // Row(
                        //   children: [
                        //     Row(
                        //       children: List.generate(
                        //         nearJobs.length > 4 ? 4 : nearJobs.length,
                        //         (index) => DynamicJobCard(
                        //           job: nearJobs[index],
                        //           cardState: CardState.near,
                        //         ),
                        //       ),
                        //     ),
                        //     // SizedBox(
                        //     //   width: nearJobs.length == 4 ? 30 : 00,
                        //     // ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 30,
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _customjob(styles),
                              SizedBox(
                                width: 8,
                              ),
                              _resumeBuilder(styles),
                            ]),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 8.0),
                          child: _jobViewAll(
                              text: "RECENTLY VIEWED JOBS",
                              function: () {
                                if (kIsWeb) {
                                  context.vRouter.to(
                                    "/hindustaan-jobs/filter-job-search",
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FilterJobPage(
                                        flag: JobListFlag.near,
                                        isFromConnectedRoutes: true,
                                        isFromSearch: false,
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RecommendCard(
                          cardState: CardState.recommend,
                          listOfJobs: recommendJobs,
                        ),
                        // Row(
                        //   children: List.generate(
                        //     nearJobs.length > 4 ? 4 : nearJobs.length,
                        //     (index) => DynamicJobCard(
                        //       job: nearJobs[index],
                        //       cardState: CardState.near,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: Sizeconfig.screenHeight! / 15),
                  Footer(),
                  // Container(
                  //   alignment: Alignment.center,
                  //   color: MyAppColor.normalblack,
                  //   height: 30,
                  //   width: double.infinity,
                  //   child: Text(
                  //     Mystring.hackerkernel,
                  //     style: Mytheme.lightTheme(context)
                  //         .textTheme
                  //         .headline1!
                  //         .copyWith(color: MyAppColor.white),
                  //   ),
                  // ),
                ],
              ),
            );
    });
  }

  completeYourProfileDetails() {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditProfile()));
        } else {
          context.vRouter.to('/job-seeker/edit-profile');
          ref.read(editProfileData).calculateProfilePercent();
        }
      },
      child: Center(
        child: Container(
            color: MyAppColor.lightBlue,
            height: Responsive.isDesktop(context) ? 60 : 87,
            width: Responsive.isDesktop(context)
                ? 750
                : MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Image.asset(
                    'assets/cut_staff.png',
                    color: Colors.blue,
                  ),
                ),
                Text(
                    Responsive.isDesktop(context)
                        ? 'Complete your profile for better placements and get a job of your domain.'
                        : 'Complete your profile for better \nplacements and get a job of your domain.',
                    style: whiteM12()),
                if (Responsive.isDesktop(context))
                  Padding(
                    padding: EdgeInsets.only(
                        top: Responsive.isDesktop(context) ? 48.0 : 75),
                    child: Image.asset('assets/mask.png'),
                  ),
                Icon(
                  Icons.arrow_forward,
                  color: MyAppColor.white,
                )
              ],
            )),
      ),
    );
  }

  Container _resumeBuilder(TextStyle styles) {
    return Container(
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth! / 2 - 8
          : Sizeconfig.screenWidth! / 4.8,
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 3.5
          : Sizeconfig.screenHeight! / 6,
      color: MyAppColor.darkBlue,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Responsive.isMobile(context))
                    Text(
                      'Professional\nResume Builder',
                      textAlign: TextAlign.center,
                      style: !Responsive.isDesktop(context)
                          ? whiteSb16()
                          : whiteSb12(),
                    ),
                  if (Responsive.isDesktop(context))
                    Text(
                      '     Professional  Resume Builder',
                      style: !Responsive.isDesktop(context)
                          ? whiteSb16()
                          : whiteSb12(),
                    ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 18,
                  ),
                  SizedBox(
                    // width: 130,
                    child: OutlinedButton(
                      onPressed: () {
                        if (kIsWeb) {
                          context.vRouter.to('/hindustaan-jobs/resume-builder');
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResumeBuilder(
                                        isFromConnectedRoutes: true,
                                      )));
                        }
                        return;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: !Responsive.isDesktop(context)
                                ? const EdgeInsets.all(5.0)
                                : EdgeInsets.symmetric(horizontal: 0),
                            child: Text(
                              'GET STARTED',
                              style: !Responsive.isDesktop(context)
                                  ? whiteR12()
                                  : whiteR10(),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Image.asset(
                            'assets/get-started-icon.png',
                            height: 16,
                          )
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                          // minimumSize: Size(40, 30),
                          side: BorderSide(color: MyAppColor.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 00,
            right: 00,
            child: Image.asset(
              'assets/get-started-image-up.png',
              height: 18,
            ),
          ),
          Positioned(
            bottom: 00,
            left: 00,
            child: Image.asset(
              'assets/get-started-image-down.png',
              height: 18,
            ),
          )
        ],
      ),
    );
  }

  Container _activesubscription(TextTheme styles, {planName}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: !Responsive.isDesktop(context) ? 10 : 20),
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Active Subscription Plan:',
              style: !Responsive.isDesktop(context)
                  ? blackDarkM14()
                  : blackdarkM12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              '$planName',
              style: !Responsive.isDesktop(context)
                  ? blackDarkM14()
                  : blackdarkM12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Column __subscription(BuildContext context, TextTheme styles, double size,
      {daysLeft, startDate, planName}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubscriptionPlans(
                          isLimitPlans: false,
                        )));
          },
          child: Container(
            width: double.infinity,
            padding: !Responsive.isDesktop(context)
                ? EdgeInsets.all(20)
                : EdgeInsets.symmetric(horizontal: 30, vertical: 37),
            color: MyAppColor.darkBlue,
            child: Column(
              children: [
                Image.asset('assets/company_homel.png'),
                Text(
                  'YOU HAVE A SUBSCRIPTION',
                  style: whiteR12(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Container(
                    height: 240,
                    width: 240,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.asset(
                        'assets/company_circle.png',
                      ).image),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(

                            // shape: BoxShape.circle,

                            ),
                        height: 200,
                        width: 200,
                        child: Stack(
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return SweepGradient(
                                  colors: [
                                    MyAppColor.orangelight,
                                    MyAppColor.white
                                  ],
                                  startAngle: 0.0,
                                  center: Alignment.center,
                                  endAngle: TWO_PI,
                                ).createShader(rect);
                              },
                              child: Container(
                                height: size,
                                width: size,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyAppColor.white,
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: size - 15,
                                width: size - 15,
                                decoration: BoxDecoration(
                                    color: MyAppColor.darkBlue,
                                    shape: BoxShape.circle),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${daysLeft ?? 0}",
                                      style: whiteSb18(),
                                    ),
                                    Text(
                                      'Days left',
                                      style: whiteR12(),
                                    ),
                                    Text(
                                      'in Subscription',
                                      style: whiteR12(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Yoh can post Un-limited Job  ',
                  style: whiteR12(),
                ),
                Text(
                  '& Find Candidates without any limit. ',
                  style: whiteR12(),
                ),
              ],
            ),
          ),
        ),
        _activesubscription(styles, planName: planName),
        SizedBox(
          height: 4,
        ),
        _subscribe(styles, startDate: startDate),
      ],
    );
  }

  Widget _subscribe(TextTheme styles, {startDate}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: !Responsive.isDesktop(context) ? 10 : 20),
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Subscribed on:',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
          ),
          Text(
            '${startDate ?? ''}',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
          ),
        ],
      ),
    );
  }

  Container _customjob(TextStyle styles) {
    return Container(
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth! / 2 - 15
          : Sizeconfig.screenWidth! / 4.8,
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 3.5
          : Sizeconfig.screenHeight! / 6,
      color: MyAppColor.orangelight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Responsive.isMobile(context))
                    Text(
                      'Get Free Custom\nJob Alerts',
                      textAlign: TextAlign.center,
                      style: !Responsive.isDesktop(context)
                          ? whiteSb16()
                          : whiteSb12(),
                    ),
                  if (Responsive.isDesktop(context))
                    Text(
                      'Get Free Custom Job Alerts',
                      style: !Responsive.isDesktop(context)
                          ? whiteSb16()
                          : whiteSb12(),
                    ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 18,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 130,
                        child: OutlinedButton(
                          onPressed: () {
                            if (kIsWeb) {
                              context.vRouter
                                  .to("/job-seeker/custom-job-alert");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomJobAlerts(
                                            isFromConnectedRoutes: true,
                                          )));
                            }
                            return;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GET ALERTS',
                                style: !Responsive.isDesktop(context)
                                    ? whiteR12()
                                    : whiteR10(),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Image.asset(
                                'assets/get-alert-icon.png',
                                height: 16,
                              )
                            ],
                          ),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: MyAppColor.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 00,
            right: 00,
            child: Image.asset(
              'assets/get-alert-image-up.png',
              height: 20,
            ),
          ),
          Positioned(
            bottom: 00,
            left: 00,
            child: Image.asset(
              'assets/get-alert-image-down.png',
              height: 18,
            ),
          )
        ],
      ),
    );
  }

  Widget _jobViewAll({Function? function, String? text}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 00),
      child: Padding(
        padding: const EdgeInsets.only(right: 00.0, left: 00),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text!,
              style: blackDarkM14(),
            ),
            _viewAll(func: () {
              function!();
            }),
          ],
        ),
      ),
    );
  }

  Widget _viewAll({Function? func}) {
    return OutlinedButton(
      onPressed: () {
        func!();
      },
      child: Container(
          alignment: Alignment.center,
          width: 110,
          child: Text(
            "View all",
            style: TextStyle(
              color: Colors.black,
            ),
          )),
      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.black)),
    );
  }
}

class _privateJob extends StatelessWidget {
  const _privateJob({
    Key? key,
    required this.styles,
  }) : super(key: key);

  final TextStyle styles;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth! / 2.2
          : Sizeconfig.screenWidth! / 4.8,
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 4.9
          : Sizeconfig.screenHeight! / 6,
      color: MyAppColor.greylight,
      child: Stack(
        children: [
          Padding(
            padding: !Responsive.isDesktop(context)
                ? EdgeInsets.symmetric()
                : EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                if (Responsive.isMobile(context))
                  Text(
                    'Private Sector\n      Jobs',
                    style: styles.copyWith(
                        color: MyAppColor.white, fontWeight: FontWeight.w800),
                  ),
                if (Responsive.isDesktop(context))
                  Text(
                    'Private Sector Jobs',
                    style: !Responsive.isDesktop(context)
                        ? whiteSb16()
                        : whiteSb12(),
                  ),
                Text(
                  '25.4 Lakh Jobs',
                  style: !Responsive.isDesktop(context)
                      ? backgroundColorM14()
                      : backgroundColorR10(),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'explore',
                        style: !Responsive.isDesktop(context)
                            ? whiteM12()
                            : whiteR10(),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: MyAppColor.white,
                        size: Responsive.isMobile(context) ? 16 : 15,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: !Responsive.isDesktop(context) ? 00 : 15,
            child: Row(
              children: [
                Image.asset(
                  'assets/contact-image.png',
                  height: 20,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 00,
            child: Image.asset(
              'assets/private-job-image.png',
              height: 20,
            ),
          ),
          Positioned(
            bottom: 00,
            child: Image.asset(
              'assets/private-job-image-down.png',
              height: 20,
            ),
          )
        ],
      ),
    );
  }
}

class JobTypeCard extends StatelessWidget {
  String type;
  String count;
  JobTypeCard({
    Key? key,
    required this.type,
    required this.count,
    required this.styles,
  }) : super(key: key);

  final TextStyle styles;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 4.5
          : Sizeconfig.screenHeight! / 6,
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth! / 2.2
          : Sizeconfig.screenWidth! / 4.8,
      color: MyAppColor.greylight,
      child: Stack(
        children: [
          Container(
            padding: !Responsive.isDesktop(context)
                ? EdgeInsets.symmetric()
                : EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!Responsive.isDesktop(context))
                  SizedBox(
                    height: 44,
                  ),
                Spacer(),
                Text(
                  type,
                  style: !Responsive.isDesktop(context)
                      ? whiteSb16()
                      : whiteSb12(),
                ),
                Text(
                  count,
                  style: !Responsive.isDesktop(context)
                      ? backgroundColorM14()
                      : backgroundColorR10(),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'explore',
                        style: !Responsive.isDesktop(context)
                            ? whiteM12()
                            : whiteR10(),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: MyAppColor.white,
                        size: Responsive.isMobile(context) ? 16 : 15,
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 14,
                // ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: !Responsive.isDesktop(context) ? 00 : 15,
            child: Row(
              children: [
                Image.asset(
                  'assets/contact-image.png',
                  height: 20,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 00,
            child: Image.asset(
              'assets/private-job-image.png',
              height: 20,
            ),
          ),
          Positioned(
            bottom: 00,
            child: Image.asset(
              'assets/private-job-image-down.png',
              height: 20,
            ),
          )
        ],
      ),
    );
  }
}
