import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/header/back_text_widget.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/localHunarAccount/model/local_hunar_video_model.dart';
import 'package:hindustan_job/services/api_services/local_hunar_services.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';
import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../services/services_constant/response_model.dart';
import '../widget/common_app_bar_widget.dart';

class AddVideoScreen extends ConsumerStatefulWidget {
  LocalHunarVideo? localHunarVideo;
  AddVideoScreen({Key? key, this.localHunarVideo}) : super(key: key);
  @override
  ConsumerState<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends ConsumerState<AddVideoScreen> {
  TextEditingController videoTitleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final picker = ImagePicker();
  XFile? pickedVideo;
  ChewieController? chewieController;
  VideoPlayerController? vidPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.localHunarVideo != null) {
      setData();
    }
  }

  setData() {
    videoTitleController.text = widget.localHunarVideo!.title!;
    descriptionController.text = widget.localHunarVideo!.description!;
    videoInitialize();
  }

  videoInitialize() {
    vidPlayerController =
        VideoPlayerController.network(currentUrl(widget.localHunarVideo!.url));
    chewieController = ChewieController(
      videoPlayerController: vidPlayerController!,
      looping: true,
      // aspectRatio: vidPlayerController!.value.aspectRatio,
      autoInitialize: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    if (vidPlayerController != null) {
      vidPlayerController!.dispose();
      chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      resizeToAvoidBottomInset: false,
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: !kIsWeb
          ? PreferredSize(
              child: BackWithText(text: "HOME (LOCAL-HUNAR) /ADD A VIDEO"),
              preferredSize: Size.fromHeight(50))
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(Responsive.isDesktop(context) ? 150 : 150),
              child: CommomAppBar(
                drawerKey: _drawerKey,
                back: "HOME (LOCAL-HUNAR) /ADD A VIDEO",
              ),
            ),
      body: Responsive.isDesktop(context)
          ? Container(
              color: MyAppColor.backgroundColor,
              child: Column(
                children: [
                  SizedBox(
                    height: Sizeconfig.screenHeight! - 150,
                    child: ListView(
                      children: [serviceDetailsTab(context), Footer()],
                    ),
                  )
                ],
              ),
            )
          : Container(
              color: MyAppColor.backgroundColor,
              child: Column(
                children: [
                  SizedBox(
                    height: Sizeconfig.screenHeight! - 215,
                    child: ListView(
                      children: [serviceDetailsTab(context), Footer()],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  backButtonContainer(context) {
    return Container(
        color: MyAppColor.greynormal,
        height: Responsive.isDesktop(context) ? 40 : 40,
        child: Row(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: Responsive.isDesktop(context) ? 40 : 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: Responsive.isMobile(context) ? 25 : 20,
                    child: CircleAvatar(
                      radius: Responsive.isDesktop(context) ? 20.0 : 15,
                      backgroundColor: MyAppColor.backgray,
                      child: Icon(
                        Icons.arrow_back,
                        color: MyAppColor.greylight,
                        size: Responsive.isDesktop(context) ? 20 : 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Responsive.isDesktop(context) ? 20 : 10,
                ),
                Text(
                  LabelString.back,
                  style: grey14,
                ),
                SizedBox(
                  width: Responsive.isDesktop(context) ? 40 : 20,
                ),
                Text(
                  'HOME (HSP) / COMPLETE PROFILE',
                  style: greyMedium10,
                )
              ],
            )
          ],
        ));
  }

  stackUploadVideo() {
    return pickedVideo == null && chewieController == null
        ? Stack(children: [
            Container(
              height: 400,
              color: MyAppColor.greynormal,
            ),
            Positioned.fill(
              child: InkWell(
                onTap: () async {
                  pickedVideo =
                      await picker.pickVideo(source: ImageSource.gallery);
                  if (kIsWeb) {
                    vidPlayerController =
                        VideoPlayerController.network(pickedVideo!.path);
                    chewieController = ChewieController(
                      videoPlayerController: vidPlayerController!,
                      looping: true,
                      autoInitialize: true,
                    );
                    setState(() {});
                  } else {
                    vidPlayerController =
                        VideoPlayerController.file(File(pickedVideo!.path));
                    chewieController = ChewieController(
                      videoPlayerController: vidPlayerController!,
                      looping: true,
                      aspectRatio: vidPlayerController!.value.aspectRatio,
                      autoInitialize: true,
                    );
                    setState(() {});
                  }
                },
                child: Align(
                    alignment: FractionalOffset.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_call_outlined, size: 60),
                        Text(
                          'UPLOAD VIDEO',
                          style: blackRegular12,
                        ),
                      ],
                    )),
              ),
            )
          ])
        : SizedBox(
            height: 400,
            child: Stack(
              children: [
                Chewie(
                  controller: chewieController!,
                ),
                Positioned(
                  top: 3,
                  left: 3,
                  child: IconButton(
                      onPressed: () {
                        pickedVideo = null;
                        chewieController = null;
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 30,
                      )),
                )
              ],
            ),
          );
  }

  headerVideoDetails(context) {
    return Container(
      /// width: Responsive.isDesktop(context) ? 770 : 332,
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width - 20,
      height: 40,
      color: MyAppColor.greyDark,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                child: Text(
              'VIDEO & DETAILS',
              style: titleHeadGrey16,
            ))
          ]),
    );
  }

  serviceDetailsTab(context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? 400 : 10),
      child: Column(children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ADD A LOCAL HUNAR VIDEO',
                  style: Responsive.isDesktop(context)
                      ? titleHeadGrey16
                      : titleHeadGrey14),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text('.   .   .   .   .   .   .   .   .   .   .   .   .'),
        const SizedBox(
          height: 30,
        ),
        //header video details
        headerVideoDetails(context),
        const SizedBox(
          height: 40,
        ),
        //stack
        stackUploadVideo(),
        const SizedBox(
          height: 20,
        ),
        Responsive.isDesktop(context)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2,
                      child: TextFormFieldWidget(
                        type: TextInputType.multiline,
                        control: videoTitleController,
                        text: "Specify Video Title",
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 2,
                      child: TextFormFieldWidget(
                        type: TextInputType.multiline,
                        control: descriptionController,
                        text: "Description",
                      ))
                ],
              )
            :
            //specify video,
            textfieldContainer(context, videoTitleController,
                height: 40.0, text: 'Specify Video Title', bottomPadding: 13.0),
        if (!Responsive.isDesktop(context))
          //descriptino Container,
          textfieldContainer(context, descriptionController,
              maxlines: 3,
              text: 'Description',
              height: 100.0,
              topPadding: 10.0),
        const SizedBox(
          height: 20,
        ),
        Responsive.isDesktop(context)
            ? Text(
                '_______________________________________________________________________________________________________________')
            : Text('________________________________________________________'),
        const SizedBox(
          height: 30,
        ),
        addVideoButton(context),
        const SizedBox(
          height: 40,
        ),
      ]),
    );
  }

  textfieldContainer(context, control,
      {text, maxlines, height, topPadding, bottomPadding}) {
    return Container(
      height: height ?? 30,
      color: MyAppColor.white,
      margin: EdgeInsets.only(top: 20),
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 4.5
          : Sizeconfig.screenWidth!,
      child: TextFormField(
        controller: control,
        onTap: () {},
        style: blackDarkM14(),
        maxLines: maxlines ?? 1,
        // onChanged: (value) =>
        //     onChanged != null ? onChanged!(value) : {},
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide.none,
            //borderSide: const BorderSide(),
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(
              top: topPadding ?? 0,
              left: 8,
              right: 0,
              bottom: bottomPadding ?? 20),
          fillColor: Colors.white,
          filled: true,
          hintText: text,

          hintStyle: !Responsive.isDesktop(context)
              ? blackDarkO40M14
              : blackMediumGalano12,
          // labelText: "$text",
          // labelStyle:
          //     !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M12,
        ),
      ),
    );
  }

  specifyVideoTitleMobileView(context) {
    return Container(
      color: MyAppColor.white,
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 4.5
          : Sizeconfig.screenWidth!,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          /// controller: control,
          onTap: () {},
          style: blackDarkM14(),
          // onChanged: (value) =>
          //     onChanged != null ? onChanged!(value) : {},
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide.none,
              //borderSide: const BorderSide(),
            ),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(top: 0, left: 15, right: 8, bottom: 20),
            fillColor: Colors.white,
            filled: true,
            hintText: 'Specify Video Title',
            hintStyle: !Responsive.isDesktop(context)
                ? blackDarkO40M14
                : blackMediumGalano12,
            // labelText: "$text",
            // labelStyle:
            //     !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M12,
          ),
        ),
      ),
    );
  }

  onPressed(cont) async {
    Map<String, dynamic> carryData = {
      'title': videoTitleController.text,
      'description': descriptionController.text
    };
    if (pickedVideo == null && widget.localHunarVideo == null) {
      return showSnack(context: cont, msg: "Select Video", type: 'error');
    }

    if (pickedVideo != null) {
      var imageData;
      EasyLoading.show();
      if (kIsWeb) {
        imageData = await pickedVideo!.readAsBytes().then((value) => value);
      }
      carryData["video"] = kIsWeb
          ? MultipartFile.fromBytes(imageData, filename: pickedVideo!.name)
          : await MultipartFile.fromFile(pickedVideo!.path,
              filename: pickedVideo!.path.toString().split('/').last);
      carryData['length'] =
          vidPlayerController!.value.duration.toString().split('.').first;
    }
    if (widget.localHunarVideo != null) {
      carryData['video_id'] = widget.localHunarVideo!.id;
    }
    ApiResponse response = widget.localHunarVideo != null
        ? await editLocalHunarVideo(
            body: carryData, id: widget.localHunarVideo!.id)
        : await addLocalHunarvideo(carryData);
    if (response.status == 200) {
      EasyLoading.dismiss();
      ref.read(localHunarProvider).getMyLocalHunarVideo();
      if (kIsWeb && context.vRouter.previousPath != null) {
        context.vRouter.to(context.vRouter.previousPath!);
      } else {
        Navigator.pop(cont);
      }
    }
  }

  Widget addVideoButton(context) {
    return ElevatedButton(
        onPressed: () {
          onPressed(context);
        },
        style: ElevatedButton.styleFrom(
          primary: MyAppColor.orangelight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.localHunarVideo == null ? 'SUBMIT VIDEO' : 'UPDATE VIDEO',
            textAlign: TextAlign.center,
            style: Responsive.isDesktop(context) ? whiteR14() : whiteR12(),
          ),
        ));
  }
}
