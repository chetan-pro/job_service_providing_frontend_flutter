class WFHModel {
  List<WFHType>? wfhType;

  WFHModel({this.wfhType});

  WFHModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      wfhType = <WFHType>[];
      json['rows'].forEach((v) {
        wfhType!.add(WFHType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (WFHType != null) {
      data['rows'] = wfhType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WFHType {
  String? key;
  String? name;
  bool? isSelected = false;

  WFHType({this.key, this.name});

  WFHType.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = name;
    return data;
  }
}
