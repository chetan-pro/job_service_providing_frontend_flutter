import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/header/back_text_widget.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/localHunarAccount/model/local_hunar_video_model.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../widget/common_app_bar_widget.dart';
import '../widget/drop_down_widget/select_dropdown.dart';
import 'home_video_details_screen.dart';
import 'my_video_details_screen.dart';
import 'my_videos_tab.dart';

class SearchVideosScreen extends ConsumerStatefulWidget {
  const SearchVideosScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchVideosScreen> createState() => _SearchVideosScreenState();
}

class _SearchVideosScreenState extends ConsumerState<SearchVideosScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.read(localHunarProvider).getFilterLocalHunarVideos();
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = blackRegular12;
    return Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        resizeToAvoidBottomInset: false,
        key: _drawerKey,
        drawer: const Drawer(
          child: const DrawerJobSeeker(),
        ),
        appBar: !kIsWeb
            ? PreferredSize(
                child: BackWithText(text: "HOME (LOCAL-HUNAR) /SEARCH"),
                preferredSize: const Size.fromHeight(50))
            : PreferredSize(
                preferredSize:
                    Size.fromHeight(Responsive.isDesktop(context) ? 70 : 150),
                child: CommomAppBar(
                  drawerKey: _drawerKey,
                  back: "HOME (LOCAL-HUNAR) /SEARCH",
                ),
              ),
        body: mainBody(styles));
  }

  String? selectedSortBy;
  Widget mainBody(styles) {
    return Container(
      color: MyAppColor.backgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: Responsive.isDesktop(context)
                ? Sizeconfig.screenHeight! - 110
                : Sizeconfig.screenHeight! - 212,
            child: ListView(
              children: [
                SizedBox(
                  height: Responsive.isDesktop(context) ? 20 : 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: !Responsive.isDesktop(context) ? 10 : 140.0,
                      left: !Responsive.isDesktop(context) ? 10 : 140),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        headers(text: 'Search Result for "Designer"'),
                        if (Responsive.isDesktop(context))
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            children: [
                              const Icon(Icons.arrow_drop_down),
                              Text(LabelString.sortByRelevance,
                                  style: blackdarkM12),
                            ],
                          ),
                      ]),
                ),
                if (!Responsive.isDesktop(context))
                  Padding(
                    padding: EdgeInsets.only(
                        right: !Responsive.isDesktop(context) ? 10 : 140.0,
                        left: !Responsive.isDesktop(context) ? 10 : 140),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 165,
                            child: BuildDropdown(
                              itemsList: const ['Ascending', 'Descending'],
                              dropdownHint: LabelString.sortByRelevance,
                              onChanged: (value) {
                                selectedSortBy = value;
                                ref
                                    .read(localHunarProvider)
                                    .getFilterLocalHunarVideos(
                                        sortBy: selectedSortBy !=
                                                LabelString.sortByRelevance
                                            ? selectedSortBy
                                            : null);
                              },
                              height: 47,
                              selectedValue: selectedSortBy,
                              defaultValue: LabelString.sortByRelevance,
                            ),
                          ),
                        ]),
                  ),
                const SizedBox(height: 10),
                if (Responsive.isDesktop(context))
                  Padding(
                    padding: EdgeInsets.only(
                        right: !Responsive.isDesktop(context) ? 10 : 140.0,
                        left: !Responsive.isDesktop(context) ? 10 : 140),
                    child: videos(),
                  ),
                if (!Responsive.isDesktop(context))
                  Padding(
                    padding: EdgeInsets.only(
                        right: !Responsive.isDesktop(context) ? 10 : 140.0,
                        left: !Responsive.isDesktop(context) ? 10 : 140),
                    child: Consumer(builder: (context, ref, child) {
                      List<LocalHunarVideo> filterLocalHunarVideos =
                          ref.watch(localHunarProvider).filterLocalHunarVideos;
                      return Wrap(
                          runSpacing: 10,
                          children: List.generate(
                            filterLocalHunarVideos.length,
                            (index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyVideoDetailsScreen(
                                              localHunarVideo:
                                                  filterLocalHunarVideos[index],
                                            )));
                              },
                              child: NewVideoContainer(
                                localHunarVideo: filterLocalHunarVideos[index],
                                height: 200.0,
                                widthh: Sizeconfig.screenWidth,
                              ),
                            ),
                          ));
                    }),
                  ),
                SizedBox(
                  height: Responsive.isDesktop(context) ? 20 : 60,
                ),
                Footer()
              ],
            ),
          ),
          // if (!Responsive.isDesktop(context)) Footer(),
        ],
      ),
    );
  }

  backButtonContainer(context) {
    return Container(
        color: MyAppColor.greynormal,
        height: Responsive.isDesktop(context) ? 40 : 40,
        child: Row(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: Responsive.isDesktop(context) ? 40 : 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 20,
                    child: CircleAvatar(
                      radius: Responsive.isDesktop(context) ? 20.0 : 15,
                      backgroundColor: MyAppColor.backgray,
                      child: Icon(
                        Icons.arrow_back,
                        color: MyAppColor.greylight,
                        size: Responsive.isDesktop(context) ? 20 : 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Responsive.isDesktop(context) ? 20 : 10,
                ),
                Text(
                  LabelString.back,
                  style: grey14,
                ),
                SizedBox(
                  width: Responsive.isDesktop(context) ? 40 : 20,
                ),
                Text(
                  'HOME (HSP) / COMPLETE PROFILE',
                  style: greyMedium10,
                )
              ],
            )
          ],
        ));
  }

  headers({text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Responsive.isDesktop(context) ? blackRegular14 : blackRegular12,
        textAlign: TextAlign.center,
      ),
    );
  }

  videos() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.spaceBetween,
      alignment: WrapAlignment.spaceBetween,
      children: [
        for (int i = 0; i < 3; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyVideoDetailsScreen(
                              localHunarVideo: LocalHunarVideo())));
                },
                child: ImageContainer(
                  height: 300,
                  widthh: Sizeconfig.screenWidth! / 2.5,
                ),
              ),
              ImageContainer(
                height: 300,
                widthh: Sizeconfig.screenWidth! / 2.5,
              ),
            ],
          )
      ],
    );
  }
}
