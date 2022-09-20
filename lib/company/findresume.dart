import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/buttons/elevated_button.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';

class FindResume extends StatefulWidget {
  const FindResume({Key? key}) : super(key: key);

  @override
  State<FindResume> createState() => _FindResumeState();
}

class _FindResumeState extends State<FindResume> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text(
                      'Resume Access',
                      style: Mytheme.lightTheme(context)
                          .textTheme
                          .headline1!
                          .copyWith(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              _jobsTitleHere(),
              for (var i = 0; i < 5; i++) _location(context),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 40,
                // width: Sizeconfig.screenHeight! / 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MyAppColor.orangedark,
                  ),
                  child: ElavatedButtons(
                    func: () {},
                    myHexColor: MyAppColor.orangedark,
                    text: 'FIND RESUME',
                    // myHexColor: MyAppColor.orangelight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _location(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: Responsive.isMobile(context) ? 46 : 35,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            child: DropdownButton<String>(
              value: DropdownString.location,
              icon: IconFile.arrow,
              iconSize: 25,
              elevation: 16,
              style: TextStyle(color: MyAppColor.blackdark),
              underline: Container(
                height: 3,
                width: MediaQuery.of(context).size.width,
                color: MyAppColor.blackdark,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  DropdownString.location = newValue!;
                });
              },
              items: ListDropdown.locations
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.grey[400], fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Padding _jobsTitleHere() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: TextfieldWidget(
        text: 'Jobs Keywords here..',
      ),
    );
  }
}
