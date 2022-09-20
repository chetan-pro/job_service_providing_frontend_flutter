//get capital String

// ignore_for_file: avoid_types_as_parameter_names, unnecessary_new, prefer_const_constructors
import 'package:device_info/device_info.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vrouter/vrouter.dart';
// import 'dart:html' as html;

import 'package:permission_handler/permission_handler.dart';

import '../candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import '../candidate/pages/landing_page/home_page.dart';

final picker = ImagePicker();

String getCapitalizeString(str) {
  if (str == null) return '';
  if (str.length <= 1) {
    return str.toUpperCase();
  }
  return '${str[0].toUpperCase()}${str.substring(1)}';
}

//toast message
toast(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.grey[850],
      textColor: Colors.white70,
      fontSize: 16);
}

showSnack({context, msg, type}) {
  var snackBar = SnackBar(
    content: Text(
      msg,
      style: TextStyle(color: Colors.white, fontSize: 15),
    ),
    backgroundColor: type == 'error' ? Colors.red : Colors.green,
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool checkPassword(context, {password, confirmPassword}) {
  if (password == '') {
    showSnack(context: context, msg: "Enter password", type: 'error');
    return true;
  } else if (confirmPassword == '') {
    showSnack(context: context, msg: "Enter confirm password", type: 'error');
    return true;
  } else if (password.length < 6) {
    showSnack(
        context: context,
        msg: "Password is not less than 6 digits",
        type: 'error');
    return true;
  } else if (password != confirmPassword) {
    showSnack(context: context, msg: "Password not matched", type: 'error');
    return true;
  }
  return false;
}

bool checkEmail(contxt, {email}) {
  if (isEmpty(email)) {
    // showSnack(context: contxt, msg: "Enter email", type: 'error');
    return true;
  } else if (!EmailValidator.validate(email.trim())) {
    // showSnack(context: contxt, msg: "Email is not valid", type: 'error');
    return true;
  }
  return false;
}

bool isEmpty(value) {
  return value == '' ? true : false;
}

currentUrl(dataPost) {
  var img = dataPost;
  if (img == null || img == '') {
    return "https://i.stack.imgur.com/l60Hf.png";
  } else if (img.startsWith('http') || img.startsWith('https')) {
    return img;
  } else if (img.startsWith('/assets')) {
    return "https://admin.hindustaanjobs.com" + img;
  } else if (img.startsWith('assets')) {
    return "https://admin.hindustaanjobs.com/" + img;
  } else if (img.startsWith('..')) {
    return "https://admin.hindustaanjobs.com" + img.split('public').last;
  } else if (img != null && img.isNotEmpty) {
    if (img.startsWith('http') && img.startsWith('https')) {
      return img;
    } else if (img.startsWith('localhost')) {
      img = img.split('/').last;
      return imageUrl + img;
    } else {
      return imageUrl + img;
    }
  }
  return null;
}

currentCertificateUrl(dataPost, {type}) {
  var img = dataPost;
  if (img.startsWith('..')) {
    return "https://admin.hindustaanjobs.com" + img.split('public').last;
  } else if (img != null && img.isNotEmpty) {
    if (img.startsWith('http') && img.startsWith('https')) {
      return offerletter + img.split('/').last;
    } else if (img.startsWith('localhost')) {
      img = img.split('/').last;
      return (type != null && type == 'resume'
              ? resumeUrl
              : type != null && type == 'offer_letter'
                  ? offerletter
                  : certificateUrl) +
          img;
    } else {
      return (type != null && type == 'resume'
              ? resumeUrl
              : type != null && type == 'offer_letter'
                  ? offerletter
                  : certificateUrl) +
          img;
    }
  }
  return null;
}

checkUserValue(value) {
  if (value != null && value.isNotEmpty) {
    return value;
  } else {
    return '';
  }
}

checkValueAddNull(value) {
  return value == null || value == 'null' || value == ''
      ? null
      : double.parse("$value");
}

boolValueAddNull(value) {
  return value == null || value == 'null' || value == '' ? false : true;
}

checkUserLocationValue(value) {
  if (value != null && value.name != null) {
    return value.name;
  } else {
    return '';
  }
}

isFormValid(_formKey) {
  _formKey.currentState!.save();
  return _formKey.currentState!.validate();
}

bool hasValidUrl(url) {
  if (!url.toString().contains('http') && url.toString().startsWith('www')) {
    url = "https://" + url;
  }
  url = url + '/';
  Uri uri = Uri.parse(url);
  if (!uri.isAbsolute) {
    return true;
  }
  return false;
}

nullCheckValue(value) {
  return value ?? '';
}

//alert box pop up
alertBox(context, message, {route, title, hideNo}) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: AlertDialog(
        backgroundColor: MyAppColor.backgroundColor,
        elevation: 10,
        title: Text(
          title,
          style: TextStyle(color: MyAppColor.blackdark, fontSize: 18),
        ),
        content: Text(message, style: TextStyle(color: MyAppColor.blackdark)),
        actions: <Widget>[
          if (hideNo == null)
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'No',
                style: TextStyle(color: MyAppColor.blackdark),
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Done');

              if (route == Home()) {
              } else if (route != null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => route));
              }
            },
            child: Text('Yes', style: TextStyle(color: MyAppColor.blackdark)),
          ),
        ],
      ),
    ),
  );
}

//subscription alert box pop up
subscriptionaAlertBox(context, message, {route, title, hideNo}) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: AlertDialog(
        backgroundColor: MyAppColor.backgroundColor,
        elevation: 10,
        title: Text(
          title,
          style: TextStyle(color: MyAppColor.blackdark, fontSize: 18),
        ),
        content: Text(message, style: TextStyle(color: MyAppColor.blackdark)),
        actions: <Widget>[
          if (hideNo == null)
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'No',
                style: TextStyle(color: MyAppColor.blackdark),
              ),
            ),
          TextButton(
            onPressed: () {
              if (kIsWeb) {
                context.vRouter.to("/hindustaan-jobs/subscription-plans");
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubscriptionPlans()));
              }
            },
            child: Text('Yes', style: TextStyle(color: MyAppColor.blackdark)),
          ),
        ],
      ),
    ),
  );
}

salaryShow(salary, salaryFrom, salaryTo) {
  return salary != null ? "₹ $salary" : "₹ $salaryFrom - ₹ $salaryTo";
}

locationShow({state, city}) {
  if (state == null || city == null) {
    return '';
  }
  return '${city.name}, ${state.name}';
}

experienceShow({expFrom, expTo}) {
  String showString;
  int years = int.parse("$expFrom") ~/ 12;
  int months = int.parse("$expFrom") % 12;
  showString = "$years Years $months Months";
  return showString;
}

doubleToIntValue(value) {
  return value.toString().split('.').first;
}

findValueConstant({list, keyValue}) {
  var r;
  for (var i = 0; i < list['rows'].length; i++) {
    if (list['rows'][i]['key'] == keyValue) {
      r = list['rows'][i]['value'];
    }
  }

  return r;
}

findValueConstantObject({list, keyValue}) {
  var r;
  for (var i = 0; i < list['rows'].length; i++) {
    if (list['rows'][i]['key'] == keyValue) {
      r = list['rows'][i];
    }
  }
  return r;
}

dateFormat(date) {
  return date != null && date != ''
      ? DateFormat("dd/MM/yyyy").format(DateTime.parse(date))
      : '';
}

dateReverseFormat(date) {
  return date != null && date != ''
      ? DateFormat("MM/dd/yyyy").format(DateTime.parse(date))
      : '';
}

findRemainingDays({from, to}) {
  if (from == null && to == null) {
    return;
  }
  DateTime date1 = DateTime.parse("$to");
  DateTime date2 = DateTime.parse("$from");
  date1 = DateTime(date1.year, date1.month, date1.day);
  date2 = DateTime(date2.year, date2.month, date2.day);
  return (date1.difference(date2).inHours / 24).round();
}

loaderIndicator(context) {
  return Center(
    child: SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(MyAppColor.blackdark))),
  );
}

dateServerFormat(date) {
  return date != null && date != ''
      ? DateFormat("MM/dd/yyyy").format(DateTime.parse(date))
      : '';
}

calculateExperience(controller, selected) {
  return selected != null
      ? selected.key == 'M'
          ? controller.text
          : int.parse("${controller.text}") * 12
      : null;
}

calculateExperienceForEdit(controller, selected) {
  selected = selected.runtimeType == String ? selected : selected.key;
  return selected != null
      ? selected == 'M'
          ? controller.toString()
          : (int.parse("$controller") / 12).round().toString()
      : null;
}

removeNullEmptyKey(data) {
  data.removeWhere(
      (key, value) => value == null || value == '' || value == 'null');
  return data;
}

containsInArray(arrayObj, obj) {
  return arrayObj.id == obj.id &&
      arrayObj.name == obj.name &&
      arrayObj.skillCategoryId == obj.skillCategoryId;
}

int indexFile = 0;

duratonOfSubscription(amount) {
  return int.parse(amount.toString()) <= 100
      ? 1
      : int.parse(amount.toString()) >= 350
          ? 6
          : 3;
}

checkNullOverValueName(value) {
  return value != null ? value.name : '';
}

Future<bool> isVersionBig() async {
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  var release = androidInfo.version.release;
  return int.parse(release.toString().split('.').first) > 10;
}

checkPermission() async {
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  var release = androidInfo.version.release;
  await [
    Permission.storage,
    Permission.accessMediaLocation,
  ].request();
  if (int.parse(release.toString().split('.').first) > 10) {
    await Permission.manageExternalStorage.request();
  }
}

formatDate(date) {
  try {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd.MM.yyyy');
    return outputFormat.format(inputDate);
  } catch (e) {
    return '';
  }
}

removeNulEmptyFromObj(filterData) {
  filterData
      .removeWhere((key, value) => value == null || value == '' || value == 0);
  return filterData;
}

formatTime(date) {
  try {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('HH:mm');
    return outputFormat.format(inputDate);
  } catch (e) {
    return '';
  }
}

UserData findOppositeUser(data) {
  return data.senderId == authUserId() ? data.receiverInfo : data.senderInfo;
}

removeUnderScore(value) {
  return value.toString().replaceAll("_", " ");
}

authUserId() {
  return RoleTypeConstant.companyStaff == userData!.userRoleType
      ? userData!.companyId
      : userData!.id;
}

countExperience(value, type) {
  return type != null
      ? type == 'M'
          ? value
          : int.parse("$value") * 12
      : null;
}

bool checkRoleType(role) {
  return role == RoleTypeConstant.company ||
          role == RoleTypeConstant.companyStaff
      ? true
      : false;
}

showChoiceDialog(BuildContext context, croppedFile) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: MyAppColor.backgroundColor,
        title: Text(
          "Choose option",
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(
                height: 1,
                color: MyAppColor.blackdark,
              ),
              ListTile(
                onTap: () {
                  _openGallery(context, croppedFile);
                },
                title: Text("Gallery",
                    style: TextStyle(color: MyAppColor.blackdark)),
                leading: Icon(
                  Icons.account_box,
                  color: MyAppColor.blackdark,
                ),
              ),
              Divider(
                height: 1,
                color: MyAppColor.blackdark,
              ),
              ListTile(
                onTap: () {
                  _openCamera(context, croppedFile);
                },
                title: Text("Camera",
                    style: TextStyle(color: MyAppColor.blackdark)),
                leading: Icon(
                  Icons.camera,
                  color: MyAppColor.blackdark,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future cropImage(context, imageFile, croppedFile) async {
  croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: MyAppColor.backgroundColor,
          toolbarWidgetColor: MyAppColor.blackdark,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
  return croppedFile;
}

Future _openGallery(context, croppedFile) async {
  var pickedFile = await picker.getImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    Navigator.pop(context);
    return cropImage(context, pickedFile.path, croppedFile);
  }
}

Future webGallery(context) async {
  var result = await FilePicker.platform.pickFiles();
  if (result != null) {
    return result.files.first;
  }
}

Future _openCamera(context, croppedFile) async {
  var pickedFile = await picker.getImage(source: ImageSource.camera);
  if (pickedFile != null) {
    Navigator.pop(context);
    return cropImage(context, pickedFile.path, croppedFile);
  }
}

trimControllerValue(TextEditingController value) {
  return value.text.trim();
}

List<String> getRouteParams(String routeName) {
  List<String> _temp = [];
  _temp = routeName.split('/');
  return _temp;
}

takePermission() {
  Future<bool> requestPermission() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = int.parse(androidInfo.version.release);
    Permission permission;
    if (release < 11) {
      permission = Permission.storage;
    } else {
      permission = Permission.manageExternalStorage;
    }
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}

widgetPopDialog(Widget child, context, {width}) {
  return showDialog(
    context: context,
    builder: (_) => Container(
      constraints: BoxConstraints(maxWidth: width),
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding:
            EdgeInsets.symmetric(horizontal: width / 2.9, vertical: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(00),
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(
                right: 25,
              ),
              child: child,
            ),
            Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 25,
                  width: 25,
                  padding: EdgeInsets.all(5),
                  color: MyAppColor.backgroundColor,
                  alignment: Alignment.topRight,
                  child: Image.asset('assets/back_buttons.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

widgetFullScreenPopDialog(Widget child, context, {width}) {
  return showDialog(
      context: context,
      builder: (_) => Container(
          constraints: BoxConstraints(maxWidth: width),
          child: Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00),
              ),
              child: child)));
}

returnIndexString(index) {
  return index == 0
      ? "home"
      : index == 1
          ? 'my-jobs'
          : 'my-profile';
}

returnIndexInteger(index) {
  return index == 'home'
      ? 0
      : index == 'my-jobs'
          ? 1
          : 2;
}

returnIndexHSPString(index) {
  return index == 0
      ? "home"
      : index == 1
          ? 'service-requests'
          : index == 2
              ? 'my-service'
              : 'my-profile';
}

returnIndexHSPInteger(index) {
  return index == 'home'
      ? 0
      : index == 'service-requests'
          ? 1
          : index == 'my-service'
              ? 2
              : 3;
}

returnIndexHSSString(index) {
  return index == 0
      ? "home"
      : index == 1
          ? 'my-service-requests'
          : 'my-profile';
}

returnIndexHSSInteger(index) {
  return index == 'home'
      ? 0
      : index == 'my-service-requests'
          ? 1
          : 2;
}

returnIndexLHString(index) {
  return index == 0
      ? "home"
      : index == 1
          ? 'my-videos'
          : 'my-profile';
}

returnIndexLHInteger(index) {
  return index == 'home'
      ? 0
      : index == 'my-videos'
          ? 1
          : 2;
}

returnIndexCOMPANYString(index) {
  return index == 0
      ? "home"
      : index == 1
          ? 'job-posts'
          : index == 2
              ? 'our-staff'
              : 'my-profile';
}

returnIndexCOMPANYInteger(index) {
  return index == 'home'
      ? 0
      : index == 'job-posts'
          ? 1
          : index == 'our-staff'
              ? 2
              : 3;
}

returnNameStringOfRoleType(type) {
  switch (type) {
    case RoleTypeConstant.jobSeeker:
      return 'job-seeker';
    case RoleTypeConstant.companyStaff:
      return 'company-staff';
    default:
  }
}

void downloadFileOnWeb(String url) {
  // html.AnchorElement anchorElement = new html.AnchorElement(href: url);
  // anchorElement.download = url;
  // anchorElement.click();
}
