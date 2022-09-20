import 'package:hindustan_job/candidate/model/user_model.dart';

class CompanyListModel {
  dynamic count;
  List<UserData>? companyList;

  CompanyListModel({this.count, this.companyList});

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != dynamic) {
      companyList = <UserData>[];
      json['rows'].forEach((v) {
        companyList!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = count;
    if (companyList != dynamic) {
      data['rows'] = companyList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
