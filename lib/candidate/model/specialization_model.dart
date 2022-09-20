class SpecializationModel {
  dynamic count;
  List<Specialization>? specialization;

  SpecializationModel({this.count, this.specialization});

  SpecializationModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      specialization = <Specialization>[];
      json['rows'].forEach((v) {
        specialization!.add(new Specialization.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.specialization != null) {
      data['rows'] = this.specialization!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specialization {
  int? id;
  int? courseId;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;

  Specialization(
      {this.id,
      this.courseId,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt});

  Specialization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
