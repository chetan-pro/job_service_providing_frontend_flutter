import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';

class CustomJobAlertModel {
  dynamic count;
  List<CustomAlert>? customJobAlert;

  CustomJobAlertModel({this.count, this.customJobAlert});

  CustomJobAlertModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      customJobAlert = <CustomAlert>[];
      json['rows'].forEach((v) {
        customJobAlert!.add(CustomAlert.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (customJobAlert != null) {
      data['rows'] = customJobAlert!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomAlert {
  int? id;
  int? userId;
  int? companyId;
  int? industryId;
  int? sectorId;
  int? stateId;
  int? cityId;
  int? pincode;
  int? status;
  String? createdAt;
  String? updatedAt;
  Industry? industry;
  Industry? jobRoleType;
  Sector? sector;
  UserData? user;
  City? city;
  States? state;

  CustomAlert(
      {this.id,
      this.userId,
      this.companyId,
      this.industryId,
      this.sectorId,
      this.stateId,
      this.cityId,
      this.pincode,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.industry,
      this.jobRoleType,
      this.sector,
      this.user,
      this.city,
      this.state});

  CustomAlert.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    industryId = json['industry_id'];
    sectorId = json['sector_id'];
    pincode = json['pin_code'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    jobRoleType = json['JobRoleType'] != null
        ? Industry.fromJson(json['JobRoleType'])
        : null;
    industry =
        json['Industry'] != null ? Industry.fromJson(json['Industry']) : null;
    sector = json['Sector'] != null ? Sector.fromJson(json['Sector']) : null;
    user = json['User'] != null ? UserData.fromJson(json['User']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    state = json['state'] != null ? States.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['company_id'] = companyId;
    data['industry_id'] = industryId;
    data['sector_id'] = sectorId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['pin_code'] = pincode;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (jobRoleType != null) {
      data['JobRoleType'] = jobRoleType!.toJson();
    }
    if (industry != null) {
      data['Industry'] = industry!.toJson();
    }
    if (sector != null) {
      data['Sector'] = sector!.toJson();
    }
    if (user != null) {
      data['User'] = user!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    return data;
  }
}
