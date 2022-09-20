class LanguageModel {
  dynamic count;
  List<Language>? language;

  LanguageModel({this.count, this.language});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      language = <Language>[];
      json['rows'].forEach((v) {
        language!.add(Language.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (language != null) {
      data['rows'] = language!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Language {
  int? id;
  String? name;
  String? code;
  int? status;
  int? userLangId;
  String? createdAt;
  String? updatedAt;
  String? languageId;
  bool isSelected = false;

  Language(
      {this.id,
      this.name,
      this.code,
      this.userLangId,
      this.status,
      this.languageId,
      this.createdAt,
      this.updatedAt});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageId = json['language_id'];
    name = json['name'];
    code = json['code'];
    userLangId = json['user_lang_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['language_id'] = languageId;
    data['user_lang_id'] = userLangId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
