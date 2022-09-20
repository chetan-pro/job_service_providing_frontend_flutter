import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/search/searchcompany.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

class CandidateSearch extends ConsumerStatefulWidget {
  bool isNavigate;
  bool isNotApplied;
  bool isUserSubscribed;
  CandidateSearch(
      {Key? key,
      this.isNavigate = false,
      this.isNotApplied = false,
      required this.isUserSubscribed})
      : super(key: key);

  @override
  ConsumerState<CandidateSearch> createState() => _CandidateSearchState();
}

class _CandidateSearchState extends ConsumerState<CandidateSearch> {
  int group = 1;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 6),
      color: MyAppColor.greynormal,
      child: Column(
        children: [
          RadioButton(
            text: "Search by name",
            groupValue: group,
            onChanged: (value) => setState(() {
              FocusScope.of(context).unfocus();
              group = value;
            }),
            value: 1,
          ),
          RadioButton(
            text: "Search by Mobile Number",
            groupValue: group,
            onChanged: (value) => setState(() {
              FocusScope.of(context).unfocus();
              group = value;
            }),
            value: 2,
          ),
          RadioButton(
            text: "Search by Email",
            groupValue: group,
            onChanged: (value) => setState(() {
              FocusScope.of(context).unfocus();
              group = value;
            }),
            value: 3,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormFieldWidget(
                type: group == 1
                    ? TextInputType.multiline
                    : group == 2
                        ? TextInputType.number
                        : TextInputType.emailAddress,
                text: 'Search Applicants here...',
                control: searchController,
              )),
          InkWell(
              onTap: () {
                var key = group == 1
                    ? 'name'
                    : group == 2
                        ? 'mobile_no'
                        : 'email';
                FocusScope.of(context).unfocus();
                if (widget.isNavigate) {
                  if (widget.isNotApplied) {
                    ref.read(jobData).fetchJobAppliedCandidates(context,
                        filterData: {
                          key: searchController.text.trim(),
                          "candidate": "NOT_APPLIED",
                        },
                        page: 1);
                  } else {
                    ref.read(jobData).fetchJobAppliedCandidates(context,
                        filterData: {key: searchController.text.trim()},
                        page: 1);
                  }
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchCompany(
                                isUserSubscribed: widget.isUserSubscribed,
                                data: {key: searchController.text.trim()},
                              )));
                }
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: MyAppColor.orangelight,
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  child: Text(
                    "Search",
                    style: whiteDarkR12,
                  )))
        ],
      ),
    );
  }
}
