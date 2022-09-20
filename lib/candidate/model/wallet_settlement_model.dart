class WalletSettleMentModel {
  dynamic count;
  List<WalletSettleMent>? walletSettleMent;

  WalletSettleMentModel({this.count, this.walletSettleMent});

  WalletSettleMentModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      walletSettleMent = <WalletSettleMent>[];
      json['rows'].forEach((v) {
        walletSettleMent!.add(new WalletSettleMent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.walletSettleMent != null) {
      data['rows'] = this.walletSettleMent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletSettleMent {
  int? id;
  int? userId;
  String? amount;
  String? status;
  dynamic? transactionId;
  String? file;
  dynamic? description;
  dynamic? updateBy;
  String? time;
  String? createdAt;
  String? updatedAt;

  WalletSettleMent(
      {this.id,
      this.userId,
      this.amount,
      this.status,
      this.transactionId,
      this.file,
      this.description,
      this.updateBy,
      this.time,
      this.createdAt,
      this.updatedAt});

  WalletSettleMent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    status = json['status'];
    transactionId = json['transaction_id'];
    file = json['file'];
    description = json['description'];
    updateBy = json['update_by'];
    time = json['time'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['transaction_id'] = this.transactionId;
    data['file'] = this.file;
    data['description'] = this.description;
    data['update_by'] = this.updateBy;
    data['time'] = this.time;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
