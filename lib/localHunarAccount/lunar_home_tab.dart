import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/topjobindustries.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/localHunarAccount/add_video_screen.dart';
import 'package:hindustan_job/localHunarAccount/home_video_details_screen.dart';
import 'package:hindustan_job/localHunarAccount/search_videos.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';

import '../services/api_services/local_hunar_services.dart';
import '../services/services_constant/response_model.dart';
import '../utility/function_utility.dart';
import 'model/local_hunar_video_model.dart';

class LunarHomeTab extends StatefulWidget {
  const LunarHomeTab({Key? key}) : super(key: key);

  @override
  State<LunarHomeTab> createState() => _LunarHomeTabState();
}

class _LunarHomeTabState extends State<LunarHomeTab> {
  @override
  void initState() {
    super.initState();
    getTopLocalHunar();
  }

  int group = 1;
  List cardList = [
    for (var i = 0; i < 4; i++) const TopJobIndustries(),
  ];
  int current = 0;

  List<LocalHunarVideo> localTopHunarVideos = [];

  getTopLocalHunar() async {
    ApiResponse response = await getAllLocalHunarVideo(view: true);
    if (response.status == 200) {
      localTopHunarVideos =
          LocalHunarVideoModel.fromJson(response.body!.data).localHunarVideo!;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = blackRegular12;
    return Responsive.isDesktop(context)
        ? ListView(
            children: [
              Container(
                color: MyAppColor.backgroundColor,
                height: Sizeconfig.screenHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 140),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 20),
                        child: searchBarAnaAddVideoButton(),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headers(text: 'TOP LOCAL HUNARS'),
                            viewAllOutLinedButton(context,
                                styles: styles, onTap: () {})
                          ]),
                      const SizedBox(height: 10),
                      videos(),
                      const SizedBox(height: 40),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headers(text: 'NEW LOCAL HUNARS'),
                            viewAllOutLinedButton(context,
                                styles: styles, onTap: () {})
                          ]),
                      const SizedBox(height: 10),
                      videos(),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Footer()
            ],
          )
        : ListView(
            children: [
              Container(
                color: MyAppColor.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      searchBarAnaAddVideoButton(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: headers(text: 'TOP LOCAL HUNARS'),
                      ),
                      sliderImages(localTopHunarVideos),
                      viewAllOutLinedButton(context,
                          styles: styles, onTap: () {}),
                      const SizedBox(
                        height: 30,
                      ),
                      headers(text: 'NEW LOCAL HUNARS'),
                      viewAllOutLinedButton(context,
                          styles: styles, onTap: () {}),
                    ],
                  ),
                ),
              ),
              Footer(),
            ],
          );
  }

  //
  videos() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.spaceBetween,
      alignment: WrapAlignment.spaceBetween,
      children: [
        for (int i = 0;
            i <
                (localTopHunarVideos.length > 1
                    ? 2
                    : localTopHunarVideos.length);
            i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeVideoDetailsScreen()));
                },
                child: ImageContainer(
                  height: 300,
                  widthh: Sizeconfig.screenWidth! / 2.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeVideoDetailsScreen()));
                },
                child: ImageContainer(
                  height: 300,
                  widthh: Sizeconfig.screenWidth! / 2.5,
                ),
              ),
            ],
          )
      ],
    );
  }

  backButtonContainer() {
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

  sliderImages(localTopHunarVideos) {
    return Column(
      children: [
        Row(
          children: List.generate(
              localTopHunarVideos.length,
              (index) => NewVideoContainer(
                    localHunarVideo: localTopHunarVideos[index],
                    height: 200.0,
                    widthh: Responsive.isDesktop(context)
                        ? 400
                        : Sizeconfig.screenWidth,
                  )),
        )
      ],
    );
  }

  orangeCircleDots(localTopHunarVideos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: localTopHunarVideos<Widget>(cardList, (index, url) {
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
          if (kIsWeb) {
            context.vRouter.to("/hindustaan-jobs/add-local-hunar-video");
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddVideoScreen()));
          }
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
                onTap: () {},
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
            InkWell(
              onTap: () {
                context.vRouter.to("/hindustaan-jobs/search-video-screen");
              },
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      color: MyAppColor.orangelight),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.search,
                      size: 17,
                      color: MyAppColor.white,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchVideosScreen()));
                },
                style: blackDarkM14(),
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

  viewAllOutLinedButton(context, {styles, required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        width: Responsive.isDesktop(context) ? null : 110,
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
