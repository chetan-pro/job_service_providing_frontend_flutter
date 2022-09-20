// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/homeserviceSeeker/search_home_service_list_screen.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

import '../../candidate/pages/job_seeker_page/home/homeappbar.dart';

class SeekerSearch extends ConsumerStatefulWidget {
  bool isUserSubscribed;
  bool isNavigater;
  Function? isProvider;
  SeekerSearch(
      {Key? key,
      required this.isUserSubscribed,
      required this.isNavigater,
      this.isProvider})
      : super(key: key);

  @override
  ConsumerState<SeekerSearch> createState() => _SeekerSearchState();
}

class _SeekerSearchState extends ConsumerState<SeekerSearch> {
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
            text: "Search Home-Services",
            groupValue: group,
            onChanged: (value) => setState(() {
              FocusScope.of(context).unfocus();
              group = value;
            }),
            value: 1,
          ),
          RadioButton(
            text: "Search Home-Services Providers",
            groupValue: group,
            onChanged: (value) => setState(() {
              FocusScope.of(context).unfocus();
              group = value;
            }),
            value: 2,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormFieldWidget(
                type: TextInputType.multiline,
                text: 'Search Services here...',
                control: searchController,
              )),
          InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (widget.isProvider != null) {
                  widget.isProvider!(group == 2 ? true : false);
                }
                var filterData = group == 2
                    ? {"ServiceProviderName": searchController.text.trim()}
                    : {"service_name": searchController.text.trim()};
                if (widget.isNavigater) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchHomeServicesListScreen(
                                isProvider: group == 2 ? true : false,
                                filterData: filterData,
                              )));
                } else {
                  if (group == 1) {
                    ref.read(serviceSeeker).filterServicesAndProviders(context,
                        isProvider: false, filterData: filterData);
                  } else {
                    ref.read(serviceSeeker).filterServicesAndProviders(context,
                        isProvider: true, filterData: filterData);
                  }
                }
              },
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: MyAppColor.orangelight,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0))),
                  child: Text(
                    "Search",
                    style: whiteDarkR12,
                  )))
        ],
      ),
    );
  }
}
