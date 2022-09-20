import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/topjobindustries.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/localHunarAccount/home_video_details_screen.dart';
import 'package:hindustan_job/localHunarAccount/model/local_hunar_video_model.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:video_player/video_player.dart';

import '../candidate/header/back_text_widget.dart';
import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../services/api_services/local_hunar_services.dart';
import '../services/auth/auth.dart';
import '../services/services_constant/response_model.dart';
import '../utility/function_utility.dart';
import '../widget/common_app_bar_widget.dart';
import 'add_video_screen.dart';

class MyVideoDetailsScreen extends ConsumerStatefulWidget {
  LocalHunarVideo localHunarVideo;
  MyVideoDetailsScreen({Key? key, required this.localHunarVideo})
      : super(key: key);

  @override
  ConsumerState<MyVideoDetailsScreen> createState() =>
      _MyVideoDetailsScreenState();
}

class _MyVideoDetailsScreenState extends ConsumerState<MyVideoDetailsScreen> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;

  int group = 1;
  List cardList = [
    for (var i = 0; i < 4; i++) const TopJobIndustries(),
  ];

  @override
  void initState() {
    super.initState();
    videoInitialize(widget.localHunarVideo);
  }

  videoInitialize(localHunarVideo) {
    videoPlayerController =
        VideoPlayerController.network(currentUrl(localHunarVideo.url));
    setState(() {});

    if (kIsWeb) {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        looping: true,
        autoInitialize: true,
      );
    } else {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        looping: true,
        aspectRatio: videoPlayerController!.value.aspectRatio,
        autoInitialize: true,
      );
    }
    setState(() {});
  }

  int current = 0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = blackRegular12;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _drawerKey,
        drawer: Drawer(
          child: DrawerJobSeeker(),
        ),
        appBar: PreferredSize(
            child: BackWithText(text: "HOME (LOCAL-HUNAR) /VIDEO DETAILS"),
            preferredSize: Size.fromHeight(50)),
        // : PreferredSize(
        //     preferredSize:
        //         Size.fromHeight(Responsive.isDesktop(context) ? 150 : 150),
        //     child: CommomAppBar(
        //       drawerKey: _drawerKey,
        //     ),
        //   ),
        body: Responsive.isDesktop(context)
            ? SizedBox(
                height: Sizeconfig.screenHeight!,
                child: Column(
                  children: [
                    Container(
                      color: MyAppColor.backgroundColor,
                      height: Sizeconfig.screenHeight! - 172,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 460),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  headers(text: 'MY VIDEO #12345'),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 0),
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddVideoScreen(
                                                                localHunarVideo:
                                                                    widget
                                                                        .localHunarVideo,
                                                              )));
                                                  ApiResponse response =
                                                      await getLocalHunarVideo(
                                                          id: widget
                                                              .localHunarVideo
                                                              .id);
                                                  if (response.status == 200) {
                                                    widget.localHunarVideo =
                                                        LocalHunarVideo
                                                            .fromJson(response
                                                                .body!.data);
                                                    videoInitialize(
                                                        widget.localHunarVideo);
                                                    setState(() {});
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/edit_small_icon.png'),
                                                    Text('edit',
                                                        style:
                                                            orangeDarkSemibold12),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15.0,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await ref
                                                      .read(localHunarProvider)
                                                      .deleteHunarVideo(widget
                                                          .localHunarVideo.id);
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/delete.png'),
                                                    Text('delete',
                                                        style:
                                                            orangeDarkSemibold12)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 460.0),
                              child: SizedBox(
                                height: 400,
                                child: Chewie(
                                  controller: chewieController!,
                                ),
                              )),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 460),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: detailsContainer()),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    flex: 2,
                                    child: detailsWithImageContainer()),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 460),
                            child: descriptions(),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Footer(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                    height: Sizeconfig.screenHeight! - 205,
                    color: MyAppColor.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          if (userData!.id == widget.localHunarVideo.userId)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    headers(text: 'MY VIDEO #12345'),
                                    Wrap(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddVideoScreen(
                                                          localHunarVideo: widget
                                                              .localHunarVideo,
                                                        )));
                                            ApiResponse response =
                                                await getLocalHunarVideo(
                                                    id: widget
                                                        .localHunarVideo.id);
                                            if (response.status == 200) {
                                              widget.localHunarVideo =
                                                  LocalHunarVideo.fromJson(
                                                      response.body!.data);
                                              videoInitialize(
                                                  widget.localHunarVideo);
                                              setState(() {});
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  'assets/edit_small_icon.png'),
                                              Text('edit',
                                                  style: orangeDarkSemibold12),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await ref
                                                .read(localHunarProvider)
                                                .deleteHunarVideo(
                                                    widget.localHunarVideo.id);
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset('assets/delete.png'),
                                              Text('delete',
                                                  style: orangeDarkSemibold12)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          SizedBox(
                            height: 10,
                          ),

                          /// headers(text: 'TOP LOCAL HUNARS'),
                          // sliderImages(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              height: 400,
                              child: Chewie(
                                controller: chewieController!,
                              ),
                            ),
                          ),

                          ///  viewAllOutLinedButton(context, styles: styles, onTap: () {}),
                          const SizedBox(
                            height: 3,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: detailsContainer()),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: detailsWithImageContainer()),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: descriptions()),
                          const SizedBox(
                            height: 30,
                          ),
                          // Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 10),
                          //     child: similarVideosContainer(styles)),
                          // const SizedBox(
                          //   height: 30,
                          // ),
                          Footer()
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }

  detailsContainer() {
    return Container(
      color: MyAppColor.greynormal,
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 3 : null,
      child: Padding(
        padding: EdgeInsets.all(Responsive.isDesktop(context) ? 10 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              SizedBox(
                height: 12,
              ),
            if (!Responsive.isDesktop(context))
              Text(
                'VIDEO TITLE',
                style: blackDarkR12(),
              ),
            Text(
              '${widget.localHunarVideo.title}',
              style: blackDarkSb14(),
            )
          ],
        ),
      ),
    );
  }

  descriptions() {
    return Container(
      color: MyAppColor.greynormal,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'DESCRIPTIONS',
              style: blackRegular12,
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '${widget.localHunarVideo.description}',
              style: blackRegular12,
            )
          ],
        ),
      ),
    );
  }

  similarVideosContainer(styles) {
    return Container(
      child: Column(
        children: [
          !Responsive.isDesktop(context)
              ? Text(
                  'SIMILAR VIDEOS',
                  style: blackRegular14,
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SIMILAR VIDEOS',
                      style: blackRegular14,
                    ),
                    viewAllOutLinedButton(context, styles: styles, onTap: () {})
                  ],
                ),
          SizedBox(
            height: 15,
          ),
          Responsive.isDesktop(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      ImageContainer(
                        height: 300.0,
                        widthh: Sizeconfig.screenWidth! / 2.83,
                      ),
                      ImageContainer(
                        height: 300.0,
                        widthh: Sizeconfig.screenWidth! / 2.83,
                      ),
                    ])
              : ImageContainer(),
          if (!Responsive.isDesktop(context))
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: orangeCircleDots(),
            ),
          if (!Responsive.isDesktop(context))
            viewAllOutLinedButton(context, styles: styles, onTap: () {})
        ],
      ),
    );
  }

  onTap() {}

  detailsWithImageContainer() {
    return Container(
      color: MyAppColor.greynormal,
      width:
          Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 4.63 : null,
      child: Padding(
        padding: EdgeInsets.all(Responsive.isDesktop(context) ? 10 : 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'TOTAL VIEWS',
                  style: blackDarkR12(),
                ),
                Text('${widget.localHunarVideo.views}', style: blackDarkSb12())
              ],
            )
          ],
        ),
      ),
    );
  }

  searchBarAnaAddVideoButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: MyAppColor.white,
          width: Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth! / 2.7
              : Sizeconfig.screenWidth! / 2.7,
          child: Padding(
            padding: EdgeInsets.all(Responsive.isDesktop(context) ? 4.0 : 12),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: [
                const Icon(Icons.search),
                const Text(
                  'Search Local Hunar',
                ),
              ],
            ),
          ),
        ),
        const Text('|'),
        addVideoButton()
      ],
    );
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
              ? EdgeInsets.symmetric(horizontal: 20)
              : EdgeInsets.symmetric(vertical: 10),
          child: Text("VIEW ALL", style: styles.copyWith()),
        ),
      ),
    );
  }

  sliderImages() {
    return GestureDetector(
      onTap: () {
        //-------
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const VideoDetailsScreen()));
      },
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: 6,
            itemBuilder: (context, index, _) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: ImageContainer(
                  height: Responsive.isDesktop(context) ? 270 : 270,
                  widthh: Responsive.isDesktop(context)
                      ? Sizeconfig.screenWidth
                      : 300,
                ),
              );
            },
            options: CarouselOptions(
              enableInfiniteScroll: true,
              height: 150,
              aspectRatio: 5,

              /// autoPlay: true,
              onPageChanged: (index, _) {
                setState(
                  () {
                    current = index;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

//
  orangeCircleDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(cardList, (index, url) {
        return Container(
          width: 4.0,
          height: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: current == index ? MyAppColor.orangedark : Colors.grey,
          ),
        );
      }),
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

  Widget addVideoButton() {
    return ElevatedButton(
        onPressed: () {
          ///  onPressedViewRequest(flag);
        },
        style: ElevatedButton.styleFrom(
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
}
////..
