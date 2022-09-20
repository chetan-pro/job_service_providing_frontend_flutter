class JobScheduleModel {
  List<JobScheduleType>? jobScheduleType;

  JobScheduleModel({this.jobScheduleType});

  JobScheduleModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      jobScheduleType = <JobScheduleType>[];
      json['rows'].forEach((v) {
        jobScheduleType!.add(JobScheduleType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (jobScheduleType != null) {
      data['rows'] = jobScheduleType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobScheduleType {
  String? key;
  String? name;

  JobScheduleType({this.key, this.name});

  JobScheduleType.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = name;
    return data;
  }
}
