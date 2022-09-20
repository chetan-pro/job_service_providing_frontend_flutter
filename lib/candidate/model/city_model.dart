class CityModel {
  dynamic count;
  List<City>? cities;

  CityModel({this.count, this.cities});

  CityModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      cities = <City>[];
      json['rows'].forEach((v) {
        cities!.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.cities != null) {
      data['rows'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  int? id;
  String? name;
  int? stateId;
  String? description;
  int? status;
  bool? isSelected = false;
  String? createdAt;
  String? updatedAt;

  City(
      {this.id,
      this.name,
      this.stateId,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
