// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/widget/cards/dynamic_job_card_widget.dart';
import 'package:hindustan_job/widget/drop_down_widget/text_drop_down_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/landing_page_widget/latest_goverment_job.dart';

class OfferingByCompany extends StatefulWidget {
  List<JobsTwo> jobs;
  OfferingByCompany({Key? key, required this.jobs}) : super(key: key);

  @override
  _OfferingByCompanyState createState() => _OfferingByCompanyState();
}

class _OfferingByCompanyState extends State<OfferingByCompany> {
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    return ListView(
      children: [
        if (!Responsive.isDesktop(context)) sortBY(styles),
        if (Responsive.isDesktop(context)) sortBY(styles),
        !Responsive.isDesktop(context)
            ? Column(
                children: List.generate(
                    widget.jobs.length,
                    (index) => DynamicJobCard(
                        job: widget.jobs[index], cardState: CardState.offer)))
            : Center(
                child: Wrap(
                    runSpacing: 15,
                    children: List.generate(
                        widget.jobs.length,
                        (index) => DynamicJobCard(
                            job: widget.jobs[index],
                            cardState: CardState.offer)))),
        SizedBox(
          height: Sizeconfig.screenHeight! / 20,
        ),
        Footer(),
        Container(
          alignment: Alignment.center,
          color: MyAppColor.normalblack,
          height: 30,
          width: double.infinity,
          child: Text(Mystring.hackerkernel,
              style: Mytheme.lightTheme(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: MyAppColor.white)),
        ),
      ],
    );
  }

  String sortValue = 'Sort by relevance';
  Padding sortBY(TextTheme styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppDropdownInput(
            hintText: "Sort by relevance",
            options: ['Ascending', 'Descending'],
            value: sortValue,
            changed: (String value) async {
              sortValue = value;
              setState(() {});
            },
            getLabel: (String value) => value,
          )
        ],
      ),
    );
  }
}
