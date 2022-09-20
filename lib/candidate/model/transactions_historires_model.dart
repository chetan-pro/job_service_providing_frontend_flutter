class TransactionHistoriesModel {
  dynamic count;
  List<TransactionHistories>? transactionHistories;

  TransactionHistoriesModel({this.count, this.transactionHistories});

  TransactionHistoriesModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      transactionHistories = <TransactionHistories>[];
      json['rows'].forEach((v) {
        transactionHistories!.add(new TransactionHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.transactionHistories != null) {
      data['rows'] = this.transactionHistories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionHistories {
  int? id;
  String? orderId;
  String? tnxId;
  String? paymentJsonResponse;
  String? paymentJsonRequest;
  int? subscribedUserId;
  int? totalAmount;
  int? eAmount;
  int? walletAmount;
  int? planId;
  String? currency;
  String? paymentType;
  String? paymentStatus;
  String? cronUpdate;
  dynamic? cronUpdatedTime;
  String? status;
  String? createdAt;
  String? updatedAt;

  TransactionHistories(
      {this.id,
      this.orderId,
      this.tnxId,
      this.paymentJsonResponse,
      this.paymentJsonRequest,
      this.subscribedUserId,
      this.totalAmount,
      this.eAmount,
      this.walletAmount,
      this.planId,
      this.currency,
      this.paymentType,
      this.paymentStatus,
      this.cronUpdate,
      this.cronUpdatedTime,
      this.status,
      this.createdAt,
      this.updatedAt});

  TransactionHistories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    tnxId = json['tnx_id'];
    paymentJsonResponse = json['payment_json_response'];
    paymentJsonRequest = json['payment_json_request'];
    subscribedUserId = json['subscribed_user_id'];
    totalAmount = json['total_amount'];
    eAmount = json['e_amount'];
    walletAmount = json['wallet_amount'];
    planId = json['plan_id'];
    currency = json['currency'];
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    cronUpdate = json['cron_update'];
    cronUpdatedTime = json['cron_updated_time'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['tnx_id'] = this.tnxId;
    data['payment_json_response'] = this.paymentJsonResponse;
    data['payment_json_request'] = this.paymentJsonRequest;
    data['subscribed_user_id'] = this.subscribedUserId;
    data['total_amount'] = this.totalAmount;
    data['e_amount'] = this.eAmount;
    data['wallet_amount'] = this.walletAmount;
    data['plan_id'] = this.planId;
    data['currency'] = this.currency;
    data['payment_type'] = this.paymentType;
    data['payment_status'] = this.paymentStatus;
    data['cron_update'] = this.cronUpdate;
    data['cron_updated_time'] = this.cronUpdatedTime;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
