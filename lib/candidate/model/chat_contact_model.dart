import 'package:hindustan_job/candidate/model/user_model.dart';

class ChatContactModel {
  dynamic count;
  List<ChatContact>? chatContact;

  ChatContactModel({this.count, this.chatContact});

  ChatContactModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      chatContact = <ChatContact>[];
      json['rows'].forEach((v) {
        chatContact!.add(ChatContact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (chatContact != null) {
      data['rows'] = chatContact!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatContact {
  int? id;
  int? senderId;
  int? receiverId;
  String? createdAt;
  String? updatedAt;
  UserData? senderInfo;
  UserData? receiverInfo;
  List<Chats>? chats;

  ChatContact(
      {this.id,
      this.senderId,
      this.receiverId,
      this.createdAt,
      this.updatedAt,
      this.senderInfo,
      this.receiverInfo,
      this.chats});

  ChatContact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    senderInfo = json['senderInfo'] != null
        ? UserData.fromJson(json['senderInfo'])
        : null;
    receiverInfo = json['receiverInfo'] != null
        ? UserData.fromJson(json['receiverInfo'])
        : null;
    if (json['Chats'] != null) {
      chats = <Chats>[];
      json['Chats'].forEach((v) {
        chats!.add(Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (senderInfo != null) {
      data['senderInfo'] = senderInfo!.toJson();
    }
    if (receiverInfo != null) {
      data['receiverInfo'] = receiverInfo!.toJson();
    }
    if (chats != null) {
      data['Chats'] = chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Chats {
  int? id;
  int? chatChannelId;
  int? userId;
  dynamic staffId;
  String? message;
  bool? readStatus;
  String? createdAt;
  String? updatedAt;

  Chats(
      {this.id,
      this.chatChannelId,
      this.userId,
      this.staffId,
      this.message,
      this.readStatus,
      this.createdAt,
      this.updatedAt});

  Chats.fromJson(Map<String, dynamic> json) {
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
