import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';

import 'job_model_two.dart';

class CandidateProfileModel {
  int? id;
  String? name;
  dynamic companyId;
  String? email;
  String? password;
  String? gender;
  String? dob;
  String? image;
  dynamic resume;
  dynamic companyLink;
  dynamic companyDescription;
  dynamic aboutUs;
  String? addressLine1;
  dynamic addressLine2;
  dynamic yourFullName;
  dynamic yourDesignation;
  String? pinCode;
  String? mobile;
  String? resetToken;
  String? resetExpiry;
  int? otp;
  int? stateId;
  int? cityId;
  String? userRoleType;
  String? referrerCode;
  int? socialLoginType;
  dynamic socialLoginId;
  String? isUserAvailable;
  String? fcmToken;
  dynamic walletMoney;
  String? shareLink;
  int? status;
  bool? isStaffActive;
  String? createdAt;
  String? updatedAt;
  City? city;
  List<Certifications>? certifications;
  States? state;
  List<UserAppliedJob>? userAppliedJobs;
  List<WorkExperiences>? workExperiences;
  List<Education>? education;
  List<UserSkills>? userSkills;
  List<Answers>? answers;
  String? employeesStatus;
  int? currentSalary;
  int? workExperienceMonths;
  int? noticePeriodDays;
  ResumeDataAccess? resumeDataAccess;

  CandidateProfileModel(
      {this.id,
      this.name,
      this.companyId,
      this.email,
      this.password,
      this.gender,
      this.dob,
      this.image,
      this.resume,
      this.companyLink,
      this.companyDescription,
      this.aboutUs,
      this.userAppliedJobs,
      this.addressLine1,
      this.addressLine2,
      this.yourFullName,
      this.yourDesignation,
      this.pinCode,
      this.mobile,
      this.resetToken,
      this.resetExpiry,
      this.otp,
      this.stateId,
      this.cityId,
      this.userRoleType,
      this.referrerCode,
      this.socialLoginType,
      this.socialLoginId,
      this.isUserAvailable,
      this.fcmToken,
      this.walletMoney,
      this.shareLink,
      this.status,
      this.isStaffActive,
      this.createdAt,
      this.answers,
      this.updatedAt,
      this.city,
      this.certifications,
      this.state,
      this.workExperiences,
      this.education,
      this.userSkills,
      this.employeesStatus,
      this.currentSalary,
      this.workExperienceMonths,
      this.noticePeriodDays,
      this.resumeDataAccess});

  CandidateProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    dob = json['dob'];
    image = json['image'];
    resume = json['resume'];
    companyLink = json['company_link'];
    companyDescription = json['company_description'];
    aboutUs = json['about_us'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    yourFullName = json['your_full_name'];
    yourDesignation = json['your_designation'];
    pinCode = json['pin_code'];
    mobile = json['mobile'];
    resetToken = json['reset_token'];
    resetExpiry = json['reset_expiry'];
    otp = json['otp'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    userRoleType = json['user_role_type'];
    referrerCode = json['referrer_code'];
    socialLoginType = json['social_login_type'];
    socialLoginId = json['social_login_id'];
    isUserAvailable = json['is_user_available'];
    fcmToken = json['fcm_token'];
    walletMoney = json['wallet_money'];
    shareLink = json['share_link'];
    status = json['status'];
    isStaffActive = json['is_staff_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['Answers'] != null) {
      answers = <Answers>[];
      json['Answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    if (json['Certifications'] != null) {
      certifications = <Certifications>[];
      json['Certifications'].forEach((v) {
        certifications!.add(Certifications.fromJson(v));
      });
    }
    if (json['UserAppliedJobs'] != null) {
      userAppliedJobs = <UserAppliedJob>[];
      json['UserAppliedJobs'].forEach((v) {
        userAppliedJobs!.add(UserAppliedJob.fromJson(v));
      });
    }
    state = json['state'] != null ? States.fromJson(json['state']) : null;
    if (json['WorkExperiences'] != null) {
      workExperiences = <WorkExperiences>[];
      json['WorkExperiences'].forEach((v) {
        workExperiences!.add(WorkExperiences.fromJson(v));
      });
    }
    if (json['Education'] != null) {
      education = <Education>[];
      json['Education'].forEach((v) {
        education!.add(Education.fromJson(v));
      });
    }
    if (json['UserSkills'] != null) {
      userSkills = <UserSkills>[];
      json['UserSkills'].forEach((v) {
        userSkills!.add(UserSkills.fromJson(v));
      });
    }
    employeesStatus = json['EmployeesStatus'];
    currentSalary = json['current_salary'];
    noticePeriodDays = json['notice_period_days'];
    resumeDataAccess = json['ResumeDataAccess'] != null
        ? ResumeDataAccess.fromJson(json['ResumeDataAccess'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['company_id'] = companyId;
    data['email'] = email;
    data['password'] = password;
    data['gender'] = gender;
    data['dob'] = dob;
    data['image'] = image;
    data['resume'] = resume;
    data['company_link'] = companyLink;
    data['company_description'] = companyDescription;
    data['about_us'] = aboutUs;
    data['address_line1'] = addressLine1;
    data['address_line2'] = addressLine2;
    data['your_full_name'] = yourFullName;
    data['your_designation'] = yourDesignation;
    data['pin_code'] = pinCode;
    data['mobile'] = mobile;
    data['reset_token'] = resetToken;
    data['reset_expiry'] = resetExpiry;
    data['otp'] = otp;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['user_role_type'] = userRoleType;
    data['referrer_code'] = referrerCode;
    data['social_login_type'] = socialLoginType;
    data['social_login_id'] = socialLoginId;
    data['is_user_available'] = isUserAvailable;
    data['fcm_token'] = fcmToken;
    data['wallet_money'] = walletMoney;
    data['share_link'] = shareLink;
    data['status'] = status;
    data['is_staff_active'] = isStaffActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (answers != null) {
      data['Answers'] = answers!.map((v) => v.toJson()).toList();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (certifications != null) {
      data['Certifications'] = certifications!.map((v) => v.toJson()).toList();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (workExperiences != null) {
      data['WorkExperiences'] =
          workExperiences!.map((v) => v.toJson()).toList();
    }
    if (userAppliedJobs != null) {
      data['UserAppliedJobs'] =
          userAppliedJobs!.map((v) => v.toJson()).toList();
    }
    if (education != null) {
      data['Education'] = education!.map((v) => v.toJson()).toList();
    }
    if (userSkills != null) {
      data['UserSkills'] = userSkills!.map((v) => v.toJson()).toList();
    }
    data['EmployeesStatus'] = employeesStatus;
    data['current_salary'] = currentSalary;
    data['work_experience_months'] = workExperienceMonths;
    data['notice_period_days'] = noticePeriodDays;
    if (resumeDataAccess != null) {
      data['ResumeDataAccess'] = resumeDataAccess!.toJson();
    }
    return data;
  }
}

class Answers {
  int? id;
  int? userId;
  String? answer;
  String? questionId;
  String? createdAt;
  String? updatedAt;
  Question? question;

  Answers(
      {this.id,
      this.userId,
      this.answer,
      this.questionId,
      this.createdAt,
      this.updatedAt,
      this.question});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    answer = json['answer'];
    questionId = json['question_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    question =
        json['Question'] != null ? Question.fromJson(json['Question']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['answer'] = answer;
    data['question_id'] = questionId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (question != null) {
      data['Question'] = question!.toJson();
    }
    return data;
  }
}

class Question {
  int? id;
  int? jobPostId;
  String? questions;
  int? status;
  String? createdAt;
  String? updatedAt;

  Question(
      {this.id,
      this.jobPostId,
      this.questions,
      this.status,
      this.createdAt,
      this.updatedAt});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobPostId = json['job_post_id'];
    questions = json['questions'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_post_id'] = jobPostId;
    data['questions'] = questions;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Certifications {
  int? id;
  String? title;
  String? fileName;
  int? userId;
  String? instituteName;
  int? yearOfAchievingCertificate;
  String? file;
  int? status;
  String? createdAt;
  String? updatedAt;

  Certifications(
      {this.id,
      this.title,
      this.fileName,
      this.userId,
      this.instituteName,
      this.yearOfAchievingCertificate,
      this.file,
      this.status,
      this.createdAt,
      this.updatedAt});

  Certifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    fileName = json['file_name'];
    userId = json['user_id'];
    instituteName = json['institute_name'];
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
    data['file_name'] = fileName;
    data['user_id'] = userId;
    data['institute_name'] = instituteName;
    data['year_of_achieving_certificate'] = yearOfAchievingCertificate;
    data['file'] = file;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class WorkExperiences {
  int? id;
  int? userId;
  String? currentlyEmployed;
  String? jobTitle;
  String? companyName;
  int? industryId;
  String? jobDescription;
  String? dateOfJoining;
  dynamic dateOfResigning;
  int? currentSalary;
  String? noticePeriod;
  int? noticePeriodDays;
  String? salaryType;
  String? noticePeriodType;
  String? activeJob;
  int? status;
  String? createdAt;
  String? updatedAt;

  WorkExperiences(
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
      this.salaryType,
      this.noticePeriodType,
      this.activeJob,
      this.status,
      this.createdAt,
      this.updatedAt});

  WorkExperiences.fromJson(Map<String, dynamic> json) {
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
    salaryType = json['salary_type'];
    noticePeriodType = json['notice_period_type'];
    activeJob = json['active_job'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['currently_employed'] = currentlyEmployed;
    data['job_title'] = jobTitle;
    data['company_name'] = companyName;
    data['industry_id'] = industryId;
    data['job_description'] = jobDescription;
    data['date_of_joining'] = dateOfJoining;
    data['date_of_resigning'] = dateOfResigning;
    data['current_salary'] = currentSalary;
    data['notice_period'] = noticePeriod;
    data['notice_period_days'] = noticePeriodDays;
    data['salary_type'] = salaryType;
    data['notice_period_type'] = noticePeriodType;
    data['active_job'] = activeJob;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Education {
  int? educationId;
  City? educationDatum;

  Education({this.educationId, this.educationDatum});

  Education.fromJson(Map<String, dynamic> json) {
    educationId = json['education_id'];
    educationDatum = json['EducationDatum'] != null
        ? City.fromJson(json['EducationDatum'])
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

class UserSkills {
  int? skillSubCategoryId;
  SkillSubCategory? skillSubCategory;

  UserSkills({this.skillSubCategoryId, this.skillSubCategory});

  UserSkills.fromJson(Map<String, dynamic> json) {
    skillSubCategoryId = json['skill_sub_category_id'];
    skillSubCategory = json['SkillSubCategory'] != null
        ? SkillSubCategory.fromJson(json['SkillSubCategory'])
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

class SkillSubCategory {
  int? id;
  String? name;
  int? skillCategoryId;

  SkillSubCategory({this.id, this.name, this.skillCategoryId});

  SkillSubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    skillCategoryId = json['skill_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['skill_category_id'] = skillCategoryId;
    return data;
  }
}

class ResumeDataAccess {
  int? id;
  int? userId;
  int? userSubscribedId;
  String? emailDownloaded;
  dynamic cvDownloaded;
  int? infoAccessedUserId;
  String? createdAt;
  String? updatedAt;

  ResumeDataAccess(
      {this.id,
      this.userId,
      this.userSubscribedId,
      this.emailDownloaded,
      this.cvDownloaded,
      this.infoAccessedUserId,
      this.createdAt,
      this.updatedAt});

  ResumeDataAccess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userSubscribedId = json['user_subscribed_id'];
    emailDownloaded = json['email_downloaded'];
    cvDownloaded = json['cv_downloaded'];
    infoAccessedUserId = json['info_accessed_user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_subscribed_id'] = userSubscribedId;
    data['email_downloaded'] = emailDownloaded;
    data['cv_downloaded'] = cvDownloaded;
    data['info_accessed_user_id'] = infoAccessedUserId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
