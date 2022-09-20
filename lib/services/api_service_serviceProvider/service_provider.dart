import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';

Future addServiceProviderBranch(addData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ServiceProviderString.addServiceProviderBranch;

  return await ApiProvider.post(url: url, body: addData, headers: headers);
}

Future getServiceProviderBranch() async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.get(
    ServiceProviderString.getServiceProviderBranchList,
    headers: headers,
  );
}

Future editServiceProviderBranch(editData) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.post(
      body: editData,
      url: ServiceProviderString.updateServiceProviderBranch,
      headers: headers);
}

Future deleteServiceProviderBranchData(deleteId) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.delete(
      ServiceProviderString.deleteServiceProviderBranch + '/$deleteId',
      headers: headers);
}

Future addServices(addData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ServiceAdd.serviceAddField;

  return await ApiProvider.post(
      url: url, body: addData, headers: headers, media: true);
}

Future getDays() async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.get(ServiceAdd.dayfetch, headers: headers);
}

Future category() async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.get(ServiceAdd.category, headers: headers);
}

Future getService({id, status, sortBy}) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };
  String url = ServiceAdd.getallService + "?";

  if (id != null) {
    url = url + "serviceId=$id&";
  }
  if (status != null) {
    url = url + "status=${status == 'Active' ? 'Y' : 'N'}&";
  }
  if (sortBy != null) {
    url = url + "sortBy=$sortBy&";
  }
  return await ApiProvider.get(
    url,
    headers: headers,
  );
}

Future updateServiceAll(editData) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.post(
    url: ServiceAdd.updateServiceAll,
    headers: headers,
    body: editData,
    media: true,
  );
}

Future alldeleteServiceProviderData(deleteId) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.delete(ServiceAdd.deleteServices + '/$deleteId',
      headers: headers);
}

Future getServiceRequest(
    {status, userStatus, sortBy, month, year, branchId,serviceRequestId}) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };
  String url = ServiceAdd.getServiceRequest + "?";
  if (status != null) {
    url = url + "status=$status&";
  }
  if (serviceRequestId != null) {
    url = url + "service_request_id=$serviceRequestId&";
  }
  if (status != null) {
    url = url + "user_status=$userStatus&";
  }
  if (sortBy != null) {
    url = url + "sortBy=$sortBy&";
  }
  if (month != null) {
    url = url + "month=$month&";
  }
  if (branchId != null) {
    url = url + "branch_id=$branchId&";
  }
  return await ApiProvider.get(
    url,
    headers: headers,
  );
}

Future updateServiceStatus({id, status}) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.post(
    url: ServiceAdd.updateServiceStatus + "/$id",
    headers: headers,
    body: {"service_status": status},
  );
}

Future statsuDataRequest(statusdata) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.post(
    url: ServiceAdd.statusServiceRequest,
    headers: headers,
    body: statusdata,
  );
}

Future documentData(statusdata) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.post(
    media: true,
    url: Document.documenData,
    headers: headers,
    body: statusdata,
  );
}

Future documentFetchApi() async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  return await ApiProvider.get(
    Document.fethdocumenData,
    headers: headers,
  );
}

Future getRateAndReview(getRate) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };

  var url = Rate.rate;

  if (getRate != null) {
    url = url + '/$getRate';
  }

  return await ApiProvider.get(url, headers: headers);
}

Future serviceDashboard() async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };
  var url = "service-provider-dashboard";
  return await ApiProvider.get(url, headers: headers);
}

Future deleteServiceDocument(deleteId) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString(),
  };
  return await ApiProvider.delete(
      ServiceProviderString.deleteDocumentService + '/$deleteId',
      headers: headers);
}
