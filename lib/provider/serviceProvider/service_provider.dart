// ignore_for_file: unnecessary_import, avoid_print, unused_import

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/alldata_get_modal.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/day_provider.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/document_data.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/mybranch.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/rate_service.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/service_provider_dashboard.dart';
import 'package:hindustan_job/candidate/model/service_categories_model.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_profile.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/service_provider.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';

import '../../candidate/model/active_subscription_details_model.dart';
import '../../candidate/model/services_model.dart';

class ServiceProviderChangeNotifier extends ChangeNotifier {
  ServiceProviderChangeNotifier();

  List<Branch> serviceget = [];
  Documents? doc;
  List<Services> serviceRequest = [];
  ServiceProviderDashboard? dashboardServiceProvider;
  List<RatingServices> rateService = [];
  RateService? rateServiceData;
  List<AllServiceFetch> alldata = [];
  List<Services> pending = [];
  List<Services> upcoming = [];
  List<Services> completed = [];
  List<Services> rejected = [];
  List<Services> cancelled = [];
  bool isPending = false;
  bool isUpcoming = false;
  bool isComplete = false;
  bool isCancelled = false;
  bool isAccecpt = false;
  bool isRejected = false;
  List<ServiceDays> days = [];
  List<ServiceCategories> catego = [];
  bool isCandidateSubscribed = false;
  bool isLoading = false;
  int? remainingDays;
  String? startDateOfSubscription;
  String? planName;

  checkSubscription() async {
    isLoading = true;
    isCandidateSubscribed = false;
    notifyListeners();
    ApiResponse response = await subscriptionData();
    notifyListeners();
    if (response.status == 200 && response.body!.data != null) {
      ActiveSubscriptionDetailsModel object =
          ActiveSubscriptionDetailsModel.fromJson(response.body!.data);
      if (object.activeSubscriptionDetails!.isNotEmpty) {
        ActiveSubscriptionDetail activeSubscriptionDetail =
            object.activeSubscriptionDetails!.first;
        DateTime valEnd = DateTime.parse(activeSubscriptionDetail.expiryDate!);
        DateTime date = DateTime.now();
        print("????????????valEnd?????????????????");
        print(valEnd);
        print(date);
        bool valDate = date.isBefore(valEnd);
        print("::valDate::");
        print(valDate);
        if (valDate) {
          isCandidateSubscribed = true;
        }
        remainingDays = await findRemainingDays(
            from: activeSubscriptionDetail.startDate,
            to: activeSubscriptionDetail.expiryDate);
        startDateOfSubscription =
            formatDate(activeSubscriptionDetail.startDate);
        planName = activeSubscriptionDetail.subscriptionPlans!.title;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  getServiceBranchData() async {
    ApiResponse response = await getServiceProviderBranch();
    var res = response.body!.data;

    if (response.status == 200) {
      serviceget = ServiceBranches.fromJson(res).branches!.toList();
    } else {
      serviceget = [];
    }

    notifyListeners();
  }

  getAlldataservice({status, sortBy}) async {
    ApiResponse response = await getService(status: status, sortBy: sortBy);
    var res = response.body!.data;
    if (response.status == 200) {
      alldata = AllData.fromJson(res).rows!.toList();
    } else {
      alldata = [];
    }
    notifyListeners();
  }

  updateStatus(status, userStatus) {
    switch (status) {
      case 'PENDING':
        isPending = true;
        isUpcoming = false;
        isComplete = false;
        isRejected = false;
        if (userStatus == ServiceStatus.reject)
          isCancelled = true;
        else
          isCancelled = false;
        break;
      case 'ACCEPTED':
        isPending = false;
        isUpcoming = true;
        isComplete = false;
        isRejected = false;
        isCancelled = false;
        break;
      case 'COMPLETED':
        isPending = false;
        isUpcoming = false;
        isComplete = true;
        isRejected = false;
        isCancelled = false;
        break;
      case 'REJECTED':
        isPending = false;
        isUpcoming = false;
        isComplete = false;
        isRejected = true;
        isCancelled = false;
        break;

      default:
    }
    notifyListeners();
  }

  deleteServiceData(deleteid, context) async {
    ApiResponse response = await deleteServiceProviderBranchData(deleteid);
    if (response.status == 200) {
      getServiceBranchData();
      showSnack(context: context, msg: "Branch Deleted Successfully");
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }

    notifyListeners();
  }

  alldeleteServiceData(deleteid, context) async {
    ApiResponse response = await alldeleteServiceProviderData(deleteid);

    if (response.status == 200) {
      showSnack(context: context, msg: "Deleted Custom Alert Successfully");

      await getAlldataservice();

      getServiceBranchData();

      Navigator.pop(context);
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }

    notifyListeners();
  }

  fetchData(context) async {
    ApiResponse response = await getDays();

    var res = response.body!.data;

    if (response.status == 200) {
      days = Days.fromJson(res).rows!.toList();
    } else {
      await showSnack(
        context: context,
        msg: response.body!.message,
        type: 'error',
      );
    }
    notifyListeners();
  }

  categoryData(context) async {
    ApiResponse response = await category();

    if (response.status == 200) {
      return ServiceCategoriesModel.fromJson(response.body!.data)
          .serviceCategories;
    } else {
      <ServiceCategories>[];
    }
    notifyListeners();
  }

  getdataserviceRequest(
      {userStatus, serviceStatus, sortBy, year, month, branchId}) async {
    ApiResponse response = await getServiceRequest(
        status: serviceStatus,
        userStatus: userStatus ?? ServiceStatus.request,
        sortBy: sortBy,
        month: month,
        year: year,
        branchId: branchId);
    var res = response.body!.data;
    if (response.status == 200) {
      if (serviceStatus == 'ACCEPTED') {
        upcoming = ServicesModel.fromJson(res).services!;
        notifyListeners();
      }
      if (serviceStatus == 'COMPLETED') {
        completed = ServicesModel.fromJson(res).services!;
        notifyListeners();
      }
      if (serviceStatus == 'REJECTED') {
        rejected = ServicesModel.fromJson(res).services!;
        notifyListeners();
      }
      if (serviceStatus == 'PENDING' && userStatus != null) {
        cancelled = ServicesModel.fromJson(res).services!;
        return notifyListeners();
      }
      if (serviceStatus == 'PENDING') {
        pending = ServicesModel.fromJson(res).services!;
        notifyListeners();
      }
      serviceRequest = ServicesModel.fromJson(res).services!;
      // return AllData.fromJson(res).rows;
      // for (Map i in res) {
      //   alldata.add(AllServiceFetch.fromJson(i));
      // }
    } else if (response.status == 400) {
      if (serviceStatus == 'ACCEPTED') {
        upcoming = [];
        notifyListeners();
      }
      if (serviceStatus == 'COMPLETED') {
        completed = [];
        notifyListeners();
      }
      if (serviceStatus == 'REJECTED') {
        rejected = [];
        notifyListeners();
      }
      if (serviceStatus == 'PENDING' && userStatus != null) {
        cancelled = [];
        notifyListeners();
      }
      if (serviceStatus == 'PENDING' && userStatus == null) {
        pending = [];
        notifyListeners();
      }
    }
    notifyListeners();
  }

  accept(
    context, {
    serReqId,
    status,
  }) async {
    Map<String, dynamic> statusdata = {
      "service_provider_status": status,
      "service_request_id": serReqId.toString(),
    };
    ApiResponse response = await statsuDataRequest(statusdata);
    if (response.status == 200) {
      showSnack(context: context, msg: "Successfully");

      if (status == 'REJECTED') {
        await getdataserviceRequest(serviceStatus: status);
        await getdataserviceRequest(serviceStatus: ServiceStatus.pending);
        await getdataserviceRequest(
          serviceStatus: ServiceStatus.accepted,
        );
        isUpcoming = false;
        isComplete = false;
        isPending = false;
        isRejected = true;
      } else {
        await getdataserviceRequest(serviceStatus: status);
        isUpcoming = true;
        isComplete = false;
        isPending = false;
      }
      notifyListeners();
    } else if (response.status == 400) {
      isPending = false;
      pending = [];

      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  sends(context, {serReqId, status}) async {
    Map<String, dynamic> statusdata = {
      "service_provider_status": status,
      "service_request_id": serReqId.toString()
    };

    ApiResponse response = await statsuDataRequest(statusdata);
    if (response.status == 200) {
      showSnack(context: context, msg: "Successfully");
      await getdataserviceRequest(serviceStatus: status);
      isComplete = true;
      isPending = false;
      isUpcoming = false;
      notifyListeners();
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  documetFetchData() async {
    ApiResponse response = await documentFetchApi();
    if (response.status == 200 && response.body!.data != null) {
      doc = Documents.fromJson(response.body!.data);
    } else {
      doc = null;
    }
    notifyListeners();
  }

  rate(
    String string,
  ) async {
    ApiResponse response = await getRateAndReview(string);

    if (response.status == 200) {
      rateServiceData = RateService.fromJson(response.body!.data);
      rateService = RateService.fromJson(response.body!.data).rows!.toList();
    } else {
      rateServiceData = null;
      rateService = [];
    }
    notifyListeners();
  }

  dashboard() async {
    ApiResponse response = await serviceDashboard();
    if (response.status == 200) {
      dashboardServiceProvider =
          ServiceProviderDashboard.fromJson(response.body!.data);
      return dashboardServiceProvider;
    }
  }

  sendDocument(context,
      {docName, docNumber, frontDoc, backDoc, serviceExperience}) async {
    var data = {
      "document_name": docName.toString(),
      "document_number": docNumber,
      "service_experience": serviceExperience
    };
    if (frontDoc != null) {
      data["image"] = kIsWeb
          ? MultipartFile.fromBytes(frontDoc.bytes, filename: frontDoc!.name)
          : await MultipartFile.fromFile(
              frontDoc!.path,
              filename: frontDoc!.path.toString().split('/').last,
            );
    }
    if (backDoc != null) {
      data["image_back"] = kIsWeb
          ? MultipartFile.fromBytes(backDoc.bytes, filename: backDoc!.name)
          : await MultipartFile.fromFile(
              backDoc!.path,
              filename: backDoc!.path.toString().split('/').last,
            );
    }
    ApiResponse response = await documentData(data);
    if (response.status == 200) {
      await documetFetchData();
      Navigator.pop(context);
      showSnack(context: context, msg: response.body!.message);
    } else {
      toast(response.body!.message.toString());
    }
  }

  deleteDocumentServiceData(context, deleteid) async {
    ApiResponse response = await deleteServiceDocument(deleteid);

    if (response.status == 200) {
      await documetFetchData();
      showSnack(context: context, msg: "Document Deleted Successfully");
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }

    notifyListeners();
  }
}
