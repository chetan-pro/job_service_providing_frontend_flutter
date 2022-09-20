import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/topjobindustries.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/localHunarAccount/add_video_screen.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../widget/common_app_bar_widget.dart';

class HomeVideoDetailsScreen extends StatefulWidget {
  const HomeVideoDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HomeVideoDetailsScreen> createState() => _HomeVideoDetailsScreenState();
}

class _HomeVideoDetailsScreenState extends State<HomeVideoDetailsScreen> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int group = 1;
  List cardList = [
    for (var i = 0; i < 4; i++) const TopJobIndustries(),
  ];
  int current = 0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = blackRegular12;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyAppColor.backgroundColor,
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      // appBar: PreferredSize(
      //   preferredSize:
      //       Size.fromHeight(Responsive.isDesktop(context) ? 70 : 150),
      //   child: CommomAppBar(
      //     drawerKey: _drawerKey,
      //   ),
      // ),
      body: Responsive.isDesktop(context)
          ? Container(
              height: Sizeconfig.screenHeight!,
              child: Column(
                children: [
                  BackButtonRowContainer(),
                  Container(
                    color: MyAppColor.backgroundColor,
                    height: Sizeconfig.screenHeight! - 110,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 260),
                          child: searchBarAnaAddVideoButton(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 360),
                          child: ImageContainer(
                            height: Responsive.isDesktop(context) ? 270 : 270,
                            widthh: Responsive.isDesktop(context)
                                ? Sizeconfig.screenWidth
                                : 300,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 360),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: detailsContainer(),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 2,
                                child: detailsWithImageContainer(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 360),
                          child: descriptions(),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 160),
                          child: similarVideosContainer(styles),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Footer()
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                BackButtonRowContainer(),
                Container(
                  height: Sizeconfig.screenHeight! - 180,
                  color: MyAppColor.backgroundColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: searchBarAnaAddVideoButton(),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        /// headers(text: 'TOP LOCAL HUNARS'),
                        // sliderImages(),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: ImageContainer(
                              height:
                                  Responsive.isDesktop(context) ? 270.0 : 270.0,
                              widthh: Responsive.isDesktop(context)
                                  ? Sizeconfig.screenWidth
                                  : 300.0,
                            )),

                        ///  viewAllOutLinedButton(context, styles: styles, onTap: () {}),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: detailsContainer(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: detailsWithImageContainer()),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: descriptions()),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: similarVideosContainer(styles),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Footer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.video_call_outlined),
                    Text(
                      'LOCAL HUNAR',
                      style: appleColorM12,
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('26.04.2021', style: blackDarkSemibold11),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Icon(
                        Icons.calendar_today,
                        size: 11,
                      ),
                    )
                  ],
                )
              ],
            ),
            !Responsive.isDesktop(context)
                ? Text(
                    'Jaswinder Bhalla Local Rapper',
                    style: blackDarkSb14(),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jaswinder Bhalla Local Rapper',
                        style: blackDarkSb14(),
                      ),
                      Text(
                        '7.5 M Views',
                        style: blackMediumGalano12,
                      )
                    ],
                  ),
            if (!Responsive.isDesktop(context))
              Text(
                '7.5 M Views',
                style: blackMediumGalano12,
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
            Text(
              'The quick, brown fox jumps over a lazy dog.\nDJs flock by when MTV ax quiz prog. Junk MTV\nquiz graced by fox whelps. Bawds jog, flick quartz,\nvex nymphs. Waltz, bad nymph, for quick jigs vex! Fox nymphs grab quick-jived waltz.\nBrick quiz whangs jumpy veldt fox. Bright vixens\njump; dozy fowl quack. Quick wafting zephyrs vex\nbold Jim. Quick zephyrs blow, vexing daft Jim.\nSex-charged fop blew my junk TV quiz. How quickly daft\njumping zebras vex. Two driven jocks help fax my\nbig quiz. Quick, Baz, get my woven flax jodhpurs!\n"Now fax quiz Jack!" my brave ghost pled. Five\nquacking zephyrs jolt my wax bed. Flummoxed by\njob, kvetching W. zaps Iraq. Cozy sphinx waves quart\njug of bad milk. A very bad quack might\njinx zippy fowls. Few quips galvanized the mock jury box.\nQuick brown dogs jump over the lazy fox. The jay, pig,\nfox, zebra, and my wolves quack! Blowzy red vixens\nfight for a quick jump. Joaquin Phoenix was gazed by MTV\nfor luck. A wizard’s job is to vex chumps quickly\nin fog. Watch "Jeopardy!", Alex Trebek"s fun\nTV quiz game. The quick, brown fox jumps over a lazy dog.\nDJs flock by when MTV ax quiz prog. Junk MTV quiz graced by fox whelps. Bawds jog\nflick quartz, vex nymphs. Waltz, bad nymph, for quick jigs vex!\nFox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox.\nBright vixens jump; dozy fowl quack. Quick wafting\nzephyrs vex bold Jim. Quick zephyrs blow, vexing daft Jim.\nSex-charged fop blew my junk TV quiz. How quickly daft\njumping zebras vex. Two driven jocks help fax.',
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
                      Expanded(
                        flex: 2,
                        child: ImageContainer(
                          height: 300.0,
                          widthh: Sizeconfig.screenWidth! / 2.83,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeVideoDetailsScreen()));
                          },
                          child: ImageContainer(
                            height: 300.0,
                            widthh: Sizeconfig.screenWidth! / 2.83,
                          ),
                        ),
                      ),
                    ])
              : sliderImages(),
          // if (!Responsive.isDesktop(context))
          //   Padding(
          //     padding: EdgeInsets.symmetric(vertical: 10),
          //     child: orangeCircleDots(),
          //   ),
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
        padding: EdgeInsets.all(Responsive.isDesktop(context) ? 15 : 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/image1.png', width: 34, height: 34),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Roman Kumar Reigns',
                  style: blackDarkM14(),
                ),
                Text('UPLOADER', style: blackDarkR10())
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
      mainAxisAlignment: Responsive.isDesktop(context)
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.spaceBetween,
      children: [
        Responsive.isDesktop(context) ? searchWindow() : searchMobile(),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isDesktop(context) ? 0 : 8.0),
          child: Text('|'),
        ),
        addVideoButton()
      ],
    );
  }

  searchWindow() {
    return Container(
      /// color: MyAppColor.white,
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 2.2
          : Sizeconfig.screenWidth! / 2.3,
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.all(0)
            : EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              height: 30,
              width: Responsive.isDesktop(context)
                  ? Sizeconfig.screenWidth! / 2.3
                  : Sizeconfig.screenWidth! / 2.1,
              padding: EdgeInsets.symmetric(horizontal: 10),
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
                      ? EdgeInsets.only(top: 0, left: 15, right: 8, bottom: 15)
                      : EdgeInsets.only(top: 0, left: 15, right: 8, bottom: 3),
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

  searchMobile() {
    return Container(
      /// color: MyAppColor.white,
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 2.2
          : Sizeconfig.screenWidth! / 2.2,
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.all(0)
            : EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(
                      'assets/orange_search_icon_small.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  contentPadding: Responsive.isDesktop(context)
                      ? EdgeInsets.only(top: 0, left: 15, right: 8, bottom: 17)
                      : EdgeInsets.only(top: 0, left: 0.0, right: 8, bottom: 0),
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
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
    );
  }

  sliderImages() {
    return GestureDetector(
      onTap: () {
        //-------
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeVideoDetailsScreen()));
      },
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: 6,
            itemBuilder: (context, index, _) {
              return ImageContainer(
                height: 300.0,
                widthh: Sizeconfig.screenWidth!,
              );
            },
            options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 1,
              aspectRatio: 2.0,
              initialPage: 2,
              //  autoPlay: true,
              onPageChanged: (index, _) {
                setState(
                  () {
                    current = index;
                  },
                );
              },
            ),
          ),
          orangeCircleDots()
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

  onPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddVideoScreen()));
  }

  Widget addVideoButton() {
    return ElevatedButton(
        onPressed: () {
          onPressed();
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

class ImageContainer extends StatelessWidget {
  final height;
  final widthh;

  const ImageContainer({Key? key, this.height, this.widthh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);

    return Container(
      width: widthh,
      height: height,
      decoration: const BoxDecoration(
        // color: Colors.red,
        image: DecorationImage(
          image: NetworkImage(
              'https://static1.makeuseofimages.com/wordpress/wp-content/uploads/2017/02/Photoshop-Replace-Background-Featured.jpg'),
          fit: BoxFit.cover,
        ),
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
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'INDUSTRIES',
                style: whiteRegularGalano10,
              ),
              Text(
                'Character Design',
                style: whiteSemiBoldGalano18,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '3,523 Jobs',
                    style: whiteRegularGalano12,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'explore',
                        style: whiteBoldGalano12,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: MyAppColor.white,
                        size: Responsive.isMobile(context) ? 16 : 15,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//
class BackButtonRowContainer extends StatelessWidget {
  const BackButtonRowContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return backButtonContainer(context);
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
}
