// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/Company/chart_bar.dart';
import 'package:hindustan_job/candidate/model/company_dashboard_model.dart';
import 'package:hindustan_job/company/home/widget/chart_bar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_profile.dart';

class Chart extends ConsumerStatefulWidget {
  List<GraphData> graphData;
  Chart({Key? key, required this.graphData}) : super(key: key);

  @override
  ConsumerState<Chart> createState() => _ChartState();
}

class _ChartState extends ConsumerState<Chart> {
  @override
  void initState() {
    super.initState();
  }

  final List<HiredApplication> data = [
    HiredApplication(id: 1, year: 'jan', sale: 0),
    HiredApplication(id: 2, year: 'feb', sale: 0),
    HiredApplication(id: 3, year: 'mar', sale: 0),
    HiredApplication(id: 4, year: 'april', sale: 0),
    HiredApplication(id: 5, year: 'may', sale: 0),
    HiredApplication(id: 6, year: 'june', sale: 0),
    HiredApplication(id: 7, year: 'july', sale: 0),
    HiredApplication(id: 8, year: 'Aug', sale: 0),
    HiredApplication(id: 9, year: 'Sep', sale: 0),
    HiredApplication(id: 10, year: 'Oct', sale: 0),
    HiredApplication(id: 11, year: 'Nov', sale: 0),
    HiredApplication(id: 12, year: 'Dec', sale: 0),
  ];

  @override
  Widget build(BuildContext context) {
    for (var element in widget.graphData) {
      List<HiredApplication> obj =
          data.where((ele) => ele.id == element.monthCount).toList();
      if (obj.isNotEmpty) {
        obj.first.sale = element.count;
      }
    }
    return Scaffold(
      backgroundColor: MyAppColor.greynormal,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Container(
              height: 400,
              width: Sizeconfig.screenWidth,
              child: ChartbarWidget(data: data),
            ),
          ],
        ),
      ),
    );
  }
}
