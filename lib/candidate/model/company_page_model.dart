import 'package:hindustan_job/candidate/model/company_image_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';

class CompanyPageModel {
  List<JobsTwo>? postedJobs;
  List<CompanyImage>? companyPhoto;
  UserData? companyDetail;

  CompanyPageModel({this.postedJobs, this.companyPhoto, this.companyDetail});

  CompanyPageModel.fromJson(Map<String, dynamic> json) {
    if (json['posted_jobs'] != null) {
      postedJobs = <JobsTwo>[];
      json['posted_jobs'].forEach((v) {
        postedJobs!.add(JobsTwo.fromJson(v));
      });
    }
    if (json['company_photo'] != null) {
      companyPhoto = <CompanyImage>[];
      json['company_photo'].forEach((v) {
        companyPhoto!.add(CompanyImage.fromJson(v));
      });
    }
    companyDetail = json['company_detail'] != null
        ? UserData.fromJson(json['company_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (postedJobs != null) {
      data['posted_jobs'] = postedJobs!.map((v) => v.toJson()).toList();
    }
    if (companyPhoto != null) {
      data['company_photo'] =
          companyPhoto!.map((v) => v.toJson()).toList();
    }
    if (companyDetail != null) {
      data['company_detail'] = companyDetail!.toJson();
    }
    return data;
  }
}
