import 'package:flutter/material.dart';

class TransparentScaffold extends StatelessWidget {
  Widget body;
  TransparentScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10), child: body));
  }
}
