import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hindustan_job/candidate/model/Company/chart_bar.dart';

class ChartbarWidget extends StatelessWidget {
  List<HiredApplication>? data;

  ChartbarWidget({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<HiredApplication, String>> series = [
      charts.Series(
        id: 'Hired',
        data: data!,
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (HiredApplication sales, _) => sales.year!,
        measureFn: (HiredApplication sales, _) => sales.sale,
      )
    ];
    return charts.BarChart(
      series,
      animate: true,
    );
  }
}
