import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';

class SubscribedListed extends StatefulWidget {
  const SubscribedListed({Key? key}) : super(key: key);

  @override
  State<SubscribedListed> createState() => _SubscribedListedState();
}

class _SubscribedListedState extends State<SubscribedListed> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: CustomAppBar(
        context: context,
        drawerKey: _drawerKey,
        back: "HOME (JOB-SEEKER) / Edit Bank Details  ",
      ),
      body: Container(),
    );
  }
}
