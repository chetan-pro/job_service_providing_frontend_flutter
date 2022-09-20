import 'package:hindustan_job/candidate/model/industry_model.dart';

class WorkExperienceModel {
  dynamic count;
  List<WorkExperience>? workExperience;

  WorkExperienceModel({this.count, this.workExperience});

  WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      workExperience = <WorkExperience>[];
      json['rows'].forEach((v) {
        workExperience!.add(new WorkExperience.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.workExperience != null) {
      data['rows'] = this.workExperience!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkExperience {
  int? id;
  int? userId;
  dynamic currentlyEmployed;
  String? jobTitle;
  String? companyName;
  int? industryId;
  String? jobDescription;
  dynamic dateOfJoining;
  dynamic dateOfResigning;
  dynamic currentSalary;
  dynamic noticePeriod;
  dynamic noticePeriodDays;
  Industry? industry;
  String? activeJob;
  int? status;
  String? createdAt;
  String? updatedAt;

  WorkExperience(
      {this.id,
      this.userId,
      this.currentlyEmployed,
      this.jobTitle,
      this.companyName,
      this.industryId,
      this.jobDescription,
      this.dateOfJoining,
      this.dateOfResigning,
      this.currentSalary,
      this.noticePeriod,
      this.noticePeriodDays,
      this.activeJob,
      this.industry,
      this.status,
      this.createdAt,
      this.updatedAt});

  WorkExperience.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    currentlyEmployed = json['currently_employed'];
    jobTitle = json['job_title'];
    companyName = json['company_name'];
    industryId = json['industry_id'];
    jobDescription = json['job_description'];
    dateOfJoining = json['date_of_joining'];
    dateOfResigning = json['date_of_resigning'];
    currentSalary = json['current_salary'];
    noticePeriod = json['notice_period'];
    noticePeriodDays = json['notice_period_days'];
    industry =
        json['Industry'] == null ? null : Industry.fromJson(json['Industry']);
    activeJob = json['active_job'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['currently_employed'] = this.currentlyEmployed;
    data['job_title'] = this.jobTitle;
    data['company_name'] = this.companyName;
    data['industry_id'] = this.industryId;
    data['job_description'] = this.jobDescription;
    data['date_of_joining'] = this.dateOfJoining;
    data['date_of_resigning'] = this.dateOfResigning;
    data['current_salary'] = this.currentSalary;
    data['notice_period'] = this.noticePeriod;
    data['notice_period_days'] = this.noticePeriodDays;
    data['active_job'] = this.activeJob;
    data['Industry'] = this.industry;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
