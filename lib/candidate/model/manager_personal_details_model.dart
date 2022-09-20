class ManagerPersonalDetails {
  int? id;
  int? userId;
  String? realtiveName;
  String? relativeRelation;
  String? residenceNo;
  String? officeNo;
  String? whatsappNo;
  String? currentStatus;
  String? educationQualification;
  String? educationFile;
  String? adharNo;
  String? adharImgFront;
  String? adharImgBack;
  String? panNo;
  String? panImgFront;
  String? panImgBack;
  String? residentialProofName;
  String? residentialProof;
  String? createdAt;
  String? updatedAt;

  ManagerPersonalDetails(
      {this.id,
      this.userId,
      this.realtiveName,
      this.relativeRelation,
      this.residenceNo,
      this.officeNo,
      this.whatsappNo,
      this.currentStatus,
      this.educationQualification,
      this.educationFile,
      this.adharNo,
      this.adharImgFront,
      this.adharImgBack,
      this.panNo,
      this.panImgFront,
      this.panImgBack,
      this.residentialProofName,
      this.residentialProof,
      this.createdAt,
      this.updatedAt});

  ManagerPersonalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    realtiveName = json['realtive_name'];
    relativeRelation = json['relative_relation'];
    residenceNo = json['residence_no'];
    officeNo = json['office_no'];
    whatsappNo = json['whatsapp_no'];
    currentStatus = json['current_status'];
    educationQualification = json['education_qualification'];
    educationFile = json['education_file'];
    adharNo = json['adhar_no'];
    adharImgFront = json['adhar_img_front'];
    adharImgBack = json['adhar_img_back'];
    panNo = json['pan_no'];
    panImgFront = json['pan_img_front'];
    panImgBack = json['pan_img_back'];
    residentialProofName = json['residential_proof_name'];
    residentialProof = json['residential_proof'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['realtive_name'] = realtiveName;
    data['relative_relation'] = relativeRelation;
    data['residence_no'] = residenceNo;
    data['office_no'] = officeNo;
    data['whatsapp_no'] = whatsappNo;
    data['current_status'] = currentStatus;
    data['education_qualification'] = educationQualification;
    data['education_file'] = educationFile;
    data['adhar_no'] = adharNo;
    data['adhar_img_front'] = adharImgFront;
    data['adhar_img_back'] = adharImgBack;
    data['pan_no'] = panNo;
    data['pan_img_front'] = panImgFront;
    data['pan_img_back'] = panImgBack;
    data['residential_proof_name'] = residentialProofName;
    data['residential_proof'] = residentialProof;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
