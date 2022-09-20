import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/localHunarAccount/home_video_details_screen.dart';
import 'package:hindustan_job/localHunarAccount/model/local_hunar_video_model.dart';
import 'package:hindustan_job/localHunarAccount/my_video_details_screen.dart';
import 'package:hindustan_job/localHunarAccount/search_videos.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';
import '../utility/function_utility.dart';
import 'add_video_screen.dart';

class LunarMyVideosTab extends ConsumerStatefulWidget {
  const LunarMyVideosTab({Key? key}) : super(key: key);

  @override
  ConsumerState<LunarMyVideosTab> createState() => _LunarMyVideosTabState();
}

class _LunarMyVideosTabState extends ConsumerState<LunarMyVideosTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(localHunarProvider).getMyLocalHunarVideo();
    ref.read(localHunarProvider).getAllCountData();
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = blackRegular12;
    return mainBody(styles);
  }

  Widget mainBody(styles) {
    return Consumer(builder: (context, ref, child) {
      int videoUploadedThisMonthCount =
          ref.watch(localHunarProvider).videoUploadedThisMonthCount;
      int totalViewsThisMonth =
          ref.watch(localHunarProvider).totalViewsThisMonth;
      int totalVideosUploaded =
          ref.watch(localHunarProvider).totalVideosUploaded;
      int totalViewsOfAllTime =
          ref.watch(localHunarProvider).totalViewsOfAllTime;
      return Container(
        color: MyAppColor.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: !Responsive.isDesktop(context) ? 10 : 140.0,
                    left: !Responsive.isDesktop(context) ? 10 : 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: Responsive.isDesktop(context) ? 20.0 : 10),
                    searchBarAnaAddVideoButton(),
                    SizedBox(height: Responsive.isDesktop(context) ? 20.0 : 25),
                    cardsRow(videoUploadedThisMonthCount, totalViewsThisMonth,
                        totalVideosUploaded, totalViewsOfAllTime),
                    if (!Responsive.isDesktop(context))
                      const SizedBox(height: 10),
                    if (!Responsive.isDesktop(context))
                      cardsRow2(
                          videoUploadedThisMonthCount,
                          totalViewsThisMonth,
                          totalVideosUploaded,
                          totalViewsOfAllTime),
                    SizedBox(height: Responsive.isDesktop(context) ? 20.0 : 10),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 20,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          headers(text: 'MY VIDEOS'),
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
                    const SizedBox(height: 10),
                    // if (Responsive.isDesktop(context)) videos(),
                    // if (!Responsive.isDesktop(context))
                    Consumer(builder: (context, ref, child) {
                      List<LocalHunarVideo> localHunarVideos =
                          ref.watch(localHunarProvider).localHunarVideos;
                      return Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: List.generate(
                            localHunarVideos.length,
                            (index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyVideoDetailsScreen(
                                                localHunarVideo:
                                                    localHunarVideos[index])));
                              },
                              child: NewVideoContainer(
                                localHunarVideo: localHunarVideos[index],
                                height: 200.0,
                                widthh: Responsive.isDesktop(context)
                                    ? 400
                                    : Sizeconfig.screenWidth,
                              ),
                            ),
                          ));
                    }),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 60,
                    ),
                  ],
                ),
              ),
              Footer()
            ],
          ),
        ),
      );
    });
  }

  viewAllOutLinedButton(context, {styles, required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        width: Responsive.isDesktop(context)
            ? null
            : Sizeconfig.screenWidth! / 3.5,
        child: Padding(
          padding: Responsive.isDesktop(context)
              ? const EdgeInsets.symmetric(horizontal: 20)
              : const EdgeInsets.symmetric(vertical: 10),
          child: Text("VIEW ALL", style: styles.copyWith()),
        ),
      ),
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
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
                                localHunarVideo: LocalHunarVideo(),
                              )));
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

  headers({text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: blackRegular16,
        textAlign: TextAlign.center,
      ),
    );
  }

  searchWindow() {
    return SizedBox(
      /// color: MyAppColor.white,
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 2.2
          : Sizeconfig.screenWidth! / 2.3,
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              height: 30,
              width: Responsive.isDesktop(context)
                  ? Sizeconfig.screenWidth! / 2.3
                  : Sizeconfig.screenWidth! / 2.1,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                ///controller: control,
                onTap: () {
                  context.vRouter.to('search-video-screen');
                  return;
                },
                style: blackDarkM14(),
                onChanged: (value) {},

                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(const Radius.circular(4.0)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  prefixIconConstraints:
                      const BoxConstraints(minHeight: 24, minWidth: 24),
                  contentPadding: Responsive.isDesktop(context)
                      ? const EdgeInsets.only(
                          top: 0, left: 15, right: 8, bottom: 15)
                      : const EdgeInsets.only(
                          top: 0, left: 15, right: 8, bottom: 3),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search services here...',

                  hintStyle: !Responsive.isDesktop(context)
                      ? blackDarkO40M14
                      : blackDarkO40M12,
                  // labelText: "$text",
                  // labelStyle:
                  //     !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M12,
                ),
              ),
            ),
            Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    color: MyAppColor.orangelight),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.search,
                    size: 17,
                    color: MyAppColor.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  searchBarAnaAddVideoButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: Responsive.isDesktop(context)
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.spaceBetween,
      children: [
        Responsive.isDesktop(context) ? searchWindow() : searchMobile(),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isDesktop(context) ? 0 : 8.0),
          child: const Text('|'),
        ),
        addVideoButton()
      ],
    );
  }

  //
  searchMobile() {
    return SizedBox(
      /// color: MyAppColor.white,
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 2.2
          : Sizeconfig.screenWidth! / 2.2,
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            Container(
              height: Responsive.isDesktop(context) ? 30 : 50,
              width: Responsive.isDesktop(context)
                  ? Sizeconfig.screenWidth! / 2.3
                  : Sizeconfig.screenWidth!,
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isDesktop(context) ? 10 : 0),
              child: TextFormField(
                ///controller: control,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchVideosScreen()));
                },
                style: blackDarkM14(),
                // onChanged: (value) =>
                //     onChanged != null ? onChanged!(value) : {},
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(const Radius.circular(4.0)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,

                  prefixIconConstraints:
                      const BoxConstraints(minHeight: 24, minWidth: 24),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(
                      'assets/orange_search_icon_small.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  contentPadding: Responsive.isDesktop(context)
                      ? const EdgeInsets.only(
                          top: 0, left: 15, right: 8, bottom: 17)
                      : const EdgeInsets.only(
                          top: 0, left: 0.0, right: 8, bottom: 0),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search local hunar..',
                  hintStyle: !Responsive.isDesktop(context)
                      ? blackDarkO40M10withOpacity
                      : blackDarkO40M10,
                  // labelText: "$text",
                  // labelStyle:
                  //     !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onPressedAddVideo() {
    if (kIsWeb) {
      context.vRouter.to("/hindustaan-jobs/add-local-hunar-video");
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddVideoScreen()));
    }
  }

  Widget addVideoButton() {
    return ElevatedButton(
        onPressed: () {
          onPressedAddVideo();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: MyAppColor.logoBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Responsive.isDesktop(context)
                ? 'ADD A LOCAL HUNAR VIDEO'
                : 'ADD A LOCAL HUNAR\nVIDEO',
            textAlign: TextAlign.center,
            style: whiteR10(),
          ),
        ));
  }

  Widget cardsRow(videoUploadedThisMonthCount, totalViewsThisMonth,
      totalVideosUploaded, totalViewsOfAllTime) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Responsive.isDesktop(context) ? 0.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 5,
                    Responsive.isDesktop(context) ? 8.0 : 0),
                child: cards(
                    icon: 'assets/videos_icon.png',
                    count: "$videoUploadedThisMonthCount",
                    text: Responsive.isDesktop(context)
                        ? 'Videos Uploaded this Month '
                        : 'Videos Uploaded\nthis Month '))),
        Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Responsive.isDesktop(context) ? 0.0 : 05,
                    Responsive.isDesktop(context) ? 8.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 00),

                // padding:
                //     EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 0),
                child: cards(
                    icon: 'assets/videos_icon.png',
                    count: "${totalViewsThisMonth ?? 0}",
                    text: 'Total Views this Month'))),
        if (Responsive.isDesktop(context))
          Expanded(
            child: Padding(
                padding:
                    EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 0),
                child: cards(
                    icon: 'assets/videos_icon.png',
                    count: "$totalVideosUploaded",
                    text: 'Total Videos Uploaded')),
          ),
        if (Responsive.isDesktop(context))
          Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      Responsive.isDesktop(context) ? 8.0 : 4,
                      Responsive.isDesktop(context) ? 8.0 : 4,
                      Responsive.isDesktop(context) ? .0 : 4,
                      Responsive.isDesktop(context) ? 8.0 : 4),
                  child: cards(
                      icon: 'assets/videos_icon.png',
                      count: "${totalViewsOfAllTime ?? 0}",
                      text: 'Total Views (of All Time)'))),
      ],
    );
  }

  Widget cardsRow2(videoUploadedThisMonthCount, totalViewsThisMonth,
      totalVideosUploaded, totalViewsOfAllTime) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (!Responsive.isDesktop(context))
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Responsive.isDesktop(context) ? 0.0 : 0,
                  Responsive.isDesktop(context) ? 8.0 : 0,
                  Responsive.isDesktop(context) ? 8.0 : 05,
                  Responsive.isDesktop(context) ? 8.0 : 00),
              // padding: EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 5),
              child: cards(
                  icon: 'assets/videos_icon.png',
                  count: "$totalVideosUploaded",
                  text: 'Total Videos\nUploaded '),
            ),
          ),
        if (!Responsive.isDesktop(context))
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Responsive.isDesktop(context) ? 0.0 : 05,
                  Responsive.isDesktop(context) ? 8.0 : 0,
                  Responsive.isDesktop(context) ? 8.0 : 0,
                  Responsive.isDesktop(context) ? 8.0 : 00),
              //  padding: EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 5),
              child: cards(
                  icon: 'assets/videos_icon.png',
                  count: "${totalViewsOfAllTime ?? 0}",
                  text: 'Total Views\n(of All Time)'),
            ),
          ),
      ],
    );
  }

  Widget cards({icon, text, count}) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Responsive.isDesktop(context)
                ? FractionalOffset.topRight
                : FractionalOffset.centerRight,
            end: Responsive.isDesktop(context)
                ? FractionalOffset.bottomLeft
                : FractionalOffset.centerLeft,
            colors: [
              MyAppColor.greylight,
              MyAppColor.greylight,
              MyAppColor.applecolor,
              MyAppColor.applecolor,
            ],
            stops: [
              Responsive.isDesktop(context) ? 0.80 : 0.78,
              0.3,
              0.3,
              0.7,
            ]),
      ),
      child: Padding(
        padding: EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: Responsive.isDesktop(context) ? 8.0 : 22.0,
                    left: Responsive.isDesktop(context) ? 6.0 : 0.0,
                    right: Responsive.isDesktop(context) ? 8.0 : 0,
                    bottom: Responsive.isDesktop(context) ? 8.0 : 0,
                  ),
                  child: Image.asset(
                    icon,
                    height: Responsive.isDesktop(context) ? 30.0 : 20,
                    width: Responsive.isDesktop(context) ? 30.0 : 20,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.isDesktop(context) ? 8.0 : 22.0,
                      left: Responsive.isDesktop(context) ? 16.0 : 22.0,
                      right: Responsive.isDesktop(context) ? 12.0 : 6,
                      bottom: Responsive.isDesktop(context) ? 8.0 : 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$count',
                          style: Responsive.isDesktop(context)
                              ? whiteDarkR22
                              : whiteSemiBoldGalano18,
                        ),
                        Text(
                          '$text',
                          style: Responsive.isDesktop(context)
                              ? whiteDarkR12
                              : whiteDarkR10,
                        )
                      ],
                    ),
                  ),
                ),
                // if (Responsive.isDesktop(context))
                //   Padding(
                //     padding: EdgeInsets.only(
                //       left: Responsive.isDesktop(context) ? 8.0 : 0,
                //       right: Responsive.isDesktop(context) ? 8.0 : 0,
                //       top: Responsive.isDesktop(context) ? 8.0 : 0,
                //       bottom: Responsive.isDesktop(context) ? 8.0 : 0,
                //     ),
                //     child: Icon(
                //       Icons.arrow_forward,
                //       color: MyAppColor.white,
                //     ),
                //   ),
              ],
            ),
            // if (!Responsive.isDesktop(context))
            //   Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.only(
            //           left: Responsive.isDesktop(context) ? 8.0 : 0,
            //           right: Responsive.isDesktop(context) ? 8.0 : 0,
            //           top: Responsive.isDesktop(context) ? 8.0 : 0,
            //           bottom: Responsive.isDesktop(context) ? 8.0 : 0,
            //         ),
            //         child: Icon(
            //           Icons.arrow_forward,
            //           color: MyAppColor.white,
            //         ),
            //       ),
            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}

//
class NewVideoContainer extends StatefulWidget {
  final height;
  final widthh;
  LocalHunarVideo localHunarVideo;

  NewVideoContainer(
      {Key? key, this.height, this.widthh, required this.localHunarVideo})
      : super(key: key);

  @override
  State<NewVideoContainer> createState() => _NewVideoContainerState();
}

class _NewVideoContainerState extends State<NewVideoContainer> {
  ChewieController? chewieController;
  VideoPlayerController? vidPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoInitialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    vidPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  videoInitialize() {
    vidPlayerController =
        VideoPlayerController.network(currentUrl(widget.localHunarVideo.url));
    chewieController = ChewieController(
        videoPlayerController: vidPlayerController!,
        looping: true,
        showOptions: false,
        aspectRatio: vidPlayerController!.value.aspectRatio,
        autoInitialize: true,
        showControls: false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);

    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          width: widget.widthh,
          child: Chewie(
            controller: chewieController!,
          ),
        ),
        Container(
          width: widget.widthh,
          height: widget.height,
          decoration: const BoxDecoration(
              // color: Colors.red,

              ),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.8),
              ],
            )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          Icon(Icons.video_call, color: MyAppColor.white),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'MY LOCAL HUNAR VIDEO',
                            style: whiteBoldGalano12,
                          ),
                        ],
                      ),
                      // Icon(Icons.arrow_forward)
                      arrowButton(context)
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${widget.localHunarVideo.title}',
                        style: whiteMedium14,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '7.5 M Views',
                        style: whiteRegularGalano10,
                      ),
                      Text(
                        '${widget.localHunarVideo.length}',
                        style: whiteDarkR10,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  arrowButton(context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 8),
      height: Responsive.isDesktop(context) ? 55 : 55,
      child: Container(
          margin: const EdgeInsets.fromLTRB(0.0, 10, 10, 10),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
              border: Border.all(color: MyAppColor.white)),
          child: Image.asset(
            'assets/forward_arrow.png',
            color: MyAppColor.white,
          )),
    );
  }
}
