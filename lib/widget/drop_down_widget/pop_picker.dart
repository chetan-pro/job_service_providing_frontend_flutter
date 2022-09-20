import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/resume_services.dart';

class PopPicker extends ConsumerStatefulWidget {
  String title;
  String flag;
  var list;
  var allReadySelected;
  PopPicker(
      {Key? key,
      required this.title,
      required this.list,
      required this.flag,
      this.allReadySelected});

  @override
  _PopPickerState createState() => _PopPickerState();
}

class _PopPickerState extends ConsumerState<PopPicker> {
  List dataList = [];
  var stateId;
  var ids = [];
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
      List<City> city = ref.watch(listData).city;
      if (widget.flag == 'city') {
        dataList = city;
      }
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: MyAppColor.backgroundColor.withOpacity(0.3),
          alignment: Alignment.center,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: MyAppColor.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.title, style: blackDarkSemiBold16),
                        InkWell(
                          onTap: () {
                            // addItem(index, value);
                            Navigator.pop(context);
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
                      if (widget.flag == 'city') {
                        ref.read(listData).fetchCity(context, name: val);
                      } else {
                        dataList = widget.list
                            .where((element) => element.name
                                .toString()
                                .toUpperCase()
                                .startsWith(val.toUpperCase()))
                            .toList();
                      }
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
                      children: List.generate(dataList.length, (index) {
                        return Row(
                          children: [
                            checkbox(dataList[index].isSelected, index),
                            Container(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SizedBox(
                                      width: size.width * 0.8 - 70,
                                      child: Text(
                                        "${dataList[index].name}",
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
                        );
                      }),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, widget.allReadySelected);
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

  checkbox(isChecked, index) {
    return Container(
      child: Theme(
          data: ThemeData(unselectedWidgetColor: MyAppColor.blackdark),
          child: Checkbox(
            checkColor: MyAppColor.white,
            value: isChecked,
            onChanged: (value) async {
              dataList[index].isSelected = value;
              if (value == true) {
                if (widget.flag == "skill") {
                  dataList[index].rating = '';
                }
                widget.allReadySelected.add(dataList[index]);
              } else {
                if (widget.flag == "skill") {
                  await resumeSkillsDelete(context,
                      id: dataList[index].resumeSkillId);
                }
                widget.allReadySelected.removeWhere(
                    (element) => element.name == dataList[index].name);
              }
              setState(() {});
            },
          )),
    );
  }
}
