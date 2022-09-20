class MessageModel {
  dynamic count;
  List<Message>? message;

  MessageModel({this.count, this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      message = <Message>[];
      json['rows'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? id;
  int? chatChannelId;
  int? userId;
  int? staffId;
  String? message;
  bool? readStatus;
  String? createdAt;
  String? updatedAt;

  Message(
      {this.id,
      this.chatChannelId,
      this.userId,
      this.staffId,
      this.message,
      this.readStatus,
      this.createdAt,
      this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatChannelId = json['chat_channel_id'];
    userId = json['user_id'];
    staffId = json['staff_id'];
    message = json['message'];
    readStatus = json['read_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chat_channel_id'] = chatChannelId;
    data['user_id'] = userId;
    data['staff_id'] = staffId;
    data['message'] = message;
    data['read_status'] = readStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
