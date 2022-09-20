// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/checkbox/customchekbox.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hindustan_job/widget/serchfield_candidate_box.dart';

class SearchJobjobSeeker extends StatefulWidget {
  const SearchJobjobSeeker({Key? key}) : super(key: key);

  @override
  _SearchJobjobSeekerState createState() => _SearchJobjobSeekerState();
}

class _SearchJobjobSeekerState extends State<SearchJobjobSeeker> {
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(item, style: blackDarkOpacityM12()),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: SizedBox(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<int> _getDividersIndexes() {
    List<int> _dividersIndexes = [];
    for (var i = 0; i < (ListDropdown.salutations.length * 2) - 1; i++) {
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _dividersIndexes.add(i);
      }
    }
    return _dividersIndexes;
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool _isSelected = false;
  int val = -1;
  double start = 40.0;
  double end = 60.0;

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: _appbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                serchJobDesktop(context),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 50, right: 20, top: 20),
                    margin: const EdgeInsets.only(left: 40, right: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: paddingAll10,
                          color: MyAppColor.simplegrey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Filters',
                                style: blackDarkR12(),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Clear all Filters',
                                    style: blackdarkM10,
                                  ),
                                  const Icon(
                                    Icons.clear,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          color: MyAppColor.graydf,
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            backgroundColor: MyAppColor.graydf,
                            title: Text(
                              'JOB INDUSTRY',
                              style: blackDarkR16,
                            ),
                            children: [
                              CustomcheckBox(
                                  term: '',
                                  label: 'ALL Memories',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Design',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  })
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        filtersClear(text: 'JOB SECTOR', childrens: [
                          RadioButton(
                              groupValue: val,
                              text: 'All',
                              value: 1,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Government Jobs',
                              value: 2,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Private Jobs',
                              value: 3,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              })
                        ]),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          color: MyAppColor.graydf,
                          child: ExpansionTile(
                            title: const Text('EXPERIENCE REQUIRED'),
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.orange,
                                  thumbColor: Colors.black12,
                                ),
                                child: RangeSlider(
                                  inactiveColor: MyAppColor.white,
                                  activeColor: MyAppColor.orangelight,
                                  values: RangeValues(start, end),
                                  labels: RangeLabels(
                                      start.toString(), end.toString()),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        start = value.start;
                                        end = value.end;
                                      },
                                    );
                                  },
                                  min: 10.0,
                                  max: 80.0,
                                ),
                              ),
                              Text(
                                "₹ 3.56 -  "
                                "8.46 Lakh per Annum: ",
                                style: blackDarkR12(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          color: MyAppColor.graydf,
                          child: ExpansionTile(
                            title: Text(
                              'JOB LOCATION',
                              style: blackDarkR16,
                            ),
                            children: [
                              CustomcheckBox(
                                  term: '',
                                  label: 'ALL Memories',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'ALL Memories',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'ALL Memories',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              SizedBox(
                                height: 38,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40.0, right: 25),
                                  child: TextFormField(
                                    maxLines: 01,
                                    decoration: InputDecoration(
                                        suffixIcon: const Icon(
                                          Icons.search,
                                          size: 16,
                                        ),
                                        hoverColor: MyAppColor.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          borderSide: const BorderSide(
                                              color: Colors.white70),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Search City to Add',
                                        hintStyle:
                                            !Responsive.isDesktop(context)
                                                ? blackDarkOpacityM14()
                                                : blackDarkOpacityR12(),
                                        contentPadding: const EdgeInsets.only(
                                            top: 2,
                                            left: 15,
                                            right: 8,
                                            bottom: 10)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          color: MyAppColor.graydf,
                          child: ExpansionTile(
                            title: Text(
                              'SKILLS REQUIRED',
                              style: blackDarkR16,
                            ),
                            children: [
                              CustomcheckBox(
                                  term: '',
                                  label: 'ALL Memories',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Design',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  }),
                              CustomcheckBox(
                                  term: '',
                                  label: 'Software Engineering',
                                  padding: paddingAllver5,
                                  value: _isSelected,
                                  onChanged: (bool newvalue) {
                                    setState(() {
                                      _isSelected = newvalue;
                                    });
                                  })
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        filtersClear(text: 'EXPERIENCE REQUIRED', childrens: [
                          RadioButton(
                              groupValue: val,
                              text: 'All',
                              value: 1,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Government Jobs',
                              value: 2,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Private Jobs',
                              value: 3,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              })
                        ]),
                        const SizedBox(
                          height: 2,
                        ),
                        filtersClear(text: 'WORK FROM HOME', childrens: [
                          RadioButton(
                              groupValue: val,
                              text: 'All',
                              value: 1,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Government Jobs',
                              value: 2,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Private Jobs',
                              value: 3,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              })
                        ]),
                        const SizedBox(
                          height: 2,
                        ),
                        filtersClear(text: 'EMPLOYMENT TYPE', childrens: [
                          RadioButton(
                              groupValue: val,
                              text: 'All',
                              value: 1,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Government Jobs',
                              value: 2,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Private Jobs',
                              value: 3,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              })
                        ]),
                        const SizedBox(
                          height: 2,
                        ),
                        filtersClear(text: 'CONTRACT TYPE', childrens: [
                          RadioButton(
                              groupValue: val,
                              text: 'All',
                              value: 1,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Government Jobs',
                              value: 2,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Private Jobs',
                              value: 3,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              })
                        ]),
                        const SizedBox(
                          height: 2,
                        ),
                        filtersClear(text: 'WORK SCHEDULE', childrens: [
                          RadioButton(
                              groupValue: val,
                              text: 'All',
                              value: 1,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Government Jobs',
                              value: 2,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              }),
                          RadioButton(
                              groupValue: val,
                              text: 'Private Jobs',
                              value: 3,
                              onChanged: (value) {
                                setState(() {
                                  val = value;
                                });
                              })
                        ]),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: paddingvertical15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _customjob(styles),
                            SizedBox(
                              width: Sizeconfig.screenWidth! / 95,
                            ),
                            _resumeBuilder(styles)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              // SizedBox(
                              //   width: Sizeconfig.screenWidth! / 20,
                              // ),
                              const Text(
                                'Search Result for "Motion Designer',
                              ),
                            ],
                          ),
                          const Text('f'),
                          Row(
                            children: [
                              const Icon(
                                Icons.expand_more,
                              ),
                              const Text(
                                'Sort by Relevance',
                              ),
                              // SizedBox(
                              //   width: Sizeconfig.screenWidth! / 25,
                              // ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      ),
                      SizedBox(
                        height: Sizeconfig.screenHeight! / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 95,
                          ),
                          SearchCard(),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(width: Sizeconfig.screenWidth! / 20)
              ],
            ),
            SizedBox(height: Sizeconfig.screenWidth! / 30),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget checkboxFilter({
    bool? selected,
    String? labes,
    Function? func,
  }) {
    return CustomcheckBox(
        label: labes!,
        term: '',
        padding: const EdgeInsets.all(5),
        value: selected!,
        onChanged: (newValue) {
          func!();
        });
  }

  Widget filtersClear({List<Widget>? childrens, String? text}) {
    return Container(
      color: MyAppColor.graydf,
      child: ExpansionTile(
        title: Text(
          text!,
          style: blackDarkR16,
        ),
        children: childrens!,
      ),
    );
  }

  Widget _menu() {
    return Container(
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 3 : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.orangelight,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Job-seeker Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.orangelight),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service provider",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          color: MyAppColor.normalblack,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service seeker",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.normalblack,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Local Hunar Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.normalblack,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: !Responsive.isDesktop(context) ? 120 : 58,
      iconTheme: IconThemeData(color: MyAppColor.blackdark),
      backgroundColor: MyAppColor.backgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _drawerKey.currentState!.openDrawer();
              },
              child: Image.asset(
                'assets/drawers.png',
                height: 18,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                'assets/logosmall.png',
                fit: BoxFit.cover,
              ),
            ),
            if (Responsive.isDesktop(context))
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _menu(),
                ],
              )),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Row(
            children: [
              Image.asset(
                'assets/walleticon.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => NotificationScreen()));
                },
                child: Image.asset(
                  'assets/notificationiocn.png',
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profileIcon.png',
                      height: 36,
                      width: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Column(
          children: [
            if (Responsive.isDesktop(context))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                color: MyAppColor.greynormal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 2,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: !Responsive.isDesktop(context) ? 27 : 22,
                        child: CircleAvatar(
                            backgroundColor: MyAppColor.backgray,
                            child: Icon(
                              Icons.arrow_back,
                              size: !Responsive.isDesktop(context) ? 21 : 18,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: !Responsive.isDesktop(context) ? 3 : 00,
                    ),
                    Text("Back", style: grayLightM12()),
                    SizedBox(
                      width: !Responsive.isDesktop(context) ? 20 : 50,
                    ),
                    Text(
                      'SEARCH RESULT FOR "DESIGNER"',
                      style: blackDarkOpacityM10(),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        preferredSize: const Size.fromHeight(60),
      ),
    );
  }

  Widget serchJobDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: Sizeconfig.screenWidth! / 6,
            height: 35,
            child: TextfieldWidget(
              styles: desktopstyle,
              text: 'Search by job title',
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.selectIndustry,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.selectIndustry = newValue!;
                },
              );
            },
            context: context,
            label: "Select job role",
            listDropdown: ListDropdown.selectIndustries,
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.sector,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.sector = newValue!;
                },
              );
            },
            context: context,
            label: "Select Sector",
            listDropdown: ListDropdown.sectors,
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.location,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.location = newValue!;
                },
              );
            },
            context: context,
            label: "Select Location",
            listDropdown: ListDropdown.locations,
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.experience,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.experience = newValue!;
                },
              );
            },
            context: context,
            label: "Select Expeience",
            listDropdown: ListDropdown.experiences,
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.salery,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.salery = newValue!;
                },
              );
            },
            context: context,
            label: "Salary/Hourly Rate",
            listDropdown: ListDropdown.saleries,
          ),
          const SizedBox(
            width: 5,
          ),
          search(),
        ],
      ),
    );
  }

  Widget customDropdown({
    BuildContext? context,
    List<String>? listDropdown,
    String? label,
    String? selectingValue,
    Function? setdata,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 0),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            autofocus: false,

            iconDisabledColor: MyAppColor.white,
            focusColor: MyAppColor.white,
            buttonElevation: 00,
            icon: IconFile.arrow,
            iconSize: 17,
            isExpanded: true,
            hint: Text(
              // ,
              label!,
              style: blackDarkOpacityR9(),
            ),
            items: _addDividersAfterItems(listDropdown!),
            customItemsIndexes: _getDividersIndexes(),
            customItemsHeight: 4,
            value: selectingValue, style: blackDarkOpacityR9(),
            onChanged: (value) => setdata!(value),
            buttonWidth: !Responsive.isDesktop(context!)
                ? Sizeconfig.screenWidth! / 1.2
                : Sizeconfig.screenWidth! / 9.1,
            buttonPadding: const EdgeInsets.symmetric(horizontal: 0),

            buttonHeight: 40,
            // dropdownDecoration:
            //     BoxDecoration(borderRadius: BorderRadius.circular(50)),            // buttonWidth: 140,
            itemHeight: 40,
            // itemWidth: Sizeconfig.screenWidth,
            //  // itemPadding:
            //       const EdgeInsets.(vertical: 8.0),
          ),
        ),
      ),
    );
  }

  search() {
    return Container(
      padding: const EdgeInsets.all(6),
      height: Sizeconfig.screenHeight! / 20,
      width: Sizeconfig.screenWidth! / 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: MyAppColor.orangelight,
      ),
      child: Image.asset(
        'assets/search_image.png',
        height: 10,
      ),
    );
  }

  Container _resumeBuilder(TextStyle styles) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 4.2
          : Sizeconfig.screenHeight! / 6,
      color: MyAppColor.darkBlue,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Responsive.isMobile(context))
                    Text(
                      'Professional\nResume Builder',
                      textAlign: TextAlign.center,
                      style: whiteSemiBoldGalano16,
                    ),
                  if (Responsive.isDesktop(context))
                    Text(
                      '     Professional  Resume Builder',
                      style: whiteSb16(),
                    ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 15,
                  ),
                  SizedBox(
                    // width: Responsive.isMobile(context)
                    //     ? Sizeconfig.screenWidth! / 2.8
                    //     : Sizeconfig.screenWidth! / 10,

                    child: OutlinedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GET STARTED',
                            style: whiteR12(),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            'assets/get-started-icon.png',
                            height: 16,
                          )
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: MyAppColor.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 00,
            right: 00,
            child: Image.asset(
              'assets/get-started-image-up.png',
              height: 18,
            ),
          ),
          Positioned(
            bottom: 00,
            left: 00,
            child: Image.asset(
              'assets/get-started-image-down.png',
              height: 18,
            ),
          )
        ],
      ),
    );
  }

  Widget _customjob(TextStyle styles) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      height: Responsive.isMobile(context)
          ? Sizeconfig.screenHeight! / 4.2
          : Sizeconfig.screenHeight! / 6,
      color: MyAppColor.orangelight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Responsive.isMobile(context))
                    Text(
                      'Get Free Custom\nJob Alerts',
                      textAlign: TextAlign.center,
                      style: whiteSemiBoldGalano16,
                    ),
                  if (Responsive.isDesktop(context))
                    Text('Get Free Custom Job Alerts', style: whiteSb16()),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 15,
                  ),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GET ALERTS',
                            style: whiteR12(),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            'assets/get-alert-icon.png',
                            height: 16,
                          )
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: MyAppColor.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 00,
            right: 00,
            child: Image.asset(
              'assets/get-alert-image-up.png',
              height: 20,
            ),
          ),
          Positioned(
            bottom: 00,
            left: 00,
            child: Image.asset(
              'assets/get-alert-image-down.png',
              height: 18,
            ),
          )
        ],
      ),
    );
  }
}
