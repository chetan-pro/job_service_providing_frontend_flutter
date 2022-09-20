import 'package:hindustan_job/candidate/model/user_model.dart';

class RateService {
  int? count;
  List<RatingServices>? rows;
  int? mean;

  RateService({this.count, this.rows, this.mean});

  RateService.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <RatingServices>[];
      json['rows'].forEach((v) {
        rows!.add(new RatingServices.fromJson(v));
      });
    }
    mean = json['mean'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['mean'] = this.mean;
    return data;
  }
}

class RatingServices {
  int? id;
  int? userId;
  int? serviceId;
  int? serviceRequestId;
  int? star;
  String? comment;
  String? createdAt;
  String? updatedAt;
  UserData? user;
  int? mean;

  RatingServices(
      {this.id,
      this.userId,
      this.serviceId,
      this.serviceRequestId,
      this.star,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.mean,
      this.user});

  RatingServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    serviceRequestId = json['service_request_id'];
    star = json['star'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    mean = json['mean'];
    user = json['User'] != null ? new UserData.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['service_id'] = this.serviceId;
    data['service_request_id'] = this.serviceRequestId;
    data['star'] = this.star;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    return data;
  }
}
