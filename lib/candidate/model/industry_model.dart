// ignore_for_file: unnecessary_new

class IndustryModel {
  dynamic count;
  List<Industry>? industry;

  IndustryModel({this.count, this.industry});

  IndustryModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      industry = <Industry>[];
      json['rows'].forEach((v) {
        industry!.add(new Industry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.industry != null) {
      data['rows'] = this.industry!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Industry {
  int? id;
  String? name;
  int? status;
  bool? isSelected = false;
  String? createdAt;
  String? updatedAt;

  Industry({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Industry.fromJson(Map<String, dynamic> json) {
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
    data['updatedAt'] = updatedAt;

    return data;
  }
}
