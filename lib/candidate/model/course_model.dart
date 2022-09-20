class CourseModel {
  dynamic count;
  List<Course>? course;

  CourseModel({this.count, this.course});

  CourseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      course = <Course>[];
      json['rows'].forEach((v) {
        course!.add(new Course.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.course != null) {
      data['rows'] = this.course!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Course {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;

  Course({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  Course.fromJson(Map<String, dynamic> json) {
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
