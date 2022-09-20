// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:http/http.dart' as http;

class ResumeView extends StatefulWidget {
  const ResumeView({Key? key}) : super(key: key);

  @override
  State<ResumeView> createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  final ReceivePort _port = ReceivePort();
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  WebViewController? _webViewController;
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      getHtmlData();
    }
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  String? generatedPdfFilePath;

  Future<void> generateExampleDocuments(html) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    String targetFileName =
        "${DateTime.now().millisecondsSinceEpoch}_Hindustan-Job";
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        html, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;
    OpenFile.open('$generatedPdfFilePath')
        .then((value) => print("ggggggggg$value"))
        .catchError((onError) {});
  }

  var htmlData;
  getHtmlData() async {
    EasyLoading.show();
    var data = await http.get(
      Uri.parse("https://admin.hindustaanjobs.com/api/resume-html"),
      headers: {"Authorization": "Bearer ${userData!.resetToken!}"},
    );
    EasyLoading.dismiss();

    htmlData = data.body;
    if (data.statusCode == 200) {
      generateExampleDocuments(htmlData);
    } else {
      showSnack(context: context, msg: "Something went wrong", type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    _completer.future.then((controller) {
      _webViewController = controller;
      Map<String, String> header = {
        'Authorization': 'Bearer ${userData!.resetToken}'
      };
      _webViewController!.loadUrl(
          "https://admin.hindustaanjobs.com/api/resume-html",
          headers: header);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyAppColor.backgroundColor,
        title: Text(
          'Your Resume',
          style: blackBold16,
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: MyAppColor.blackdark)),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => getHtmlData(),
          child: Icon(Icons.download, color: Colors.white, size: 22)),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: WebView(
              debuggingEnabled: true,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) async {
                _completer.complete(controller);
              })),
    );
  }
}
