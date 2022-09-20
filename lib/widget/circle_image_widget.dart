import 'package:flutter/material.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class CircleImage extends StatelessWidget {
  String image;
  double width;
  CircleImage({Key? key, required this.image,this.width=45}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: MyAppColor.white, shape: BoxShape.circle),
      child: Container(
        width: width,
        height:width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("${currentUrl(image)}"), fit: BoxFit.cover),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
