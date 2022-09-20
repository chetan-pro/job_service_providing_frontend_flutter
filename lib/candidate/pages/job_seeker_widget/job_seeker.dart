import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/jobseekartab.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/myprofile_page.dart';

import '../../../config/responsive.dart';
import '../../../config/size_config.dart';
import '../../../constants/colors.dart';
import '../../theme_modeule/new_text_style.dart';
import '../job_seeker_page/home/homeappbar.dart';
import 'myjob.dart';

class JobSeekerTab extends ConsumerStatefulWidget {
  const JobSeekerTab({Key? key}) : super(key: key);
  @override
  ConsumerState<JobSeekerTab> createState() => _JobSeekerTabState();
}

class _JobSeekerTabState extends ConsumerState<JobSeekerTab>
    with TickerProviderStateMixin {
  TabController? _control;
  List<int> arrayIndex = [0];

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    _control = TabController(length: 3, vsync: this, initialIndex: 0);
    tabListner();
    ref.read(editProfileData).checkSubscription();
  }

  tabListner() {
    _control?.addListener(() {
      if (arrayIndex.isEmpty) {
        arrayIndex.add(_control?.index ?? 0);
      } else if (arrayIndex.last != _control?.index) {
        arrayIndex.add(_control?.index ?? 0);
      }
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_control?.index != 0) {
      arrayIndex.removeLast();
      int index = arrayIndex.last;
      arrayIndex.removeLast();
      _control?.animateTo(index);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Container(color: MyAppColor.greynormal, child: _tab())),
        body: SizedBox(
          height: Sizeconfig.screenHeight!,
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: _control,
            children: const [
              JobSeekar(),
              MyJobTab(),
              MyprofilePage(),
            ],
          ),
        ));
  }

  _tab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TabBar(
        isScrollable: true,
        labelColor: Colors.black,
        indicatorWeight: 2,
        controller: _control,
        onTap: (i) {},
        indicatorColor: MyAppColor.orangelight,
        tabs: [
          tabTextWithIcon(iconUrl: "assets/home_company.png", text: 'Home'),
          tabTextWithIcon(iconUrl: "assets/company_home2.png", text: 'My jobs'),
          tabTextWithIcon(iconUrl: "assets/cut_staff.png", text: 'My profile')
        ],
      ),
    );
  }

  tabTextWithIcon({iconUrl, text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Stack(
          children: [
            SizedBox(
              height: Responsive.isMobile(context) ? 25 : 20,
              child: CircleAvatar(
                  backgroundColor: MyAppColor.blackdark,
                  child: ImageIcon(AssetImage(iconUrl),
                      size: 12, color: Colors.white)),
            ),
            if (text == 'My profile')
              Consumer(builder: (context, ref, child) {
                int profilePercent =
                    ref.watch(editProfileData).percentOfProfile;
                return profilePercent > 95
                    ? const SizedBox()
                    : Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: MyAppColor.orangelight,
                              shape: BoxShape.circle),
                        ),
                      );
              }),
          ],
        ),
        SizedBox(
          width: Responsive.isDesktop(context) ? 15 : 0,
        ),
        Text("$text", style: blackDark12),
      ]),
    );
  }
}
