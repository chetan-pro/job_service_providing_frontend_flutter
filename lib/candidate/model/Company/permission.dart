class PermissionStaff {
  List<PermissonModel>? data;
  String? message;

  PermissionStaff({this.data, this.message});

  PermissionStaff.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <PermissonModel>[];
      json['data'].forEach((v) {
        data!.add(PermissonModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class PermissonModel {
  int? id;
  String? name;
  String? description;
  bool? isActive;
  bool? toggle;
  String? createdAt;
  String? updatedAt;

  PermissonModel(
      {this.id,
      this.name,
      this.description,
      this.isActive,
      this.toggle,
      this.createdAt,
      this.updatedAt});

  PermissonModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    toggle = json['toggle'] ?? false;
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['is_active'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
