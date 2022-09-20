class NotificationModel {
  int? count;
  List<Notifications>? notification;

  NotificationModel({this.count, this.notification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      notification = <Notifications>[];
      json['rows'].forEach((v) {
        notification!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (notification != null) {
      data['rows'] = notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? id;
  String? title;
  String? message;
  String? notificationType;
  int? userId;
  int? readStatus;
  int? status;
  String? createdAt;
  String? updatedAt;

  Notifications(
      {this.id,
      this.title,
      this.message,
      this.notificationType,
      this.userId,
      this.readStatus,
      this.status,
      this.createdAt,
      this.updatedAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    notificationType = json['notification_type'];
    userId = json['user_id'];
    readStatus = json['read_status'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['message'] = message;
    data['notification_type'] = notificationType;
    data['user_id'] = userId;
    data['read_status'] = readStatus;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
