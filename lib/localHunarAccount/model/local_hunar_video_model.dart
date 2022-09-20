import 'package:hindustan_job/candidate/model/user_model.dart';

class LocalHunarVideoModel {
  int? count;
  List<LocalHunarVideo>? localHunarVideo;

  LocalHunarVideoModel({this.count, this.localHunarVideo});

  LocalHunarVideoModel.fromJson(Map<String, dynamic> json) {
    json = json['data'] ?? json;
    count = json['count'];
    if (json['rows'] != null) {
      localHunarVideo = <LocalHunarVideo>[];
      json['rows'].forEach((v) {
        localHunarVideo!.add(new LocalHunarVideo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.localHunarVideo != null) {
      data['rows'] = this.localHunarVideo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocalHunarVideo {
  int? id;
  int? userId;
  String? url;
  String? title;
  UserData? user;
  String? description;
  int? views;
  String? length;
  String? approved;
  String? createdAt;
  String? updatedAt;

  LocalHunarVideo(
      {this.id,
      this.userId,
      this.url,
      this.title,
      this.description,
      this.views,
      this.approved,
      this.createdAt,
      this.length,
      this.user,
      this.updatedAt});

  LocalHunarVideo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    url = json['url'];
    title = json['title'];
    description = json['description'];
    views = json['views'];
    length = json['length'];
    user = json['User'] != null ? UserData.fromJson(json['User']) : UserData();
    approved = json['approved'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['url'] = this.url;
    data['title'] = this.title;
    data['description'] = this.description;
    data['views'] = this.views;
    data['length'] = this.length;
    data['User'] = this.user;
    data['approved'] = this.approved;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
