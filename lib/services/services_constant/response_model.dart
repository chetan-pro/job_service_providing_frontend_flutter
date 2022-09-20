class ApiResponse {
  int? status;
  Body? body;

  ApiResponse({this.status, this.body});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  dynamic data;
  String? message;
  dynamic walletMoney;

  Body({this.data, this.message, this.walletMoney});

  Body.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'] ?? json['error_message'];
    walletMoney = json['wallet_money'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = message;
    data['wallet_money'] = walletMoney;
    return data;
  }
}
