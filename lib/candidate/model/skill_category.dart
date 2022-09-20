class SkillCategory {
  dynamic count;
  List<Skill>? skill;

  SkillCategory({this.count, this.skill});

  SkillCategory.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      skill = <Skill>[];
      json['rows'].forEach((v) {
        skill!.add(new Skill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.skill != null) {
      data['rows'] = this.skill!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Skill {
  int? id;
  String? name;
  int? status;
  bool? isSelected = false;
  String? createdAt;
  String? updatedAt;

  Skill({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  Skill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
