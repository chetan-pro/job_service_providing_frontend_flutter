// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:vrouter/vrouter.dart';

class BackWithText extends StatefulWidget {
  String text;
  BackWithText({Key? key, required this.text}) : super(key: key);

  @override
  State<BackWithText> createState() => _BackWithTextState();
}

class _BackWithTextState extends State<BackWithText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: 50,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                if (kIsWeb) {
                  context.vRouter.to(context.vRouter.previousPath!);
                } else {
                  Navigator.pop(context);
                }
              },
              child: Row(children: [
                SizedBox(
                  height: 30,
                  child: CircleAvatar(
                      backgroundColor: MyAppColor.backgray,
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Back",
                  style: TextStyle(
                    color: MyAppColor.blackdark,
                  ),
                ),
              ]),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.text,
              style: TextStyle(
                color: MyAppColor.greylight,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
