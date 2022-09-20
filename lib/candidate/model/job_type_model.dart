class JobTypeModel {
  dynamic count;
  List<JobType>? jobType;

  JobTypeModel({this.count, this.jobType});

  JobTypeModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      jobType = <JobType>[];
      json['rows'].forEach((v) {
        jobType!.add( JobType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['count'] = count;
    if (jobType != null) {
      data['rows'] = jobType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobType {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;

  JobType({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  JobType.fromJson(Map<String, dynamic> json) {
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
