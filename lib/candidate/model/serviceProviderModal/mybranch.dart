// ignore_for_file: unnecessary_new, unnecessary_this

class ServiceBranches {
  int? count;
  List<Branch>? branches;

  ServiceBranches({this.count, this.branches});

  ServiceBranches.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      branches = <Branch>[];
      json['rows'].forEach((v) {
        branches!.add(new Branch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.branches != null) {
      data['rows'] = this.branches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Branch {
  int? id;
  int? serviceProviderId;
  String? shopName;
  String? address1;
  String? address2;
  int? pinCode;
  int? stateId;
  int? cityId;
  String? createdAt;
  String? updatedAt;
  User? user;
  User? city;
  User? state;

  Branch(
      {this.id,
      this.serviceProviderId,
      this.shopName,
      this.address1,
      this.address2,
      this.pinCode,
      this.stateId,
      this.cityId,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.city,
      this.state});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceProviderId = json['service_provider_id'];
    shopName = json['shop_name'];
    address1 = json['address1'];
    address2 = json['address2'];
    pinCode = json['pin_code'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    city = json['city'] != null ? new User.fromJson(json['city']) : null;
    state = json['state'] != null ? new User.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_provider_id'] = this.serviceProviderId;
    data['shop_name'] = this.shopName;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['pin_code'] = this.pinCode;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
