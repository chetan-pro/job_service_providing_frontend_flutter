class CompanyImageModel {
  dynamic count;
  List<CompanyImage>? companyImage;

  CompanyImageModel({this.count, this.companyImage});

  CompanyImageModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      companyImage = <CompanyImage>[];
      json['rows'].forEach((v) {
        companyImage!.add( CompanyImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (companyImage != null) {
      data['rows'] = companyImage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyImage {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

  CompanyImage(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.image,
      this.status,
      this.createdAt,
      this.updatedAt});

  CompanyImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
