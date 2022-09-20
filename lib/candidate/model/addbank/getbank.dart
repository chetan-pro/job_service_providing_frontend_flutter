
class Data {
  int? id;
  String? bankName;
  String? branchName;
  String? fullRegisteredName;
  String? ifscCode;
  String? bankAccountNumber;
  String? bankAccountType;
  int? userId;
  int? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.bankName,
      this.branchName,
      this.fullRegisteredName,
      this.ifscCode,
      this.bankAccountNumber,
      this.bankAccountType,
      this.userId,
      this.status,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    fullRegisteredName = json['full_registered_name'];
    ifscCode = json['ifsc_code'];
    bankAccountNumber = json['bank_account_number'];
    bankAccountType = json['bank_account_type'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['full_registered_name'] = fullRegisteredName;
    data['ifsc_code'] = ifscCode;
    data['bank_account_number'] = bankAccountNumber;
    data['bank_account_type'] = bankAccountType;
    data['user_id'] = userId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
