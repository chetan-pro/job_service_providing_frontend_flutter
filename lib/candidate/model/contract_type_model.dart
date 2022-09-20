class ContractTypeModel {
  List<ContractType>? contractType;

  ContractTypeModel({this.contractType});

  ContractTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      contractType = <ContractType>[];
      json['rows'].forEach((v) {
        contractType!.add(ContractType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contractType != null) {
      data['rows'] = contractType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContractType {
  String? key;
  String? name;

  ContractType({this.key, this.name});

  ContractType.fromJson(Map<String, dynamic> json) {
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
