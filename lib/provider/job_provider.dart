// ignore_for_file: unused_import, unnecessary_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/candidate_data_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/api_services/jobs_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/message_string.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:dio/dio.dart';

class JobDataChangeNotifier extends ChangeNotifier {
  JobDataChangeNotifier();

  List jobAppliedCandidates = [];
  List jobAppliedApplicants = [];
  List jobShortlistedApplicants = [];
  List jobAcceptedOffersApplicants = [];
  List<JobsTwo> filterJobsList = [];
  List<JobsTwo> favJobs = [];
  List<JobsTwo> appliedJobs = [];
  List<JobsTwo> shortListedJobs = [];
  List<JobsTwo> offeredJobs = [];
  List<JobsTwo> hiredJobs = [];
  List<JobsTwo> rejectedJobs = [];
  List<JobsTwo> rejectedByYouJobs = [];
  List<JobsTwo> notInterestedJobs = [];
  List<JobsTwo> nearJobs = [];
  List<JobsTwo> recommendJobs = [];
  List<JobsTwo> latestJobs = [];
  List applicantsApplied = [];
  List applicantsShortListed = [];
  List applicantsJobOffers = [];
  List applicantsAcceptedOffer = [];
  List applicantsRejectedOffer = [];
  List applicantsHired = [];
  List applicantsRejected = [];
  List<JobsTwo> openJobs = [];
  List<JobsTwo> closeJobs = [];
  CandidateProfileModel? candidate;

  bool isApplied = false;
  bool isClosed = false;
  bool isShortListed = false;
  bool isOfferSend = false;
  bool isRejected = false;
  bool isRejectedByCandidate = false;
  bool isAccepted = false;
  bool isLoading = true;
  bool isVisible = false;

  fetchCompanyHomeData(context) async {
    fetchApplicantsData(context);
    fetchOpenJob(context);
    fetchCloseJob(context);
    notifyListeners();
  }

  fetchApplicantsData(context) async {
    jobAppliedApplicants = await fetchCandidateAppliedOnJobs(context,
        additionalUrl: "?application_status=${CandidateStatus.applyJob}");
    jobShortlistedApplicants = await fetchCandidateAppliedOnJobs(context,
        additionalUrl: "?application_status=${CompanyStatus.shortListed}");
    jobAcceptedOffersApplicants = await fetchCandidateAppliedOnJobs(context,
        additionalUrl: "?application_status=${CandidateStatus.acceptOffer}");
    notifyListeners();
  }

  updateStatus(status, {candidateStatus}) {
    switch (status) {
      case CompanyStatus.shortListed:
        isShortListed = true;
        isApplied = true;
        break;
      case CompanyStatus.rejected:
        isApplied = true;
        isRejected = true;
        break;
      case CompanyStatus.sendOffer:
        isApplied = true;
        isOfferSend = true;
        if (CandidateStatus.acceptOffer == candidateStatus) {
          isAccepted = true;
        } else if (CandidateStatus.rejectOffer == candidateStatus) {
          isRejectedByCandidate = true;
        }
        break;
      case CompanyStatus.pending:
        isApplied = true;
        isShortListed = false;
        break;
      default:
    }
    notifyListeners();
  }

  fetchHomeJobsCardData(context) async {
    recommendJobs = await fetchRecommendedJobs(context);
    nearJobs = await filterJobs(context,
        additionalUrl: "?filter_by_city=${userData!.cityId}");
    latestJobs = await filterJobs(context);
    isLoading = false;
    notifyListeners();
  }

  fetchFilterJobs(context, filter, {page}) async {
    String url = '?page=$page&';
    var filterData = filter;
    if (filterData.isNotEmpty) {
      for (String key in filterData.keys) {
        url = url + "$key=${filterData[key].toString()}&";
      }
    }
    // EasyLoading.show();
    if (page != null && page > 1) {
      filterJobsList = [
        ...filterJobsList,
        ...await filterJobs(context, additionalUrl: url)
      ];
    } else {
      filterJobsList = await filterJobs(context, additionalUrl: url);
    }
    notifyListeners();
  }

  likeUnlike(context, jobId, cardState) async {
    ApiResponse response = await addLikeOnJobs(context, jobId: jobId);
    // if (cardState == null) {
    //   filterJobsList = fetchFavoriteJobs(context);
    //   notifyListeners();
    // }
    switch (cardState) {
      case CardState.recommend:
        recommendJobs =
            addRemoveLikeMapFunction(recommendJobs, response, jobId);
        notifyListeners();
        break;
      case CardState.latest:
        latestJobs = addRemoveLikeMapFunction(latestJobs, response, jobId);
        notifyListeners();
        break;
      case CardState.near:
        nearJobs = addRemoveLikeMapFunction(nearJobs, response, jobId);
        notifyListeners();
        break;
      case CardState.fav:
        favJobs = addRemoveLikeMapFunction(favJobs, response, jobId);
        favJobs.removeWhere((element) => element.id == jobId);
        notifyListeners();
        break;
      case CardState.applied:
        appliedJobs = addRemoveLikeMapFunction(appliedJobs, response, jobId);
        notifyListeners();
        break;
      case CardState.shortListed:
        shortListedJobs =
            addRemoveLikeMapFunction(shortListedJobs, response, jobId);
        notifyListeners();
        break;
      case CardState.offer:
        offeredJobs = addRemoveLikeMapFunction(offeredJobs, response, jobId);
        notifyListeners();
        break;
      case CardState.filter:
        filterJobsList =
            addRemoveLikeMapFunction(filterJobsList, response, jobId);
        notifyListeners();
        break;
      case CardState.hired:
        hiredJobs = addRemoveLikeMapFunction(hiredJobs, response, jobId);
        notifyListeners();
        break;
      case CardState.rejected:
        rejectedJobs = addRemoveLikeMapFunction(rejectedJobs, response, jobId);
        rejectedByYouJobs =
            addRemoveLikeMapFunction(rejectedByYouJobs, response, jobId);
        notifyListeners();
        break;
      default:
        filterJobsList =
            addRemoveLikeMapFunction(filterJobsList, response, jobId);
    }
    if (CardState.fav != cardState) {
      fetchFavoriteJobs(context, page: 1);
    }
    notifyListeners();
    return response.body!.data;
  }

  addInNotInterested(context, jobId, cardState) async {
    ApiResponse response = await addNotInterested(context, jobId: jobId);
    fetchNotInterestedJobs(context);
    switch (cardState) {
      case CardState.recommend:
        recommendJobs = fetchRecommendJobs(context);
        notifyListeners();
        break;
      case CardState.latest:
        latestJobs = await filterJobs(context);
        notifyListeners();
        break;
      case CardState.near:
        nearJobs = await filterJobs(context,
            additionalUrl: "?filter_by_city=${userData!.cityId}");
        notifyListeners();
        break;
      case CardState.fav:
        await fetchFavoriteJobs(context);
        notifyListeners();
        break;
      case CardState.applied:
        await fetchAppliedJobs(context);
        notifyListeners();
        break;
      case CardState.shortListed:
        await fetchShortListedJobs(context);
        notifyListeners();
        break;
      case CardState.offer:
        await fetchOfferedJobs(context);
        notifyListeners();
        break;
      case CardState.filter:
        await fetchFilterJobs(context, {});
        notifyListeners();
        break;
      case CardState.hired:
        await fetchHiredJobs(context);
        notifyListeners();
        break;
      case CardState.rejected:
        await fetchRejectedByYouJobs(context);
        notifyListeners();
        break;
      default:
        await fetchFilterJobs(context, {});
    }

    notifyListeners();
    return response.body!.data;
  }

  addRemoveLikeMapFunction(List<JobsTwo> list, ApiResponse response, jobId) {
    return list.map((element) {
      if (element.id == jobId) {
        element.userLikedJob = response.body!.data != null
            ? UserLikedJob.fromJson(response.body!.data)
            : null;
      }
      return element;
    }).toList();
  }

  fetchRecommendJobs(context) async {
    recommendJobs = await fetchRecommendedJobs(context);
    notifyListeners();
  }

  deleteJob(context, {jobId, flag}) async {
    ApiResponse response = await deleteJobPost(context, jobId: jobId);
    if (response.status == 200) {
      await fetchCloseJob(context);
      await fetchOpenJob(context);
      Navigator.pop(context);
    } else {}
    notifyListeners();
  }

  removeFalse() {
    isApplied = false;
    isShortListed = false;
    isRejectedByCandidate = false;
    isOfferSend = false;
    isRejected = false;
    isAccepted = false;
  }

  fetchFavoriteJobs(context, {page, sortByRelevance}) async {
    if (page != null && page > 1) {
      favJobs = [
        ...favJobs,
        ...await fetchLikedJobs(context,
            page: page, sortByRelevance: sortByRelevance)
      ];
    } else {
      favJobs = await fetchLikedJobs(context,
          page: page, sortByRelevance: sortByRelevance);
    }

    notifyListeners();
  }

  fetchShortListedJobs(context, {page, sortByRelevance}) async {
    if (page != null && page > 1) {
      shortListedJobs = [
        ...shortListedJobs,
        ...await fetchAppliedJob(context,
            page: page,
            companyStatus: CompanyStatus.shortListed,
            sortByRelevance: sortByRelevance)
      ];
    } else {
      shortListedJobs = await fetchAppliedJob(context,
          page: page,
          companyStatus: CompanyStatus.shortListed,
          sortByRelevance: sortByRelevance);
    }
    notifyListeners();
  }

  fetchOfferedJobs(context, {page, sortByRelevance}) async {
    if (page != null && page > 1) {
      offeredJobs = [
        ...offeredJobs,
        ...await fetchAppliedJob(context,
            page: page,
            companyStatus: CompanyStatus.sendOffer,
            candidateStatus: CandidateStatus.applyJob,
            sortByRelevance: sortByRelevance)
      ];
    } else {
      offeredJobs = await fetchAppliedJob(context,
          page: page,
          companyStatus: CompanyStatus.sendOffer,
          candidateStatus: CandidateStatus.applyJob,
          sortByRelevance: sortByRelevance);
    }
    notifyListeners();
  }

  fetchHiredJobs(context, {page, sortByRelevance}) async {
    if (page != null && page > 1) {
      hiredJobs = [
        ...hiredJobs,
        ...await fetchAppliedJob(context,
            page: page,
            companyStatus: CompanyStatus.sendOffer,
            candidateStatus: CandidateStatus.acceptOffer,
            sortByRelevance: sortByRelevance)
      ];
    } else {
      hiredJobs = await fetchAppliedJob(context,
          page: page,
          companyStatus: CompanyStatus.sendOffer,
          candidateStatus: CandidateStatus.acceptOffer,
          sortByRelevance: sortByRelevance);
    }
    notifyListeners();
  }

  fetchRejectedJobs(context, {page, sortByRelevance}) async {
    if (page != null && page > 1) {
      rejectedJobs = [
        ...rejectedJobs,
        ...await fetchAppliedJob(context,
            page: page,
            companyStatus: CompanyStatus.rejected,
            candidateStatus: CandidateStatus.applyJob,
            sortByRelevance: sortByRelevance)
      ];
    } else {
      rejectedJobs = await fetchAppliedJob(context,
          page: page,
          companyStatus: CompanyStatus.rejected,
          candidateStatus: CandidateStatus.applyJob,
          sortByRelevance: sortByRelevance);
    }
    notifyListeners();
  }

  fetchRejectedByYouJobs(context, {page}) async {
    if (page != null && page > 1) {
      rejectedByYouJobs = [
        ...rejectedByYouJobs,
        ...await fetchAppliedJob(context,
            page: page,
            companyStatus: CompanyStatus.sendOffer,
            candidateStatus: CandidateStatus.rejectOffer)
      ];
    } else {
      rejectedByYouJobs = await fetchAppliedJob(context,
          page: page,
          companyStatus: CompanyStatus.sendOffer,
          candidateStatus: CandidateStatus.rejectOffer);
    }
    notifyListeners();
  }

  fetchNotInterestedJob(context, {page, sortByRelevance}) async {
    if (page != null && page > 1) {
      notInterestedJobs = [
        ...notInterestedJobs,
        ...await fetchNotInterestedJobs(context,
            page: page, sortByRelevance: sortByRelevance)
      ];
    } else {
      notInterestedJobs = await fetchNotInterestedJobs(context,
          page: page, sortByRelevance: sortByRelevance);
    }
    notifyListeners();
  }

  fetchAppliedJobs(context, {page, sortByRelevance}) async {
    if (page != null && page > 1) {
      appliedJobs = [
        ...appliedJobs,
        ...await fetchAppliedJob(context,
            page: page,
            candidateStatus: CandidateStatus.applyJob,
            companyStatus: CompanyStatus.pending)
      ];
    } else {
      appliedJobs = await fetchAppliedJob(context,
          page: page,
          sortByRelevance: sortByRelevance,
          candidateStatus: CandidateStatus.applyJob,
          companyStatus: CompanyStatus.pending);
    }
    notifyListeners();
  }

  jobLike(context, {jobId}) async {
    ApiResponse response = await addLikeOnJobs(context, jobId: jobId);
    if (response.status == 200) {
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  applyJob(context, {jobId, file}) async {
    Map<String, dynamic> carryData = {'id': jobId.toString()};
    if (file != null) {
      carryData['file'] = kIsWeb
          ? MultipartFile.fromBytes(file.bytes, filename: file.name)
          : await MultipartFile.fromFile(file.path,
              filename: file.path.toString().split('/').last);
    }
    ApiResponse response = await applyOnJobs(context, carryData);
    if (response.status == 200) {
      showSnack(context: context, msg: JobMessage.appliedJob);
      isApplied = true;
      await fetchAppliedJobs(context);

      notifyListeners();
      await fetchHomeJobsCardData(context);
      await fetchAppliedJobs(context);
      await fetchFavoriteJobs(context);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  acceptRejectOffer(context, {jobId, status}) async {
    Map<String, dynamic> carryData = {
      "candidate_status": status,
      "job_post_id": jobId.toString()
    };
    ApiResponse response = await acceptRejectOfferLetter(context, carryData);
    if (response.status == 200) {
      if (status == CandidateStatus.rejectOffer) {
        showSnack(context: context, msg: JobMessage.rejectedOfferJob);
      } else {
        showSnack(context: context, msg: JobMessage.acceptedOfferJob);
      }
      if (status == CandidateStatus.rejectOffer) {
        isRejected = true;
      } else {
        isAccepted = true;
      }
      notifyListeners();
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  jobHistoryData(context, jobId) async {
    await fetchJobAppliedCandidate(
      context,
      jobId: jobId,
      status: CandidateStatus.applyJob,
    );
    await fetchJobAppliedCandidate(context,
        jobId: jobId, status: CandidateStatus.acceptOffer);
    await fetchJobAppliedCandidate(context,
        jobId: jobId, status: CandidateStatus.rejectOffer);
    await fetchJobAppliedCandidate(context,
        jobId: jobId, status: CompanyStatus.sendOffer);
    await fetchJobAppliedCandidate(context,
        jobId: jobId, status: CompanyStatus.shortListed);
    await fetchJobAppliedCandidate(context,
        jobId: jobId, status: CompanyStatus.rejected);
    notifyListeners();
  }

  fetchJobAppliedCandidate(context, {jobId, status}) async {
    switch (status) {
      case CandidateStatus.applyJob:
        applicantsApplied = await fetchJobHistory(context,
            jobId: jobId,
            candidateStatus: CandidateStatus.applyJob,
            companyStatus: CompanyStatus.pending);
        break;
      case CandidateStatus.acceptOffer:
        applicantsAcceptedOffer = await fetchJobHistory(context,
            jobId: jobId, candidateStatus: CandidateStatus.acceptOffer);
        break;
      case CandidateStatus.rejectOffer:
        applicantsRejectedOffer = await fetchJobHistory(context,
            jobId: jobId, candidateStatus: CandidateStatus.rejectOffer);
        break;
      case CompanyStatus.sendOffer:
        applicantsJobOffers = await fetchJobHistory(context,
            jobId: jobId,
            companyStatus: CompanyStatus.sendOffer,
            candidateStatus: CandidateStatus.applyJob);
        break;
      case CompanyStatus.shortListed:
        applicantsShortListed = await fetchJobHistory(context,
            jobId: jobId, companyStatus: CompanyStatus.shortListed);
        break;
      case CompanyStatus.rejected:
        applicantsRejected = await fetchJobHistory(context,
            jobId: jobId, companyStatus: CompanyStatus.rejected);
        break;
    }
    notifyListeners();
  }

  changeCandidateStatus(context, {jobId, userId, companyStatus, reason}) async {
    ApiResponse response = await acceptRejectShortListCandidate(context,
        jobId: jobId, userId: userId, status: companyStatus, reason: reason);
    if (response.status == 200) {
      if (companyStatus == CompanyStatus.shortListed) {
        showSnack(context: context, msg: JobMessage.shortlistedJob);
      } else if (companyStatus == CompanyStatus.pending) {
        showSnack(context: context, msg: JobMessage.removedShortlistedJob);
      } else {
        showSnack(context: context, msg: JobMessage.rejectedJob);
      }
      await updateStatus(companyStatus);
      await fetchJobAppliedCandidate(
        context,
        jobId: jobId,
        status: companyStatus,
      );
      showSnack(context: context, msg: response.body!.message.toString());
      notifyListeners();
    }
  }

  sendOfferLetter(context, {jobId, userId, companyStatus, offerLetter}) async {
    ApiResponse response = await sendOfferLetterToCandidate(context,
        jobId: jobId,
        userId: userId,
        status: companyStatus,
        offerLetter: offerLetter);
    if (response.status == 200) {
      showSnack(context: context, msg: JobMessage.sendOffer);
      await updateStatus(companyStatus);
      await jobHistoryData(context, jobId);
      notifyListeners();
    }
  }

  sendOfferLetterToJobSeeker(context,
      {jobId, userId, companyStatus, offerLetter}) async {
    ApiResponse response = await addUserAppliedJobsCompany(context,
        jobId: jobId,
        userId: userId,
        status: companyStatus,
        offerLetter: offerLetter);
    if (response.status == 200) {
      jobAppliedCandidates.removeWhere((element) => element.id == userId);
      showSnack(context: context, msg: JobMessage.sendOffer);
      await updateStatus(companyStatus);
      await jobHistoryData(context, jobId);
      notifyListeners();
    }
  }

  fetchJobHistory(context, {jobId, companyStatus, candidateStatus}) async {
    String additionalUrl = '?';
    if (jobId != null) {
      additionalUrl = additionalUrl + "job_post_id=$jobId&";
    }
    if (companyStatus != null) {
      additionalUrl =
          additionalUrl + "filter_by_company_status=$companyStatus&";
    }
    if (candidateStatus != null) {
      additionalUrl =
          additionalUrl + "filter_by_candidate_status=$candidateStatus";
    }
    return await fetchJobHistoryData(context, additionalUrl);
  }

  fetchOpenJob(context, {page, filterData}) async {
    if (page != null && page > 1) {
      openJobs = [
        ...openJobs,
        ...await fetchOpenCloseJobs(context, jobStatus: JobStatus.open)
      ];
    } else {
      openJobs = await fetchOpenCloseJobs(context, jobStatus: JobStatus.open);
    }
    notifyListeners();
  }

  fetchCloseJob(context, {page}) async {
    if (page != null && page > 1) {
      closeJobs = [
        ...closeJobs,
        ...await fetchOpenCloseJobs(context, jobStatus: JobStatus.close)
      ];
    } else {
      closeJobs = await fetchOpenCloseJobs(context, jobStatus: JobStatus.close);
    }
    notifyListeners();
  }

  checkJobClosing(status) {
    isClosed = status == 'OPEN' ? false : true;
    notifyListeners();
  }

  checkPostStatus(status) {
    isVisible = status == 0 ? false : true;
    notifyListeners();
  }

  changeStatusJob(context, data) async {
    ApiResponse response = await changeJobStatus(context, data: data);
    if (response.status == 200) {
      isClosed = !isClosed;
      fetchOpenJob(context);
      fetchCloseJob(context);
    }
    notifyListeners();
  }

  changeJobVisibility(context, data) async {
    ApiResponse response = await changePostStatus(context, data: data);
    if (response.status == 200) {
      isVisible = !isVisible;
    }
    notifyListeners();
  }

  fetchJobAppliedCandidates(context, {filterData, page}) async {
    String url = '?';
    if (page != null) {
      url = url + 'page=$page&';
    }
    if (filterData.isNotEmpty) {
      for (String key in filterData.keys) {
        if (boolValueAddNull(filterData[key])) {
          url = url + "$key=${filterData[key].toString()}&";
        }
      }
    }
    if (page != null && page > 1) {
      jobAppliedCandidates = [
        ...jobAppliedCandidates,
        ...await fetchCandidateAppliedOnJobs(context, additionalUrl: url)
      ];
    } else {
      jobAppliedCandidates =
          await fetchCandidateAppliedOnJobs(context, additionalUrl: url);
    }

    notifyListeners();
  }

  fetchCandidateData(context, refresh, {candidateId, jobId}) async {
    if (refresh) {
      candidate = null;
      notifyListeners();
    }
    candidate = await fetchCandidatProfile(context,
        candidateId: candidateId, jobId: jobId);
    notifyListeners();
  }
}
