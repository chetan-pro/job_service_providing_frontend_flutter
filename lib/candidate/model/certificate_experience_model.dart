class CertificateExperienceModel {
  dynamic count;
  List<CertificateExperience>? certificateExperience;

  CertificateExperienceModel({this.count, this.certificateExperience});

  CertificateExperienceModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      certificateExperience = <CertificateExperience>[];
      json['rows'].forEach((v) {
        certificateExperience!.add(CertificateExperience.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (certificateExperience != null) {
      data['rows'] =
          certificateExperience!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CertificateExperience {
  int? id;
  String? title;
  int? userId;
  String? instituteName;
  String? fileName;
  int? yearOfAchievingCertificate;
  String? file;
  int? status;
  String? createdAt;
  String? updatedAt;

  CertificateExperience(
      {this.id,
      this.title,
      this.userId,
      this.instituteName,
      this.fileName,
      this.yearOfAchievingCertificate,
      this.file,
      this.status,
      this.createdAt,
      this.updatedAt});

  CertificateExperience.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    userId = json['user_id'];
    instituteName = json['institute_name'];
    fileName = json['file_name'];
    yearOfAchievingCertificate = json['year_of_achieving_certificate'];
    file = json['file'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['user_id'] = userId;
    data['institute_name'] = instituteName;
    data['file_name'] = fileName;
    data['year_of_achieving_certificate'] = yearOfAchievingCertificate;
    data['file'] = file;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
