class SettleBank {
  dynamic count;
  List<GetSettleBank>? getSettle;

  SettleBank({this.count, this.getSettle});

  SettleBank.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      getSettle = <GetSettleBank>[];
      json['rows'].forEach((v) {
        getSettle!.add(GetSettleBank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (getSettle != null) {
      data['rows'] = getSettle!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetSettleBank {
  int? id;
  int? userId;
  String? amount;
  String? status;
  dynamic transactionId;
  dynamic file;
  dynamic description;
  dynamic updateBy;
  String? time;
  String? createdAt;
  String? updatedAt;

  GetSettleBank(
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

  GetSettleBank.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['status'] = status;
    data['transaction_id'] = transactionId;
    data['file'] = file;
    data['description'] = description;
    data['update_by'] = updateBy;
    data['time'] = time;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
