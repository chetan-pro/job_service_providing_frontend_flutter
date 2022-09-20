import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/create_job_post.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';

import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class OpenJobBox extends StatelessWidget {
  final JobsTwo job;

  OpenJobBox({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Container(
        margin: EdgeInsets.only(
          left: Responsive.isDesktop(context) ? 12 : 00,
        ),
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width / 4.7
            : 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[300],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateJobPost(jobsEditId: job.id.toString())));
                  },
                  child: Container(
                    height: 20,
                    color: MyAppColor.backgray,
                    child: const Icon(
                      Icons.more_vert,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 10 : 6,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isMobile(context) ? 20 : 10,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/bag_icn.png',
                          width: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          job.jobStatus == JobStatus.open
                              ? "Open Job"
                              : "Close Job",
                          style: const TextStyle(
                              fontSize: 8,
                              color: Colors.brown,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 10 : 8,
                    ),
                    Text('${job.jobTitle}',
                        style: !Responsive.isDesktop(context)
                            ? BlackDarkSb18()
                            : blackDarkSb14()),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 12 : 7,
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        HashTag(text: "${job.jobRoleType!.name}"),
                        HashTag(text: "${job.industry!.name}"),
                        HashTag(text: "${job.sector!.name}")
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 14 : 13,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "${formatDate(job.createdAt)}",
                                  style: !Responsive.isDesktop(context)
                                      ? blackDarkSb12()
                                      : blackDarkSb9(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'view details',
                                  style: !Responsive.isDesktop(context)
                                      ? orangeDarkSb12()
                                      : orangeDarkSb9(),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: MyAppColor.orangedark,
                                  size: Responsive.isMobile(context) ? 14 : 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Text(
                            '${checkNullOverValueName(job.city)} ${checkNullOverValueName(job.state)}',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb12()
                                : blackDarkSb9(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 30,
              color: MyAppColor.simplegrey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Application Received",
                      style: const TextStyle(fontSize: 11),
                    ),
                    Text(
                      "${job.applyCount}",
                      style: !Responsive.isDesktop(context)
                          ? blackDarkM16()
                          : blackDarkM12(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
