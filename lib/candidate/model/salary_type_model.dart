class SalaryTypeModel {
  List<SalaryType>? salaryType;

  SalaryTypeModel({this.salaryType});

  SalaryTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      salaryType = <SalaryType>[];
      json['rows'].forEach((v) {
        salaryType!.add(SalaryType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rows'] = salaryType!.map((v) => v.toJson()).toList();
    return data;
  }
}

class SalaryType {
  String? key;
  String? name;

  SalaryType({this.key, this.name});

  SalaryType.fromJson(Map<String, dynamic> json) {
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
