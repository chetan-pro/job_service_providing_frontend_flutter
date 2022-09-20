class ChatChannelObjectModel {
  int? id;
  int? senderId;
  int? receiverId;
  String? createdAt;
  String? updatedAt;

  ChatChannelObjectModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.createdAt,
      this.updatedAt});

  ChatChannelObjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
