class Permissons {
  int? id;
  String? name;
  String? description;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  UserPermissions? userPermissions;

  Permissons(
      {this.id,
      this.name,
      this.description,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.userPermissions});

  Permissons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userPermissions = json['user_permissions'] != null
        ?  UserPermissions.fromJson(json['user_permissions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['is_active'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (userPermissions != null) {
      data['user_permissions'] = userPermissions!.toJson();
    }
    return data;
  }
}

class UserPermissions {
  String? createdAt;
  String? updatedAt;
  int? permissionId;
  int? userId;

  UserPermissions(
      {this.createdAt, this.updatedAt, this.permissionId, this.userId});

  UserPermissions.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    permissionId = json['permissionId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['permissionId'] = permissionId;
    data['userId'] = userId;
    return data;
  }
}
