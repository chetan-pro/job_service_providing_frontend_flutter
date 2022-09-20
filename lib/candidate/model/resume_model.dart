import 'package:hindustan_job/candidate/model/skill_sub_category_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';

import 'city_model.dart';

class ResumeModel {
  int? id;
  int? userId;
  String? name;
  String? designation;
  String? about;
  String? description;
  String? contact;
  String? email;
  int? pinCode;
  String? image;
  String? stateId;
  String? cityId;
  String? facebook;
  String? twitter;
  dynamic behance;
  dynamic instagram;
  dynamic linkedin;
  dynamic portfolio;
  String? createdAt;
  String? updatedAt;
  List<ResumeEducations>? resumeEducations;
  List<ResumeEducations>? resumeExperiences;
  List<ResumeSkills>? resumeSkills;
  List<ResumeHobbies>? resumeHobbies;
  List<ResumeReferences>? resumeReferences;
  City? city;
  States? state;

  ResumeModel(
      {this.id,
      this.userId,
      this.name,
      this.designation,
      this.about,
      this.description,
      this.contact,
      this.email,
      this.pinCode,
      this.image,
      this.stateId,
      this.cityId,
      this.facebook,
      this.twitter,
      this.behance,
      this.instagram,
      this.linkedin,
      this.portfolio,
      this.createdAt,
      this.updatedAt,
      this.resumeEducations,
      this.resumeExperiences,
      this.resumeSkills,
      this.resumeHobbies,
      this.resumeReferences,
      this.city,
      this.state});

  ResumeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    designation = json['designation'];
    about = json['about'];
    description = json['description'];
    contact = json['contact'];
    email = json['email'];
    pinCode = json['pin_code'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    behance = json['behance'];
    image = json['image'];
    instagram = json['instagram'];
    linkedin = json['linkedin'];
    portfolio = json['portfolio'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['resume_educations'] != null) {
      resumeEducations = <ResumeEducations>[];
      json['resume_educations'].forEach((v) {
        resumeEducations!.add(ResumeEducations.fromJson(v));
      });
    }
    if (json['resume_experiences'] != null) {
      resumeExperiences = <ResumeEducations>[];
      json['resume_experiences'].forEach((v) {
        resumeExperiences!.add(ResumeEducations.fromJson(v));
      });
    }
    if (json['resume_skills'] != null) {
      resumeSkills = <ResumeSkills>[];
      json['resume_skills'].forEach((v) {
        resumeSkills!.add(ResumeSkills.fromJson(v));
      });
    }
    if (json['resume_hobbies'] != null) {
      resumeHobbies = <ResumeHobbies>[];
      json['resume_hobbies'].forEach((v) {
        resumeHobbies!.add(ResumeHobbies.fromJson(v));
      });
    }
    if (json['resume_references'] != null) {
      resumeReferences = <ResumeReferences>[];
      json['resume_references'].forEach((v) {
        resumeReferences!.add(ResumeReferences.fromJson(v));
      });
    }
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    state = json['state'] != null ? States.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['designation'] = designation;
    data['about'] = about;
    data['description'] = description;
    data['contact'] = contact;
    data['email'] = email;
    data['pin_code'] = pinCode;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['image'] = image;
    data['behance'] = behance;
    data['instagram'] = instagram;
    data['linkedin'] = linkedin;
    data['portfolio'] = portfolio;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (resumeEducations != null) {
      data['resume_educations'] =
          resumeEducations!.map((v) => v.toJson()).toList();
    }
    if (resumeExperiences != null) {
      data['resume_experiences'] =
          resumeExperiences!.map((v) => v.toJson()).toList();
    }
    if (resumeSkills != null) {
      data['resume_skills'] = resumeSkills!.map((v) => v.toJson()).toList();
    }
    if (resumeHobbies != null) {
      data['resume_hobbies'] = resumeHobbies!.map((v) => v.toJson()).toList();
    }
    if (resumeReferences != null) {
      data['resume_references'] =
          resumeReferences!.map((v) => v.toJson()).toList();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    return data;
  }
}

class ResumeEducations {
  int? id;
  int? resumeId;
  String? title;
  String? description;
  String? designation;
  int? from;
  int? to;
  String? createdAt;
  String? updatedAt;

  ResumeEducations(
      {this.id,
      this.resumeId,
      this.title,
      this.description,
      this.designation,
      this.from,
      this.to,
      this.createdAt,
      this.updatedAt});

  ResumeEducations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resumeId = json['resume_id'];
    title = json['title'];
    designation = json['designation'];
    description = json['description'];
    from = int.parse(json['from'].toString());
    to = int.parse(json['to'].toString());
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['resume_id'] = resumeId;
    data['title'] = title;
    data['description'] = description;
    data['designation'] = designation;
    data['from'] = from;
    data['to'] = to;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ResumeSkills {
  int? id;
  int? resumeId;
  int? skillCategoryId;
  String? skillSubCategoryId;
  bool isSelected = false;
  String? rating;
  String? createdAt;
  String? updatedAt;
  SubSkill? skillSubCategory;

  ResumeSkills(
      {this.id,
      this.resumeId,
      this.skillCategoryId,
      this.skillSubCategoryId,
      this.rating,
      this.createdAt,
      this.updatedAt,
      this.skillSubCategory});

  ResumeSkills.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resumeId = json['resume_id'];
    skillCategoryId = json['skillCategory_id'];
    skillSubCategoryId = json['skillSubCategory_id'];
    rating = json['rating'] ?? 0;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    skillSubCategory = json['SkillSubCategory'] != null
        ? SubSkill.fromJson(json['SkillSubCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['resume_id'] = resumeId;
    data['skillCategory_id'] = skillCategoryId;
    data['skillSubCategory_id'] = skillSubCategoryId;
    data['rating'] = rating;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (skillSubCategory != null) {
      data['SkillSubCategory'] = skillSubCategory!.toJson();
    }
    return data;
  }
}

class ResumeHobbies {
  int? id;
  int? resumeId;
  String? hobbyName;
  String? createdAt;
  String? updatedAt;

  ResumeHobbies(
      {this.id, this.resumeId, this.hobbyName, this.createdAt, this.updatedAt});

  ResumeHobbies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resumeId = json['resume_id'];
    hobbyName = json['hobbyName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['resume_id'] = resumeId;
    data['hobbyName'] = hobbyName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ResumeReferences {
  int? id;
  int? resumeId;
  String? title;
  String? designation;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;

  ResumeReferences(
      {this.id,
      this.resumeId,
      this.title,
      this.designation,
      this.phone,
      this.email,
      this.createdAt,
      this.updatedAt});

  ResumeReferences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resumeId = json['resume_id'];
    title = json['title'];
    designation = json['designation'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['resume_id'] = resumeId;
    data['title'] = title;
    data['designation'] = designation;
    data['phone'] = phone;
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
