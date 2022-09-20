import 'package:hindustan_job/candidate/model/course_model.dart';
import 'package:hindustan_job/candidate/model/education_model.dart';
import 'package:hindustan_job/candidate/model/specialization_model.dart';

class EducationExperienceModel {
  dynamic count;
  List<EducationExperience>? educationExperience;

  EducationExperienceModel({this.count, this.educationExperience});

  EducationExperienceModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      educationExperience = <EducationExperience>[];
      json['rows'].forEach((v) {
        educationExperience!.add( EducationExperience.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (educationExperience != null) {
      data['rows'] = educationExperience!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EducationExperience {
  int? id;
  int? userId;
  int? courseId;
  int? specializationId;
  String? instituteName;
  int? yearOfPassing;
  int? status;
  String? createdAt;
  String? updatedAt;
  Specialization? specializations;
  Course? courses;
  Education? educationDatum;

  EducationExperience(
      {this.id,
      this.userId,
      this.courseId,
      this.specializationId,
      this.instituteName,
      this.yearOfPassing,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.specializations,
      this.educationDatum,
      this.courses});

  EducationExperience.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    courseId = json['course_id'];
    specializationId = json['specialization_id'];
    instituteName = json['institute_name'];
    yearOfPassing = json['year_of_passing'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    educationDatum = json['EducationDatum'] != null
        ?  Education.fromJson(json['EducationDatum'])
        : null;
    if (json['Specializations'] != null) {
      specializations = json['Specializations'] != null
          ?  Specialization.fromJson(json['Specialization'])
          : null;
    }
    if (json['Course'] != null) {
      courses =
          json['Course'] != null ?  Course.fromJson(json['Course']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['course_id'] = courseId;
    data['specialization_id'] = specializationId;
    data['institute_name'] = instituteName;
    data['year_of_passing'] = yearOfPassing;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (educationDatum != null) {
      data['EducationDatum'] = educationDatum!.toJson();
    }
    if (specializations != null) {
      data['Specialization'] = specializations!.toJson();
    }
    if (courses != null) {
      data['Course'] = courses!.toJson();
    }
    return data;
  }
}
