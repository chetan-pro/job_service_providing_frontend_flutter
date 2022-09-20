class SkillSubCategory {
  dynamic count;
  List<SubSkill>? subSkill;

  SkillSubCategory({this.count, this.subSkill});

  SkillSubCategory.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      subSkill = <SubSkill>[];
      json['rows'].forEach((v) {
        subSkill!.add(new SubSkill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.subSkill != null) {
      data['rows'] = this.subSkill!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSkill {
  int? id;
  String? name;
  int? resumeSkillId;
  int? skillCategoryId;
  String? rating = '';
  bool? isSelected = false;

  SubSkill(
      {this.id,
      this.name,
      this.skillCategoryId,
      this.rating,
      this.isSelected,
      this.resumeSkillId});

  SubSkill.fromJson(Map<String, dynamic> json) {
    id = json['id'] ;
    name = json['name'];
    isSelected = json['isSelected'];
    rating = json['rating'].toString();
  resumeSkillId = json['resume_skill_id'];
    skillCategoryId = json['skill_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['skill_category_id'] = this.skillCategoryId;
    return data;
  }
}
