import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrlLauncherWidget extends StatelessWidget {
  String url;
  UrlLauncherWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyAppColor.backgroundColor,
          elevation: 0.0,
          title: Text(
            "Company Website",
            style: black16,
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: MyAppColor.blackdark,
              )),
        ),
        body: WebView(
          initialUrl: url,
        ));
  }
}
