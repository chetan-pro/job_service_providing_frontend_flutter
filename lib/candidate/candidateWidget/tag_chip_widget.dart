// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  String text;
  Function? onTap;
  TagChip({Key? key, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff755F55),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 14,
            child: Icon(
              Icons.edit,
              size: 18.0,
              color: Color(0xff755F55),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onTap!();
            },
            child: const Icon(
              Icons.clear,
              size: 18.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
