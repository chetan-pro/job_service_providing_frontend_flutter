class StateModel {
  dynamic count;
  List<States>? states;

  StateModel({this.count, this.states});

  StateModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      states = <States>[];
      json['rows'].forEach((v) {
        states!.add(States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = this.count;
    if (this.states != null) {
      data['rows'] = this.states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  int? id;
  String? name;
  String? description;
  int? status;
bool? isSelected = false;
  String? createdAt;
  String? updatedAt;

  States(
      {this.id,
      this.name,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
