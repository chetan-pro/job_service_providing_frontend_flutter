class WalletTransactions {
  dynamic count;
  List<Transactions>? transactions;

  WalletTransactions({this.count, this.transactions});

  WalletTransactions.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      transactions = <Transactions>[];
      json['rows'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (transactions != null) {
      data['rows'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  int? id;
  int? userId;
  String? previousAmount;
  String? amount;
  String? totalAmount;
  String? type;
  String? reason;
  String? details;
  String? createdAt;
  String? updatedAt;

  Transactions(
      {this.id,
      this.userId,
      this.previousAmount,
      this.amount,
      this.totalAmount,
      this.type,
      this.reason,
      this.details,
      this.createdAt,
      this.updatedAt});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    previousAmount = json['previous_amount'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    type = json['type'];
    reason = json['reason'];
    details = json['details'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['previous_amount'] = previousAmount;
    data['amount_to_add'] = amount;
    data['total_amount'] = totalAmount;
    data['type'] = type;
    data['reason'] = reason;
    data['details'] = details;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
