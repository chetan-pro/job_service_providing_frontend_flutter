// class BranchModel {
//   int? count;
//   List<Branch>? branch;
//   BranchModel({this.count, this.branch});
//   BranchModel.fromJson(Map<String, dynamic> json) {
//     count = json['count'];
//     if (json['rows'] != null) {
//       branch = <Branch>[];
//       json['rows'].forEach((v) {
//         branch!.add(Branch.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['count'] = count;
//     if (branch != null) {
//       data['rows'] = branch!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Branch {
//   int? id;
//   int? serviceProviderId;
//   String? shopName;
//   String? address1;
//   String? address2;
//   int? pinCode;
//   int? stateId;
//   int? cityId;
//   String? createdAt;
//   String? updatedAt;

//   Branch(
//       {this.id,
//       this.serviceProviderId,
//       this.shopName,
//       this.address1,
//       this.address2,
//       this.pinCode,
//       this.stateId,
//       this.cityId,
//       this.createdAt,
//       this.updatedAt});

//   Branch.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     serviceProviderId = json['service_provider_id'];
//     shopName = json['shop_name'];
//     address1 = json['address1'];
//     address2 = json['address2'];
//     pinCode = json['pin_code'];
//     stateId = json['state_id'];
//     cityId = json['city_id'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['service_provider_id'] = serviceProviderId;
//     data['shop_name'] = shopName;
//     data['address1'] = address1;
//     data['address2'] = address2;
//     data['pin_code'] = pinCode;
//     data['state_id'] = stateId;
//     data['city_id'] = cityId;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     return data;
//   }
// }
