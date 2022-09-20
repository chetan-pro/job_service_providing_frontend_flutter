import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/Company/permission.dart';
import 'package:hindustan_job/candidate/model/company_image_model.dart';
import 'package:hindustan_job/candidate/model/transactions_historires_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';

import '../candidate/model/active_subscription_details_model.dart';
import '../services/api_services/panel_services.dart';

class CompanyProfileChangeNotifier extends ChangeNotifier {
  CompanyProfileChangeNotifier({required this.isUserSubscribed});

  bool isUserSubscribed = false;
  bool isLoading = false;
  int? remainingDays;
  int? subscribedPlanId;
  int? resumeAccessPlanId;
  int availableJobLimits = 0;
  int availableEmailLimits = 0;
  int availableCvlLimits = 0;
  int? descriptionLimit;
  bool jobBoostingAll = false;
  String? startDateOfSubscription;
  String? planName;

  List<TransactionHistories> transactionHisotries = [];

  List<CompanyImage> companyImageList = [];
  UserData user = userData!;

  List<UserData> staffShow = [];
  bool isStaffActive = false;

  List<PermissonModel> getstaffPermission = [];
  int notificationCount = 0;

  getNotificationCount() async {
    ApiResponse response = await getNotificationUnreadCount();
    if (response.status == 200) {
      notificationCount = response.body!.data;
    }
    notifyListeners();
  }

  getStaffResponse(context, {List<PermissonModel>? permission}) async {
    ApiResponse response = await getStaffPermission();
    getstaffPermission = [];
    if (response.status == 200) {
      var res = response.body!.data;
      for (int i = 0; i < res.length; i++) {
        PermissonModel obj = PermissonModel.fromJson(res[i]);
        if (permission != null) {
          bool serachObj =
              permission.where((element) => element.id == obj.id).isNotEmpty;
          if (serachObj) {
            obj.toggle = true;
          }
        }
        getstaffPermission.add(obj);
      }
    } else {
      getstaffPermission = [];
    }

    notifyListeners();
  }

  deleteStaffNotify(context, {stffdelete}) async {
    ApiResponse response = await deleteStaff(deleteId: stffdelete);
    if (response.status == 200) {
      staffShow.removeWhere((element) => element.id == stffdelete);
      notifyListeners();
      showSnack(context: context, msg: "Deleted Staff Successfully");
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
    return true;
  }

  activeInActiveStaffStatus(value, id) {
    isStaffActive = value;
    UserData changeData = staffShow.where((element) => element.id == id).first;
    changeData.isStaffActive = value;
    notifyListeners();
  }

  addStaffDataShow(staff) async {
    staffShow.insert(0, UserData.fromJson(staff[0]));
    notifyListeners();
  }

  getStaffDataShow(context, {sortBy}) async {
    ApiResponse response = await staffShowData(sortBy: sortBy);
    if (response.status == 200) {
      List<UserData> fetchedUser = [];
      for (var i in response.body!.data) {
        fetchedUser.add(UserData.fromJson(i));
      }
      staffShow = fetchedUser;
      notifyListeners();
    }
  }

  List<ActiveSubscriptionDetail> activeSubscriptionDetails = [];

  List<ActiveSubscriptionDetail> inactiveSubscriptionDetails = [];
  checkSubscription() async {
    availableJobLimits = 0;
    availableEmailLimits = 0;
    availableCvlLimits = 0;
    isUserSubscribed = false;
    jobBoostingAll = false;
    isLoading = true;
    notifyListeners();
    ApiResponse response = await subscriptionData();
    if (response.status == 200 && response.body!.data != null) {
      var data = response.body!.data;
      activeSubscriptionDetails = ActiveSubscriptionDetailsModel.fromJson(data)
          .activeSubscriptionDetails!
          .where((element) => element.status == 1)
          .toList();
      inactiveSubscriptionDetails =
          ActiveSubscriptionDetailsModel.fromJson(data)
              .activeSubscriptionDetails!
              .where((element) => element.status == 0)
              .toList();

      List<ActiveSubscriptionDetail> object = activeSubscriptionDetails
          .where((element) => element.planType == SubscriptionType.validityPlan)
          .toList();
      List<ActiveSubscriptionDetail> object1 = activeSubscriptionDetails
          .where((element) =>
              element.planType == SubscriptionType.resumeDataAccessPlan)
          .toList();
      if (object1.isNotEmpty) {
        resumeAccessPlanId = object1.first.id;
      }
      for (var activeSubscriptionDetail in activeSubscriptionDetails) {
        DateTime valEnd = DateTime.parse(activeSubscriptionDetail.expiryDate!);
        DateTime date = DateTime.now();
        bool valDate = date.isBefore(valEnd);
        if (valDate) {
          availableCvlLimits =
              availableCvlLimits + activeSubscriptionDetail.availableCvlLimits!;
          availableEmailLimits = availableEmailLimits +
              activeSubscriptionDetail.availableEmailLimits!;
          availableJobLimits =
              availableJobLimits + activeSubscriptionDetail.availableJobLimits!;
        }
      }
      if (object.isNotEmpty) {
        DateTime objEnd = DateTime.parse(object.first.expiryDate!);
        DateTime date = DateTime.now();
        bool objDate = date.isBefore(objEnd);
        if (objDate) {
          isUserSubscribed = true;
          descriptionLimit = object.first.subscriptionPlans!.descriptionLimit;
          jobBoostingAll = object.first.subscriptionPlans!.jobBoosting == null
              ? false
              : true;
          remainingDays = await findRemainingDays(
              from: object.first.startDate, to: object.first.expiryDate);
          startDateOfSubscription = formatDate(object.first.startDate);
          planName = object.first.subscriptionPlans!.title;
          subscribedPlanId = object.first.id;
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  updateUserData(userData) {
    user = userData;
    notifyListeners();
  }

  getTransactionHistories(context, {filterData}) async {
    String url = '';
    if (filterData != null && filterData.isNotEmpty) {
      for (String key in filterData.keys) {
        url = url + "$key=${filterData[key].toString()}&";
      }
    }
    ApiResponse response = await getTransactionsHistories(additionalUrl: url);
    if (response.status == 200) {
      transactionHisotries =
          TransactionHistoriesModel.fromJson(response.body!.data)
              .transactionHistories!;
    } else {
      transactionHisotries = [];
    }
    notifyListeners();
  }

  addCompanyImage(
    context, {
    imageTitle,
    uploadImage,
  }) async {
    if (uploadImage == null) {
      return toast("Please select image to upload");
    }
    var imageData = {
      "title": imageTitle,
      "description": 'optional',
      "image": kIsWeb
          ? MultipartFile.fromBytes(uploadImage.bytes,
              filename: uploadImage.name)
          : await MultipartFile.fromFile(uploadImage.path,
              filename: uploadImage.path.toString().split('/').last),
    };
    ApiResponse response = await addCompanyImages(imageData);
    if (response.status == 200) {
      await showSnack(
          context: context, msg: "Company image added successfully");
      await fetchCompanyImages(context);
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  fetchCompanyImages(context) async {
    companyImageList = await fetchCompanyImage(context);
    notifyListeners();
  }

  deleteCompanyImage(context, {id, object}) async {
    ApiResponse response = await deleteCompanyImages(id.toString());
    if (response.status == 200) {
      companyImageList.remove(object);
      await showSnack(context: context, msg: "Deleted successfully");
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
    notifyListeners();
  }
}
