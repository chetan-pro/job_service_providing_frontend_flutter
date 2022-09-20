import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  List<Widget> children;
  RowWidget({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
