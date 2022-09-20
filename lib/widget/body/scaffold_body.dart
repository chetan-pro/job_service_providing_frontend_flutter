import 'package:flutter/material.dart';
import 'package:hindustan_job/constants/colors.dart';

class ScaffoldBody extends StatefulWidget {
  Widget body;
  ScaffoldBody({Key? key, required this.body}) : super(key: key);

  @override
  _ScaffoldBodyState createState() => _ScaffoldBodyState();
}

class _ScaffoldBodyState extends State<ScaffoldBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        body: widget.body,
      ),
    );
  }
}
