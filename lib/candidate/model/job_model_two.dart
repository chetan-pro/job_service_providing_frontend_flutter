// ignore_for_file: avoid_print

import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';

class JobModelTwo {
  dynamic count;
  List<JobsTwo>? jobsTwo;

  JobModelTwo({this.count, this.jobsTwo});

  JobModelTwo.fromJson(Map<String, dynamic> json) {
    // count = json['count'];
    if (json['rows'] != null) {
      jobsTwo = <JobsTwo>[];
      json['rows'].forEach((v) {
        if (v['JobPost'] != null) {
          v['JobPost']['offer_letter'] = v['offer_letter'];
          v['JobPost']['company_status'] = v['company_status'];
          v['JobPost']['candidate_status'] = v['candidate_status'];
          jobsTwo!.add(JobsTwo.fromJson(v['JobPost']));
        } else {
          jobsTwo!.add(JobsTwo.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (jobsTwo != null) {
      data['rows'] = jobsTwo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobsTwo {
  int? id;
  String? name;
  String? roleOfHiring;
  String? otherRoleOfHiring;
  String? jobTitle;
  int? industryId;
  int? sectorId;
  int? appliedUserCount;
  String? jobTimetable;
  int? jobTypeId;
  String? experienceRequired;
  dynamic expFrom;
  dynamic expFromType;
  dynamic expToType;
  dynamic expTo;
  String? educationRequired;
  int? cityId;
  int? stateId;
  String? cityName;
  String? stateName;
  String? pinCode;
  int? numberOfPosition;
  String? workFromHome;
  String? employmentType;
  String? contractType;
  int? contractDuration;
  String? candidateStatus;
  String? companyStatus;
  String? jobSchedule;
  dynamic salaryType;
  dynamic salary;
  NotInterested? notInterested;
  String? paidType;
  dynamic salaryFrom;
  dynamic salaryTo;
  String? submitResume;
  String? email;
  String? jobDescription;
  int? userId;
  int? status;
  String? reason;
  String? createdAt;
  String? updatedAt;
  String? jobTypeName;
  Industry? industry;
  Sector? sector;
  City? city;
  dynamic subSkills;
  UserData? user;
  States? state;
  States? boostingJobStateData;
  List<JobPostSkills>? jobPostSkills;
  Industry? educationDatum;
  Industry? jobType;
  Industry? jobRoleType;
  String? otherContractType;
  String? jobTimeFrom;
  String? jobTimeTo;
  String? offerLetter;
  List<Questions>? questions;
  UserLikedJob? userLikedJob;
  UserAppliedJob? userAppliedJob;
  String? jobStatus;
  int? applyCount;
  String? deadline;
  String? organization;
  String? advertiseLink;
  String? officialWebsite;
  String? image;

  JobsTwo(
      {this.id,
      this.name,
      this.deadline,
      this.advertiseLink,
      this.organization,
      this.officialWebsite,
      this.image,
      this.roleOfHiring,
      this.otherRoleOfHiring,
      this.jobTitle,
      this.industryId,
      this.sectorId,
      this.jobTimetable,
      this.appliedUserCount,
      this.notInterested,
      this.jobTypeId,
      this.experienceRequired,
      this.expFrom,
      this.expFromType,
      this.expToType,
      this.expTo,
      this.reason,
      this.educationRequired,
      this.cityId,
      this.userLikedJob,
      this.stateId,
      this.pinCode,
      this.numberOfPosition,
      this.workFromHome,
      this.candidateStatus,
      this.companyStatus,
      this.employmentType,
      this.contractType,
      this.contractDuration,
      this.jobSchedule,
      this.salaryType,
      this.salary,
      this.paidType,
      this.salaryFrom,
      this.salaryTo,
      this.submitResume,
      this.email,
      this.subSkills,
      this.jobDescription,
      this.userId,
      this.status,
      this.cityName,
      this.stateName,
      this.userAppliedJob,
      this.offerLetter,
      this.createdAt,
      this.updatedAt,
      this.industry,
      this.applyCount,
      this.otherContractType,
      this.city,
      this.sector,
      this.user,
      this.state,
      this.boostingJobStateData,
      this.jobTypeName,
      this.jobPostSkills,
      this.educationDatum,
      this.questions,
      this.jobType,
      this.jobTimeFrom,
      this.jobTimeTo,
      this.jobRoleType,
      this.jobStatus});

  JobsTwo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    roleOfHiring = json['role_of_hiring'];
    otherRoleOfHiring = json['other_role_of_hiring'];
    jobTitle = json['job_title'];
    appliedUserCount = json['appliedUserCount'];
    industryId = json['industry_id'];
    deadline = json['deadline'];
    advertiseLink = json['advertise_link'];
    officialWebsite = json['offical_website'];
    image = json['image'];
    jobTimeFrom = json['job_time_from'];
    jobTimeTo = json['job_time_to'];
    sectorId = json['sector_id'];
    jobTimetable = json['job_timetable'];
    jobTypeId = json['job_type_id'];
    experienceRequired = json['experience_required'];
    expFrom = json['exp_from'];
    expTo = json['exp_to'];
    subSkills = json['sub_skills'];
    educationRequired = json['education_required'];
    cityId = json['city_id'];
    notInterested = json['NotInterested'] != null
        ? new NotInterested.fromJson(json['NotInterested'])
        : null;
    stateId = json['state_id'];
    pinCode = json['pin_code'].toString();
    numberOfPosition = json['number_of_position'];
    workFromHome = json['work_from_home'];
    employmentType = json['employment_type'];
    contractType = json['contract_type'];
    contractDuration = json['contract_duration'];
    jobSchedule = json['job_schedule'];
    salaryType = json['salary_type'];
    salary = json['salary'];
    paidType = json['paid_type'];
    salaryFrom = json['salary_from'];
    salaryTo = json['salary_to'];
    reason =
        json['UserAppliedJobs'] != null && json['UserAppliedJobs'].isNotEmpty
            ? UserAppliedJob.fromJson(json['UserAppliedJobs'][0]).reason
            : json['reason'];
    submitResume = json['submit_resume'];
    email = json['email'];
    jobDescription = json['job_description'];
    offerLetter = json['offer_letter'];
    userId = json['user_id'];
    expFromType = json['exp_from_type'];
    expToType = json['exp_to_type'];
    status = json['status'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    jobTypeName = json['jobTypeName'];
    createdAt = json['createdAt'];
    companyStatus =
        json['UserAppliedJobs'] != null && json['UserAppliedJobs'].isNotEmpty
            ? UserAppliedJob.fromJson(json['UserAppliedJobs'][0]).companyStatus
            : json['company_status'];
    candidateStatus = json['UserAppliedJobs'] != null &&
            json['UserAppliedJobs'].isNotEmpty
        ? UserAppliedJob.fromJson(json['UserAppliedJobs'][0]).candidateStatus
        : json['candidate_status'];
    updatedAt = json['updatedAt'];
    otherContractType = json['contract_other_type'];
    jobStatus = json['job_status'];
    applyCount = json['applyCount'];
    userLikedJob = json['UserLikedJob'] != null
        ? UserLikedJob.fromJson(json['UserLikedJob'])
        : null;
    userAppliedJob =
        json['UserAppliedJobs'] != null && json['UserAppliedJobs'].isNotEmpty
            ? UserAppliedJob.fromJson(json['UserAppliedJobs'][0])
            : null;
    jobRoleType = json['JobRoleType'] != null
        ? Industry.fromJson(json['JobRoleType'])
        : null;
    industry =
        json['Industry'] != null ? Industry.fromJson(json['Industry']) : null;
    educationDatum = json['EducationDatum'] != null
        ? Industry.fromJson(json['EducationDatum'])
        : null;
    sector = json['Sector'] != null ? Sector.fromJson(json['Sector']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    user = json['User'] != null ? UserData.fromJson(json['User']) : null;
    state = json['state'] != null ? States.fromJson(json['state']) : null;
    boostingJobStateData = json['boosting_job_state_data'] != null
        ? States.fromJson(json['boosting_job_state_data'])
        : null;
    if (json['JobPostSkills'] != null) {
      jobPostSkills = <JobPostSkills>[];
      json['JobPostSkills'].forEach((v) {
        jobPostSkills!.add(JobPostSkills.fromJson(v));
      });
    }
    if (json['Questions'] != null) {
      questions = <Questions>[];
      json['Questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }

    jobType =
        json['JobType'] != null ? Industry.fromJson(json['JobType']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['applyCount'] = applyCount;
    data['role_of_hiring'] = roleOfHiring;
    data['other_role_of_hiring'] = otherRoleOfHiring;
    data['job_title'] = jobTitle;
    data['industry_id'] = industryId;
    data['sector_id'] = sectorId;
    data['job_timetable'] = jobTimetable;
    data['job_time_from'] = jobTimeFrom;
    data['job_time_to'] = jobTimeTo;
    data['offer_letter'] = offerLetter;
    data['company_status'] = companyStatus;
    data['candidate_status'] = candidateStatus;
    data['job_type_id'] = jobTypeId;
    data['experience_required'] = experienceRequired;
    data['exp_from'] = expFrom;
    data['job_status'] = jobStatus;
    data['appliedUserCount'] = appliedUserCount;
    data['exp_from_type'] = expFromType;
    data['exp_to_type'] = expToType;
    data['exp_to'] = expTo;
    if (this.notInterested != null) {
      data['NotInterested'] = this.notInterested!.toJson();
    }
    data['contract_other_type'] = otherContractType;
    data['sub_skills'] = subSkills;
    data['education_required'] = educationRequired;
    data['city_id'] = cityId;
    data['state_id'] = stateId;
    data['pin_code'] = pinCode;
    data['number_of_position'] = numberOfPosition;
    data['work_from_home'] = workFromHome;
    data['employment_type'] = employmentType;
    data['contract_type'] = contractType;
    data['contract_duration'] = contractDuration;
    data['job_schedule'] = jobSchedule;
    data['salary_type'] = salaryType;
    data['salary'] = salary;
    data['paid_type'] = paidType;
    data['salary_from'] = salaryFrom;
    data['salary_to'] = salaryTo;
    data['submit_resume'] = submitResume;
    data['email'] = email;
    data['job_description'] = jobDescription;
    data['user_id'] = userId;
    data['status'] = status;
    data['stateName'] = stateName;
    data['cityName'] = cityName;
    data['jobTypeName'] = jobTypeName;
    if (userLikedJob != null) {
      data['UserLikedJob'] = userLikedJob!.toJson();
    }
    if (userAppliedJob != null) {
      data['UserAppliedJobs'] = userAppliedJob!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (jobRoleType != null) {
      data['JobRoleType'] = jobRoleType!.toJson();
    }
    if (industry != null) {
      data['Industry'] = industry!.toJson();
    }
    if (sector != null) {
      data['Sector'] = sector!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (user != null) {
      data['User'] = user!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (boostingJobStateData != null) {
      data['boosting_job_state_data'] = boostingJobStateData!.toJson();
    }
    if (jobPostSkills != null) {
      data['JobPostSkills'] = jobPostSkills!.map((v) => v.toJson()).toList();
    }
    if (educationDatum != null) {
      data['EducationDatum'] = educationDatum!.toJson();
    }
    if (jobType != null) {
      data['JobType'] = jobType!.toJson();
    }
    if (questions != null) {
      data['Questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotInterested {
  int? id;
  int? jobPostId;
  int? userId;
  int? status;
  String? createdAt;
  String? updatedAt;

  NotInterested(
      {this.id,
      this.jobPostId,
      this.userId,
      this.status,
      this.createdAt,
      this.updatedAt});

  NotInterested.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobPostId = json['job_post_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_post_id'] = this.jobPostId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class UserAppliedJob {
  int? id;
  int? jobPostId;
  int? userId;
  String? companyStatus;
  String? candidateStatus;
  String? separateResume;
  String? reason;
  int? status;
  String? createdAt;
  String? updatedAt;
  UserData? hiredStaff;

  UserAppliedJob(
      {this.id,
      this.jobPostId,
      this.userId,
      this.companyStatus,
      this.candidateStatus,
      this.separateResume,
      this.reason,
      this.status,
      this.hiredStaff,
      this.createdAt,
      this.updatedAt});

  UserAppliedJob.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobPostId = json['job_post_id'];
    userId = json['user_id'];
    companyStatus = json['company_status'];
    candidateStatus = json['candidate_status'];
    separateResume = json['separate_resume'];
    status = json['status'];
    reason = json['reason'];
    hiredStaff = json['hiredStaff'] != null
        ? UserData.fromJson(json['hiredStaff'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_post_id'] = jobPostId;
    data['user_id'] = userId;
    data['company_status'] = companyStatus;
    data['candidate_status'] = candidateStatus;
    data['separate_resume'] = separateResume;
    data['status'] = status;
    data['reason'] = reason;
    data['hiredStaff'] = hiredStaff;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class UserLikedJob {
  int? id;
  int? jobPostId;
  int? userId;
  int? status;
  String? createdAt;
  String? updatedAt;

  UserLikedJob(
      {this.id,
      this.jobPostId,
      this.userId,
      this.status,
      this.createdAt,
      this.updatedAt});

  UserLikedJob.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      id = int.parse(json['id'].toString());
      jobPostId = int.parse(json['job_post_id'].toString());
      userId = int.parse(json['user_id'].toString());
      status = int.parse(json['status'].toString());
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_post_id'] = jobPostId;
    data['user_id'] = userId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class JobPostSkills {
  int? skillSubCategoryId;
  SkillSubCategories? skillSubCategories;

  JobPostSkills({this.skillSubCategoryId, this.skillSubCategories});

  JobPostSkills.fromJson(Map<String, dynamic> json) {
    skillSubCategoryId = json['skill_sub_category_id'];
    skillSubCategories = json['SkillSubCategory'] == null
        ? null
        : SkillSubCategories.fromJson(json['SkillSubCategory']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skill_sub_category_id'] = skillSubCategoryId;
    data['SkillSubCategories'] = skillSubCategories;
    return data;
  }
}

class SkillSubCategories {
  int? id;
  String? name;
  int? skillCategoryId;
  Industry? skillCategory;

  SkillSubCategories(
      {this.id, this.name, this.skillCategoryId, this.skillCategory});

  SkillSubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    skillCategoryId = json['skill_category_id'];
    skillCategory = json['SkillCategory'] != null
        ? Industry.fromJson(json['SkillCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['skill_category_id'] = skillCategoryId;
    if (skillCategory != null) {
      data['SkillCategory'] = skillCategory!.toJson();
    }
    return data;
  }
}

class JobPostEducations {
  int? educationId;
  Industry? educationDatum;

  JobPostEducations({this.educationId, this.educationDatum});

  JobPostEducations.fromJson(Map<String, dynamic> json) {
    educationId = json['education_id'];
    educationDatum = json['EducationDatum'] != null
        ? Industry.fromJson(json['EducationDatum'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['education_id'] = educationId;
    if (educationDatum != null) {
      data['EducationDatum'] = educationDatum!.toJson();
    }
    return data;
  }
}

class Questions {
  int? id;
  String? questions;

  Questions({this.id, this.questions});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questions = json['questions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['questions'] = questions;
    return data;
  }
}

class JobTypeCountModel {
  int? privateJobCount;
  int? govtJobCount;

  JobTypeCountModel({this.privateJobCount, this.govtJobCount});

  JobTypeCountModel.fromJson(Map<String, dynamic> json) {
    privateJobCount = json['privateJobCount'];
    govtJobCount = json['govtJobCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['privateJobCount'] = this.privateJobCount;
    data['govtJobCount'] = this.govtJobCount;
    return data;
  }
}
