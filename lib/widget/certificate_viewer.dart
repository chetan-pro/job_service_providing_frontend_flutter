// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDialog extends StatelessWidget {
  String url;
  // ignore: use_key_in_widget_constructors
  ImageDialog({required this.url});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}
