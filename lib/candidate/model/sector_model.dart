class SectorModel {
  dynamic count;
  List<Sector>? sector;

  SectorModel({this.count, this.sector});

  SectorModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      sector = <Sector>[];
      json['rows'].forEach((v) {
        sector!.add(Sector.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (sector != null) {
      data['rows'] = sector!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sector {
  int? id;
  int? industryId;
  String? name;
  int? status;
  bool? isSelected = false;
  String? createdAt;
  String? updatedAt;

  Sector(
      {this.id,
      this.industryId,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt});

  Sector.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    industryId = json['industry_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['industry_id'] = industryId;
    data['name'] = name;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
