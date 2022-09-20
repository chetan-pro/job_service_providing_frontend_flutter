class YesNoModel {
  List<YesNoType>? yesNoType;

  YesNoModel({this.yesNoType});

  YesNoModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      yesNoType = <YesNoType>[];
      json['rows'].forEach((v) {
        yesNoType!.add(YesNoType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (YesNoType != null) {
      data['rows'] = yesNoType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YesNoType {
  String? key;
  String? name;

  YesNoType({this.key, this.name});

  YesNoType.fromJson(Map<String, dynamic> json) {
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
