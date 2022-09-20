class CommisionModel {
  int? count;
  List<Commision>? commision;

  CommisionModel({this.count, this.commision});

  CommisionModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      commision = <Commision>[];
      json['rows'].forEach((v) {
        commision!.add(Commision.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (commision != null) {
      data['rows'] = commision!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commision {
  int? id;
  String? reason;
  String? date;
  String? myCommissionAmount;

  Commision({this.id, this.reason, this.date, this.myCommissionAmount});

  Commision.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['Reason'];
    date = json['date'];
    myCommissionAmount = json['my_commission_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Reason'] = reason;
    data['date'] = date;
    data['my_commission_amount'] = myCommissionAmount;
    return data;
  }
}
