class KeyValueModel {
  List<KeyValue>? keyValue;

  KeyValueModel({this.keyValue});

  KeyValueModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      keyValue = <KeyValue>[];
      json['rows'].forEach((v) {
        keyValue!.add(KeyValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (KeyValue != null) {
      data['rows'] = keyValue!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KeyValue {
  String? key;
  String? name;
  bool? isSelected = false;
  

  KeyValue({this.key, this.name});

  KeyValue.fromJson(Map<String, dynamic> json) {
    key = json['key'].toString();
    name = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = name;
    return data;
  }
}
