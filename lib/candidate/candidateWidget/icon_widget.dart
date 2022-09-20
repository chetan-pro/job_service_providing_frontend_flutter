// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  String url;
  IconWidget({Key? key,required this.url }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      url,
      width: 22,
      height: 22,
    );
  }
}
