import 'package:hindustan_job/candidate/model/Company/permission.dart';
import 'package:hindustan_job/candidate/model/applicants_model.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/skill_sub_category_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';

class UserDataModel {
  int? count;
  List<UserData>? userData;

  UserDataModel({this.count, this.userData});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      userData = <UserData>[];
      json['rows'].forEach((v) {
        userData!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (userData != null) {
      data['rows'] = userData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  int? id;
  int? companyId;
  String? name;
  String? email;
  String? password;
  String? image;
  String? companyLink;
  String? companyDescription;
  String? addressLine1;
  String? addressLine2;
  String? yourFullName;
  String? yourDesignation;
  String? pinCode;
  String? mobile;
  String? gender;
  String? dob;
  String? resetToken;
  String? resetExpiry;
  int? otp;
  String? stateId;
  String? cityId;
  String? userRoleType;
  String? referrerCode;
  String? socialLoginType;
  String? socialLoginId;
  int? status;
  bool? isStaffActive;
  String? companyStatus;
  String? candidateStatus;
  String? resume;
  String? createdAt;
  String? updatedAt;
  String? linkdinId;
  City? city;
  States? state;
  Industry? industry;
  List<UserSkills>? userSkills;
  List<PermissonModel>? permissons;
  List<Applicants>? userAppliedJobs;
  UserData? companyData;
  int? workExperienceCount;
  int? noticePeriodDays;
  String? message;

  UserData(
      {this.id,
      this.companyId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.resume,
      this.companyLink,
      this.companyDescription,
      this.addressLine1,
      this.addressLine2,
      this.yourFullName,
      this.yourDesignation,
      this.pinCode,
      this.gender,
      this.dob,
      this.linkdinId,
      this.mobile,
      this.resetToken,
      this.resetExpiry,
      this.otp,
      this.companyStatus,
      this.candidateStatus,
      this.stateId,
      this.cityId,
      this.userSkills,
      this.userRoleType,
      this.referrerCode,
      this.socialLoginType,
      this.companyData,
      this.socialLoginId,
      this.status,
      this.message,
      this.isStaffActive,
      this.createdAt,
      this.updatedAt,
      this.city,
      this.industry,
      this.userAppliedJobs,
      this.state,
      this.permissons,
      this.workExperienceCount,
      this.noticePeriodDays});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    linkdinId = json['linkedIn_id'];
    image = json['image'];
    message = json['message'];
    companyLink = json['company_link'];
    companyDescription = json['company_description'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    yourFullName = json['your_full_name'];
    yourDesignation = json['your_designation'];
    pinCode = json['pin_code'];
    gender = json['gender'];
    resume = json['resume'];
    dob = json['dob'];
    mobile = json['mobile'];
    companyData = json['companyData'] != null
        ? UserData.fromJson(json['companyData'])
        : null;
    resetToken = json['reset_token'];
    resetExpiry = json['reset_expiry'];
    otp = json['otp'];
    companyStatus = json['company_status'];
    candidateStatus = json['candidate_status'];
    stateId = json['state_id'].toString();
    cityId = json['city_id'].toString();
    userRoleType = json['user_role_type'];
    referrerCode = json['referrer_code'];
    socialLoginType = json['social_login_type'].toString();
    socialLoginId = json['social_login_id'].toString();
    status = json['status'];
    isStaffActive = json['is_staff_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    industry =
        json['Industry'] != null ? Industry.fromJson(json['Industry']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    state = json['state'] != null ? States.fromJson(json['state']) : null;
    if (json['UserSkills'] != null) {
      userSkills = <UserSkills>[];
      json['UserSkills'].forEach((v) {
        userSkills!.add(UserSkills.fromJson(v));
      });
    }
    if (json['Permissons'] != null) {
      permissons = <PermissonModel>[];
      json['Permissons'].forEach((v) {
        permissons!.add(PermissonModel.fromJson(v));
      });
    }
    if (json['UserAppliedJobs'] != null) {
      userAppliedJobs = <Applicants>[];
      json['UserAppliedJobs'].forEach((v) {
        userAppliedJobs!.add(Applicants.fromJson(v));
      });
    }
    workExperienceCount = json['workExperienceCount'];
    noticePeriodDays = json['notice_period_days'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['name'] = name;
    data['email'] = email;
    data['is_staff_active'] = isStaffActive;
    data['password'] = password;
    data['company_status'] = companyStatus;
    data['candidate_status'] = candidateStatus;
    data['image'] = image;
    data['company_link'] = companyLink;
    data['company_description'] = companyDescription;
    data['address_line1'] = addressLine1;
    data['address_line2'] = addressLine2;
    data['your_full_name'] = yourFullName;
    data['your_designation'] = yourDesignation;
    data['pin_code'] = pinCode;
    data['message'] = message;
    data['mobile'] = mobile;
    data['reset_token'] = resetToken;
    data['reset_expiry'] = resetExpiry;
    data['otp'] = otp;
    data['linkedIn_id'] = linkdinId;
    data['gender'] = gender;
    data['dob'] = dob;
    data['resume'] = resume;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['user_role_type'] = userRoleType;
    data['referrer_code'] = referrerCode;
    data['social_login_type'] = socialLoginType;
    data['social_login_id'] = socialLoginId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['workExperienceCount'] = workExperienceCount;
    data['notice_period_days'] = noticePeriodDays;
    if (companyData != null) {
      data['companyData'] = companyData!.toJson();
    }
    if (industry != null) {
      data['Industry'] = industry!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (userSkills != null) {
      data['UserSkills'] = userSkills!.map((v) => v.toJson()).toList();
    }
    if (permissons != null) {
      data['Permissons'] = permissons!.map((v) => v.toJson()).toList();
    }
    if (userAppliedJobs != null) {
      data['UserAppliedJobs'] =
          userAppliedJobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserSkills {
  int? skillSubCategoryId;
  SubSkill? skillSubCategory;

  UserSkills({this.skillSubCategoryId, this.skillSubCategory});

  UserSkills.fromJson(Map<String, dynamic> json) {
    skillSubCategoryId = json['skill_sub_category_id'];
    skillSubCategory = json['SkillSubCategory'] != null
        ? SubSkill.fromJson(json['SkillSubCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skill_sub_category_id'] = skillSubCategoryId;
    if (skillSubCategory != null) {
      data['SkillSubCategory'] = skillSubCategory!.toJson();
    }
    return data;
  }
}
