// import 'dart:js';

// ignore_for_file: avoid_print, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:hindustan_job/candidate/model/addbank/getbank.dart';
import 'package:hindustan_job/candidate/model/addbank/settle_bank.dart';
import 'package:hindustan_job/candidate/model/addbank/wallet_transactions.dart';
import 'package:hindustan_job/candidate/model/certificate_experience_model.dart';
import 'package:hindustan_job/candidate/model/current_job_model.dart';
import 'package:hindustan_job/candidate/model/custom_job_alert_model.dart';
import 'package:hindustan_job/candidate/model/education_experience_model.dart';
import 'package:hindustan_job/candidate/model/language_model.dart';
import 'package:hindustan_job/candidate/model/transactions_historires_model.dart';
import 'package:hindustan_job/candidate/model/user_language_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/model/wallet_settlement_model.dart';
import 'package:hindustan_job/candidate/model/work_experience_model.dart';
import 'package:hindustan_job/constants/enum_contants.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/key_percent_value_list.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'dart:io';

import '../candidate/model/active_subscription_details_model.dart';
import '../services/api_services/panel_services.dart';

class CandidateEditProfileChangeNotifier extends ChangeNotifier {
  CandidateEditProfileChangeNotifier(isCandidateSubscribed);

  Data? addBank;

  List<GetSettleBank> settleBank = [];
  List<Transactions> walletTransactions = [];
  List<WalletSettleMent> walletSettlements = [];
  List<TransactionHistories> transactionHisotries = [];

  List<Language> userLanguages = [];
  List<WorkExperience> workExperiences = [];
  List<EducationExperience> educationExperiences = [];
  List<CertificateExperience> certificateExperiences = [];
  CurrentJobModel? currentJobModel;
  CurrentEmployed currentEmployed = CurrentEmployed.employed;
  NoticePeriod noticePeriod = NoticePeriod.noticePeriod;
  List<CustomAlert> customJobAlert = [];
  bool isUserAvailableForJob = false;
  int percentOfProfile = 0;
  bool isCandidateSubscribed = false;
  bool isLoading = false;
  int? remainingDays;
  String? startDateOfSubscription;
  String? planName;
  int notificationCount = 0;

  getNotificationCount() async {
    ApiResponse response = await getNotificationUnreadCount();
    if (response.status == 200) {
      notificationCount = response.body!.data;
    }
    notifyListeners();
  }

  List<ActiveSubscriptionDetail> activeSubscriptionDetails = [];
  List<ActiveSubscriptionDetail> inactiveSubscriptionDetails = [];

  checkSubscription() async {
    isLoading = true;
    isCandidateSubscribed = false;
    ApiResponse response = await subscriptionData();
    notifyListeners();
    if (response.status == 200 && response.body!.data != null) {
      var data = response.body!.data;

      ActiveSubscriptionDetailsModel object =
          ActiveSubscriptionDetailsModel.fromJson(response.body!.data);
      if (object.activeSubscriptionDetails!.isNotEmpty) {
        activeSubscriptionDetails =
            ActiveSubscriptionDetailsModel.fromJson(data)
                .activeSubscriptionDetails!
                .where((element) => element.status == 1)
                .toList();
        inactiveSubscriptionDetails =
            ActiveSubscriptionDetailsModel.fromJson(data)
                .activeSubscriptionDetails!
                .where((element) => element.status == 0)
                .toList();

        List<ActiveSubscriptionDetail> activeSubscriptionDetail = object
            .activeSubscriptionDetails!
            .where((element) =>
                element.planType == SubscriptionType.validityPlan &&
                element.status == 1)
            .toList();
        if (activeSubscriptionDetail.isNotEmpty) {
          try {
            ActiveSubscriptionDetail activeSubscriptionDetailSingle =
                activeSubscriptionDetail.first;
            DateTime valEnd =
                DateTime.parse(activeSubscriptionDetailSingle.expiryDate!);
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
                from: activeSubscriptionDetailSingle.startDate,
                to: activeSubscriptionDetailSingle.expiryDate);
            startDateOfSubscription =
                formatDate(activeSubscriptionDetailSingle.startDate);
            planName = activeSubscriptionDetailSingle.subscriptionPlans!.title;
          } catch (e) {}
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  getAllData(context) async {
    await fetchWorkExperience(context);
    await fetchEducationExperience(context);
    await fetchUserLanguages(context);
    await fetchCertificateExperience(context);
    await fetchCurrentJobData(context);
    await fetchAvailableForJobStatus();
    calculateProfilePercent();
  }

  calculateProfilePercent() {
    percentOfProfile = 0;
    for (var element in basicDetails) {
      userData!.toJson().forEach((key, value) {
        if (key == element['key'] && (value != null && value != '')) {
          percentOfProfile =
              percentOfProfile + int.parse("${element['value']}");
        }
      });
    }
    if (userLanguages.isNotEmpty) {
      percentOfProfile = percentOfProfile + 5;
    }
    if (workExperiences.isNotEmpty || currentJobModel != null) {
      percentOfProfile = percentOfProfile + 10;
    }
    if (educationExperiences.isNotEmpty) {
      percentOfProfile = percentOfProfile + 10;
    }
    if (certificateExperiences.isNotEmpty) {
      percentOfProfile = percentOfProfile + 10;
    }
    notifyListeners();
  }

  calculateStaffProfilePercent() {
    percentOfProfile = 0;
    for (var element in staffDetails) {
      userData!.toJson().forEach((key, value) {
        if (key == element['key'] && (value != null && value != '')) {
          percentOfProfile =
              percentOfProfile + int.parse("${element['value']}");
        }
      });
    }
    notifyListeners();
  }

  fetchAvailableForJobStatus() async {
    ApiResponse response = await getStatusAvailableForJob();
    if (response.status == 200) {
      isUserAvailableForJob =
          response.body!.data['is_user_available'] == 'N' ? false : true;
    }
    notifyListeners();
  }

  addStatusAvailableForJob(flag) async {
    ApiResponse response = await availableForJob(flag);
    if (response.status == 200) {
      fetchAvailableForJobStatus();
    }
  }

  fetchUserLanguages(context) async {
    userLanguages = await fetchUserLanguage(context);
    notifyListeners();
  }

  getCustomAlert(context) async {
    ApiResponse response = await getUserCustomAlert();
    if (response.status == 200) {
      customJobAlert =
          CustomJobAlertModel.fromJson(response.body!.data).customJobAlert!;
    } else {
      customJobAlert = [];
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
    notifyListeners();
  }

  getBankDetails(context) async {
    ApiResponse response = await bankAddDetails();
    if (response.status == 200) {
      addBank = Data.fromJson(response.body!.data);
    }
    notifyListeners();
  }

  getWalletTransactions(context, {filterData}) async {
    String url = '';
    if (filterData.isNotEmpty) {
      for (String key in filterData.keys) {
        url = url + "$key=${filterData[key].toString()}&";
      }
    }
    ApiResponse response = await getWalletTransaction(additionalUrl: url);

    if (response.status == 200) {
      walletTransactions =
          WalletTransactions.fromJson(response.body!.data).transactions!;
    } else {
      walletTransactions = [];
    }

    notifyListeners();
  }

  getWalletSettlements(context, {filterData}) async {
    String url = '';
    if (filterData.isNotEmpty) {
      for (String key in filterData.keys) {
        url = url + "$key=${filterData[key].toString()}&";
      }
    }
    ApiResponse response = await getWalletSettlement(additionalUrl: url);

    if (response.status == 200) {
      walletSettlements =
          WalletSettleMentModel.fromJson(response.body!.data).walletSettleMent!;
    } else {
      walletSettlements = [];
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
    notifyListeners();
  }

  getTransactionHistories(context, {filterData}) async {
    String url = '';
    if (filterData.isNotEmpty) {
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

  filterListingOfWallet(context, {status, filterData}) async {
    switch (status) {
      case WalletStatus.wallet:
        await getWalletTransactions(context, filterData: filterData);
        break;
      case WalletStatus.transaction:
        await getTransactionHistories(context, filterData: filterData);
        break;
      case WalletStatus.settlement:
        await getWalletSettlements(context, filterData: filterData);
        break;
      default:
    }
  }

  deleteCustomAlert(context, {customAlertId}) async {
    ApiResponse response = await deleteUserCustomAlert(deleteId: customAlertId);
    if (response.status == 200) {
      showSnack(context: context, msg: "Deleted Custom Alert Successfully");
      await getCustomAlert(context);
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
  }

  addLanguage(context, {languageIds}) async {
    var languageData = {"language_ids": languageIds};
    ApiResponse response = await addUserLanguage(languageData);

    if (response.status == 200) {
      fetchUserLanguages(context);
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
    return response;
  }

  employedValueChange(value, {context, id}) async {
    currentEmployed = value;

    if (currentEmployed == CurrentEmployed.notEmployed && id != null) {
      await deletCurrentJobData(context, id: id);
    }
    notifyListeners();
  }

  noticePeriodValueChange(value) {
    noticePeriod = value;
    notifyListeners();
  }

  delLanguage(context, {id, object}) async {
    ApiResponse response = await deleteUserLanguage(id.toString());
    if (response.status == 200) {
      fetchUserLanguages(context);
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
    notifyListeners();
  }

  fetchWorkExperience(context) async {
    workExperiences = await fetchWorkExp(context);
    notifyListeners();
    // calculateProfilePercent();
  }

  sendBankData(context,
      {bankname,
      branchName,
      registeredName,
      ifscCode,
      accountNo,
      accountType}) async {
    var addBankMember = {
      "bank_name": bankname,
      "branch_name": branchName,
      "full_registered_name": registeredName,
      "ifsc_code": ifscCode,
      "bank_account_number": accountNo,
      "bank_account_type": "Saving account"
    };

    ApiResponse response = await bankPostDetails(addBankMember);
    if (response.status == 200) {
      await showSnack(context: context, msg: " added successfully");
      Navigator.pop(context);
      notifyListeners();
    }
  }

  addWorkExp(context,
      {jobTitle,
      companyName,
      industryId,
      jobDescripton,
      dateOfJoin,
      dateOfResgin}) async {
    var workExpData = {
      "job_title": jobTitle,
      "company_name": companyName,
      "industry_id": industryId,
      "job_description": jobDescripton,
      "date_of_joining": dateOfJoin,
      "date_of_resigning": dateOfResgin
    };

    ApiResponse response = await addWorkExperience(workExpData);
    if (response.status == 200) {
      await showSnack(context: context, msg: "Experience added successfully");
      fetchWorkExperience(context);
      Navigator.pop(context);
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
  }

  updateWorkExp(context,
      {jobTitle,
      companyName,
      industryId,
      workExpId,
      jobDescripton,
      dateOfJoin,
      dateOfResgin}) async {
    var workExpData = {
      'id': workExpId,
      "job_title": jobTitle,
      "company_name": companyName,
      "industry_id": industryId,
      "job_description": jobDescripton,
      "date_of_joining": dateOfJoin,
      "date_of_resigning": dateOfResgin
    };

    ApiResponse response = await editWorkExperience(workExpData);
    if (response.status == 200) {
      await showSnack(context: context, msg: "Experience updated successfully");
      fetchWorkExperience(context);
      Navigator.pop(context);
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  delWorkExp(context, {id, object}) async {
    ApiResponse response = await deleteWorkExperience(id.toString());
    if (response.status == 200) {
      workExperiences.remove(object);
      await showSnack(context: context, msg: "Deleted successfully");
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
    notifyListeners();
  }

  fetchEducationExperience(context) async {
    educationExperiences = await fetchEducationExp(context);
    notifyListeners();
    // calculateProfilePercent();
  }

  addEducationExp(context,
      {courseId,
      specializationId,
      instituteName,
      yearOfPassing,
      educationId}) async {
    var educationData = {
      "course_id": courseId,
      "specialization_id": specializationId,
      "education_id": educationId,
      "institute_name": instituteName,
      "year_of_passing": yearOfPassing
    };
    ApiResponse response = await addEducationExperience(educationData);
    if (response.status == 200) {
      await showSnack(context: context, msg: "Education added successfully");
      fetchEducationExperience(context);
      Navigator.pop(context);
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  updateEducationExp(context,
      {courseId,
      educationExpId,
      specializationId,
      instituteName,
      yearOfPassing,
      educationId}) async {
    var educationData = {
      'id': educationExpId,
      "course_id": courseId,
      "specialization_id": specializationId,
      "education_id": educationId,
      "institute_name": instituteName,
      "year_of_passing": yearOfPassing
    };
    ApiResponse response = await editEducationExperience(educationData);
    if (response.status == 200) {
      await showSnack(context: context, msg: "Education updated successfully");
      fetchEducationExperience(context);
      Navigator.pop(context);
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
  }

  delEducationExp(context, {id, object}) async {
    ApiResponse response = await deleteEducationExperience(id.toString());
    if (response.status == 200) {
      educationExperiences.remove(object);
      await showSnack(context: context, msg: "Deleted successfully");
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
    notifyListeners();
  }

  fetchCertificateExperience(context) async {
    certificateExperiences = await fetchCertificateExp(context);
    notifyListeners();
    // calculateProfilePercent();
  }

  addCertificate(context,
      {certificateTitle,
      selectedCerficate,
      nameOfInstitute,
      yearOfAchieving}) async {
    if (selectedCerficate == null) {
      return toast("Please select certificate to upload");
    }
    var certificateData = {
      "title": certificateTitle,
      "institute_name": nameOfInstitute,
      "year_of_achieving_certificate": yearOfAchieving,
      "file_name": kIsWeb
          ? selectedCerficate.name
          : selectedCerficate.path.toString().split('/').last,
      "file": kIsWeb
          ? MultipartFile.fromBytes(selectedCerficate.bytes,
              filename: selectedCerficate.name)
          : await MultipartFile.fromFile(selectedCerficate.path,
              filename: selectedCerficate.path.toString().split('/').last),
    };
    ApiResponse response = await addCertificates(certificateData);
    if (response.status == 200) {
      await showSnack(context: context, msg: "Certificate added successfully");
      await fetchCertificateExperience(context);
      Navigator.pop(context);
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
  }

  updateCertificate(context,
      {certificateTitle,
      selectedCerficate,
      nameOfInstitute,
      certificateId,
      nameOfCertificate,
      yearOfAchieving}) async {
    var certificateData = {
      'id': certificateId,
      "title": certificateTitle,
      "institute_name": nameOfInstitute,
      "year_of_achieving_certificate": yearOfAchieving,
    };
    if (selectedCerficate != null) {
      certificateData['file_name'] = kIsWeb
          ? selectedCerficate.name
          : selectedCerficate.path.toString().split('/').last;
      certificateData["file"] = kIsWeb
          ? MultipartFile.fromBytes(selectedCerficate.bytes,
              filename: selectedCerficate.name)
          : await MultipartFile.fromFile(selectedCerficate.path,
              filename: selectedCerficate.path.toString().split('/').last);
    } else {
      certificateData['file_name'] = nameOfCertificate;
    }
    ApiResponse response = await editCertificates(certificateData);
    if (response.status == 200) {
      await showSnack(
          context: context, msg: "Certificate updated successfully");
      await fetchCertificateExperience(context);
      Navigator.pop(context);
    } else {
      await showSnack(
          context: context, msg: response.body!.message, type: 'error');
    }
  }

  delCertificateExp(context, {id, object}) async {
    ApiResponse response = await deleteCertificate(id.toString());
    if (response.status == 200) {
      certificateExperiences.remove(object);
      await showSnack(context: context, msg: "Deleted successfully");
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
    notifyListeners();
  }

  addCurrentJobData(
    context, {
    currentlyEmployed,
    jobTitle,
    currentJobId,
    companyName,
    industryId,
    jobDescription,
    dateOfJoining,
    currentSalary,
    noticePeriod,
    noticePeriodDays,
    noticePeriodType,
    salaryType,
  }) async {
    var currentJobData = {
      "currently_employed": currentlyEmployed,
      "job_title": jobTitle,
      "company_name": companyName,
      "industry_id": industryId,
      "job_description": jobDescription,
      "date_of_joining": dateOfJoining,
      "current_salary": currentSalary,
      "notice_period": noticePeriod,
      "notice_period_type": noticePeriodType,
      "salary_type": salaryType,
      "notice_period_days": noticePeriodDays == '' ? null : noticePeriodDays
    };

    ApiResponse response;
    if (currentJobId != null) {
      currentJobData['id'] = currentJobId;
      response = await editCurrentJobDetails(currentJobData);
    } else {
      response = await addCurrentJobDetails(currentJobData);
    }

    if (response.status == 200) {
      fetchCurrentJobData(context);
      await showSnack(
          context: context, msg: "Current job updated successfully");
    } else {
      // await showSnack(
      //     context: context, msg: response.body!.message, type: 'error');
    }
  }

  fetchCurrentJobData(context) async {
    currentJobModel = await fetchCurrentJobDetails(context);
    notifyListeners();
  }

  deletCurrentJobData(context, {id}) async {
    currentJobModel = await deleteCurrentJobDetails(context, id);
    await fetchWorkExperience(context);
    notifyListeners();
  }
}
