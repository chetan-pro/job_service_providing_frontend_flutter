// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/widget/buttons/outline_buttons.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: MyAppColor.blackdark),
        backgroundColor: MyAppColor.backgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 11),
          child: Row(
            children: [
              Image.asset(
                'assets/drawer.png',
                height: 22,
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                child: Image.asset(
                  'assets/hind.png',
                  height: 35,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                right: 12.0,
                bottom: 5,
              ),
              child: Button(text: Mystring.login),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 13, right: 11, bottom: 9),
                  child: Container(
                    child: Column(
                      children: [
                        Search(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                //_back(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
