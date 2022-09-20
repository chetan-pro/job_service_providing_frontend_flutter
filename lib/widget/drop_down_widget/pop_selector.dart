import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/skill_sub_category_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/drop_down_widget/pop_picker.dart';

class PopSelector extends ConsumerStatefulWidget {
  String title;
  var list;
  var allreadySelected;
  PopSelector(
      {Key? key,
      required this.title,
      required this.list,
      this.allreadySelected});

  @override
  _PopSelectorState createState() => _PopSelectorState();
}

class _PopSelectorState extends ConsumerState<PopSelector> {
  var dataList = [];
  @override
  void initState() {
    super.initState();
    dataList = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: MyAppColor.backgroundColor.withOpacity(0.3),
          alignment: Alignment.center,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: MyAppColor.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getCapitalizeString(widget.title),
                            style: blackDarkSemiBold16),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, widget.allreadySelected);
                          },
                          child: Icon(
                            Icons.cancel,
                            size: 20,
                            color: theme.indicatorColor,
                          ),
                        )
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (val) async {
                      dataList = widget.list
                          .where((element) => element.name
                              .toString()
                              .toUpperCase()
                              .startsWith(val.toUpperCase()))
                          .toList();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      enabledBorder: new OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.indicatorColor, width: 1),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.indicatorColor, width: 1),
                      ),
                      labelText: 'Search',
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                      labelStyle: blackDarkR16,
                    ),
                    style: blackDarkR16,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        dataList.length,
                        (index) => Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      List<SubSkill> subSkill = await ref
                                          .read(listData)
                                          .fetchSubSkills(
                                              context, dataList[index].id);
                                      for (var element in subSkill) {
                                        var sub = widget.allreadySelected
                                            .where((el) => el.id == element.id);

                                        if (sub.isNotEmpty) {
                                          element.isSelected = true;
                                          element.resumeSkillId =
                                              sub.first.resumeSkillId;
                                        } else {
                                          element.isSelected = false;
                                        }
                                      }
                                      await showDialog(
                                          context: context,
                                          builder: (_) => PopPicker(
                                              title: 'Title',
                                              list: subSkill,
                                              allReadySelected:
                                                  widget.allreadySelected,
                                              flag: 'skill'));
                                    },
                                    child: SizedBox(
                                      width: size.width * 0.8 - 70,
                                      child: Text(
                                        "${dataList[index].name}",
                                        // "dataList[index].name",
                                        style: blackDarkR16,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, widget.allreadySelected);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: MyAppColor.orangelight,
                      ),
                      child: Text(
                        'Done',
                        style: whiteRegularGalano12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }
}
