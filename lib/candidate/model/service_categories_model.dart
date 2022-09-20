import 'package:hindustan_job/candidate/model/serviceProviderModal/alldata_get_modal.dart';

class ServiceCategoriesModel {
  int? count;
  List<ServiceCategories>? serviceCategories;

  ServiceCategoriesModel({this.count, this.serviceCategories});

  ServiceCategoriesModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      serviceCategories = <ServiceCategories>[];
      json['rows'].forEach((v) {
        serviceCategories!.add(ServiceCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (serviceCategories != null) {
      data['rows'] = serviceCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class ServiceCategories {
//   int? id;
//   String? categoryName;
//   String? categoryDesc;
//   String? createdAt;
//   String? updatedAt;

//   ServiceCategories(
//       {this.id,
//       this.categoryName,
//       this.categoryDesc,
//       this.createdAt,
//       this.updatedAt});

//   ServiceCategories.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryName = json['category_name'];
//     categoryDesc = json['category_desc'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['category_name'] = this.categoryName;
//     data['category_desc'] = this.categoryDesc;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     return data;
//   }
// }
class CatergoryCountModel {
  List<ServiceCountCategory>? serviceCountCategory;

  CatergoryCountModel({this.serviceCountCategory});

  CatergoryCountModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      serviceCountCategory = <ServiceCountCategory>[];
      json['rows'].forEach((v) {
        serviceCountCategory!.add(ServiceCountCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceCountCategory != null) {
      data['rows'] = serviceCountCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceCountCategory {
  int? categoryId;
  int? categoryCount;
  ServiceCategory? serviceCategory;

  ServiceCountCategory({this.categoryId, this.categoryCount, this.serviceCategory});

  ServiceCountCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryCount = json['CategoryCount'];
    serviceCategory = json['ServiceCategory'] != null
        ? ServiceCategory.fromJson(json['ServiceCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['CategoryCount'] = categoryCount;
    if (serviceCategory != null) {
      data['ServiceCategory'] = serviceCategory!.toJson();
    }
    return data;
  }
}

class ServiceCategory {
  int? id;
  String? image;
  String? categoryName;

  ServiceCategory({this.id, this.image, this.categoryName});

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['category_name'] = categoryName;
    return data;
  }
}
