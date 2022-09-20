import 'package:hindustan_job/candidate/model/language_model.dart';

class UserLanguageModel {
  dynamic count;
  List<Language>? userLanguage;

  UserLanguageModel({this.count, this.userLanguage});

  UserLanguageModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      userLanguage = <Language>[];
      json['rows'].forEach((v) {
        if (v['Languages'] != null) {
          v['Languages'][0]['user_lang_id'] = v['id'];
          userLanguage!.add(new Language.fromJson(v['Languages'][0]));
        } else {
          userLanguage!.add(new Language.fromJson(v));
        }
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.userLanguage != null) {
      data['rows'] = this.userLanguage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
