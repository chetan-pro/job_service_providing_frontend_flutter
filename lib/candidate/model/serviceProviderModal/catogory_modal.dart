
class Categories {
  List<CategoryModel>? data;
  int? count;

  Categories({this.data, this.count});

  Categories.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      data = <CategoryModel>[];
      json['rows'].forEach((v) {
        data!.add(CategoryModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['rows'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class CategoryModel {
  int? id;
  String? categoryName;
  String? categoryDesc;
  String? createdAt;
  String? updatedAt;

  CategoryModel(
      {this.id,
      this.categoryName,
      this.categoryDesc,
      this.createdAt,
      this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categoryDesc = json['category_desc'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['category_desc'] = categoryDesc;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
