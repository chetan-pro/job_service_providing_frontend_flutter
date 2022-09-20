class EducationModel {
  dynamic count;
  List<Education>? education;

  EducationModel({this.count, this.education});

  EducationModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      education = <Education>[];
      json['rows'].forEach((v) {
        education!.add(Education.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (education != null) {
      data['rows'] = education!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Education {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  bool? isSelected=false;

  Education({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  Education.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
