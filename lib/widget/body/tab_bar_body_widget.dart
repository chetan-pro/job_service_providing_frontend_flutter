// // ignore_for_file: must_be_immutable, prefer_const_constructors, unused_local_variable

// import 'package:flutter/material.dart';
// import 'package:hindustan_job/config/responsive.dart';
// import 'package:hindustan_job/constants/colors.dart';

// import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
// import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';

// class TabBarSliverAppbar extends StatefulWidget {
//   int length;
//   Widget? col;
//   Widget? sort;
//   int? toolBarHeight;
//   TabBar tabs;
//   Color? backColor;
//   Widget? headColumn;
//   TabController control;
//   List<Widget> tabsWidgets;
//   TabBarSliverAppbar(
//       {Key? key,
//       this.col,
//       this.sort,
//       this.toolBarHeight,
//       required this.length,
//       required this.tabs,
//       required this.tabsWidgets,
//       this.headColumn,
//       this.backColor,
//       required this.control})
//       : super(key: key);

//   @override
//   State<TabBarSliverAppbar> createState() => _TabBarSliverAppbarState();
// }

// class _TabBarSliverAppbarState extends State<TabBarSliverAppbar>
//     with SingleTickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
//   TabController? _control;

//   @override
//   Widget build(BuildContext context) {
//     final styles = Mytheme.lightTheme(context).textTheme;
//     return DefaultTabController(
//       length: widget.length,
//       child: NestedScrollView(
//         headerSliverBuilder: (context, value) {
//           return [
//             SliverAppBar(
//               backgroundColor: MyAppColor.backgroundColor,
//               leading: SizedBox(),
//               toolbarHeight: widget.toolBarHeight != null
//                   ? double.parse("${widget.toolBarHeight}")
//                   : 60,
//               actions: [
//                 Container(
//                   color: widget.backColor ?? Colors.transparent,
//                   width: MediaQuery.of(context).size.width -
//                       (widget.headColumn != null ? 0 : 16),
//                   margin: widget.headColumn != null
//                       ? const EdgeInsets.all(0)
//                       : const EdgeInsets.only(left: 8.0, top: 20, right: 8),
//                   child: widget.headColumn ?? Search(),
//                 ),
//               ],
//               bottom: Responsive.isDesktop(context) ? widget.tabs : widget.tabs,

//               // flexibleSpace:        ,
//             ),
//           ];
//         },
//         body: TabBarView(
//           physics: BouncingScrollPhysics(),
//           controller: widget.control,
//           children: widget.tabsWidgets,
//         ),
//       ),
//     );
//   }

//   tabBar({tabs}) {
//     return SizedBox(
//       width: 400,
//       child: tabs,
//     );
//   }
// }

// ignore_for_file: must_be_immutable, prefer_const_constructors, unused_local_variable, unnecessary_null_comparison, unused_field

import 'package:flutter/material.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';

class TabBarSliverAppbar extends StatefulWidget {
  Widget? col;

  Widget? sort;
  int length;
  int? toolBarHeight;
  TabBar tabs;
  Color? backColor;

  Widget? headColumn;
  TabController control;
  List<Widget> tabsWidgets;
  TabBarSliverAppbar(
      {Key? key,
      this.col,
      this.sort,
      this.backColor,
      this.toolBarHeight,
      required this.length,
      required this.tabs,
      required this.tabsWidgets,
      this.headColumn,
      required this.control})
      : super(key: key);

  @override
  State<TabBarSliverAppbar> createState() => _TabBarSliverAppbarState();
}

class _TabBarSliverAppbarState extends State<TabBarSliverAppbar>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  TabController? _control;

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme;
    return DefaultTabController(
      length: widget.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              backgroundColor: MyAppColor.backgroundColor,
              leading: SizedBox(),
              toolbarHeight: widget.toolBarHeight != null
                  ? double.parse("${widget.toolBarHeight}")
                  : 60,
              actions: [
                // if (!Responsive.isDesktop(context))  
                Container(
                      color: widget.backColor ?? Colors.transparent,
                      width: MediaQuery.of(context).size.width -
                          (widget.headColumn != null ? 0 : 16),
                      margin: widget.headColumn != null
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.only(left: 8.0, top: 20, right: 8),
                      child: widget.headColumn ?? Search()),
              ],
              bottom: PreferredSize(
                child: Column(
                  children: [
                    // if (!Responsive.isDesktop(context))
                    SizedBox(
                      child: widget.col,
                    ),
                    // if (!Responsive.isDesktop(context))
                    SizedBox(
                      height: 20,
                    ),
                    if (!Responsive.isDesktop(context))
                      if (widget.tabs != null)
                        Container(
                          height: 50,
                          color: Colors.transparent,
                          child: widget.tabs,
                        ),
                    if (Responsive.isDesktop(context))
                      if (widget.tabs != null)
                        Stack(
                          children: [
                            Container(
                              height: 40,
                              color: Colors.transparent,
                              width: Sizeconfig.screenWidth!,
                            ),
                            Positioned(
                              height: 40,
                              left: 50,
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(bottom: 00),
                                padding: EdgeInsets.only(
                                    right: 120, top: 00, bottom: 00),
                                width: Sizeconfig.screenWidth!,
                                color: Colors.transparent,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 47.0, right: 27),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: widget.tabs,
                                      ),
                                      SizedBox(
                                        child: widget.sort,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
                preferredSize:
                    Size.fromHeight(Responsive.isDesktop(context) ? 60 : 80),
              ),
            ),
          ];
        },
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          controller: widget.control,
          children: widget.tabsWidgets,
        ),
      ),
    );
  }

  tabBar({tabs}) {
    return SizedBox(
      width: 400,
      child: tabs,
    );
  }
}
