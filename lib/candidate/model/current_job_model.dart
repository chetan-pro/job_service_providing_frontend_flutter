// ignore_for_file: unnecessary_new, unnecessary_this

class CurrentJobModel {
  int? id;
  String? currentlyEmployed;
  int? userId;
  String? jobTitle;
  String? companyName;
  int? industryId;
  String? jobDescription;
  int? currentSalary;
  String? dateOfJoining;
  String? noticePeriod;
  String? noticePeriodDays;
  String? activeJob;
  int? status;
  String? updatedAt;
  String? createdAt;

  CurrentJobModel(
      {this.id,
      this.currentlyEmployed,
      this.userId,
      this.jobTitle,
      this.companyName,
      this.industryId,
      this.jobDescription,
      this.currentSalary,
      this.dateOfJoining,
      this.noticePeriod,
      this.noticePeriodDays,
      this.activeJob,
      this.status,
      this.updatedAt,
      this.createdAt});

  CurrentJobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentlyEmployed = json['currently_employed'];
    userId = json['user_id'];
    jobTitle = json['job_title'];
    companyName = json['company_name'];
    industryId = json['industry_id'];
    jobDescription = json['job_description'];
    currentSalary = json['current_salary'];
    dateOfJoining = json['date_of_joining'];
    noticePeriod = json['notice_period'];
    noticePeriodDays = json['notice_period_days'].toString();
    activeJob = json['active_job'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currently_employed'] = this.currentlyEmployed;
    data['user_id'] = this.userId;
    data['job_title'] = this.jobTitle;
    data['company_name'] = this.companyName;
    data['industry_id'] = this.industryId;
    data['job_description'] = this.jobDescription;
    data['current_salary'] = this.currentSalary;
    data['date_of_joining'] = this.dateOfJoining;
    data['notice_period'] = this.noticePeriod;
    data['notice_period_days'] = this.noticePeriodDays;
    data['active_job'] = this.activeJob;
    data['status'] = this.status;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
