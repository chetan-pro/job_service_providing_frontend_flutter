
class RoleModel {
  dynamic count;
  List<Roles>? roles;

  RoleModel({this.count, this.roles});

  RoleModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      roles = <Roles>[];
      json['rows'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }
}

class Roles {
  int? id;
  String? name;
  String? roleType;
  String? createdAt;
  String? updatedAt;

  Roles({this.id, this.name, this.roleType, this.createdAt, this.updatedAt});

  factory Roles.fromJson(Map<String, dynamic> json) {
    return Roles(
        id: json['id'],
        name: json['name'],
        roleType: json['role_type'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
}

