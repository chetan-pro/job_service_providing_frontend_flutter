// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/applicants_model.dart';
import 'package:hindustan_job/candidate/model/candidate_data_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';

Future apiCaller({method, body, url}) async {
  switch (method) {
    case 'POST':
      break;
    case 'GET':
      break;
    case 'DELETE':
      break;
    case 'BASE':
      break;
    default:
  }
  return null;
}

Future fetchJobs(context) async {
  String url = JobsApiString.jobsList;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return JobModelTwo.fromJson(response.body!.data).jobsTwo;
  } else {
    return <JobsTwo>[];
  }
}

Future fetchRecommendedJobs(context) async {
  String url = JobsApiString.jobsRecommendedList;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return JobModelTwo.fromJson(response.body!.data).jobsTwo;
  } else {
    return <JobsTwo>[];
  }
}

Future applyOnJobs(context, applyData) async {
  String url = JobsApiString.applyOnJobs;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: url, headers: headers, body: applyData, media: true);
}

Future acceptRejectOfferLetter(context, applyData) async {
  String url = JobsApiString.acceptRejectOffer;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, headers: headers, body: applyData);
}

Future deleteJobPost(context, {jobId}) async {
  String url = JobsApiString.deleteJobPost + "/$jobId";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.delete(url, headers: headers);
}

Future addLikeOnJobs(context, {jobId}) async {
  String url = JobsApiString.addUserLikedJobs + "/$jobId";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, headers: headers);
}

Future changeJobStatus(context, {data}) async {
  String url = JobsApiString.changeJobStatus;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: data, headers: headers);
}

Future changePostStatus(context, {data}) async {
  String url = JobsApiString.changePostStatus;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: data, headers: headers);
}

Future addNotInterested(context, {jobId}) async {
  String url = JobsApiString.addNotInterestedJobs + "/$jobId";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, headers: headers);
}

Future acceptRejectShortListCandidate(context,
    {jobId, userId, status, reason}) async {
  var carryData = {
    "company_status": status,
    "job_post_id": jobId,
    "user_id": userId
  };
  if (reason != null) {
    carryData["reason"] = reason;
  }
  String url = JobsApiString.acceptRejectShorlistCandidate;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, headers: headers, body: carryData);
}

Future sendOfferLetterToCandidate(context,
    {jobId, userId, status, offerLetter}) async {
  var carryData = {"job_post_id": jobId, "user_id": userId};
  if (offerLetter != null) {
    carryData["file"] = kIsWeb
        ? MultipartFile.fromBytes(offerLetter.bytes,
            filename: offerLetter!.name)
        : await MultipartFile.fromFile(offerLetter.path,
            filename: offerLetter.path.split('/').last);
  }
  String url = JobsApiString.sendOffer;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: url, headers: headers, body: carryData, media: true);
}

Future addUserAppliedJobsCompany(context,
    {jobId, userId, status, offerLetter}) async {
  var carryData = {"job_post_id": jobId, "user_id": userId};
  if (offerLetter != null) {
    carryData["OfferLetter"] = kIsWeb
        ? MultipartFile.fromBytes(offerLetter.bytes,
            filename: offerLetter!.name)
        : await MultipartFile.fromFile(offerLetter.path,
            filename: offerLetter.path.split('/').last);
  }
  String url = JobsApiString.addUserAppliedJobsCompany;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: url, headers: headers, body: carryData, media: true);
}

Future fetchJobHistoryData(context, additionalUrl, {page}) async {
  String url = JobsApiString.jobHistoryData;
  if (additionalUrl != null) {
    url = url + additionalUrl;
  }
  if (page != null) {
    url = url + "${additionalUrl != null ? '?' : '&'}page=$page";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return ApplicantsCompanyModel.fromJson(response.body!.data).applicants;
  } else {
    return <Applicants>[];
  }
}

Future fetchLikedJobs(context, {page, sortByRelevance}) async {
  String url = JobsApiString.userLikedJobs;
  if (page != null) {
    url = url + "?page=$page";
  }
  if (sortByRelevance != null) {
    url = url + "&sortBy=$sortByRelevance";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return JobModelTwo.fromJson(response.body!.data).jobsTwo;
  } else {
    return <JobsTwo>[];
  }
}

Future fetchShortListedJob(context, {page, sortByRelevance}) async {
  String url = JobsApiString.userShortListedJobs;
  if (page != null) {
    url = url + "?page=$page";
  }
  if (sortByRelevance != null) {
    url = url + "&sortBy=$sortByRelevance";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return JobModelTwo.fromJson(response.body!.data).jobsTwo;
  } else {
    return <JobsTwo>[];
  }
}

Future fetchAppliedJob(context,
    {page, candidateStatus, companyStatus, sortByRelevance}) async {
  String url = JobsApiString.userAppliedJobs + "?";
  if (sortByRelevance != null) {
    url = url + "sortBy=$sortByRelevance&";
  }
  if (candidateStatus != null) {
    url = url + "filter_by_candidate_status=$candidateStatus&";
  }
  if (companyStatus != null) {
    url = url + "filter_by_company_status=$companyStatus&";
  }
  if (page != null) {
    url = url + "page=$page";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return JobModelTwo.fromJson(response.body!.data).jobsTwo;
  } else {
    return <JobsTwo>[];
  }
}

Future fetchNotInterestedJobs(context, {page, sortByRelevance}) async {
  String url = JobsApiString.notInterestedJobs + "?";
  if (sortByRelevance != null) {
    url = url + "sortBy=$sortByRelevance&";
  }
  if (page != null) {
    url = url + "page=$page";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return JobModelTwo.fromJson(response.body!.data).jobsTwo;
  } else {
    return <JobsTwo>[];
  }
}

Future fetchCandidateAppliedOnJobs(context, {additionalUrl}) async {
  String url = JobsApiString.appliedCandidates;
  if (additionalUrl != null) {
    url = url + additionalUrl;
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  print("::url:::");
  print(url);
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return ApplicantsModel.fromJson(response.body!.data).applicants;
  } else {
    return <UserData>[];
  }
}

Future fetchOpenCloseJobs(context, {page, jobStatus}) async {
  String url = JobsApiString.getOpenCloseJobs + "?job_status=$jobStatus";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return JobModelTwo.fromJson(response.body!.data).jobsTwo;
  } else {
    return <JobsTwo>[];
  }
}

Future fetchCandidatProfile(context, {candidateId, jobId}) async {
  String url = JobsApiString.getCandidateData + "?user_id=$candidateId";
  if (jobId != null) {
    url = url + "&job_id=$jobId";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return CandidateProfileModel.fromJson(response.body!.data);
  } else {
    return CandidateProfileModel();
  }
}

Future filterJobs(context, {additionalUrl}) async {
  String url = JobsApiString.jobSearchList;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  if (additionalUrl != null) {
    url = url + additionalUrl;
  }
  ApiResponse response = await ApiProvider.get(url, headers: headers);

  if (response.status == 200 && response.body!.data != null) {
    return JobModelTwo.fromJson(response.body!.data).jobsTwo;
  } else {
    return <JobsTwo>[];
  }
}

Future jobDetails(context, {jobId}) async {
  String url = JobsApiString.jobDetail + "/$jobId";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return JobsTwo.fromJson(response.body!.data);
  } else {
    return JobsTwo;
  }
}

Future addAJob(context, navigate, jobData, {isFromPreview}) async {
  String url = JobsApiString.addJob;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.post(
      url: url, body: jobData, media: true, headers: headers);

  if (response.status == 200) {
    showSnack(
      context: context,
      msg: "Job posted successfully",
    );
    fetchOpenCloseJobs(context, page: 1, jobStatus: 'OPEN');
    if (isFromPreview != null) {
      Navigator.pop(context);
    }
    if (kIsWeb) {
      navigate.to("/home-company");
    } else {
      return Navigator.pop(context);
    }
  } else {
    showSnack(context: context, msg: response.body!.message, type: 'error');
  }
}

Future editAJob(context, jobData, {isFromPreview}) async {
  String url = JobsApiString.editJob;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.post(
      url: url, body: jobData, media: true, headers: headers);
  if (response.status == 200) {
    showSnack(
      context: context,
      msg: "Job edited successfully",
    );
    if (isFromPreview != null) {
      Navigator.pop(context);
    }
    return Navigator.pop(context);
  }
}

Future addJobPostAnswer(context, {answer, questionId}) async {
  String url = JobsApiString.addJobPostAnswer + '/$questionId';
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.post(
      url: url, body: {"answer": answer}, headers: headers);
  if (response.status == 200) {
    showSnack(
      context: context,
      msg: "Answers submited",
    );
  }
}

getJobTypeCount() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(JobsApiString.getJobTypeCount, headers: headers);
}
