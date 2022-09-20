class Documents {
  int? id;
  int? userId;
  String? documentName;
  String? documentNumber;
  String? image;
  String? serviceExperience;
  String? createdAt;
  String? updatedAt;
  String? imageBack;

  Documents(
      {this.id,
      this.userId,
      this.documentName,
      this.documentNumber,
      this.image,
      this.imageBack,
      this.serviceExperience,
      this.createdAt,
      this.updatedAt});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    documentName = json['document_name'];
    documentNumber = json['document_number'];
    image = json['image'];
    imageBack = json['image_back'];
    serviceExperience = json['service_experience'].toString();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['document_name'] = this.documentName;
    data['document_number'] = this.documentNumber;
    data['image'] = this.image;
    data['image_back'] = this.imageBack;
    data['service_experience'] = serviceExperience;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
