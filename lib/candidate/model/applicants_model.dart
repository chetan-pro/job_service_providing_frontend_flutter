import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';

class ApplicantsModel {
  dynamic count;
  List? applicants;

  ApplicantsModel({this.count, this.applicants});

  ApplicantsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      applicants = [];
      json['rows'].forEach((v) {
  
        applicants!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (applicants != null) {
      data['rows'] = applicants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ApplicantsCompanyModel {
  dynamic count;
  List? applicants;

  ApplicantsCompanyModel({this.count, this.applicants});

  ApplicantsCompanyModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      applicants = [];
      json['rows'].forEach((v) {
        applicants!.add(Applicants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (applicants != null) {
      data['rows'] = applicants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Applicants {
  int? id;
  int? jobPostId;
  int? userId;
  String? companyStatus;
  String? candidateStatus;
  String? separateResume;
  String? offerLetter;
  String? reason;
  int? status;
  String? createdAt;
  String? updatedAt;
  UserData? user;
  JobsTwo? jobPost;
  Applicants(
      {this.id,
      this.jobPostId,
      this.userId,
      this.companyStatus,
      this.candidateStatus,
      this.reason,
      this.separateResume,
      this.offerLetter,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.jobPost});

  Applicants.fromJson(Map<String, dynamic> json) {
    if(json['JobPost']!=null){
      json['JobPost']['company_status']=json['company_status'];
      json['JobPost']['candidate_status']=json['candidate_status'];
      json['JobPost']['offer_letter']=json['offer_letter'];
      json['JobPost']['separate_resume']=json['separate_resume'];
    }
    id = json['id'];
    jobPostId = json['job_post_id'];
    userId = json['user_id'];
    companyStatus = json['company_status'];
    candidateStatus = json['candidate_status'];
    separateResume = json['separate_resume'];
    offerLetter = json['offer_letter'];
    status = json['status'];
    reason = json['reason'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    jobPost =
        json['JobPost'] != null ? JobsTwo.fromJson(json['JobPost']) : null;
    user = json['User'] != null ? UserData.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    data['job_post_id'] = jobPostId;
    data['user_id'] = userId;
    data['company_status'] = companyStatus;
    data['candidate_status'] = candidateStatus;
    data['separate_resume'] = separateResume;
    data['offer_letter'] = offerLetter;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    if (jobPost != null) {
      data['JobPost'] = jobPost!.toJson();
    }
    return data;
  }
}
