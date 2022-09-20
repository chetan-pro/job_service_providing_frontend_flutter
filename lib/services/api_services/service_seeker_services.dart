import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hindustan_job/candidate/model/branch_model.dart';
import 'package:hindustan_job/candidate/model/provider_model.dart';
import 'package:hindustan_job/candidate/model/service_categories_model.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';

import '../../candidate/model/serviceProviderModal/alldata_get_modal.dart';
import '../../candidate/model/serviceProviderModal/mybranch.dart';

Future fetchAllServices(context, {status, page, additionalUrl}) async {
  String url = ServiceSeeker.getServiceSeeker + "?";
  if (status != null) {
    url = url + 'status=$status&';
  }
  if (page != null) {
    url = url + 'page=$page&';
  }
  if (additionalUrl != null) {
    url = url + additionalUrl;
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  EasyLoading.show();
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  EasyLoading.dismiss();
  if (response.status == 200) {
    return ServicesModel.fromJson(response.body!.data).services;
  } else {
    return <Services>[];
  }
}

Future getService(context, {id, serviceRequestId, additionalUrl}) async {
  String url = ServiceSeeker.getServiceSeeker + '?serviceId=$id';
  if (serviceRequestId != null) {
    url = url + "&service_request_id=$serviceRequestId";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);

  if (response.status == 200) {
    return Services.fromJson(response.body!.data);
  } else {
    return Services();
  }
}

Future getServiceProvider(context, {additionalUrl}) async {
  String url = ServiceSeeker.getServiceBranchSeeker + "?";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  if (additionalUrl != null) {
    url = url + additionalUrl;
  }
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return ServiceProviderModel.fromJson(response.body!.data).serviceProvider;
  } else {
    return <ServiceProvider>[];
  }
}

Future getServiceProviderById(context, userId, {sortBy}) async {
  String url = ServiceSeeker.getServiceBranchSeeker + "?userId=$userId";
  if (sortBy != null) {
    url = url + "&sortBy_service=$sortBy";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return ServiceProvider.fromJson(response.body!.data);
  } else {
    return null;
  }
}

Future getServiceSeekerRequest(context,
    {status, page, year, month, sortBy}) async {
  String url = ServiceSeeker.getServiceSeekerRequest + "?";
  if (status != null) {
    url = url + "provider_status=$status&user_status=REQUEST&";
  }
  if (year != null) {
    url = url + "year=$year&";
  }
  if (month != null) {
    url = url + "month=$month&";
  }
  if (sortBy != null) {
    url = url + "sortBy=$sortBy&";
  }
  if (page != null) {
    url = url + "page=$page";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return ServicesModel.fromJson(response.body!.data).services;
  } else {
    return <Services>[];
  }
}

Future getServiceSeekerReject(context, {status, page}) async {
  String url = ServiceSeeker.getServiceSeekerRequest + "?";

  url = url + "user_status=REJECT";

  if (page != null) {
    url = url + "page=$page";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return ServicesModel.fromJson(response.body!.data).services;
  } else {
    return <Services>[];
  }
}

Future getCategoryCountInfo() async {
  String url = ServiceSeeker.getCategoryCountInfo;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return CatergoryCountModel.fromJson(response.body!.data)
        .serviceCountCategory;
  } else {
    return <ServiceCategory>[];
  }
}

Future addRateServiceRequest(body) async {
  String url = ServiceSeeker.addRateServiceRequest;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future updateRateServiceRequest({id, body}) async {
  String url = ServiceSeeker.addRateServiceRequest + '/$id';
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future deleteRateServiceRequest({id}) async {
  String url = ServiceSeeker.deleteRateServiceRequest + '/$id';
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.delete(url, headers: headers);
}

Future requestService(context,
    {status, branchId, serviceId, serviceDate}) async {
  var carryData = {
    "user_status": status,
    "branch_id": branchId,
    "service_id": serviceId.toString(),
    "request_date": serviceDate
  };
  String url = ServiceSeeker.addServiceRequest;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response =
      await ApiProvider.post(url: url, body: carryData, headers: headers);
  return response;
}

Future getBranches(context, {providerId}) async {
  String url = ServiceSeeker.getServiceBranch + '?provider_id=$providerId';
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return ServiceBranches.fromJson(response.body!.data).branches;
  } else {
    return <Branch>[];
  }
}

Future updateServiceRequestSeeker(body) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ServiceSeeker.updateServiceRequestSeeker,
      body: body,
      headers: headers);
}

Future addReviewsService(
  body,
) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ServiceSeeker.addRateServiceRequest, body: body, headers: headers);
}

Future getRateServiceRequest(id, requestId) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(
      ServiceSeeker.getRateServiceRequest +
          "?service_id=$id&service_request_id=$requestId",
      headers: headers);
}
