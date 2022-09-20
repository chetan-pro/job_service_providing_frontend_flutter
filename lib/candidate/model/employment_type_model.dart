class EmploymentModel {
  List<EmploymentType>? employmentType;

  EmploymentModel({this.employmentType});

  EmploymentModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      employmentType = <EmploymentType>[];
      json['rows'].forEach((v) {
        employmentType!.add(EmploymentType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (employmentType != null) {
      data['rows'] = employmentType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmploymentType {
  String? key;
  String? name;

  EmploymentType({this.key, this.name});

  EmploymentType.fromJson(Map<String, dynamic> json) {
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
