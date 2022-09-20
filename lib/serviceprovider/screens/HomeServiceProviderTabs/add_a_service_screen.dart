// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, unused_field, unused_import, unused_local_variable, avoid_print, non_constant_identifier_names, must_be_immutable, prefer_const_constructors_in_immutables, unnecessary_new, unnecessary_null_comparison, sized_box_for_whitespace
import 'dart:io' as i;
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/alldata_get_modal.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/catogory_modal.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/day_provider.dart';
import 'package:hindustan_job/candidate/model/service_categories_model.dart';
import 'package:hindustan_job/candidate/pages/register_page/register_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/ServicesRequests/view_service_request_details_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_profile.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_services_tab.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/category.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/service_provider.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/number_input_text_form_field_widget.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import '../../../candidate/header/back_text_widget.dart';
import '../../../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../../../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../../../widget/common_app_bar_widget.dart';
import '../../../widget/select_file.dart';
import 'service_details_screen.dart';

class AddAServiceScreen extends ConsumerStatefulWidget {
  AllServiceFetch? allservice;

  AddAServiceScreen({Key? key, this.allservice}) : super(key: key);

  @override
  _AddAServiceScreenState createState() => _AddAServiceScreenState();
}

class _AddAServiceScreenState extends ConsumerState<AddAServiceScreen> {
  var listOfDays = [
    LabelString.monday,
    LabelString.tuesday,
    LabelString.wednesday,
    LabelString.thursday,
    LabelString.friday,
    LabelString.saturday,
    LabelString.sunday,
  ];

  var listOfDaysLetters = [
    LabelString.m,
    LabelString.t,
    LabelString.w,
    LabelString.t,
    LabelString.f,
    LabelString.s,
    LabelString.s
  ];

  List<bool?>? _isChecked;

  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceChargesController = TextEditingController();
  var newImageCounter = 0;

  PlatformFile? logo;
  i.File? _image;
  i.File? newprofile;

  List<ServiceDays> day = [];

  List<ServiceDays> days = [];
  ServiceDays? dayss;

  List<Asset> newImages = [];
  List<int> removedImages = [];
  ServiceImages? image;
  List<ServiceImages> imageList = [];
  List<i.File>? imageFile;
  List<PlatformFile> imageFileList = [];
  List<i.File>? _images;
  List<XFile> main_image = [];
  XFile? croppedFile;

  final picker = ImagePicker();
  Uint8List? bytesFromPicker;

  List<ServiceCategories> catogaries = [];
  ServiceCategories? selectcatogary;

  fetchDay() async {
    ApiResponse response = await getDays();
    if (response.status == 200) {
      day = Days.fromJson(response.body!.data).rows!.toList();
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    FilePickerResult filePickerResultList = FilePickerResult(imageFileList);
    String error = 'No Error Detected';

    try {
      if (kIsWeb) {
        filePickerResultList = await selectFile(multi: true);
      } else {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 300,
          enableCamera: true,
          selectedAssets: newImages,
          cupertinoOptions: CupertinoOptions(
            takePhotoIcon: "chat",
            doneButtonTitle: "Fatto",
          ),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Example App",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
      }
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      if (kIsWeb) {
        imageFileList = [...imageFileList, ...filePickerResultList.files];
        final img = imageFileList.map((e) => e.name).toSet();
        imageFileList.retainWhere((element) => img.remove(element.name));
      } else {
        newImages = [...newImages, ...resultList];
        final img = newImages.map((e) => e.name).toSet();
        newImages.retainWhere((element) => img.remove(element.name));
      }
      newImageCounter = 1;
    });
  }

  ServiceCategories? catg;

  fetchcatogary() async {
    catogaries = await categoryData(context);
    setState(() {});
  }

  addServiceField() async {
    List<MultipartFile> multipartImageList = [];
    if (newImages != null && newImages.isNotEmpty) {
      for (Asset asset in newImages) {
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile = new MultipartFile.fromBytes(
          imageData,
          filename: asset.name,
          contentType: MediaType("image", "jpg"),
        );
        multipartImageList.add(multipartFile);
      }
    }
    if (imageFileList != null && imageFileList.isNotEmpty) {
      for (PlatformFile asset in imageFileList) {
        MultipartFile multipartFile = new MultipartFile.fromBytes(
          asset.bytes!,
          filename: asset.name,
          contentType: MediaType("image", "jpg"),
        );
        multipartImageList.add(multipartFile);
      }
    }

    var addService = {
      "service_charge": serviceChargesController.text,
      "service_categories": catg!.id.toString(),
      "days_available": days
          .map(
            (e) => e.id.toString(),
          )
          .join(','),
      "image": multipartImageList,
      "service_name": serviceNameController.text,
      "service_status": 'Y',
    };

    ApiResponse response;
    if (widget.allservice == null) {
      response = await addServices(addService);
    } else {
      addService['service_id'] = widget.allservice!.id.toString();
      addService['remove_images'] = removedImages.join(',');
      response = await updateServiceAll(addService);
    }
    if (response.status == 200) {
      await showSnack(
        context: context,
        msg: response.body!.message,
      );

      if (widget.allservice == null) {
        ref.read(serviceProviderData).getAlldataservice();
        if (kIsWeb) {
          ConnectedRoutes.toHomeServiceProvider(context);
        } else {
          Navigator.pop(context);
        }
      }
    } else if (response.status == 400) {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  setData(AllServiceFetch? allser) {
    serviceNameController.text = allser!.serviceName.toString();
    serviceChargesController.text = allser.serviceCharge.toString();
    if (catogaries.isNotEmpty) {
      catg = allser.serviceCategories!.first;
    }
    if (day.isNotEmpty) {
      days = allser.serviceDays!;
      for (var d in days) {
        var dayList = day.firstWhere((element) => element.id == d.id);
        if (dayList != null) {
          dayList.toogle = true;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    await fetchDay();
    await fetchcatogary();
    DropdownString.category = 'Category';
    if (widget.allservice != null) {
      await setData(widget.allservice);
    }
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(statusBarColor: MyAppColor.backgroundColor),
        child: SafeArea(
            child: Scaffold(
          drawerEnableOpenDragGesture: false,
          backgroundColor: MyAppColor.backgroundColor,
          key: _drawerKey,
          drawer: Drawer(
            child: DrawerJobSeeker(),
          ),
          appBar: !kIsWeb
              ? PreferredSize(
                  child: BackWithText(
                      text: "HOME (HOME-SERVICE-PROVIDER) /ADD A SERVICE"),
                  preferredSize: Size.fromHeight(50))
              : PreferredSize(
                  preferredSize: Size.fromHeight(
                      Responsive.isDesktop(context) ? 150 : 150),
                  child: CommomAppBar(
                    drawerKey: _drawerKey,
                  ),
                ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isDesktop(context) ? 365 : 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 40 : 20,
                    ),
                    Text(
                      widget.allservice == null
                          ? LabelString.addaService
                          : 'UPDATE SERVICE',
                      style: blackRegular18,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                        '.   .   .   .   .   .   .   .   .   .   .   .   .'),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width - 760
                          : MediaQuery.of(context).size.width - 20,
                      height: 40,
                      color: MyAppColor.greynormal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            LabelString.serviceDetails,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    if (kIsWeb)
                      SizedBox(
                          width: Sizeconfig.screenWidth! / 1.9,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: TextFormFieldWidget(
                                    type: TextInputType.multiline,
                                    text: "Service Name",
                                    control: serviceNameController,
                                  ),
                                )),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: NumberTextFormFieldWidget(
                                    isRequired: true,
                                    type: TextInputType.number,
                                    control: serviceChargesController,
                                    text: "Specify Service charges (in ₹)",
                                  ),
                                )),
                              ])),
                    if (!kIsWeb)
                      TextFormFieldWidget(
                        type: TextInputType.multiline,
                        text: "Service Name",
                        control: serviceNameController,
                      ),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 40 : 10,
                    ),
                    DynamicDropDownListOfFields(
                        label: DropdownString.category,
                        dropDownList: catogaries,
                        selectingValue: catg,
                        setValue: (value) {
                          if (DropdownString.category != value) {
                            catg = catogaries
                                .firstWhere((element) => element.name == value);
                          }
                        }),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 40 : 20,
                    ),
                    if (!kIsWeb)
                      NumberTextFormFieldWidget(
                        isRequired: true,
                        type: TextInputType.number,
                        control: serviceChargesController,
                        text: "Specify Service charges (in ₹)",
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('.   .   .   .   .   .   .   .   .   .   .   .   .'),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width - 760
                          : MediaQuery.of(context).size.width - 20,
                      height: 40,
                      color: MyAppColor.greynormal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            LabelString.servicePhotos,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        addImageBoxes(),
                        ...List.generate(
                            widget.allservice != null
                                ? widget.allservice!.serviceImages!.length
                                : 0,
                            (index) => urlImageBoxes(index,
                                id: widget.allservice!.serviceImages![index].id,
                                url: widget
                                    .allservice!.serviceImages![index].image)),
                        ...List.generate(
                            kIsWeb ? imageFileList.length : newImages.length,
                            (index) => imageBoxes(index))
                      ],
                    ),
                    Responsive.isMobile(context)
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    const Text(
                        '.   .   .   .   .   .   .   .   .   .   .   .   .'),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width - 760
                            : MediaQuery.of(context).size.width - 20,
                        height: 40,
                        color: MyAppColor.greynormal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                Responsive.isDesktop(context)
                                    ? LabelString.daysAvailableInWeekForBooking
                                    : LabelString
                                        .daysAvailableInWeekForBookingMobile,
                                textAlign: TextAlign.center)
                          ],
                        )),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width - 760
                          : MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: List.generate(
                          day.length,
                          (index) {
                            return Container(
                              margin: EdgeInsets.only(right: 5, bottom: 8),
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              alignment: Alignment.center,
                              height: 84,
                              width: 90,
                              color: MyAppColor.whiteNormal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onChanged: (bool? value) {
                                        setState(
                                          () {
                                            day[index].toogle = value!;

                                            if (value == true) {
                                              days.add(
                                                day[index],
                                              );
                                            } else {
                                              days.removeWhere((element) =>
                                                  element.id == day[index].id);
                                            }
                                            setState(() {});
                                          },
                                        );
                                      },
                                      activeColor: MyAppColor.orangelight,
                                      value: day[index].toogle,
                                    ),
                                  ),
                                  Text(
                                    day[index].dayName.toString(),
                                    style: blackdarkM12,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Responsive.isDesktop(context)
                        ? const Text(
                            '_____________________________________________________________')
                        : const Text(
                            '___________________________________________________'),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 220,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: MyAppColor.orangelight,
                          ),
                          onPressed: () async {
                            await addServiceField();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4, left: 4),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.allservice == null
                                    ? LabelString.addService
                                    : 'Update',
                                style: whiteR14(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 40,
                    ),
                  ],
                ),
              ),
              Footer()
            ],
          ),
        )));
  }

  dummyListDays() {
    return Container(
      alignment: Alignment.center,
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width - 760
          : MediaQuery.of(context).size.width,
      child: Wrap(
        children: List.generate(
          7,
          (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                height: 84,
                width: 84,
                color: MyAppColor.whiteNormal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (bool? value) {
                          setState(
                            () {},
                          );
                        },
                        activeColor: MyAppColor.orangelight,
                        value: true,
                      ),
                    ),
                    Text(
                      listOfDaysLetters[index],
                      style: blackdarkM12,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      listOfDays[index],
                      style: grey12,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  containerWhiteDropDown({label1, label2}) {
    return Responsive.isDesktop(context)
        ? SizedBox(
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        color: MyAppColor.white,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                'City',
                                style: blackMedium14,
                              ),
                              items: <String>['City', 'B', 'C', 'D']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),
                          ),
                        )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        color: MyAppColor.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                'State',
                                style: blackMedium14,
                              ),
                              items: <String>['State', 'B', 'C', 'D']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 40,
                    width: Responsive.isDesktop(context)
                        ? 370
                        : MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.centerLeft,
                    color: MyAppColor.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(
                            'State',
                            style: blackMedium14,
                          ),
                          isExpanded: true,
                          items: <String>['State', 'B', 'C', 'D']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: 40,
                    width: Responsive.isDesktop(context)
                        ? 370
                        : MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.centerLeft,
                    color: MyAppColor.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                'City',
                                style: blackMedium14,
                              ),
                              items: <String>['City', 'B', 'C', 'D']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
  }

  addImageBoxes() {
    return Container(
        height: Sizeconfig.screenHeight! / 5,
        width: Responsive.isMobile(context)
            ? Sizeconfig.screenWidth! / 2.5
            : Sizeconfig.screenWidth! / 16,
        decoration: BoxDecoration(color: MyAppColor.greynormal),
        child: InkWell(
          onTap: loadAssets,
          child: Icon(
            Icons.camera_alt_outlined,
            size: 30,
          ),
        ));
  }

  urlImageBoxes(index, {url, id}) {
    return Container(
      height: Sizeconfig.screenHeight! / 5,
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth! / 2.5
          : Sizeconfig.screenWidth! / 16,
      decoration: BoxDecoration(color: MyAppColor.greynormal),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            currentUrl(url),
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 0,
            right: 2,
            child: InkWell(
                onTap: () {
                  setState(() {
                    removedImages
                        .add(widget.allservice!.serviceImages![index].id!);
                    widget.allservice!.serviceImages!.removeAt(index);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: MyAppColor.blackdark),
                  child: Icon(
                    Icons.cancel,
                    color: MyAppColor.greynormal,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  imageBoxes(index, {url}) {
    return Container(
      height: Sizeconfig.screenHeight! / 5,
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth! / 2.5
          : Sizeconfig.screenWidth! / 16,
      decoration: BoxDecoration(color: MyAppColor.greynormal),
      child: Stack(
        alignment: Alignment.center,
        children: [
          kIsWeb
              ? Image.memory(
                  imageFileList[index].bytes!,
                  width: 144,
                  height: 144,
                )
              : AssetThumb(
                  asset: newImages[index],
                  width: 144,
                  height: 144,
                ),
          Positioned(
            top: 0,
            right: 2,
            child: InkWell(
                onTap: () {
                  setState(() {
                    kIsWeb
                        ? imageFileList.removeAt(index)
                        : newImages.removeAt(index);
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: MyAppColor.blackdark),
                    child: Icon(
                      Icons.cancel,
                      color: MyAppColor.greynormal,
                    ))),
          ),
        ],
      ),
    );
  }

  completeYourProfileDetails() {
    return Container(
        color: MyAppColor.lightBlue,
        height: 87,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 30,
              width: 30,
              color: Colors.white,
            ),
            Text(
                'Complete your Profile for better \nPlacing for Service Searches and to \nget better Service Requests.',
                style: whiteM12()),
            Icon(
              Icons.arrow_forward,
              color: MyAppColor.white,
            )
          ],
        ));
  }
}
