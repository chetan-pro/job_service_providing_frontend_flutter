// ignore_for_file: unused_import, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';

Future contactUs(contactData) async {
  return await ApiProvider.post(
    url: ApiString.contactUs,
    body: contactData,
  );
}

Future bankAddDetails() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(BankDetails.getBankDetails, headers: headers);
}

Future getStaffPermission() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.get(CompanyStaff.getPermission, headers: headers);
}

Future staffShowData({sortBy}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = CompanyStaff.getStaffCompany;
  if (sortBy != null) {
    url = url + '?sortBy=$sortBy';
  }
  return await ApiProvider.get(url, headers: headers);
}

Future activeInactiveStaff({status, staffId}) async {
  var carryData = {"id": staffId, 'active': status};
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: CompanyStaff.activeInactiveStaff, headers: headers, body: carryData);
}

Future addStaffCompany(staffAdd) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
    url: CompanyStaff.addStaffCompany,
    headers: headers,
    body: staffAdd,
  );
}

Future getWalletAmount() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(BankDetails.getWalletBalance, headers: headers);
}

Future getWalletTransaction({additionalUrl}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = BankDetails.getWalletTransactions;
  if (additionalUrl != null) {
    url = url + "?$additionalUrl";
  }
  return await ApiProvider.get(url, headers: headers);
}

Future getWalletSettlement({additionalUrl}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = BankDetails.getbankSettle;
  if (additionalUrl != null) {
    url = url + "?$additionalUrl";
  }
  return await ApiProvider.get(url, headers: headers);
}

Future getTransactionsHistories({additionalUrl}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = BankDetails.getAllTransactionHisotries;
  if (additionalUrl != null) {
    url = url + "?$additionalUrl";
  }
  return await ApiProvider.get(url, headers: headers);
}

Future bankPostDetails(AddBankData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: BankDetails.addBankDetails, body: AddBankData, headers: headers);
}

Future banksettled(settle) async {
  Map<String, dynamic> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: BankDetails.bankSettle, headers: headers, body: settle, media: true);
}

Future editBankDetails(editBankData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return ApiProvider.post(
    body: editBankData,
    headers: headers,
    url: BankDetails.updateBankDetails,
  );
}

Future addCustomAlert(customAlertData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ApiString.addCustomAlert, headers: headers, body: customAlertData);
}

Future getUserCustomAlert() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(
    ApiString.userCustomAlertList,
    headers: headers,
  );
}

Future getDynamicLink() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(
    ApiString.getDynamicLink,
    headers: headers,
  );
}

Future deleteUserCustomAlert({deleteId}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.deleteCustomAlert + '/$deleteId';
  return await ApiProvider.delete(
    url,
    headers: headers,
  );
}

Future deleteStaff({deleteId}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  String url = CompanyStaff.deleteStaffCompany + '/$deleteId';

  return await ApiProvider.delete(
    url,
    headers: headers,
  );
}

Future editStaffNotify(editStaff) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = CompanyStaff.updateStaffCompany;
  return await ApiProvider.post(url: url, headers: headers, body: editStaff);
}

Future editUserCustomAlert(editCustomData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.editCustomAlert;
  return await ApiProvider.post(
      url: url, headers: headers, body: editCustomData);
}

Future subscriptionData() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.get(ApiString.subscriptionDetails, headers: headers);
}
